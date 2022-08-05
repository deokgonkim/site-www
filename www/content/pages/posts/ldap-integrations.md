---
# Title of your post. If not set, filename will be used.
title: "LDAP 을 사용하여 계정관리 통합하기"
date: 2010-07-02T16:11:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "ldap"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

Directory Server를 구축하여, 여러 가지 애플리케이션의 인증 관리를 통합할 수 있습니다.

저는 <strong>uid={id},ou=Users,dc=dgkim,dc=net</strong> 이란 이름의 인증 디렉토리를 구축하여 사용할 수 있습니다.

그리고, 아래와 같은 로그인에 LDAP의 ID, Password를 활용하고 있습니다.

### 웹애플리케이션 인증
JAAS를 활용하여 인증에 LDAP을 사용하고 있습니다.

#### 서블릿 웹 모듈에서 JAAS 활용하기
아래 web.xml 설정을 통해서 웹모듈에서 컨테이너가 제공하는 UserPrincipal 과 Role 정보를 활용할 수 있습니다.

web.xml : admin, user 롤을 정의하고, user 롤에 속하는 사용자가 사용할 수 있도록 구성.
```xml
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         version="2.5" xmlns="http://java.sun.com/xml/ns/javaee">
    <login-config>
        <auth-method>FORM</auth-method>
        <form-login-config>
            <form-login-page>/login_form.jsp</form-login-page>
            <form-error-page>/login_error.jsp</form-error-page>
        </form-login-config>
    </login-config>
    <security-role>
        <role-name>Admin</role-name>
    </security-role>
    <security-role>
        <role-name>User</role-name>
    </security-role>
    <security-constraint>
        <web-resource-collection>
            <web-resource-name>test web application</web-resource-name>
            <url-pattern>/*</url-pattern>
        </web-resource-collection>
        <auth-constraint>
            <role-name>User</role-name>
        </auth-constraint>
    </security-constraint>
</web-app>
```

그리고, request.getUserPrincipal() 을 호출하면, 로그인에 사용한 ID를 추출할 수 있으며, request.isUserInRole("User") 형태로 사용자가 특정 롤을 가지는지 확인할 수 있습니다.

#### OC4J 10.1.3에서 JAAS 서비스를 제공하는 구성
OC4J에서 컨테이너의 보안 제공자와 서블릿간의 연동을 위한 정보를 구성합니다.

컨테이너 보안 제공자에서 제공하는 사용자, 그룹 정보를 서블릿의 UserPrincipal, Role 정보와 매핑해 줍니다.

```xml
<?xml version="1.0"?>

<orion-application  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://xmlns.oracle.com/oracleas/schema/orion-application-10_0.xsd"  deployment-version="10.1.3.3.0" default-data-source="jdbc/OracleDS" component-classification="external"
  schema-major-version="10" schema-minor-version="0" >
        <web-module id="certmanager" path="certmanager.war" />
        <persistence path="persistence" />
        <jazn provider="XML" >
                <property name="custom.ldap.provider" value="true" />
        </jazn>
        <jazn-loginconfig>
                <application>
                        <name>bisu</name>
                        <login-modules>
                                <login-module>
                                        <class>oracle.security.jazn.login.module.LDAPLoginModule</class>
                                        <control-flag>required</control-flag>
                                        <options>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.user.object.class</name>
                                                        <value>inetOrgPerson</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.provider.connect.pool</name>
                                                        <value>true</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.provider.type</name>
                                                        <value>Other</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.provider.credential</name>
							<value>{password}</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.provider.url</name>
                                                        <value>ldap://localhost:389</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.role.searchscope</name>
                                                        <value>onelevel</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.user.searchscope</name>
                                                        <value>onelevel</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.role.searchbase</name>
                                                        <value>ou=Groups,dc=dgkim,dc=net</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.user.searchbase</name>
                                                        <value>ou=Users,dc=dgkim,dc=net</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.role.object.class</name>
                                                        <value>groupOfUniqueNames</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.role.name.attribute</name>
                                                        <value>cn</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.provider.user</name>
                                                        <value>uid=Administrator,ou=Users,dc=dgkim,dc=net</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.user.name.attribute</name>
                                                        <value>uid</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.membership.searchscope</name>
                                                        <value>direct</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.lm.cache_enabled</name>
                                                        <value>false</value>
                                                </option>
                                                <option>
                                                        <name>oracle.security.jaas.ldap.member.attribute</name>
                                                        <value>uniqueMember</value>
                                                </option>
                                        </options>
                                </login-module>
                        </login-modules>
                </application>
        </jazn-loginconfig>
        <log>
                <file path="application.log" />
        </log>
</orion-application>
```

