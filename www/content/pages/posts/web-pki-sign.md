---
# Title of your post. If not set, filename will be used.
title: "브라우저에서 제공하는 기능(javascript)으로 전자서명하기."
date: 2011-02-19T19:20:00+09:00
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

브라우저에서 제공하는 기능(javascript)으로 전자서명하기.

```html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="ko-KR">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>전자서명 테스트</title>
  <script language="javascript" type="text/javascript" src="js/sign.js"></script>
</head>
<body>
  <h2>전자서명 테스트</h2>
  <form name="form0" action="#">
    서명을 위한 원문<br />
    <textarea id="plain" type="text" name="plain"></textarea><br />
    <input type="button" onclick="document.getElementById('signed_msg').value = signDigest(document.getElementById('plain').value);" value="전자서명" /><br />
    <hr />
    전자서명문<br />
    <textarea id="signed_msg"></textarea>
  </form>
</body>
</html>
```

위에 포함된. sign.js 파일
```javascript
function signDigest(text) {
    if ( window.event ) {
        window.event.cancelBubble = true;
    }

    var dest = sign(text); //TODO
    //alert(dest);
    return dest;
}

// CAPICOM constants
var CAPICOM_STORE_OPEN_READ_ONLY = 0;
var CAPICOM_CURRENT_USER_STORE = 2;
var CAPICOM_CERTIFICATE_FIND_SHA1_HASH = 0;
var CAPICOM_CERTIFICATE_FIND_EXTENDED_PROPERTY = 6;
var CAPICOM_CERTIFICATE_FIND_TIME_VALID = 9;
var CAPICOM_CERTIFICATE_FIND_KEY_USAGE = 12;
var CAPICOM_DIGITAL_SIGNATURE_KEY_USAGE = 0x00000080;
var CAPICOM_AUTHENTICATED_ATTRIBUTE_SIGNING_TIME = 0;
var CAPICOM_INFO_SUBJECT_SIMPLE_NAME = 0;
var CAPICOM_ENCODE_BASE64 = 0;
var CAPICOM_E_CANCELLED = -2138568446;
var CERT_KEY_SPEC_PROP_ID = 6;

function IsCAPICOMInstalled() {
    if ( typeof(oCAPICOM) == 'object' ) {
        if( ( oCAPICOM.object != null ) ) {
            // We found CAPICOM!
            return true;
        }
    }
}

function FindCertificateByHash() {
    try {
        // instantiate the CAPICOM objects
        var MyStore = new ActiveXObject('CAPICOM.Store');
        // open the current users personal certificate store
        MyStore.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_READ_ONLY);

        // find all of the certificates that have the specified hash
        var FilteredCertificates = MyStore.Certificates.Find(CAPICOM_CERTIFICATE_FIND_SHA1_HASH, strUserCertigicateThumbprint);

        var Signer = new ActiveXObject('CAPICOM.Signer');
        Signer.Certificate = FilteredCertificates.Item(1);
        return Signer;

        // Clean Up
        MyStore = null;
        FilteredCertificates = null;
    } catch ( e ) {
        if (e.number != CAPICOM_E_CANCELLED) {
            return new ActiveXObject('CAPICOM.Signer');
        }
    }
}

function sign(src) {
    if ( window.crypto && window.crypto.signText ) {
        return sign_NS(src);
    }

    return sign_IE(src);
}

function sign_NS(src) {
    var s = crypto.signText(src, 'ask' );
    return s;
}

function sign_IE(src) {
    try {
        // instantiate the CAPICOM objects
        var SignedData = new ActiveXObject('CAPICOM.SignedData');
        var TimeAttribute = new ActiveXObject('CAPICOM.Attribute');

        // Set the data that we want to sign
        SignedData.Content = src;
        var Signer = FindCertificateByHash();

        // Set the time in which we are applying the signature
        var Today = new Date();
        TimeAttribute.Name = CAPICOM_AUTHENTICATED_ATTRIBUTE_SIGNING_TIME;
        TimeAttribute.Value = Today.getVarDate();
        Today = null;
        Signer.AuthenticatedAttributes.Add(TimeAttribute);

        // Do the Sign operation
        var szSignature = SignedData.Sign(Signer, true, CAPICOM_ENCODE_BASE64);
        return szSignature;
    } catch ( e ) {
        if (e.number != CAPICOM_E_CANCELLED) {
            alert('An error occurred when attempting to sign the content, the errot was: ' + e.description);
        }
    }
    return '';
}
```

위 함수를 사용하면 PKCS#7 으로 인코딩된 전자서명문을 생성할 수 있으며, 서버에서는 bouncy castle라이브러리 등을 통해서 검증을 할 수 있습니다.

crypto.signText 문법
```
Syntax
crypto.signText
   (text, selectionStyle [, authority1 [, ... authorityN]])

Parameters
text
    A string evaluating to the text you want a user to sign.
selectionStyle
    A string evaluating to either of the following:
        * ask specifies that a dialog box will present a user with a list of possible certificates.
        * auto specifies that Navigator automatically selects a certificate from authority1 through authorityN.
authority1... authorityN
    Optional strings evaluating to Certificate Authorities accepted by the server using the signed text.
```