---
# Title of your post. If not set, filename will be used.
title: "전자 공부"
date: 2018-02-18T16:25:00+09:00
draft: true

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "electronics"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

전자각
1번째 전자각(1st shell) 2개의 전자를 가진다.
2번째 전자각(2nd shell) 8개의 전자를 가진다.
3번째 전자각(3rd shell) 18개의 전자를 가진다.
4번째 전자각(4th shell) 32개의 전자를 가진다.
식 : 2n^2개

2번째 전자각 부터는 sub 전자각이 있다.
2번째 전자각의 sub전자각 = 2e, 6e
3번째 전자각의 sub전자각 = 2e, 6e, 10e
4번째 전자각의 sub전자각 = 2e, 6e, 10e, 14e
sub전자각은 각 s, p, d, f로 나타낸다.

구리는 29번째 전자가 최외각에 있다?
즉, 2e + 8e + 18e + 1e(+ 31 empty slots)?

1A = 1초에 6.242E18개의 전자 이동.

6.242E18개의 전자가 가지는 전하량 1쿨롬(Q=Coulombs=C)
즉, 전자 1개의 전하량 = 1C / 6.242E18 = 1.6E-19C = Charge/electron
I = Q/t I = amperes (A), Q = coulombs (C), t = seconds (s)

전하량이 매 65ms마다 0.16C이면,
I = Q / t = 0.16 C / 64E-3 s = 2.50A

W(potential energy) = mgh = joules, J
m = mess? 질량?
g = 중력가속도 9.754 m/s2
h = height? 위치?

두 점 사이를 1쿨롬(C)의 전하를 옮기는 데 1줄(J)의 네너지가 소모 된다면, 이 두 점 사이에는 1볼트(V)의 퍼텐셜 차이가 있다.

V = W/Q (volts)
W = Q*V (joules)
Q = W/V (coulombs)

저항.
도체의 면적
Area(circle) = pi * r^2 = pi * d^2 / 4
r = radius
d = diameter

1 mil = 1/1000 in.
1000 mils = 1 in.

A = pi * d^2 / 4 = pi / 4 * ( 1 mil )^2 = pi / 4 sq mils == 1 CM
( 음, 적긴 적었는데, 뭔질 모르겠다? )
( 어, .. 온도, 길이, 지름 물질 가지고 저항값을 구하네? ㅋㅋ 모르겠다. )

저항
서비스터(Termisters) : 온도에 따라 저항 값이 바뀐다. 집에 있는 온도계에서 측정을 해보았다. 13도 정도?에서 15 kOhm나왔고, 손으로 따뜻하게 하니, 21도? 10 kOhm나왔다.
광전도소자(Photoconductive Cell) : 태양광 전지 같은데, ... 내가 가진 것이 없다.
배리스터(Varistors) : 과전압을 제압하기 위해? 음. 다이오드는, 전류의 방향을 제한하는 건 아는데, 저항 만으로 전압을 제한하는 저항 소자가 있구나.

옴의 법칙(Ohm's Law)
I = E/R
E = I*R
R = E/I

전력
1 watt(W) = 1 joule / second(J/s)

2018/02/26
키르히호프의 전압 법칙(Kirchhoff's Voltage Law)은 임의의 폐회로(경로)에서 전압 상승과 전압 강하의 대수합이 0임을 나타내는 법칙이다.
직렬 회로에 가해지는 전압은 직렬 소자의 전압 강하의 합과 같다.
+E-V1-V2=0
E=V1+V2
(헐, 모르겠는데? 헐, 배터리 3개 Y자로 연결했네 ㅋ 뭘까? 25V, 15V, 20V 음. 40V는 이해가 되는데, -120V은 어뗗 책이 잘못된 것일까?)
음, 배터리와 저항이라는 컨셉으로 구분할 것이 아닌, 전위차란 개념을 머리에 넣어야 이해가 될 듯 한데, ... 좀 더 진행해 보아야 할 듯.
(하, 배터리+와 배터리+가 만나니 햇갈리네... 이렇게 되면, 먼저 폐회로를 만들고 계산해야 하나?)
(헐,Interchanging Series Elements, 음, 소자의 순서를 바꿔도 소자에 걸리는 전압이 같다?)
하, 키르히호프의 전압 법칙에서 부터 막히네, 앞날이 ....

2018/03/04
전압 분배의 법칙
직렬 회로에서 저항 양단에 걸리는 전압은 직렬 소자에 인가된 전체 전압에 저항값을 곱한 것을 직렬 소자의 전체 저항으로 나눈 값과 같다.
Rt = R1 + R2
I = E / Rt
V1 = I*R1 = ( E / Rt ) * R1 = R1*E / Rt
V2 = I*R2 = ( E / Rt ) * R2 = R2*E / Rt

전압원과 접지 표기

이중첨자 표기법
이중 첨자 표기 Vab는 a점을 더 높은 전위로 규정한다. 만양 이와 같은 경우가 아니면, (-) 부호가 절대값 Vab 앞에 붙어야만 한다.
전압 Vab는 b점에 대한 A점의 전압이다.

단일 첨자 표기법
단일 첨자 표기 Va는 접지점(볼트)에 대한 전압으로 규정된다. 만약, 그 전압이 0볼트보다 작다면, (-) 부호를 절대값 Va 앞에 붙여야 한다.

일반적 해석
Vab = Va - Vb

전압원의 내부 저항.
Rint ...
뭔가 쉬울 것 같긴 한데, 기호가 여럿 나와서 햇갈린다.

전압 변동률
VR = Vnl - Vfl / Vfl * 100%
VR = Rint / Rl * 100%

책에 회로 해석에 PSpice, C++, GW-BASIC을 통한 분석을 한다.
그 시절엔 Python이 접하기 쉽지 않아서 GW-BASIC 같은 걸 사용했겠지?

2018/03/17
병렬회로

컨덕턴스 = 1 / R
총 컨덕턴스 = 1/R1 + 2/R2 + n/Rn
병렬 회로의 총 저항 = 1/총 컨더턴스

2018/05/07
키르히호프의 전류 법칙

키르히호프의 전류 법칙(KCL)에 의하면 한 절점에서의 입력 전류값과 출력 전류값의 대수적인 합은 0이다.

전류 분배 법칙

동일값의 두 병렬 소자에 대해서 전류는 똑같이 나누어진다.
서로 다른값의 병렬 소자에 대해서는 저항이 작을수록 입력 전류는 커진다.
서로 다른 병렬 소자에 대해 전류는 그 저항값에 반비례하여 나누어 질 것이다.

Ix = ( Rt/Rx ) * I
Rt = (R1*R2)/R1+R2
I1 = (R2*I)/(R1+R2) ??
