---
# Title of your post. If not set, filename will be used.
title: "WLST로 DataSource 생성하기."
date: 2010-12-15T17:50:00+09:00
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

이번에 웹로직으로 웹프로젝트를 하면서, JDBC 정보를 프로그램에 녹여볼 생각을 했습니다.

예전에 Oracle WAS의 경우 Oracle WAS Deployment Descriptor중 data-sources.xml을 활용하여 애플리케이션 배포에 JDBC정보를 넣어 배포를 했었는데, 웹로직은 약간 달랐습니다.( 그리고 웹로직의 버저닝을 사용하니 뭔가 좀 더 달라지는 듯 했습니다. )

그래서, 애플리케이션 소스에는 넣지 못하더라도, 배포 가능한 소스로 해보고자 방법을 찾던 중 WLST를 사용하는 방법의 예제를 찾았습니다.

그래서 그 방법으로 하기로 하고 아래와 같은 스크립트로 한번에 DataSource를 생성하였습니다.

```python
import sys
from java.lang import System

# function definition BEGIN

# defining addJDBC function
def addJDBC(obj, servers):
    print("")
    print("*** Creating JDBC  ")
    
    # Create the Connection Pool.  The system resource will have
    # generated name of 'PoolName'+"-jdbc"
    
    myResourceName = obj["PoolName"]
    print("Here is the Resource Name: " + myResourceName)
    
    jdbcSystemResource = create(myResourceName,"JDBCSystemResource")
    myFile = jdbcSystemResource.getDescriptorFileName()
    print ("HERE IS THE JDBC FILE NAME: " + myFile)
    
    jdbcResource = jdbcSystemResource.getJDBCResource()
    jdbcResource.setName(obj["PoolName"])
    
    # Create the DataSource Params
    dpBean = jdbcResource.getJDBCDataSourceParams()
    myName=obj["JNDIName"]
    dpBean.setJNDINames([myName])
    
    # Create the Driver Params
    drBean = jdbcResource.getJDBCDriverParams()
    drBean.setPassword(obj["Password"])
    drBean.setUrl(obj["URLName"])
    drBean.setDriverName(obj["DriverName"])
    
    propBean = drBean.getProperties()
    driverProps = Properties()
    driverProps.setProperty("user",obj["UserName"])
    
    e = driverProps.propertyNames()
    while e.hasMoreElements() :
        propName = e.nextElement()
        myBean = propBean.createProperty(propName)
        myBean.setValue(driverProps.getProperty(propName))
        print myBean
        
        # Create the ConnectionPool Params
        ppBean = jdbcResource.getJDBCConnectionPoolParams()
        
        ppBean.setInitialCapacity(int(obj["InitialCapacity"]))
        ppBean.setMaxCapacity(int(obj["MaxCapacity"]))
        ppBean.setCapacityIncrement(int(obj["CapacityIncrement"]))
        
        if not obj["ShrinkPeriodMinutes"] == None:
            ppBean.setShrinkFrequencySeconds(int(obj["ShrinkPeriodMinutes"]))
        if not obj["TestTableName"] == None:
            ppBean.setTestConnectionsOnReserve(1)
            ppBean.setTestTableName(obj["TestTableName"])
        if not obj["LoginDelaySeconds"] == None:
            ppBean.setLoginDelaySeconds(int(obj["LoginDelaySeconds"]))

        # Adding KeepXaConnTillTxComplete to help with in-doubt transactions.
        xaParams = jdbcResource.getJDBCXAParams()
        xaParams.setKeepXaConnTillTxComplete(1)

        # Add Target
        
        for servername in servers:
            jdbcSystemResource.addTarget(getMBean("/Servers/" + servername))

# function definition END


print "@@@ Starting the script ..."


url = 't3://localhost:7001'
usr = 'weblogic'
password = 'welcome'
servernames = ['AdminServer', 'SSO1', 'SSO2']

connect(usr,password, url)

for servername in servernames:
    servermb=getMBean("Servers/" + servername)
    if servermb is None:
       print '@@@ No server MBean found'
       exit()

edit()
startEdit()

DB1 = {
    'PoolName' : 'DataSource for DGKIM',
    'JNDIName' : 'jdbc/dgkim',
    'Password' : 'password',
    'URLName' : 'jdbc:oracle:thin:@db.dgkim.net:1521:DGKIM',
    'DriverName' : 'oracle.jdbc.OracleDriver',
    'UserName' : 'dgkim',
    'InitialCapacity' : '20',
    'MaxCapacity' : '100',
    'CapacityIncrement' : '10',
    'ShrinkPeriodMinutes' : None,
    'TestTableName' : 'DUAL',
    'LoginDelaySeconds' : None
}

addJDBC(DB1, servernames)

save()
activate(block="true")

exit()
```

저는 프로젝트 특성상 하나의 DB가 아닌 여러개의 DB를 사용하게 됩니다. 위 예제에서는 DB1이란 것을 사용했지만, 실제로는 8개의 DB에 접속하는 프로그램을 작성했습니다.

그래서 위 코드를 만들고, 개발 서버냐 운용 서버냐에 따라 url과 servernames를 수정하여 한번에 데이터 소스를 작성해서 편리했습니다.
