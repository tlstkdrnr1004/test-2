<%-- ============================================================ --%>
<%-- 📌 JSP 페이지 기본 설정 (Page Directive)                      --%>
<%-- contentType="text/html;charset=UTF-8" → HTML 문서, 한글 지원  --%>
<%-- language="java" → JSP 내부에서 Java 코드 사용 가능            --%>
<%-- ============================================================ --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- ============================================================ --%>
<%-- 📌 JSTL Core 태그 라이브러리 선언                               --%>
<%-- <c:if>, <c:forEach>, <c:choose> 등을 사용하기 위해 필요       --%>
<%-- ============================================================ --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- ============================================================ --%>
<%-- [list.jsp] 맛집 목록 페이지                                     --%>
<%-- ============================================================ --%>
<%-- URL: http://localhost:8080/restaurants                          --%>
<%--      http://localhost:8080/restaurants?category=KOREAN          --%>
<%-- Controller: RestaurantController → list() 메서드               --%>
<%-- 역할: 등록된 모든 맛집을 카드 형태로 보여줌                     --%>
<%--       카테고리 필터링, 검색(이름/주소) 기능 제공               --%>
<%-- 비유: 배달앱의 "음식점 목록" 화면                              --%>
<%--                                                               --%>
<%-- ★ 이 페이지의 특징:                                           --%>
<%--   1. 서버 렌더링: 초기 목록은 JSTL(<c:forEach>)로 서버에서 생성--%>
<%--   2. 클라이언트 렌더링: 검색 결과는 fetch API + JavaScript로   --%>
<%--      동적으로 카드를 만들어 화면에 표시                         --%>
<%--   3. JSP EL과 JavaScript ${} 충돌이 발생하는 대표적인 파일     --%>
<%-- ============================================================ --%>

<%-- 브라우저 탭 제목 설정 --%>
<c:set var="pageTitle" value="맛집 목록" scope="request"/>

<%-- 공통 헤더 포함 --%>
<jsp:include page="../common/header.jsp"/>

<%-- ============================================================ --%>
<%-- 📌 상단 영역: 제목 + 맛집 등록 버튼                             --%>
<%-- d-flex → display: flex (가로 배치)                             --%>
<%-- justify-content-between → 양쪽 끝으로 배치 (제목↔버튼)        --%>
<%-- align-items-center → 세로 가운데 정렬                          --%>
<%-- mb-4 → 아래 여백 24px                                         --%>
<%-- ============================================================ --%>
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2><i class="bi bi-list-ul"></i> 맛집 목록</h2>
    <%-- 로그인한 사용자만 "맛집 등록" 버튼이 보임 --%>
    <c:if test="${not empty loginMember}">
        <a href="/restaurants/new" class="btn btn-primary">
            <i class="bi bi-plus-circle"></i> 맛집 등록
        </a>
    </c:if>
</div>

<%-- ============================================================ --%>
<%-- 📌 검색바 (Search Bar)                                          --%>
<%-- row → 행, col-md-6 → 중간화면에서 50% 너비                    --%>
<%-- ============================================================ --%>
<div class="row mb-3">
    <div class="col-md-6">
        <%-- d-flex gap-2: 가로 배치 + 요소 간격 8px --%>
        <%-- id="searchForm": JavaScript에서 이벤트 리스너 등록용 --%>
        <form id="searchForm" class="d-flex gap-2">
            <%-- form-control: Bootstrap 입력 필드 스타일 --%>
            <input type="text" id="keyword" class="form-control" placeholder="맛집 이름 또는 주소 검색...">
            <%-- btn-outline-primary: 파란색 테두리 버튼 (배경 투명) --%>
            <button type="submit" class="btn btn-outline-primary">
                <i class="bi bi-search"></i>
            </button>
        </form>
    </div>
</div>

<%-- ============================================================ --%>
<%-- 📌 카테고리 필터 버튼들                                         --%>
<%-- 선택된 카테고리는 btn-primary(파란 배경), 나머지는 outline     --%>
<%-- mb-4 → 아래 여백 24px                                         --%>
<%-- ============================================================ --%>
<div class="mb-4">
    <%-- "전체" 버튼: 카테고리가 선택되지 않았으면(empty) 활성화(btn-primary) --%>
    <%-- ${empty selectedCategory ? 'btn-primary' : 'btn-outline-primary'} --%>
    <%--   → 삼항연산자: selectedCategory가 비어있으면 'btn-primary', 아니면 'btn-outline-primary' --%>
    <%-- btn-sm → 작은 크기 버튼, me-1 → 오른쪽 여백 4px --%>
    <a href="/restaurants"
       class="btn btn-sm ${empty selectedCategory ? 'btn-primary' : 'btn-outline-primary'} me-1">전체</a>

    <%-- ======================================================= --%>
    <%-- 📌 JSTL <c:forEach> - 카테고리 목록을 반복하며 버튼 생성    --%>
    <%-- categories: Controller가 전달한 카테고리 배열              --%>
    <%--   (KOREAN, CHINESE, JAPANESE, WESTERN, CAFE, ETC)          --%>
    <%-- var="cat": 반복 중 현재 카테고리를 'cat'으로 참조           --%>
    <%-- ======================================================= --%>
    <c:forEach var="cat" items="${categories}">
        <%-- selectedCategory == cat: 현재 선택된 카테고리와 같으면 활성화 --%>
        <%-- ${cat}: 카테고리 enum 값 (예: KOREAN) --%>
        <%-- ${cat.displayName}: 카테고리 한글 이름 (예: 한식) --%>
        <a href="/restaurants?category=${cat}"
           class="btn btn-sm ${selectedCategory == cat ? 'btn-primary' : 'btn-outline-primary'} me-1">
            ${cat.displayName}
        </a>
    </c:forEach>
