# 🤝 팀 작업 가이드

> Git 브랜치 전략, PR 규칙, 일정 관리

---

## 📅 10일 일정표

| 일차 | 오전 (09:00~12:00) | 오후 (13:00~17:00) | 마감 (17:00~18:00) |
|------|-------------------|-------------------|--------------------|
| **Day 1** | 프로젝트 소개, 팀 역할 분배, 환경 세팅 | 스타터 코드 분석, Entity/DTO 이해 | 각자 브랜치 생성 |
| **Day 2** | Service 클래스 작성 시작 | Service 구현 + 단위 테스트 | 데일리 스크럼 |
| **Day 3** | Service 완성 | API Controller 작성 시작 | PR 올리기 |
| **Day 4** | API Controller 완성 | Postman으로 API 테스트 | 코드 리뷰 |
| **Day 5** | View Controller 작성 | JSP 페이지 작성 시작 | 중간 점검 |
| **Day 6** | JSP 핵심 페이지 완성 | JSP 스타일링 (Bootstrap) | 통합 테스트 |
| **Day 7** | 검색/필터/페이징 구현 | 기능 연결 (API + JSP) | PR 머지 |
| **Day 8** | 버그 수정, 예외 처리 | UI/UX 개선 | 통합 테스트 |
| **Day 9** | 최종 버그 수정 | 발표 자료 준비 | 리허설 |
| **Day 10** | 최종 점검 | **발표** | 회고 |

---

## 🌿 Git 브랜치 전략

```
main          ← 최종 배포용 (직접 푸시 금지!)
  └── develop ← 통합 브랜치 (PR로만 머지)
        ├── feature/member    ← A: 회원 기능
        ├── feature/restaurant ← B: 맛집 기능
        ├── feature/review    ← C: 리뷰 기능
        └── feature/wishlist  ← D: 찜 + 홈 기능
```

### 브랜치 사용 규칙

1. **main 브랜치**: 절대 직접 커밋 금지. develop에서 PR로만 머지.
2. **develop 브랜치**: 팀원들의 feature를 모으는 곳. PR로만 머지.
3. **feature 브랜치**: 각자 작업하는 곳. develop에서 분기.

### 브랜치 생성 방법

```bash
# develop 브랜치에서 시작
git checkout develop

# 최신 코드 받기
git pull origin develop

# 내 feature 브랜치 생성
git checkout -b feature/member
```

---

## 📝 커밋 메시지 규칙

```
<타입>: <설명>
```

### 타입 종류

| 타입 | 의미 | 예시 |
|------|------|------|
| feat | 새 기능 | `feat: 회원가입 기능 구현` |
| fix | 버그 수정 | `fix: 로그인 시 세션 저장 오류 수정` |
| refactor | 리팩토링 | `refactor: MemberService 중복 코드 제거` |
| style | 코드 포맷 | `style: 들여쓰기 정리` |
| docs | 문서 | `docs: README 실행 방법 추가` |
| test | 테스트 | `test: RestaurantService 단위 테스트 추가` |

### 좋은 커밋 메시지 vs 나쁜 커밋 메시지

```
# ❌ 나쁜 예시
"수정"
"ㅋㅋ"
"test"
"aaa"

# ✅ 좋은 예시
"feat: 로그인 API 구현 (POST /api/members/login)"
"fix: 맛집 삭제 시 리뷰도 함께 삭제되도록 수정"
"style: RestaurantController import 정리"
```

---

## 🔄 PR (Pull Request) 규칙

### PR 올리는 방법

1. 내 feature 브랜치에서 커밋 후 push

```bash
git add .
git commit -m "feat: 회원가입 서비스 구현"
git push origin feature/member
```

2. GitHub에서 PR 생성
   - **Base**: `develop`
   - **Compare**: `feature/member`

3. PR 제목 작성

```
[A] 회원가입 서비스 및 API 구현
```

4. PR 본문 작성

```markdown
## 변경 내용
- MemberService 회원가입 로직 구현
- MemberApiController 회원가입 API 구현

## 테스트 방법
1. POST /api/members/signup 호출
2. 이메일 중복 시 400 에러 확인

## 참고사항
- LoginForm DTO 사용
```

### 코드 리뷰 규칙

- PR은 **최소 1명** 이상 리뷰 후 머지
- 리뷰어는 같은 팀 내 다른 역할 담당자
- 리뷰 시 체크사항:
  - [ ] 코드가 이해 가능한가?
  - [ ] 오타나 하드코딩은 없는가?
  - [ ] 에러 처리가 되어 있는가?

---

## ⚠️ 충돌 해결 방법

1. develop 최신 코드를 내 브랜치로 당겨오기

```bash
git checkout feature/member
git pull origin develop
```

2. 충돌 발생 시
   - IntelliJ에서 충돌 파일 확인 (빨간색 표시)
   - `Git > Resolve Conflicts` 메뉴 사용
   - 내 코드와 다른 사람 코드를 비교하며 수동 해결

3. 해결 후 커밋

```bash
git add .
git commit -m "merge: develop 최신 코드 병합"
git push origin feature/member
```

---

## 📞 커뮤니케이션 규칙

1. **매일 아침 데일리 스크럼** (5분)
   - 어제 한 일
   - 오늘 할 일
   - 막히는 부분

2. **막힐 때**: 30분 이상 혼자 고민하지 말고 팀원에게 질문
3. **API 변경**: 반드시 팀원에게 공유 후 변경
4. **코드 충돌**: 해당 팀원과 직접 대화로 해결