#### 웹로직 보안제공자를 사용한 LDAP인증
웹로직에서 도메인 단위 보안제공자에서 LDAP 인증을 활용하는 방법을 설명합니다.

웹로직 콘솔에서 LDAP 로그인 모듈 등록하기


  - 보안영역 선택
  - Realm 선택(기본 myrealm)
  - 제공자 탭의 인증 탭 선택
  - 새로만들기
  - 이름을 주고, 유형을 LDAPAuthenticator 선택
  - 생성한 제공자 선택
  - 구성 탭의 제공자별 탭 선택
  - LDAP 정보 등록 : 호스트, 포트, 사용자 기본 DN, 그룹 기본 DN
  - 구성 탭의 공통 탭 선택
  - 콘트롤 플래그를 SUFFICIENT 선택
  - 제공자 탭의 인증 탭으로 이동
  - 순서 재지정 선택
  - 생성한 제공자를 최상위로 이동
  - 도메인 내의 서버를 재시작

위 구성을 하면, LDAP 인증을 먼저 수행하고, weblogic의 내장 사용자를 검색하게 됩니다.

아래는 웹모듈에서 위에서 지정한 JAAS를 활용하는 것에 대한 구성파일입니다.

weblogic.xml : admin 롤에 대한 사용자 및 그룹을 Administrators로 지정. ( LDAP에 그룹이 Administrators인 경우 admin 롤을 가짐 )
```xml
<weblogic-web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  xsi:schemaLocation="http://www.bea.com/ns/weblogic/weblogic-web-app http://www.bea.com/ns/weblogic/weblogic-web-app/1.0/weblogic-web-app.xsd"
                  xmlns="http://www.bea.com/ns/weblogic/weblogic-web-app">
  <security-role-assignment>
    <role-name>Admin</role-name>
    <principal-name>Administrators</principal-name>
  </security-role-assignment>
</weblogic-web-app>
```

#### Tomcat 보안제공자를 사용한 LDAP인증
Tomcat에서 LDAP 인증을 활용하는 방법을 설명합니다.

Tomcat에서 server.xml 내부의 Engine설정 항목에 Realm 항목의 설정을 통해서 설정할 수 있습니다.
아래는 기본 설정의 내용입니다.
```xml
    <Engine name="Catalina" defaultHost="localhost">

      <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
             resourceName="UserDatabase"/>
```
위 구성은 기본적으로 제공되는 파일기반 보안 제공자를 사용하는 예입니다.

해당 보안제공자는 conf/tomcat-users.xml 파일에서 정의되어 있습니다.

아래 구성은 tomcat-users.xml과 추가로 LDAP 인증을 같이 사용하는 예제입니다.

```xml
    <Engine name="Catalina" defaultHost="localhost">

      <Realm className="org.apache.catalina.realm.CombinedRealm">
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
        <Realm className="org.apache.catalina.realm.JNDIRealm"
               connectionURL="ldap://localhost:389"
               userPattern="uid={0},ou=Users,dc=dgkim,dc=net"
               roleBase="ou=Groups,dc=dgkim,dc=net"
               roleName="cn"
               roleSearch="(uniqueMember={0})"/>
      </Realm>
```

위 구성을 하면, LDAP에 기록된 인증정보와 tomcat-users.xml에 정의된 인증정보를 사용할 수 있습니다.

