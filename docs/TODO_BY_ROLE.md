# ✅ 역할별 구현 체크리스트

> 각자 담당 역할의 체크리스트를 따라 구현하세요.

---

## 🅰️ 역할 A: 회원 (Member)

### Service: `MemberService.java`

- [ ] 회원가입 (`signup`)
  - [ ] 이메일 중복 체크 → `memberRepository.existsByEmail()`
  - [ ] 닉네임 중복 체크 → `memberRepository.existsByNickname()`
  - [ ] Member 엔티티 생성 (Builder 패턴 사용)
  - [ ] 저장 후 반환
- [ ] 로그인 (`login`)
  - [ ] 이메일로 회원 조회 → `memberRepository.findByEmail()`
  - [ ] 비밀번호 일치 확인
  - [ ] 불일치 시 예외 발생

### API Controller: `MemberApiController.java` (`@RestController`)

- [ ] `POST /api/members/signup` → 회원가입
  - [ ] `@Valid` + `@RequestBody MemberSignupForm`
  - [ ] 성공 시 201 Created
- [ ] `POST /api/members/login` → 로그인
  - [ ] 성공 시 세션에 회원 정보 저장: `session.setAttribute("loginMember", member)`
- [ ] `GET /api/members/logout` → 로그아웃
  - [ ] 세션 무효화: `session.invalidate()`
  - [ ] 메인 페이지로 리다이렉트

### View Controller: `MemberViewController.java` (`@Controller`)

- [ ] `GET /members/login` → login.jsp 반환
- [ ] `GET /members/signup` → signup.jsp 반환

### JSP 페이지

- [ ] `webapp/WEB-INF/views/member/login.jsp`
  - [ ] 이메일, 비밀번호 입력 폼
  - [ ] 로그인 버튼 (JavaScript `fetch`로 API 호출)
  - [ ] 회원가입 링크
  - [ ] 에러 메시지 표시
- [ ] `webapp/WEB-INF/views/member/signup.jsp`
  - [ ] 이메일, 비밀번호, 닉네임 입력 폼
  - [ ] 회원가입 버튼 (JavaScript `fetch`로 API 호출)
  - [ ] 유효성 검증 에러 표시

### 💡 힌트

```java
// MemberService.java 예시
@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;

    @Transactional
    public Member signup(MemberSignupForm form) {
        // 1. 이메일 중복 체크
        if (memberRepository.existsByEmail(form.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }
        // 2. 닉네임 중복 체크
        // 3. Member 엔티티 생성 (Builder)
        // 4. 저장 후 반환
    }
}
```

---

## 🅱️ 역할 B: 맛집 (Restaurant)

### Service: `RestaurantService.java`

- [ ] 전체 목록 조회 (`findAll`)
  - [ ] `restaurantRepository.findAll()`
  - [ ] 각 맛집의 평균 별점 계산 → `RestaurantResponse.from()` 사용
- [ ] 카테고리별 조회 (`findByCategory`)
  - [ ] `restaurantRepository.findByCategory(category)`
- [ ] 상세 조회 (`findById`)
  - [ ] 없으면 예외 발생
- [ ] 등록 (`save`)
  - [ ] RestaurantForm → Restaurant 엔티티 변환
  - [ ] 현재 로그인한 회원을 등록자로 설정
- [ ] 수정 (`update`)
  - [ ] 작성자 본인만 수정 가능 체크
  - [ ] `restaurant.update()` 호출
- [ ] 삭제 (`delete`)
  - [ ] 작성자 본인 또는 ADMIN만 삭제 가능
- [ ] 검색 (`search`)
  - [ ] `restaurantRepository.searchByKeyword(keyword)`

### API Controller: `RestaurantApiController.java` (`@RestController`)

- [ ] `GET /api/restaurants` → 목록 (카테고리 파라미터 선택)
- [ ] `GET /api/restaurants/{id}` → 상세
- [ ] `POST /api/restaurants` → 등록
- [ ] `PUT /api/restaurants/{id}` → 수정
- [ ] `DELETE /api/restaurants/{id}` → 삭제
- [ ] `GET /api/restaurants/search?keyword=` → 검색

### View Controller: `RestaurantViewController.java` (`@Controller`)

- [ ] `GET /restaurants` → list.jsp
- [ ] `GET /restaurants/{id}` → detail.jsp
- [ ] `GET /restaurants/new` → form.jsp (등록)
- [ ] `GET /restaurants/{id}/edit` → form.jsp (수정)

### JSP 페이지

- [ ] `restaurant/list.jsp`
  - [ ] 맛집 카드 목록 (Bootstrap 그리드)
  - [ ] 카테고리 필터 버튼
  - [ ] 검색 입력란
  - [ ] 맛집 등록 버튼
- [ ] `restaurant/detail.jsp`
  - [ ] 맛집 상세 정보
  - [ ] 수정/삭제 버튼 (작성자만 표시)
  - [ ] 리뷰 목록 영역 (C역할과 협업)
  - [ ] 리뷰 작성 폼 (C역할과 협업)
  - [ ] 찜 버튼 (D역할과 협업)
- [ ] `restaurant/form.jsp`
  - [ ] 등록/수정 공통 폼
  - [ ] 카테고리 드롭다운 (Category Enum 값 사용)

### 💡 힌트

```java
// RestaurantService.java 예시
public List<RestaurantResponse> findAll() {
    return restaurantRepository.findAll().stream()
            .map(r -> {
                Double avgRating = reviewRepository.averageRatingByRestaurantId(r.getId());
                return RestaurantResponse.from(r, avgRating);
            })
            .toList();
}
```

---

## 🅲 역할 C: 리뷰 (Review)

### Service: `ReviewService.java`

