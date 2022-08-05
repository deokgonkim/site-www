---
# Title of your post. If not set, filename will be used.
title: "Tomcat 고가용성 구성 테스트 노트"
date: 2012-04-29T20:23:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "java"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

Tomcat 6.0을 가지고 고가용성, 즉 클러스터링을 따라해 보았습니다.

시나리오.
1. tomcat 인스턴스는 weblogic, oc4j와 비슷하게 제품 바이너리와 <strong>인스턴스</strong>를 분리해 본다.
2. cluster 구성으로 생성한다.
3. 애플리케이션 배포 시나리오를 생각해 본다.
4. 테스트 애플리케이션 준비
5. Apache mod_proxy_jk 세팅

### Tomcat 바이너리와 인스턴스 분리

톰캣 바이너리는 app/apache/apache-tomcat-6.0.32 경로에 있습니다.
인스턴스 경로는 아래와 같은 구성을 시도해봅니다.

```
app/apache/user_projects - 톰캣 인스턴스묶음용? 경로
app/apache/user_projects/cluster_domain - 톰캣이 만들어질 도메인?
app/apache/user_projects/cluster_domain/bin - 도메인용 스크립트 디렉토리 ( startup.sh, shutdown.sh 존재 )
app/apache/user_projects/cluster_domain/servers - 톰캣 인스턴스용 디렉토리
app/apache/user_projects/cluster_domain/servers/tomcat1 - 'tomcat1'이란 이름의 톰캣 인스턴스
app/apache/user_projects/cluster_domain/servers/tomcat1/bin,conf,logs,temp,webapps,work - 'tomcat1'인스턴스 구성요소
app/apache/user_projects/cluster_domain/servers/tomcat2 - 'tomcat2'이란 이름의 톰캣 인스턴스
app/apache/user_projects/cluster_domain/servers/tomcat2/bin,conf,logs,temp,webapps,work - 'tomcat2'인스턴스 구성요소
app/apache/user_projects/cluster_domain/webapps - 이 도메인에서 사용할 애플리케이션 준비 디렉토리
```

인스턴스 구성. bin 경로와 conf 경로를 준비합니다.
```bash
# DOMAIN_HOME=~/app/apache/user_projects/cluster_domain
# cd $DOMAIN_HOME
# cd servers/tomcat1
# cd bin
# cp ../../../../apache-tomcat-6.0.32/bin/*.sh .
# cd ../conf
# cp -R ../../../../apache-tomcat-6.0.32/conf/* .
```

인스턴스 구성중 우선 catalina.sh 구성을 수정합니다.
```bash
JAVA_HOME=~/app/sun/java/jdk1.6.0_27
JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -XX:MaxPermSize=256m"
CATALINA_HOME=~/app/apache/apache-tomcat-6.0.32
CATALINA_BASE=~/app/apache/user_projects/cluster_domain/servers/tomcat1
```

위 구성을 통해 tomcat/lib의 바이너리를 사용하면서, tomcat1경로를 기준으로한 톰캣을 사용할 수 있습니다.

인스턴스 구성중 server.xml 구성을 변경합니다.
server.xml의 경우 포트, cluster 항목, 애플리케이션 경로를 구성합니다.
기본 포트에 tomcat1은 10000번을 더하고, tomcat2는 20000번을 더하여 포트를 정했습니다.(18080, 18443, 18009, 28080, 28443, 28009 )
```xml
<?xml version='1.0' encoding='utf-8'?>
<Server port="18005" shutdown="SHUTDOWN">
  <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on" />
  <Listener className="org.apache.catalina.core.JasperListener" />
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />
  <Listener className="org.apache.catalina.mbeans.ServerLifecycleListener" />
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />

  <GlobalNamingResources>
    <Resource name="UserDatabase" auth="Container"
              type="org.apache.catalina.UserDatabase"
              description="User database that can be updated and saved"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml" />
  </GlobalNamingResources>

  <Service name="Catalina">

    <Executor name="tomcatThreadPool" namePrefix="catalina-exec-"
        maxThreads="150" minSpareThreads="4"/>

    <Connector executor="tomcatThreadPool"
               port="18080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="18443" />
    <Connector port="18443" maxThreads="200"
               scheme="https" secure="true" SSLEnabled="true"
               keystoreFile="./conf/.keystore" keystorePass="changeit"
               clientAuth="false" sslProtocol="TLS"/>

    <Connector port="18009" protocol="AJP/1.3" redirectPort="18443" />

    <Engine name="Catalina" defaultHost="localhost" jvmRoute="jvm1">

      <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true"
            xmlValidation="false" xmlNamespaceAware="false">
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log." suffix=".log" pattern="common" resolveHosts="false"/>
      </Host>
    </Engine>
  </Service>
</Server>
```

