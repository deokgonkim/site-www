---
# Title of your post. If not set, filename will be used.
title: "gcc로 몇가지 연습 -c -S -E"
date: 2013-01-03T19:50:00+09:00
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

gcc로 c언어 컴파일을 몇 가지 실습해 보았습니다.

### -c 옵션

gcc 명령에 -c 옵션을 주면, .c파일을 컴파일만하고 링크를 하지 않습니다. 결과물로는 .o 파일이 생성됩니다.

test.c 파일
```c
int test(int a, int b) {
    return a + b;
}

int main(int argc, char* argv[]) {
    test(3,4);
    return 0;
}
```

```bash
[dgkim@dgkim asm]$ ls -al
합계 12
drwxr-xr-x   2 dgkim users 4096 2013-01-03 19:37 .
drwxrwxrwt. 18 root  root  4096 2013-01-03 19:34 ..
-rw-r--r--   1 dgkim users  112 2013-01-03 18:12 test.c
[dgkim@dgkim asm]$ gcc -c test.c
[dgkim@dgkim asm]$ ls -l
합계 8
-rw-r--r-- 1 dgkim users  112 2013-01-03 18:12 test.c
-rw-r--r-- 1 dgkim users 1464 2013-01-03 19:37 test.o
[dgkim@dgkim asm]$
```

-c 옵션으로 생성된 .o 파일을 gcc를 통해 링크하려면 아래와 같이 할 수 있습니다.
여러 개의 .c 파일을 가지는 프로그램 및 링크 과정 및 순서에 따라, -c 옵션으로 컴파일만하고, 마지막에 .o 파일들을 묶는 일은 자주 있을 것입니다.
```bash
[dgkim@dgkim asm]$ gcc -o test test.o
[dgkim@dgkim asm]$ ls -l
합계 16
-rwxr-xr-x 1 dgkim users 6379 2013-01-03 19:39 test
-rw-r--r-- 1 dgkim users  112 2013-01-03 18:12 test.c
-rw-r--r-- 1 dgkim users 1464 2013-01-03 19:37 test.o
[dgkim@dgkim asm]$
```

### -S 옵션

gcc에서 -S 옵션을 주고 실행하면, .c파일에서 .s파일, 즉 어셈블러 소스가 생성됩니다.

```bash
[dgkim@dgkim asm]$ ls -al
합계 28
drwxr-xr-x   2 dgkim users 4096 2013-01-03 19:41 .
drwxrwxrwt. 18 root  root  4096 2013-01-03 19:39 ..
-rwxr-xr-x   1 dgkim users 6379 2013-01-03 19:39 test
-rw-r--r--   1 dgkim users  112 2013-01-03 18:12 test.c
-rw-r--r--   1 dgkim users 1464 2013-01-03 19:37 test.o
-rw-r--r--   1 dgkim users  807 2013-01-03 19:41 test.s
[dgkim@dgkim asm]$
```

위의 간단하고 짧던 .c 파일은 아래와 같은 복잡한 .s 파일을 만들었습니다.

```asm
        .file   "test.c"
        .text
.globl test
        .type   test, @function
test:
.LFB0:
        .cfi_startproc
        pushq   %rbp
        .cfi_def_cfa_offset 16
        .cfi_offset 6, -16
        movq    %rsp, %rbp
        .cfi_def_cfa_register 6
        movl    %edi, -4(%rbp)
        movl    %esi, -8(%rbp)
        movl    -8(%rbp), %eax
        movl    -4(%rbp), %edx
        leal    (%rdx,%rax), %eax
        leave
        .cfi_def_cfa 7, 8
        ret
        .cfi_endproc
.LFE0:
        .size   test, .-test
.globl main
        .type   main, @function
main:
.LFB1:
        .cfi_startproc
        pushq   %rbp
        .cfi_def_cfa_offset 16
        .cfi_offset 6, -16
        movq    %rsp, %rbp
        .cfi_def_cfa_register 6
        subq    $16, %rsp
        movl    %edi, -4(%rbp)
        movq    %rsi, -16(%rbp)
        movl    $4, %esi
        movl    $3, %edi
        call    test
        movl    $0, %eax
        leave
        .cfi_def_cfa 7, 8
        ret
        .cfi_endproc
.LFE1:
        .size   main, .-main
        .ident  "GCC: (GNU) 4.4.6 20120305 (Red Hat 4.4.6-4)"
        .section        .note.GNU-stack,"",@progbits
```

### -E 옵션

gcc에서 -E 옵션을 주면, preprocessor 처리가 된 c파일의 내용을 볼 수 있습니다.

preprocessor 처리를 위해서 test.c 파일에서 #define 사용하여 작은 수정을 한 결과입니다.

```bash
[dgkim@dgkim asm]$ cat test.c
#define a alpha
#define b bravo

int test(int a, int b) {
    return a + b;
}

int main(int argc, char* argv[]) {
    test(3,4);
    return 0;
}
[dgkim@dgkim asm]$ gcc -E test.c
# 1 "test.c"
# 1 "&lt;built-in&gt;"
# 1 "&lt;command-line&gt;"
# 1 "test.c"



int test(int alpha, int bravo) {
    return alpha + bravo;
}

int main(int argc, char* argv[]) {
    test(3,4);
    return 0;
}
[dgkim@dgkim asm]$
```

ps. 다음에는 -m32 옵션을 통해서 x86_64 머신에서 x86 i686용 빌드를 테스트한 글을 올려볼까요? glibc-devel.i686
ps2. 그리고, gdb를 통해서 위 파일을 디버깅하였는데, 그 글도 올려볼까요?
