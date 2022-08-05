---
# Title of your post. If not set, filename will be used.
title: "파이어폭스에서 드래그앤드롭으로 파일업로드 구현하기"
date: 2012-05-21T16:22:00+09:00
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

파이어폭스에서는 파일업로드를 드래그앤드롭으로 할 수 있습니다.

3.6 버전에서부터 지원했던 것 같습니다.

자바스크립트와 Spring 프레임워크를 사용해서 간단하게 파일 업로드 프로그램을 작성해 보았습니다.

### HTML + JavaScript 업로드 구현부분 UI

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>파일업로드</title>
</head>
<body>
    <form name="form0" action="file/upload" method="POST" enctype="multipart/form-data">
        <ul>
            <li>파일 하나 업로드 : <input id="file1" type="file" name="file" /></li>
            <li>여러 파일 업로드 : <input id="file2" type="file" name="multifile" multiple /></li>
            <li>파일을 선택하고 '전송'을 눌러 업로드하시거나, 탐색기에서 파일을 드래그앤드롭하여 업로드할 수 있습니다. 드래그앤드롭은 '전송'을 누르는 것이 아니라 드롭시점에 바로 업로드됩니다.</li>
        </ul>
        <input type="submit" value="전송"/>
    </form>
    <script type="text/javascript">
    var dropzone1 = document.getElementById('file1');
    var dropzone2 = document.getElementById('file2');
    setDnDhandler(dropzone1);
    setDnDhandler(dropzone2);
    
    function setDnDhandler(obj) {
        obj.addEventListener("dragover", function(event) {
            event.preventDefault();
        }, true);
        obj.addEventListener("drop", function(event) {
            event.preventDefault();
            var allTheFiles = event.dataTransfer.files;
            for (var i=0; i<allTheFiles.length; i++) {
                var element = document.createElement('div');
                element.id = 'f' + i;
                document.body.appendChild(element);
                sendFile(allTheFiles[i], element.id);
            }
        }, true);
    }
    function sendFile(file, fileId) {
        var xhr = new XMLHttpRequest();
        
        xhr.upload.addEventListener("progress", function(e) {
                if (e.lengthComputable) {
                    var percentage = Math.round((e.loaded * 100) / e.total);
                    document.getElementById(fileId).innerHTML = file.name + ' - ' + percentage + '%';
                }
            }, false);
        xhr.onreadystatechange = function() {  
            if (xhr.readyState == 4 && xhr.status == 200) {
                alert(xhr.responseText);
            }
        };
        xhr.upload.addEventListener("load", function(e){
                document.getElementById(fileId).innerHTML = file.name + ' - uploaded';
            }, false);
        xhr.open("POST", "file/upload");
        var fd = new FormData();
        fd.append("file", file);
        xhr.send(fd);
    }
    </script>
</body>
</html>
```

드래그앤드롭을 사용할 때, 드롭될 영역의 경우는 input형이 아니라도 가능하지만, 일반 HTML전송도 가능하게 예제를 작성하고자 input을 사용하였습니다.

드래그앤드롭을 지원하는 부분은 addEventListener 부분입니다. "dragover", "drop" 이벤트에 대하여 기본동작을 막고, 자바스크립트처리를 할 수 있도록 하였습니다.

파이어폭스에서 input에 type이 file이면, 기본동작이 파일이 업로드를 위해 준비됩니다. IE의 경우는 그 동작조차 없으며, 파일 열기가 수행되지요.

drop이벤트에서 XMLHttpRequest를 통해 AJAX업로드를 합니다.

"xhr.upload.addEventListener("progress", ...);" 부분은 업로드 처리 경과를 확인할 수 있는 기능입니다. 업로드된 양을 퍼센트로 출력해 줍니다.

### 서버에서 파일 받기

```java
package test.control;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
@RequestMapping("/file")
public class FileController {
    
    @RequestMapping("upload")
    public @ResponseBody String upload(HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        if (! (request instanceof MultipartHttpServletRequest)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Expected multipart request");
            return null;
        }
        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
        for ( String fileName : multipartRequest.getFileMap().keySet() ) {
            for ( MultipartFile file : multipartRequest.getFiles(fileName) ) {
                String originalFileName = file.getOriginalFilename();
                File destination = File.createTempFile("file", originalFileName, new File("/var/dgkim"));
            }
        }
        return "success";
    }
}
```

스프링 MVC 프레임워크를 통해, 저수준의 파일 처리부분은 빠지고 실제 파일명과 File객체 처리를 바로 할 수 있습니다.

위 예에서는 의미없이 임시 파일만 생성했으나, 필요에 따라 처리를 작성할 수 있겠습니다.

서버측 라이브러리는 Maven으로 관리하였으며, Spring 3.0외에 추가로 아래 의존성이 있습니다.

```xml
        <dependency>
            <groupId>commons-fileupload</groupId>
            <artifactId>commons-fileupload</artifactId>
            <version>1.2</version>
        </dependency>
        <dependency>
            <groupId>commons-io</groupId>
            <artifactId>commons-io</artifactId>
            <version>1.3</version>
        </dependency>
```

소스 다운로드 : <del>http://www.dgkim.net/dav/users/dgkim/fileuptest.zip</del>

참조

  - mozilla.or.kr http://hacks.mozilla.or.kr/2011/01/html5-%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%97%85%EB%A1%9C%EB%8D%94-%EA%B0%9C%EB%B0%9C-%EB%B0%A9%EB%B2%95/
  - mozilla.org https://developer.mozilla.org/en/using_files_from_web_applications
  - mozilla.org http://hacks.mozilla.org/2009/12/file-drag-and-drop-in-firefox-3-6/
  - toriworks.tistory.com http://toriworks.tistory.com/31
