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

- **회원**: 가입, 로그인/로그아웃 (Spring Security 세션 + API 용 JWT), 소셜 로그인(카카오·네이버·구글, 선택)
- **맛집**: 등록, 수정, 삭제, 목록 조회, 검색, 카테고리 필터, 대표 사진 업로드
- **리뷰**: 작성, 삭제, 별점(1~5), 평균 별점 표시, 신고, 답글
- **찜**: 맛집 찜하기/취소, 내 찜 목록
- **마이페이지**: 활동 통계, 내 맛집·리뷰, 닉네임·비밀번호 변경
- **관리자**: 통계, 회원 권한 변경·삭제, 맛집·리뷰 삭제, 신고된 리뷰 보기

---

## 🛠️ 기술 스택

| 구분 | 기술 |
|------|------|
| Language | Java 21 |
| Framework | Spring Boot 3.4.3 |
| Security | Spring Security, JWT (jjwt 0.12.6), OAuth2 Client (선택) |
| ORM | Spring Data JPA (Hibernate) |
| View | JSP + JSTL |
| Database | H2 (인메모리) |
| Build | Gradle 8.12.1 (Groovy) |
| CSS | Bootstrap 5.3.3 |
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

# 3. 실행 (Gradle Wrapper 사용, Windows 는 gradlew.bat bootRun)
./gradlew bootRun
```

- `./gradlew: Permission denied` 가 나오면 `chmod +x gradlew` 후 다시 실행합니다.
- **JWT 비밀키**: 환경 변수 `JWT_SECRET`(32자 이상)을 넣고 실행합니다. 없으면 실행할 때마다 임의 키를 만들어 씁니다(개발용, 서버를 다시 켜면 이전 토큰은 무효).
- **소셜 로그인(선택)**: 키를 발급받아 환경 변수(`KAKAO_CLIENT_ID` 등)를 넣고 프로필을 켜서 실행합니다. 예: `./gradlew bootRun --args='--spring.profiles.active=kakao,naver'`. 설정 방법은 `src/main/resources/application-kakao.properties` · `application-naver.properties` · `application-google.properties` 의 주석을 봅니다.
- 업로드한 사진은 프로젝트 폴더의 `uploads/` 에 저장됩니다(Git 에는 올리지 않음).

### 접속 주소

| 페이지 | URL |
|--------|-----|
| 메인 페이지 | http://localhost:8082 |
| H2 콘솔 | http://localhost:8082/h2-console |

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
├── build.gradle · settings.gradle · gradlew · .gitignore
├── .github/workflows/          ← CI/CD
│   ├── ci.yml                   (빌드 + 테스트)
│   └── code-review.yml          (PR 변경량 요약 댓글)
├── docs/
│   ├── my-matzip-tutorial.html  ← 처음부터 완성 자습서
│   ├── API_SPEC.md · TEAM_GUIDE.md · TODO_BY_ROLE.md
├── src/main/
│   ├── java/com/example/mymatzip/
│   │   ├── MyMatzipApplication.java
│   │   ├── config/              WebMvcConfig, GlobalExceptionHandler, DataInitializer
│   │   ├── config/security/     SecurityConfig, PasswordEncoderConfig, CustomUserDetails(Service),
│   │   │                        JwtTokenProvider, JwtAuthenticationFilter, LoginMember(+ArgumentResolver),
│   │   │                        GlobalModelAdvice, OAuthAttributes, CustomOAuth2UserService, OAuth2LoginSuccessHandler
│   │   ├── entity/              Member, Role, Restaurant, Category, Review, Reply, Wishlist, Image
│   │   ├── repository/          Member, Restaurant, Review, Reply, Wishlist, Image (…Repository)
│   │   ├── dto/                 MemberSignupForm, LoginForm, Restaurant/Review/Reply Form·Response, PageResponse
│   │   ├── service/             Member, Restaurant, Review, Reply, Wishlist, Admin, File (…Service)
│   │   ├── util/                HtmlSanitizer
│   │   └── controller/
│   │       ├── api/             Member, Restaurant, Review, Reply, Wishlist, MyPage, Admin, File (…ApiController)
│   │       └── view/            Home, Member, Restaurant, MyPage, Admin (…ViewController)
│   ├── resources/
│   │   ├── application.properties
│   │   ├── application-kakao/naver/google.properties  ← 소셜 로그인 (선택)
│   │   └── data.sql             ← 예제 데이터
│   └── webapp/WEB-INF/views/
│       ├── common/ (header, footer) · home.jsp
│       ├── member/ (login, signup) · restaurant/ (list, detail, form)
│       ├── wishlist/list.jsp · mypage/dashboard.jsp
│       └── admin/ (dashboard, members, restaurants, reviews)
└── src/test/java/com/example/mymatzip/MyMatzipApplicationTests.java
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
| Review → Reply | 1:N (한 리뷰에 여러 답글) |
| Member → Reply | 1:N (한 회원이 여러 답글 작성) |

- 위 외래 키는 모두 `ON DELETE CASCADE` 입니다. 맛집을 지우면 그 맛집의 리뷰·답글·찜이, 회원을 지우면 그 회원의 맛집·리뷰·답글·찜이 함께 지워집니다.
- `restaurant.image_url` 에 대표 사진 주소, `image` 테이블에 업로드 기록이 저장됩니다.

---

## 📡 API 명세 요약

자세한 내용은 [docs/API_SPEC.md](docs/API_SPEC.md) 참조

| Method | URL | 설명 | 담당 |
|--------|-----|------|------|
| POST | /api/members/signup | 회원가입 | A |
| POST | /api/members/login | 로그인 (세션 + JWT 발급) | A |
| GET | /api/members/logout | 로그아웃 | A |
| GET | /api/restaurants | 맛집 목록 | B |
| GET | /api/restaurants/{id} | 맛집 상세 | B |
| POST | /api/restaurants | 맛집 등록 | B |
| PUT | /api/restaurants/{id} | 맛집 수정 (등록자·관리자) | B |
| DELETE | /api/restaurants/{id} | 맛집 삭제 (등록자·관리자) | B |
| GET | /api/restaurants/search | 맛집 검색 | B |
| POST | /api/files/upload | 사진 업로드 | B |
| GET | /api/reviews/restaurant/{id} | 리뷰 목록 | C |
| POST | /api/reviews | 리뷰 작성 | C |
| DELETE | /api/reviews/{id} | 리뷰 삭제 | C |
| POST | /api/reviews/{id}/report | 리뷰 신고 | C |
| GET · POST · DELETE | /api/replies/review/{id} · /api/replies · /api/replies/{id} | 답글 목록·작성·삭제 | C |
| GET | /api/wishlists | 찜 목록 | D |
| POST | /api/wishlists/{restaurantId} | 찜 추가 | D |
| DELETE | /api/wishlists/{restaurantId} | 찜 취소 | D |
| GET · PUT | /api/mypage/** | 통계·내 글·닉네임·비밀번호 | A |
| GET · PUT · DELETE | /api/admin/** | 관리자 기능 (ADMIN 만) | D |

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