</div>

<%-- ============================================================ --%>
<%-- 📌 맛집 카드 목록                                               --%>
<%-- id="restaurantList": JavaScript 검색 시 이 영역의 내용을 교체  --%>
<%-- row g-4: 그리드 행, 카드 간격 24px                             --%>
<%-- ============================================================ --%>
<div class="row g-4" id="restaurantList">
    <%-- 맛집 데이터 유무에 따른 분기 --%>
    <c:choose>
        <%-- 맛집이 있을 때: 카드 목록 표시 --%>
        <c:when test="${not empty restaurants}">
            <%-- 각 맛집을 반복하며 카드 생성 --%>
            <%-- var="r": 변수명을 짧게 'r'로 사용 (restaurant의 약어) --%>
            <c:forEach var="r" items="${restaurants}">
                <%-- col-md-6: 중간화면 한 줄 2개, col-lg-4: 큰 화면 한 줄 3개 --%>
                <div class="col-md-6 col-lg-4">
                    <%-- card h-100: 높이 100% (같은 줄 카드 높이 통일) --%>
                    <div class="card h-100">
                        <div class="card-body">
                            <%-- 맛집 이름(왼쪽) + 카테고리 뱃지(오른쪽) --%>
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="card-title mb-0">
                                    <%-- ${r.id}: 맛집 고유번호 (상세 페이지 링크에 사용) --%>
                                    <a href="/restaurants/${r.id}" class="text-decoration-none text-dark">
                                        ${r.name}
                                    </a>
                                </h5>
                                <%-- badge bg-primary: 파란색 라벨 --%>
                                <span class="badge bg-primary">${r.categoryDisplayName}</span>
                            </div>
                            <%-- 주소 표시 --%>
                            <p class="card-text text-muted small mb-2">
                                <i class="bi bi-geo-alt"></i> ${r.address}
                            </p>
                            <%-- 설명이 있을 때만 표시 --%>
                            <c:if test="${not empty r.description}">
                                <p class="card-text small">${r.description}</p>
                            </c:if>
                            <%-- 별점 + 작성자 --%>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="rating-stars">
                                    <%-- 1~5 반복하며 별 표시 --%>
                                    <%-- 삼항연산자로 채워진 별(star-fill) / 빈 별(star) 결정 --%>
                                    <c:forEach begin="1" end="5" var="star">
                                        <i class="bi ${star <= r.averageRating ? 'bi-star-fill' : 'bi-star'}"></i>
                                    </c:forEach>
                                    <%-- ms-1: 왼쪽 여백 4px --%>
                                    <span class="text-muted small ms-1">(${r.averageRating})</span>
                                </div>
                                <small class="text-muted">by ${r.memberNickname}</small>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>

        <%-- 맛집이 없을 때: 안내 메시지 표시 --%>
        <c:otherwise>
            <div class="col-12">
                <%-- alert alert-info: 하늘색 정보 알림 박스 --%>
                <div class="alert alert-info text-center">
                    <i class="bi bi-info-circle"></i> 등록된 맛집이 없습니다.
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%-- ============================================================ --%>
<%-- 📌 JavaScript - 검색 기능 구현                                  --%>
<%-- ============================================================ --%>
<%-- ★ JSP EL vs JavaScript ${} 충돌 설명:                          --%>
<%--   이 <script> 블록 안에서 백틱(`) 템플릿 리터럴을 사용합니다.   --%>
<%--   JavaScript의 ${변수}와 JSP의 ${변수}가 동일한 문법이므로      --%>
<%--   JSP 서버가 먼저 ${r.id}를 해석하려고 시도합니다.              --%>
<%--                                                                --%>
<%--   해결 방법: JavaScript에서 \${r.id}처럼 백슬래시(\)를 붙임     --%>
<%--   \를 붙이면 JSP 서버가 이것을 무시하고, 브라우저에 ${r.id}     --%>
<%--   그대로 전달하여 JavaScript가 해석하게 됩니다.                  --%>
<%--                                                                --%>
<%--   비유:                                                        --%>
<%--   JSP ${}: 서버(요리사)가 재료를 손질하는 단계                   --%>
<%--   JS  ${}: 손님(브라우저)이 음식을 먹는 단계                     --%>
<%--   \${}: "요리사님, 이건 손대지 마세요. 손님이 직접 할 거예요"   --%>
<%-- ============================================================ --%>
<script>
// ★ fetch API 패턴 설명 (비전공자용):
// fetch('URL', {옵션}) = 서버에 요청을 보내는 함수 (비유: 전화 걸기)
//   .then(response => ...) = 서버 응답을 받으면 실행 (비유: 전화 받기)
//   .then(data => ...)     = 응답 데이터를 처리    (비유: 통화 내용 메모)
//   .catch(err => ...)     = 에러 발생 시 실행     (비유: 통화 실패 시 재시도)

// ★ 검색 폼 제출(submit) 이벤트 처리
document.getElementById('searchForm').addEventListener('submit', function(e) {
    // ★ 폼의 기본 동작(페이지 새로고침) 방지
    e.preventDefault();

    // ★ 검색어 가져오기
    // .value → 입력칸에 적힌 텍스트
    // .trim() → 앞뒤 공백 제거 (예: " 치킨 " → "치킨")
    const keyword = document.getElementById('keyword').value.trim();

    if (keyword) {
        // ★ 검색어가 있으면 → API에 검색 요청
        // encodeURIComponent(keyword) → 한글 등 특수문자를 URL에 안전한 형태로 변환
        //   예: "맛있는 치킨" → "%EB%A7%9B%EC%9E%88%EB%8A%94%20%EC%B9%98%ED%82%A8"
        //   비유: 한글 편지를 국제 우편으로 보내려면 영문 주소로 변환하는 것
        fetch('/api/restaurants/search?keyword=' + encodeURIComponent(keyword))
            .then(res => res.json())       // 서버 응답을 JSON으로 변환
            .then(data => renderCards(data)); // 카드 렌더링 함수 호출
    } else {
        // ★ 검색어가 비어있으면 → 전체 목록 페이지로 이동 (새로고침)
        window.location.href = '/restaurants';
    }
});

// ★ renderCards 함수: 검색 결과를 카드 형태로 화면에 표시
// restaurants: 서버에서 받은 맛집 배열 (JSON 데이터)
function renderCards(restaurants) {
    // ★ 카드가 표시될 컨테이너 요소를 가져옴
    const container = document.getElementById('restaurantList');

    // ★ 검색 결과가 없으면 안내 메시지 표시
    if (restaurants.length === 0) {
        // innerHTML: 요소의 HTML 내용을 직접 교체
        container.innerHTML = '<div class="col-12"><div class="alert alert-info text-center">검색 결과가 없습니다.</div></div>';
        return; // 함수 종료
    }

    // ★ ============================================================
    // ★ 검색 결과를 HTML 카드로 변환하여 화면에 표시
    // ★ .map(r => `...`) → 배열의 각 항목을 HTML 문자열로 변환
    //   비유: 각 맛집 정보를 "카드 모양 종이"에 적는 것
    // ★ .join('') → 변환된 HTML들을 하나로 합침
    //   비유: 적은 종이들을 하나로 이어 붙이는 것
    //
    // ★★★ 중요: \${r.id}, \${r.name} 등에서 \(백슬래시) 사용 이유 ★★★
    // JSP 파일 안의 JavaScript이므로, ${r.id}라고 쓰면
    // JSP 서버가 이것을 서버 측 변수로 해석하려고 시도합니다.
    // \${r.id}로 쓰면 JSP 서버가 무시하고,
    // 브라우저의 JavaScript 엔진이 템플릿 리터럴로 해석합니다.
    // ★ ============================================================
    container.innerHTML = restaurants.map(r => `
        <div class="col-md-6 col-lg-4">
            <div class="card h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <h5 class="card-title mb-0">
                            <a href="/restaurants/\${r.id}" class="text-decoration-none text-dark">\${r.name}</a>
                        </h5>
                        <span class="badge bg-primary">\${r.categoryDisplayName}</span>
                    </div>
                    <p class="card-text text-muted small mb-2"><i class="bi bi-geo-alt"></i> \${r.address}</p>
                    \${r.description ? '<p class="card-text small">' + r.description + '</p>' : ''}
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="rating-stars">\${renderStars(r.averageRating)}</div>
                        <small class="text-muted">by \${r.memberNickname}</small>
                    </div>
                </div>
            </div>
        </div>
    `).join('');
}

// ★ renderStars 함수: 별점을 별(★☆) 아이콘 HTML로 변환
// rating: 평균 별점 (예: 3.5)
// 반환값: HTML 문자열 (예: "★★★☆☆ (3.5)")
function renderStars(rating) {
    let stars = ''; // 빈 문자열에 별 아이콘을 하나씩 추가

    // 1~5까지 반복하며 채워진 별 또는 빈 별 추가
    for (let i = 1; i <= 5; i++) {
        // i <= rating이면 채워진 별(bi-star-fill), 아니면 빈 별(bi-star)
        stars += '<i class="bi ' + (i <= rating ? 'bi-star-fill' : 'bi-star') + '"></i>';
    }

    // 별 뒤에 평점 숫자를 붙여서 반환
    return stars + ' <span class="text-muted small">(' + rating + ')</span>';
}
</script>

<%-- 공통 푸터 포함 --%>
<jsp:include page="../common/footer.jsp"/>
