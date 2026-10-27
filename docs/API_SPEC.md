# 📡 API 명세서

> 팀 맛집 리스트 REST API 전체 명세

---

## 📌 공통 사항

- **Base URL**: `http://localhost:8080`
- **Content-Type**: `application/json` (API 요청/응답)
- **인증**: 세션 기반 (로그인 후 세션 쿠키 자동 전송)
- **에러 응답**: HTTP 상태 코드 + 에러 메시지

### 공통 에러 코드

| 상태 코드 | 의미 | 설명 |
|-----------|------|------|
| 400 | Bad Request | 입력값 검증 실패 |
| 401 | Unauthorized | 로그인 필요 |
| 403 | Forbidden | 권한 없음 (작성자가 아님) |
| 404 | Not Found | 리소스를 찾을 수 없음 |
| 500 | Server Error | 서버 오류 |

---

## 1. 회원 API (담당: A)

### 1-1. 회원가입

```
POST /api/members/signup
```

**Request Body:**
```json
{
  "email": "newuser@test.com",
  "password": "1234",
  "nickname": "새유저"
}
```

**Response (성공):**
```json
{
  "id": 4,
  "email": "newuser@test.com",
  "nickname": "새유저"
}
```

**Response (실패 - 이메일 중복):**
```
400 Bad Request
"이미 사용 중인 이메일입니다."
```

**검증 규칙:**
- email: 필수, 이메일 형식, 중복 불가
- password: 필수, 4~20자
- nickname: 필수, 2~10자, 중복 불가

---

### 1-2. 로그인

```
POST /api/members/login
```

**Request Body:**
```json
{
  "email": "user1@test.com",
  "password": "1234"
}
```

**Response (성공):**
```json
{
  "id": 2,
  "email": "user1@test.com",
  "nickname": "맛집탐험가"
}
```

**동작:**
- 로그인 성공 시 `HttpSession`에 `loginMember` 속성으로 회원 정보 저장
- 실패 시 401 에러

---

### 1-3. 로그아웃

```
GET /api/members/logout
```

**동작:**
- 세션 무효화 (`session.invalidate()`)
- 메인 페이지(`/`)로 리다이렉트

---

## 2. 맛집 API (담당: B)

### 2-1. 맛집 목록 조회

```
GET /api/restaurants
```

**Query Parameters (선택):**
| 파라미터 | 타입 | 설명 |
|---------|------|------|
| category | String | 카테고리 필터 (KOREAN, CHINESE, JAPANESE, WESTERN, CAFE, ETC) |

**Response:**
```json
[
  {
    "id": 1,
    "name": "김치찌개 명가",
    "category": "KOREAN",
    "categoryDisplayName": "한식",
    "address": "서울시 강남구 역삼동 123-4",
    "phone": "02-1234-5678",
    "description": "30년 전통 김치찌개 맛집",
    "memberNickname": "관리자",
    "averageRating": 4.5,
    "createdAt": "2025-01-01T12:00:00"
  }
]
```

---

### 2-2. 맛집 상세 조회

```
GET /api/restaurants/{id}
```

**Response:** 단건 RestaurantResponse (위와 동일한 형태)

---

### 2-3. 맛집 등록

```
POST /api/restaurants
```

**Request Body:**
```json
{
  "name": "새 맛집",
  "category": "KOREAN",
  "address": "서울시 어디구 어디동",
  "phone": "02-0000-0000",
  "description": "설명입니다"
}
```

**동작:**
- 현재 로그인한 회원을 등록자(member)로 설정
- 성공 시 생성된 맛집 정보 반환

---

### 2-4. 맛집 수정

```
PUT /api/restaurants/{id}
```

**Request Body:** RestaurantForm과 동일

**동작:**
- 작성자 본인만 수정 가능 (아니면 403)
- 성공 시 수정된 맛집 정보 반환

---

### 2-5. 맛집 삭제

```
DELETE /api/restaurants/{id}
```

**동작:**
- 작성자 본인 또는 ADMIN만 삭제 가능
- 관련 리뷰, 찜도 함께 삭제

---

### 2-6. 맛집 검색

```
GET /api/restaurants/search?keyword=김치
```

**Query Parameters:**
| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| keyword | String | ✅ | 검색어 (이름/주소에서 검색) |

**Response:** RestaurantResponse 배열

---

## 3. 리뷰 API (담당: C)

### 3-1. 특정 맛집의 리뷰 목록

```
GET /api/reviews/restaurant/{restaurantId}
```

**Response:**
```json
[
  {
    "id": 1,
    "content": "김치찌개가 정말 맛있어요!",
    "rating": 5,
    "memberNickname": "맛집탐험가",
    "memberId": 2,
    "restaurantId": 1,
    "createdAt": "2025-01-01T12:00:00"
  }
]
```

---

### 3-2. 리뷰 작성

```
POST /api/reviews
```

**Request Body:**
```json
{
  "content": "맛있어요! 추천합니다.",
  "rating": 5,
  "restaurantId": 1
}
```

**검증 규칙:**
- content: 필수, 1000자 이내
- rating: 필수, 1~5
- restaurantId: 필수

---

### 3-3. 리뷰 삭제

```
DELETE /api/reviews/{id}
```

**동작:**
- 작성자 본인만 삭제 가능 (아니면 403)

---

## 4. 찜 API (담당: D)

### 4-1. 내 찜 목록

```
GET /api/wishlists
```

**Response:**
```json
[
  {
    "id": 1,
    "restaurant": {
      "id": 1,
      "name": "김치찌개 명가",
      "category": "KOREAN",
      "categoryDisplayName": "한식"
    },
    "createdAt": "2025-01-01T12:00:00"
  }
]
```

---

### 4-2. 찜 추가

```
POST /api/wishlists/{restaurantId}
```

**동작:**
- 이미 찜한 맛집이면 400 에러
- 성공 시 201 Created

---

### 4-3. 찜 취소

```
DELETE /api/wishlists/{restaurantId}
```

**동작:**
- 내가 찜한 것만 취소 가능

---

## 5. 화면(View) URL (Controller에서 JSP로 연결)

| Method | URL | 설명 | JSP 파일 | 담당 |
|--------|-----|------|---------|------|
| GET | / | 메인 페이지 | home.jsp | D |
| GET | /members/login | 로그인 페이지 | member/login.jsp | A |
| GET | /members/signup | 회원가입 페이지 | member/signup.jsp | A |
| GET | /restaurants | 맛집 목록 페이지 | restaurant/list.jsp | B |
| GET | /restaurants/{id} | 맛집 상세 페이지 | restaurant/detail.jsp | B+C |
| GET | /restaurants/new | 맛집 등록 페이지 | restaurant/form.jsp | B |
| GET | /restaurants/{id}/edit | 맛집 수정 페이지 | restaurant/form.jsp | B |
| GET | /wishlists | 찜 목록 페이지 | wishlist/list.jsp | D |
