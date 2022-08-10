---
# Title of your post. If not set, filename will be used.
title: "Openssl로 사설인증기관 만들기"
date: 2010-06-18T15:53:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "Open Source"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

Openssl을 사용하여 사설인증기관 및 사설인증 서비스를 구축할 수 있습니다.

인증기관 준비하기.

### 1. 인증기관용 디렉토리 생성.

아래와 같은 구조로 생성합니다.

```
./dgkim.net # 인증기관 디렉토리
./dgkim.net/certs # 인증서 저장 디렉토리
./dgkim.net/crl # CRL 저장 디렉토리
./dgkim.net/crl.pem # CRL 파일 - 빈파일
./dgkim.net/crlnumber # CRL 넘버 파일 - 초기 00 입력
./dgkim.net/index.txt # 인증서 데이터베이스 인덱스 파일 - 빈파일
./dgkim.net/index.txt.attr # 빈파일
./dgkim.net/newcerts # 신규 발급된 인증서 저장 디렉토리
./dgkim.net/private # 개인키 디렉토리
./dgkim.net/serial # 인증서 시리얼넘버 파일 - 초기 00 입력
```

### 2. openssl.cnf 생성

아래는 제가 사용하는 설정파일입니다.

```
HOME                    = .
RANDFILE                = $ENV::HOME/.rnd

[ ca ]
default_ca      = CA_default            # The default ca section

[ CA_default ]

dir             = ./dgkim.net           # Where everything is kept
certs           = $dir/certs            # Where the issued certs are kept
crl_dir         = $dir/crl              # Where the issued crl are kept
database        = $dir/index.txt        # database index file.
#unique_subject = no                    # Set to 'no' to allow creation of
                                        # several ctificates with same subject.
new_certs_dir   = $dir/newcerts         # default place for new certs.

certificate     = $dir/cacert.pem       # The CA certificate
serial          = $dir/serial           # The current serial number
crlnumber       = $dir/crlnumber        # the current crl number
                                        # must be commented out to leave a V1 CRL
crl             = $dir/crl.pem          # The current CRL
private_key     = $dir/private/cakey.pem# The private key
RANDFILE        = $dir/private/.rand    # private random number file

x509_extensions = usr_cert              # The extentions to add to the cert

# Comment out the following two lines for the "traditional"
# (and highly broken) format.
name_opt        = ca_default            # Subject Name options
cert_opt        = ca_default            # Certificate field options

default_days    = 365                   # how long to certify for
default_crl_days= 30                    # how long before next CRL
default_md      = sha1                  # which md to use.
preserve        = no                    # keep passed DN ordering

policy          = policy_match

[ policy_match ]
countryName             = match
stateOrProvinceName     = match
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ policy_anything ]
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ req ]
default_bits            = 2048
default_keyfile         = privkey.pem
distinguished_name      = req_distinguished_name
attributes              = req_attributes
x509_extensions = v3_ca # The extentions to add to the self signed cert

string_mask = default

[ req_distinguished_name ]
countryName                     = Country Name (2 letter code)
countryName_default             = KR
countryName_min                 = 2
countryName_max                 = 2

stateOrProvinceName             = State or Province Name (full name)
stateOrProvinceName_default     = Daegu

localityName                    = Locality Name (eg, city)

0.organizationName              = Organization Name (eg, company)
0.organizationName_default      = dgkim.net

# we can do this but it is not needed normally
#1.organizationName             = Second Organization Name (eg, company)
#1.organizationName_default     = World Wide Web Pty Ltd

organizationalUnitName          = Organizational Unit Name (eg, section)
#organizationalUnitName_default =

commonName                      = Common Name (eg, YOUR name)
commonName_max                  = 64

emailAddress                    = Email Address
emailAddress_max                = 64

[ req_attributes ]
challengePassword               = A challenge password
challengePassword_min           = 4
challengePassword_max           = 20

unstructuredName                = An optional company name

[ usr_cert ]

basicConstraints=CA:FALSE

nsComment                       = "OpenSSL Generated Certificate"

subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

crlDistributionPoints=@cdp_section

nsCaRevocationUrl               = ldap://home1.dgkim.net:389/cn=arldp1,ou=CA,o=dgkim.net,st=Daegu,c=KR
nsRevocationUrl                 = ldap://home1.dgkim.net:389/cn=crldp1,ou=CA,o=dgkim.net,st=Daegu,c=KR

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment

[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer:always
basicConstraints = CA:true

[ crl_ext ]
authorityKeyIdentifier=keyid:always,issuer:always

[ proxy_cert_ext ]
basicConstraints=CA:FALSE
nsComment                       = "OpenSSL Generated Certificate"
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer:always

[crldp1_section]

[cdp_section]
URI=ldap://home1.dgkim.net:389/cn=crldp1,ou=CA,o=dgkim.net,st=Daegu,c=KR
```

