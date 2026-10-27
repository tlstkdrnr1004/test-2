# 🍽️ 팀 맛집 리스트

> KH정보교육원 팀 프로젝트 — Spring Boot + JPA + JSP

우리 동네 숨은 맛집을 등록하고, 리뷰를 공유하는 웹 서비스입니다.

> 📘 **처음부터 완성 자습서**: [docs/my-matzip-tutorial.html](docs/my-matzip-tutorial.html) — 빈 프로젝트에서 시작해 요청·응답 흐름 순서대로 파일을 만들어 전체 기능을 완성합니다. (저장소를 내려받은 뒤 브라우저로 여세요.)

---

## 📋 목차

1. [프로젝트 소개](#-프로젝트-소개)
2. [기술 스택](#-기술-스택)
3. [실행 방법](#-실행-방법)
4. [프로젝트 구조](#-프로젝트-구조)
5. [ERD (데이터베이스 설계)](#-erd-데이터베이스-설계)
6. [API 명세 요약](#-api-명세-요약)
7. [역할 분배](#-역할-분배)
8. [테스트 계정](#-테스트-계정)

---

## 🎯 프로젝트 소개

| 항목 | 내용 |
|------|------|
| 프로젝트명 | 팀 맛집 리스트 |
| 기간 | 10일 |
| 인원 | 4명 |
| 목표 | REST API + JSP 기반 맛집 리뷰 서비스 구현 |

### 주요 기능

- **회원**: 가입, 로그인/로그아웃 (세션 기반)
- **맛집**: 등록, 수정, 삭제, 목록 조회, 검색, 카테고리 필터
- **리뷰**: 작성, 삭제, 별점(1~5), 평균 별점 표시
- **찜**: 맛집 찜하기/취소, 내 찜 목록

---

## 🛠️ 기술 스택

| 구분 | 기술 |
|------|------|
| Language | Java 21 |
| Framework | Spring Boot 3.4.3 |
| ORM | Spring Data JPA (Hibernate) |
| View | JSP + JSTL |
| Database | H2 (인메모리) |
| Build | Gradle (Groovy) |
| CSS | Bootstrap 5 |
| CI/CD | GitHub Actions |
| IDE | IntelliJ IDEA |

---

## 🚀 실행 방법

### 사전 요구사항

- **JDK 21** 설치
- **IntelliJ IDEA** (Community 또는 Ultimate)

### 실행 순서

```bash
# 1. 저장소 클론
git clone https://github.com/your-org/my-matzip.git

# 2. 프로젝트 폴더로 이동
cd my-matzip

# 3. 실행 (Gradle Wrapper 사용)
./gradlew bootRun
```

### 접속 주소

| 페이지 | URL |
|--------|-----|
| 메인 페이지 | http://localhost:8080 |
| H2 콘솔 | http://localhost:8080/h2-console |

### H2 콘솔 접속 정보

```
JDBC URL: jdbc:h2:mem:matzipdb
User Name: sa
Password: (비워두기)
```

---

## 📁 프로젝트 구조

```
my-matzip/
├── build.gradle
├── settings.gradle
├── .gitignore
├── .github/workflows/          ← CI/CD
│   ├── ci.yml
│   └── code-review.yml
├── src/main/
│   ├── java/com/example/mymatzip/
│   │   ├── MyMatzipApplication.java     ← 메인 클래스
│   │   ├── config/
│   │   │   ├── WebMvcConfig.java        ← MVC 설정
│   │   │   └── LoginInterceptor.java    ← 로그인 체크
│   │   ├── entity/                      ← ✅ 제공됨
│   │   │   ├── Member.java
│   │   │   ├── Restaurant.java
│   │   │   ├── Review.java
│   │   │   ├── Wishlist.java
│   │   │   ├── Category.java (Enum)
│   │   │   └── Role.java (Enum)
│   │   ├── repository/                  ← ✅ 제공됨
│   │   │   ├── MemberRepository.java
│   │   │   ├── RestaurantRepository.java
│   │   │   ├── ReviewRepository.java
│   │   │   └── WishlistRepository.java
│   │   ├── dto/                         ← ✅ 제공됨
│   │   │   ├── MemberSignupForm.java
│   │   │   ├── LoginForm.java
│   │   │   ├── RestaurantForm.java
│   │   │   ├── RestaurantResponse.java
│   │   │   ├── ReviewForm.java
│   │   │   └── ReviewResponse.java
│   │   ├── service/                     ← ❌ 학생 구현
│   │   │   ├── MemberService.java
│   │   │   ├── RestaurantService.java
│   │   │   ├── ReviewService.java
│   │   │   └── WishlistService.java
│   │   └── controller/                  ← ❌ 학생 구현
│   │       ├── api/
│   │       │   ├── MemberApiController.java
│   │       │   ├── RestaurantApiController.java
│   │       │   ├── ReviewApiController.java
│   │       │   └── WishlistApiController.java
│   │       └── view/
│   │           ├── HomeController.java
│   │           ├── MemberViewController.java
│   │           └── RestaurantViewController.java
│   ├── resources/
│   │   ├── application.properties
│   │   └── data.sql                     ← 테스트 데이터
│   └── webapp/WEB-INF/views/
│       ├── common/
│       │   ├── header.jsp               ← ✅ 제공됨
│       │   └── footer.jsp               ← ✅ 제공됨
│       ├── home.jsp                     ← ✅ 제공됨
│       ├── member/                      ← ❌ 학생 구현
│       │   ├── login.jsp
│       │   └── signup.jsp
│       └── restaurant/                  ← ❌ 학생 구현
│           ├── list.jsp
│           ├── detail.jsp
│           └── form.jsp
└── docs/
    ├── API_SPEC.md                      ← API 명세서
    ├── TEAM_GUIDE.md                    ← 팀 작업 가이드
    └── TODO_BY_ROLE.md                  ← 역할별 체크리스트
```

---

## 📊 ERD (데이터베이스 설계)

```
┌──────────────┐     ┌──────────────────┐     ┌──────────────┐
│   Member     │     │   Restaurant     │     │   Review     │
├──────────────┤     ├──────────────────┤     ├──────────────┤
│ id (PK)      │──┐  │ id (PK)          │──┐  │ id (PK)      │
│ email        │  │  │ name             │  │  │ content      │
│ password     │  │  │ category (Enum)  │  │  │ rating (1~5) │
│ nickname     │  ├──│ member_id (FK)   │  ├──│ restaurant_id│
│ role (Enum)  │  │  │ address          │  │  │ member_id(FK)│
│ created_at   │  │  │ phone            │  │  │ created_at   │
└──────────────┘  │  │ description      │  │  └──────────────┘
                  │  │ created_at       │  │
                  │  └──────────────────┘  │
                  │                        │
                  │  ┌──────────────────┐  │
                  │  │   Wishlist       │  │
                  │  ├──────────────────┤  │
                  │  │ id (PK)          │  │
                  ├──│ member_id (FK)   │  │
                  │  │ restaurant_id(FK)│──┘
                  │  │ created_at       │
                  │  └──────────────────┘
```

### 관계 정리

| 관계 | 설명 |
|------|------|
| Member → Restaurant | 1:N (한 회원이 여러 맛집 등록) |
| Member → Review | 1:N (한 회원이 여러 리뷰 작성) |
| Restaurant → Review | 1:N (한 맛집에 여러 리뷰) |
| Member → Wishlist | 1:N (한 회원이 여러 맛집 찜) |
| Restaurant → Wishlist | 1:N (한 맛집이 여러 회원에게 찜됨) |

---

## 📡 API 명세 요약

자세한 내용은 [docs/API_SPEC.md](docs/API_SPEC.md) 참조

| Method | URL | 설명 | 담당 |
|--------|-----|------|------|
| POST | /api/members/signup | 회원가입 | A |
| POST | /api/members/login | 로그인 | A |
| GET | /api/members/logout | 로그아웃 | A |
| GET | /api/restaurants | 맛집 목록 | B |
| GET | /api/restaurants/{id} | 맛집 상세 | B |
| POST | /api/restaurants | 맛집 등록 | B |
| PUT | /api/restaurants/{id} | 맛집 수정 | B |
| DELETE | /api/restaurants/{id} | 맛집 삭제 | B |
| GET | /api/restaurants/search | 맛집 검색 | B |
| GET | /api/reviews/restaurant/{id} | 리뷰 목록 | C |
| POST | /api/reviews | 리뷰 작성 | C |
| DELETE | /api/reviews/{id} | 리뷰 삭제 | C |
| GET | /api/wishlists | 찜 목록 | D |
| POST | /api/wishlists/{restaurantId} | 찜 추가 | D |
| DELETE | /api/wishlists/{restaurantId} | 찜 취소 | D |

---

## 👥 역할 분배

자세한 내용은 [docs/TODO_BY_ROLE.md](docs/TODO_BY_ROLE.md) 참조

| 역할 | 담당 영역 | 주요 파일 |
|------|----------|----------|
| **A** (회원) | 회원가입, 로그인/로그아웃, 세션 관리 | MemberService, MemberApiController, login.jsp, signup.jsp |
| **B** (맛집) | 맛집 CRUD, 검색, 카테고리 필터 | RestaurantService, RestaurantApiController, list.jsp, detail.jsp, form.jsp |
| **C** (리뷰) | 리뷰 작성/삭제, 별점 표시 | ReviewService, ReviewApiController, detail.jsp(리뷰 섹션) |
| **D** (찜+홈) | 찜하기, 홈 컨트롤러, 전체 JSP 보완 | WishlistService, WishlistApiController, HomeController |

---

## 🔑 테스트 계정

| 이메일 | 비밀번호 | 닉네임 | 역할 |
|--------|---------|--------|------|
| admin@test.com | 1234 | 관리자 | ADMIN |
| user1@test.com | 1234 | 맛집탐험가 | USER |
| user2@test.com | 1234 | 먹보킹 | USER |