이 구성을 tomcat1, tomcat2에 맞게 각각 작성하면, 두개의 인스턴스를 구동하고 cluster를 확인할 수 있습니다.

### Tomcat 클러스터 구성

톰캣에서 기본으로 제공하고 유일한 멀티캐스트 기반 TCP 클러스터를 사용해 봅니다.

server.xml에서 Engine항목에 구성을 추가합니다.
```xml
<!-- 생략 -->
    <Engine name="Catalina" defaultHost="localhost" jvmRoute="jvm1">
<!-- 생략 -->
      <Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"/>
<!-- 생략 -->
    </Engine>
<!-- 생략 -->
```

### 애플리케이션 배포 시나리오

지금까지의 구성을 통해서는 tomcat1, tomcat2 인스턴스에 각각 webapps 경로에 애플리케이션을 배포해야 합니다.

만약 두개의 애플리케이션이 동일한 애플리케이션을 사용하고 같이 배포되어야 한다면, 앞서 준비한 cluster_domain/webapps 에 애플리케이션을 넣어주고,
server.xml의 Host항목에 appBase를 "../../webapps" 형태로 해주면 됩니다.

단, tomcat의 manager같은 경우 앞단의 load balancer를 타고 들어갈 때, 구성이 좀 까다로워지는 관계로 저는 인스턴스별로 애플리케이션이 배포되도록 했습니다.

단, 형태를 domain/webapps에 원본을 두고, 인스턴스는 symbolic link를 사용하는 꼼수를 좀 사용했구요.

### 테스트 애플리케이션 준비

클러스터링을 활용하는 애플리케이션은 아래 두 파일을 가지는 간단한 예제로 확인할 수 있습니다.

index.jsp
```jsp
<%@page contentType="text/html; charset=UTF-8" %>
<%
if ( request.getParameter("name") != null ) {
    session.setAttribute("name", request.getParameter("name"));
}
%>
<%=session.getAttribute("name") %>
<form method="POST">
    <input type="text" name="name" />
    <input type="submit" />
</form>
```

web.xml
```xml
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd"
         version="2.4" xmlns="http://java.sun.com/xml/ns/j2ee">
    <distributable />
</web-app>
```

distributable 항목을 넣어야 cluster환경에서 쓸 수 있습니다. 그리고 물론 session에 주입하는 객체는 serializable을 구현하도록해야 하고.

이 앱을 준비한 후, http://localhost:18080/test/index.jsp http://localhost:28080/test/index.jsp 형태로 호출하여 세션이 공유되는 것을 확인할 수 있습니다.

### Apache mod_proxy_jk 세팅

클러스터된 애플리케이션에 아파치가 밸런싱하여 가는 구성과 각각의 서버로 가능 구성은 각각 아래와 같습니다.

```
# 로드 밸런싱 구성
<Proxy balancer://cluster>
BalancerMember ajp://localhost:18009 loadfactor=1
BalancerMember ajp://localhost:28009 loadfactor=1
ProxySet lbmethod=bytraffic
</Proxy>

# 로드 밸런서로 보내기
ProxyPass /clusteredapp balancer://cluster/clusteredapp
ProxyPassReverse /clusteredapp balancer://cluster/clusteredapp

# 개별 서버로 보내기
ProxyPass /tomcat1-manager ajp://localhost:18009/tomcat1-manager
ProxyPassReverse /tomcat1-manager ajp://localhost:18009/tomcat1-manager
ProxyPass /tomcat2-manager ajp://localhost:28009/tomcat2-manager
ProxyPassReverse /tomcat2-manager ajp://localhost:28009/tomcat2-manager
```