아래는 웹모듈에서 위에서 지정한 JAAS를 활용하는 것에 대한 구성파일입니다.
( weblogic이나 oc4j와 달리 서블릿컨테이너 디플로이먼트 디스크립터를 사용하지 않고, 표준 디스크립터를 통해서 바로 사용가능합니다. )
/* 즉, 모든 리소스는 Users롤을 가진 사용자(ldap에서는 그룹)가 접근할 수 있도록 한 예입니다.
```xml
<web-app>
    <login-config>
        <auth-method>BASIC</auth-method>
    </login-config>
    <security-role>
        <role-name>Users</role-name>
    </security-role>
    <security-constraint>
        <web-resource-collection>
            <web-resource-name>allresources</web-resource-name>
            <url-pattern>/*</url-pattern>
        </web-resource-collection>
        <auth-constraint>
            <role-name>Users</role-name>
        </auth-constraint>
    </security-constraint>
</web-app>
```

### TRAC 인증
Trac에 로그인 모듈은 Apache의 mod_auth_ldap을 사용하면 LDAP으로 로그인을 할 수 있습니다.

```
<Location /trac>
   SetHandler mod_python
   PythonInterpreter main_interpreter
   PythonHandler trac.web.modpython_frontend
   PythonOption TracEnvParentDir /TRAC
   PythonOption TracLocale ko_KR.utf8
   PythonOption TracUriRoot /trac

   AuthType Basic
   AuthName "LDAP Authentication Information"
   AuthBasicProvider "ldap"
   AuthLDAPURL "ldap://localhost:389/ou=Users,dc=dgkim,dc=net?uid?sub?(objectClass=*)"
   AuthzLDAPAuthoritative Off
   Require valid-user
</Location>
```

### SVN 레포지토리 인증
Trac과 마찬가지로 mod_auth_ldap 모듈을 통해 LDAP 인증을 수행할 수 있습니다.

```
<Location /repository1>
    DAV svn
    SVNPath /repository1
    AuthType Basic
    AuthName "LDAP Authentication Information"
    AuthBasicProvider ldap
    AuthLDAPURL "ldap://localhost:389/ou=Users,dc=dgkim,dc=net?uid?sub?(objectClass=*)"
    AuthzLDAPAuthoritative Off
    Require valid-user
</Location>
```

### MAIL 등 네트워크 서비스 인증

Cyrus IMAP 등 유닉스 기반의 네트워크 서비스들은 기본적으로 LDAP을 통한 인증이 가능하도록 준비되어 있습니다.
아래는 Cyrus IMAP에서 사용하는 SASL 인증용 설정 파일 내용입니다.
```
ldap_servers: ldap://127.0.0.1/
ldap_bind_dn: uid=Administrator, ou=Users, dc=dgkim, dc=net
ldap_bind_pw: {password}
ldap_default_domain: dgkim.net
ldap_search_base: ou=Users, dc=dgkim, dc=net
ldap_filter: (uid=%U)
```

Thunderbird에서 LDAP을 등록하면, 주소록 검색에도 활용할 수 있고, 만약 LDAP에 인증서가 등록되어 있다면, 보안메일 발송시에 Thunderbird가 자동으로 인증서를 검색해주는 특징도 활용할 수 있습니다.

### OS 리눅스 인증

LDAP을 심지어 OS인증에도 사용할 수 있습니다.
<del datetime="2010-08-01T04:33:06+00:00">Ubuntu linux에 LDAP 인증을 세팅해 본적이 있는데, 현재는 해당 시스템이 없어 설정을 소개할 수 없네요.</del>

최근에 whity 마련과 함께 OS 인증을 테스트하였습니다.

ubuntu 에서 아래 명령으로 패키지 설치 만으로 어렵지 않게 세팅되었습니다. ( 단, 너무 간단하게 해버려서 상관관계는 잘 모르겠습니다. )

```
apt-get install libpam-ldapd
```

위 명령을 치면 libpam-ldapd 패키지와 함께 libnss-ldapd nscd nslcd 패키지가 추가로 설치됩니다.
설치후 기본적인 LDAP 정보만 알려주면 쉽게 사용할 수 있습니다. ( 심지어 search base도 일일이 지정할 필요가 없이, root dn만 주고 사용중입니다. )

### 그밖에...

LDAP 서버를 구축해 두면, 다양한 프로그램에서 인증에 활용할 수 있습니다. 본 블로그의 경우도 Wordpress에 LDAP 플러그인을 설치하여, 로그인에 LDAP 서버를 통하고 있습니다.
