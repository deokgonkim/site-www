---
# Title of your post. If not set, filename will be used.
title: "소프트웨어 공학 노트"
date: 2018-01-03T22:27:00+09:00
draft: true

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "programming"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

정의 과정(definition phase)
- 시스템 또는 정보 공학
- 소프트웨어 프로젝트 계획 수립
- 요구 사항 분석

개발 과정(development phase)
- 소프트웨어 설계
- 코드 생성
- 소프트웨어 테스팅

유지보수 과정(maintenance phase)
- 수정(correction)
- 적응(adaptation)
- 기능 향상(enhancement)
- 예방(prevention)

소프트웨어 프로젝트 추적과 관리(software project tracking and control)
정형 기술 검토(formal technical reviews)
소프트웨어 품질 보증(software quality assurance)
소프트웨어 형상 관리(software configuration management)
문서 준비와 생산(document preparation and production)
재사용성 관리(reusability management)
측정(measurement)
위험 관리(risk management)

PM-CMM people management capability maturity model
- recruiting
- selection
- performance management
- training
- compensation
- career development
- organization and work design
- team/culture development

팀장
- 동기 부여(motivation) 기술 인력이 그들의 최대 능력을 발휘하도록 격려해 주는(밀어 주고 이끌어 주는) 능력
- 조직화(organization) 초기 개념을 최종 제품으로 변환시킬 수 있도록 현재 프로세스(또는 새로운 것을 고안하는) 들을 형성화하는 능력
- 아이디어나 기술 혁신(idea or innovation) 특별한 소프트웨어 제품이나 어플리케이션에 관해 설정된 한계내에서 작업을 할 때 창조적으로 생산하거나 느끼게 해주는 능력

기능 점수(function point) 방법
- 사용자 입력 수(number of user inputs) 소프트웨어에 상이한 어플리케이션-중심 자료를 제공해 주는 각 사용자 입력의 수를 계산한다. 입력은 질의(inquiries)와 구별되고 또 분리해서 계산된다.
- 사용자 출력 수(number of user outputs) 사용자에게 어플리케이션-중심 정보를 제공해 주는 각 사용자 출력을 계산한다. 이 "출력"에는 보고서, 스크린, 오류 메시지 등이 포함된다. 보고서내의 개별적인 자료 항목들은 분리해서 계산하지 않는다.
- 사용자 질의 수(number of user inquiries) 질의는 온라인 출력의 형식으로 소프트웨어가 즉시 응답해 줄 수 있도록 온라인 입력 (on-line input)으로 구해진다. 각기 다른 질의를 계산한다.
- 파일 수(number of files) 각 논리적 마스터 파일(master file)(즉, 대형 데이터베이스의 한 부분이나 분리된 파일이 될 수 있는 자료의 논리적 모임)을 계산한다.
- 외부 인터페이스 수(number of external interfaces) 다른 시스템에 정보를 전송하는 데 사용되는 모든 기계가 읽을 수 있는 인터페이스(에, 테이프나 디스크의 데이터 파일)를 계산한다.

FP = 전체 합계 x [0.65 + 0.01 x Sum(Fi)]
Fi := [ F(i) for i in range(1, 15) ] ㅋㅋㅋ

소프트웨어 형상 관리
<blockquote>혼란을 최소화시키기 위해 소프트웨어 개발을 조정하는 기술을 형상 관리(Configuration Management)라고 부른다 형상 관리는 프로그램을 만드는 팀이 구축한 소프트웨어를 식별하고, 조직하고, 그리고 통제하는 기술이다. 형상 관리의 목적은 실수를 최소화시켜 생산성을 극대화하는 것이다.</blockquote>