DN 값에 대한 설정과, CRL DP에 대한 설정을 조정하여 사용합니다.

### 3. 인증기관 인증서 생성

아래 스크립트와 같이 생성합니다.

```bash
$ openssl req -x509 -out dgkim.net/cacert.pem -keyout dgkim.net/private/cakey.pem -config openssl.cnf -new -days 3650
Generating a 2048 bit RSA private key
...+++
.....+++
writing new private key to 'dgkim.net/private/cakey.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [KR]:
State or Province Name (full name) [Daegu]:
Locality Name (eg, city) []:
Organization Name (eg, company) [dgkim.net]:
Organizational Unit Name (eg, section) []:
Common Name (eg, YOUR name) []:dgkim.net CA
Email Address []:
```
이 과정에서 인증기관 인증서와 인증기관 개인키가 생성됩니다.

### 4. 개인 인증서(혹은 서버인증서) 발급 신청

아래 명령으로 발급 신청을 생성할 수 있습니다.

```bash
$ openssl req -new -keyout dgkim/key.pem -out dgkim/req.pem -config openssl.cnf
Generating a 2048 bit RSA private key
................+++
.................................................................+++
writing new private key to 'dgkim\key.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [KR]:
State or Province Name (full name) [Daegu]:
Locality Name (eg, city) []:
Organization Name (eg, company) [dgkim.net]:
Organizational Unit Name (eg, section) []:
Common Name (eg, YOUR name) []:Deoggon Kim
Email Address []:dgkim@dgkim.net

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

### 5. 인증기관에서 인증서 발급하기.

4번 단계에서 생성한 인증서발급 요청은 아래 스크립트를 통해 인증서 발급이 이뤄 집니다.

```bash
$ openssl ca -config openssl.cnf -in dgkim/req.pem -out dgkim/cert.pem
Using configuration from openssl.cnf
Enter pass phrase for ./dgkim.net/private/cakey.pem:
Check that the request matches the signature
Signature ok
Certificate Details:
        Serial Number: 0 (0x0)
        Validity
            Not Before: Jun 18 06:37:25 2010 GMT
            Not After : Jun 18 06:37:25 2011 GMT
        Subject:
            countryName               = KR
            stateOrProvinceName       = Daegu
            organizationName          = dgkim.net
            commonName                = Deoggon Kim
            emailAddress              = dgkim@dgkim.net
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:FALSE
            Netscape Comment:
                OpenSSL Generated Certificate
            X509v3 Subject Key Identifier:
                06:BE:86:57:69:43:30:3D:15:CA:C2:B9:85:CB:5C:34:0D:CD:D2:D5
            X509v3 Authority Key Identifier:
                keyid:72:B5:1E:14:A7:E2:CE:D1:D9:79:0D:01:1E:3D:2D:82:26:48:2B:07

            X509v3 CRL Distribution Points:
                URI:ldap://home1.dgkim.net:389/cn=crldp1,ou=CA,o=dgkim.net,st=Daegu,c=KR

            Netscape CA Revocation Url:
                ldap://home1.dgkim.net:389/cn=arldp1,ou=CA,o=dgkim.net,st=Daegu,c=KR
            Netscape Revocation Url:
                ldap://home1.dgkim.net:389/cn=crldp1,ou=CA,o=dgkim.net,st=Daegu,c=KR
Certificate is to be certified until Jun 18 06:37:25 2011 GMT (365 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
```

이상 간단하게 인증기관 생성 및 인증서 발급을 하여 보았습니다.