- [ ] 특정 맛집 리뷰 목록 (`findByRestaurantId`)
  - [ ] `reviewRepository.findByRestaurantIdOrderByCreatedAtDesc()`
  - [ ] `ReviewResponse.from()` 사용
- [ ] 리뷰 작성 (`save`)
  - [ ] ReviewForm → Review 엔티티 변환
  - [ ] 현재 로그인한 회원 설정
  - [ ] 해당 맛집이 존재하는지 확인
- [ ] 리뷰 삭제 (`delete`)
  - [ ] 작성자 본인만 삭제 가능

### API Controller: `ReviewApiController.java` (`@RestController`)

- [ ] `GET /api/reviews/restaurant/{restaurantId}` → 리뷰 목록
- [ ] `POST /api/reviews` → 리뷰 작성
- [ ] `DELETE /api/reviews/{id}` → 리뷰 삭제

### JSP (맛집 상세 페이지 내 리뷰 섹션)

- [ ] 리뷰 목록 표시 (별점 + 내용 + 작성자)
- [ ] 리뷰 작성 폼 (별점 선택 + 내용 입력)
- [ ] 내 리뷰에만 삭제 버튼 표시
- [ ] 평균 별점 별(★) 아이콘으로 표시

### 💡 힌트

```java
// ReviewService.java 예시
@Transactional
public ReviewResponse save(ReviewForm form, Member loginMember) {
    Restaurant restaurant = restaurantRepository.findById(form.getRestaurantId())
            .orElseThrow(() -> new IllegalArgumentException("맛집을 찾을 수 없습니다."));

    Review review = Review.builder()
            .content(form.getContent())
            .rating(form.getRating())
            .member(loginMember)
            .restaurant(restaurant)
            .build();

    return ReviewResponse.from(reviewRepository.save(review));
}
```

```javascript
// 별점 선택 JavaScript 예시
function selectRating(rating) {
    document.getElementById('rating').value = rating;
    for (let i = 1; i <= 5; i++) {
        const star = document.getElementById('star-' + i);
        star.className = i <= rating ? 'bi bi-star-fill text-warning fs-4' : 'bi bi-star text-warning fs-4';
    }
}
```

---

## 🅳 역할 D: 찜 + 홈 (Wishlist + Home)

### Service: `WishlistService.java`

- [ ] 내 찜 목록 (`findByMemberId`)
  - [ ] `wishlistRepository.findByMemberId()`
- [ ] 찜 추가 (`add`)
  - [ ] 이미 찜한 맛집인지 확인 → `existsByMemberIdAndRestaurantId()`
  - [ ] 중복이면 예외 발생
- [ ] 찜 취소 (`remove`)
  - [ ] `findByMemberIdAndRestaurantId()` 조회 후 삭제
- [ ] 찜 여부 확인 (`isWished`)
  - [ ] `existsByMemberIdAndRestaurantId()`

### API Controller: `WishlistApiController.java` (`@RestController`)

- [ ] `GET /api/wishlists` → 내 찜 목록
- [ ] `POST /api/wishlists/{restaurantId}` → 찜 추가
- [ ] `DELETE /api/wishlists/{restaurantId}` → 찜 취소
- [ ] `GET /api/wishlists/{restaurantId}/check` → 찜 여부 확인

### View Controller: `HomeController.java` (`@Controller`)

- [ ] `GET /` → home.jsp
  - [ ] 최신 맛집 6개 조회: `restaurantRepository.findTop6ByOrderByCreatedAtDesc()`
  - [ ] 각 맛집의 평균 별점 계산
  - [ ] Model에 담아서 JSP로 전달

### JSP 페이지

- [ ] `wishlist/list.jsp`
  - [ ] 내가 찜한 맛집 목록
  - [ ] 찜 취소 버튼
  - [ ] 맛집 상세 링크
- [ ] home.jsp 보완 (필요 시)
  - [ ] 홈 화면 추가 기능
  - [ ] 전체 JSP 디자인 통일

### 💡 힌트

```java
// HomeController.java 예시
@Controller
public class HomeController {

    private final RestaurantRepository restaurantRepository;
    private final ReviewRepository reviewRepository;

    @GetMapping("/")
    public String home(Model model) {
        List<Restaurant> latest = restaurantRepository.findTop6ByOrderByCreatedAtDesc();
        List<RestaurantResponse> restaurants = latest.stream()
                .map(r -> {
                    Double avg = reviewRepository.averageRatingByRestaurantId(r.getId());
                    return RestaurantResponse.from(r, avg);
                })
                .toList();
        model.addAttribute("restaurants", restaurants);
        return "home";
    }
}
```

---

## 🔗 협업 포인트 (역할 간 연결)

| 연결 지점 | 관련 역할 | 설명 |
|----------|----------|------|
| 맛집 상세 페이지 + 리뷰 | B + C | detail.jsp에 리뷰 목록/작성 폼 포함 |
| 맛집 상세 페이지 + 찜 | B + D | detail.jsp에 찜 버튼 포함 |
| 로그인 세션 | A + 전체 | 세션에 저장된 loginMember를 모든 역할에서 사용 |
| 홈 페이지 | D + B | 최신 맛집을 홈에 표시 |

### ⚡ 협업 타임라인

```
Day 1~3: 각자 Service 독립 개발 (충돌 없음)
Day 4~5: API Controller 개발 (각자 URL이 다르므로 충돌 없음)
Day 6~7: JSP 개발 (detail.jsp에서 B+C+D 협업 필요!)
Day 8~9: 통합 테스트 + 버그 수정
```

> **핵심**: Day 6부터는 `detail.jsp` 작업 시 B, C, D가 소통하며 작업하세요!
