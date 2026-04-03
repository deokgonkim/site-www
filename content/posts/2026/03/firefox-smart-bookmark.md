---
# Title of your post. If not set, filename will be used.
title: "Firefox Smart Bookmark"
date: 2026-03-06T17:20:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - firefox
---

예전 버전에 Firefox에서는, Smart Bookmark라고, 최근 북마크한 항목 가장 많이 방문한 페이지 등이 기능으로 제공되었으나, 최신버전에는 UX 단순화를 위해 해당 폴더가 없어진 걸로 보입니다.

그래서, 전에 자주 사용되던 Smart Bookmark 주소 형식을 일부 메모해 둡니다.
(공식 도큐멘테이션은 제대로 찾을 수가 없는 듯합니다.)

```
# Recently Bookmarked
place:queryType=1&sort=12&maxResults=10

# Most Visited
place:queryType=0&sort=8&maxResults=10

# Recent History
place:queryType=0&sort=4&maxResults=15

# Recently Visited Pages
place:queryType=0&sort=5&maxResults=10
```

```
# All bookmarks
place:queryType=1

# 최근 수정한 북마크
place:queryType=1&sort=13&maxResults=10

# 이름순 북마크 정렬
place:queryType=1&sort=1

# 태그된 북마크만
place:queryType=1&terms=&excludeQueries=1

```

## 🕓 History

```
# 오늘 방문한 페이지
place:queryType=0&beginTimeRef=1&sort=4

# 최근 7일 방문기록
place:queryType=0&beginTimeRef=1&beginTime=-7&sort=4

# 방문 횟수 많은 순
place:queryType=0&sort=8
```

## 🔖 Tag

```
# 모든 태그 목록
place:type=7&sort=1

# 특정 태그가 붙은 북마크
place:queryType=1&tag=태그이름

```

## ⭐ 자주 쓰는 정렬 옵션 (sort 값)

값	의미
1	제목순
4	최근 방문순
5	방문 날짜순
8	방문 횟수순
12	최근 북마크 추가순
13	최근 수정순

## ⭐ 개수 제한 옵션

```
&maxResults=숫자
```

## 예전 Firefox 기본 스마트폴더 세트 전체


### 📁 기본 스마트 폴더 세트 (Classic Firefox Style)

#### ⭐ 1. Most Visited (가장 많이 방문)

```
place:queryType=0&sort=8&maxResults=10
```
- 방문 횟수 높은 페이지

#### ⭐ 2. Recently Bookmarked (최근 북마크됨)

```
place:queryType=1&sort=12&maxResults=10
```
- 최근 추가한 북마크

#### ⭐ 3. Recent Tags (최근 태그)

```
place:type=7&sort=1
```
- 태그 목록 표시

#### ⭐ 4. Recent History (최근 방문 기록)

```
place:queryType=0&sort=4&maxResults=15
```
- 최근 방문 페이지

#### ⭐ 5. Bookmarks Toolbar (북마크 도구 모음 — 바로가기용)

```
place:parent=toolbar
```

#### ⭐ 6. Bookmarks Menu (북마크 메뉴 — 바로가기용)

```
place:parent=menu
```

### 💡 예전 기본 구성 모습

예전 Firefox 시절 기본 배치:

```
📂 Bookmarks Toolbar
   ├─ 📁 Most Visited
   ├─ 📁 Recently Bookmarked
   └─ 📁 Recent Tags

📂 Bookmarks Menu
   └─ 📁 Recent History
```
