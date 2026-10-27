<%-- ============================================================ --%>
<%-- 📌 JSP 페이지 기본 설정 (Page Directive)                      --%>
<%-- contentType="text/html;charset=UTF-8" → HTML 문서, 한글 지원  --%>
<%-- language="java" → JSP 내부에서 Java 코드 사용 가능            --%>
<%-- ============================================================ --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- ============================================================ --%>
<%-- 📌 JSTL Core 태그 라이브러리 선언                               --%>
<%-- <c:if>, <c:forEach>, <c:choose>, <c:set> 등을 사용하기 위해   --%>
<%-- 반드시 페이지 상단에 선언해야 합니다.                          --%>
<%-- ============================================================ --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- ============================================================ --%>
<%-- [home.jsp] 메인 홈페이지 (랜딩 페이지)                          --%>
<%-- ============================================================ --%>
<%-- URL: http://localhost:8080/                                    --%>
<%-- Controller: HomeController → home() 메서드                     --%>
<%-- 역할: 사이트의 첫 화면. 히어로 배너, 카테고리 바로가기,         --%>
<%--       최근 등록된 맛집 목록을 보여줌                           --%>
<%-- 비유: 백화점의 1층 안내 데스크 + 층별 안내도                   --%>
<%-- ============================================================ --%>

<%-- ============================================================ --%>
<%-- 📌 JSTL <c:set> 태그 - 변수 설정                               --%>
<%-- var="pageTitle" → pageTitle이라는 이름의 변수를 만듦           --%>
<%-- value="팀 맛집 리스트 - 홈" → 변수에 저장할 값                --%>
<%-- scope="request" → 이 변수의 유효 범위를 'request'로 설정       --%>
<%--   request scope: 하나의 HTTP 요청 동안만 유지                  --%>
<%--   비유: 일회용 메모지 (요청 처리가 끝나면 사라짐)              --%>
<%-- 이 변수는 header.jsp의 <title> 태그에서 사용됩니다.            --%>
<%-- ============================================================ --%>
<c:set var="pageTitle" value="팀 맛집 리스트 - 홈" scope="request"/>

<%-- ============================================================ --%>
<%-- 📌 <jsp:include> 액션 태그 - 다른 JSP 파일을 현재 위치에 포함    --%>
<%-- page="common/header.jsp" → header.jsp의 내용이 여기에 삽입됨  --%>
<%-- 비유: 레고 블록을 끼워 넣는 것처럼, header를 이 자리에 조립    --%>
<%-- 결과: <html><head>...</head><body><nav>...</nav><main> 까지   --%>
<%--       header.jsp의 내용이 이 위치에 출력됨                     --%>
<%-- ============================================================ --%>
<jsp:include page="common/header.jsp"/>

<%-- ============================================================ --%>
<%-- 📌 히어로 섹션 (Hero Section) - 페이지 상단의 큰 배너           --%>
<%-- Bootstrap 클래스 설명:                                         --%>
<%--   bg-primary → 파란색 배경                                     --%>
<%--   text-white → 흰색 글자                                       --%>
<%--   rounded-3 → 둥근 모서리 (border-radius)                      --%>
<%--   p-5 → padding(안쪽 여백) 5단위 (48px, 넉넉한 여백)          --%>
<%--   mb-4 → margin-bottom 4단위 (아래쪽 바깥 여백 24px)          --%>
<%-- 비유: 극장 영화 포스터처럼 눈에 띄는 대형 배너                 --%>
<%-- ============================================================ --%>
<div class="bg-primary text-white rounded-3 p-5 mb-4">
    <%-- text-center: 텍스트를 가운데 정렬 --%>
    <div class="text-center">
        <%-- display-5: Bootstrap 큰 제목 스타일 (display-1이 가장 크고, 6이 가장 작음) --%>
        <%-- fw-bold: font-weight bold (굵은 글씨) --%>
        <h1 class="display-5 fw-bold">
            <i class="bi bi-shop"></i> 팀 맛집 리스트
        </h1>
        <%-- lead: 본문보다 약간 큰 강조 텍스트 (부제목용) --%>
        <%-- mb-4: 아래 여백 24px --%>
        <p class="lead mb-4">
            우리 동네 숨은 맛집을 발견하고, 리뷰를 공유하세요!
        </p>

        <%-- ======================================================= --%>
        <%-- 📌 버튼 그룹 영역                                         --%>
        <%-- d-flex → display: flex (가로 배치)                        --%>
        <%-- justify-content-center → 가운데 정렬                      --%>
        <%-- gap-2 → 버튼 사이 간격 8px                                --%>
        <%-- ======================================================= --%>
        <div class="d-flex justify-content-center gap-2">
            <%-- btn btn-light → 밝은(흰색) 배경 버튼 --%>
            <%-- btn-lg → 큰 사이즈 버튼 --%>
            <a href="/restaurants" class="btn btn-light btn-lg">
                <i class="bi bi-search"></i> 맛집 둘러보기
            </a>

            <%-- ======================================================= --%>
            <%-- 📌 <c:if> 조건부 렌더링                                   --%>
            <%-- 비로그인 상태(empty loginMember)면            --%>
            <%-- "회원가입" 버튼을 표시                                     --%>
            <%-- ======================================================= --%>
            <c:if test="${empty loginMember}">
                <%-- btn-outline-light → 흰색 테두리만 있는 버튼 (투명 배경) --%>
                <a href="/members/signup" class="btn btn-outline-light btn-lg">
                    <i class="bi bi-person-plus"></i> 회원가입
                </a>
            </c:if>

            <%-- 로그인 상태면 "맛집 등록" 버튼을 표시 --%>
            <c:if test="${not empty loginMember}">
                <a href="/restaurants/new" class="btn btn-outline-light btn-lg">
                    <i class="bi bi-plus-circle"></i> 맛집 등록
                </a>
            </c:if>
        </div>
    </div>
</div>

<%-- ============================================================ --%>
<%-- 📌 카테고리 바로가기 섹션                                       --%>
<%-- Bootstrap 그리드 시스템 설명:                                   --%>
<%--   row → 행(가로줄)을 만듦                                      --%>
<%--   g-3 → gap 3단위 (카드 사이 간격 16px)                        --%>
<%--   mb-5 → 아래 여백 48px                                        --%>
<%--   col-4 → 모바일에서 한 줄에 3개 (12/4=3)                      --%>
<%--   col-md-2 → 중간화면(md=768px+)에서 한 줄에 6개 (12/2=6)     --%>
<%-- Bootstrap 그리드: 화면을 12칸으로 나누어 배치하는 시스템        --%>
<%-- 비유: 바둑판처럼 칸을 나누고, 각 카드가 몇 칸을 차지할지 지정  --%>
<%-- ============================================================ --%>
<div class="row g-3 mb-5">
    <%-- 한식 카테고리 카드 --%>
    <div class="col-4 col-md-2">
        <%-- category=KOREAN 파라미터를 URL에 붙여서 서버에 전달 --%>
        <%-- text-decoration-none: 밑줄 제거 --%>
        <a href="/restaurants?category=KOREAN" class="text-decoration-none">
            <%-- card: Bootstrap 카드 컴포넌트 (테두리 있는 박스) --%>
            <%-- text-center: 가운데 정렬 --%>
            <%-- p-3: 안쪽 여백 16px --%>
            <%-- h-100: height 100% (같은 행의 카드 높이를 동일하게) --%>
            <div class="card text-center p-3 h-100">
                <%-- fs-1: font-size 1 (가장 큰 글씨 크기 = 이모지를 크게 표시) --%>
                <div class="fs-1">🍚</div>
                <%-- fw-bold: 굵은 글씨, text-dark: 어두운(검정) 글자색 --%>
                <div class="fw-bold text-dark">한식</div>
            </div>
        </a>
    </div>

    <%-- 중식 카테고리 카드 --%>
    <div class="col-4 col-md-2">
        <a href="/restaurants?category=CHINESE" class="text-decoration-none">
            <div class="card text-center p-3 h-100">
                <div class="fs-1">🥟</div>
                <div class="fw-bold text-dark">중식</div>
            </div>
        </a>
    </div>

    <%-- 일식 카테고리 카드 --%>
    <div class="col-4 col-md-2">
        <a href="/restaurants?category=JAPANESE" class="text-decoration-none">
            <div class="card text-center p-3 h-100">
                <div class="fs-1">🍣</div>
                <div class="fw-bold text-dark">일식</div>
            </div>
        </a>
    </div>

    <%-- 양식 카테고리 카드 --%>
    <div class="col-4 col-md-2">
        <a href="/restaurants?category=WESTERN" class="text-decoration-none">
            <div class="card text-center p-3 h-100">
                <div class="fs-1">🍝</div>
                <div class="fw-bold text-dark">양식</div>
            </div>
        </a>
    </div>

    <%-- 카페 카테고리 카드 --%>
    <div class="col-4 col-md-2">
        <a href="/restaurants?category=CAFE" class="text-decoration-none">
            <div class="card text-center p-3 h-100">
                <div class="fs-1">☕</div>
                <div class="fw-bold text-dark">카페</div>
            </div>
        </a>
    </div>

    <%-- 기타 카테고리 카드 --%>
    <div class="col-4 col-md-2">
        <a href="/restaurants?category=ETC" class="text-decoration-none">
            <div class="card text-center p-3 h-100">
                <div class="fs-1">🍽️</div>
                <div class="fw-bold text-dark">기타</div>
            </div>
        </a>
    </div>
</div>

<%-- ============================================================ --%>
<%-- 📌 최근 등록된 맛집 카드 섹션                                   --%>
<%-- ============================================================ --%>
<%-- mb-3: 아래 여백 16px --%>
<h2 class="mb-3">
    <%-- bi-fire: 불꽃 아이콘 (인기/최신을 나타냄) --%>
    <i class="bi bi-fire"></i> 최근 등록된 맛집
</h2>

<%-- ============================================================ --%>
<%-- 📌 맛집 카드 목록 (Bootstrap 그리드)                             --%>
<%-- row → 행(가로줄), g-4 → 카드 간격 24px                        --%>
<%-- ============================================================ --%>
<div class="row g-4">

    <%-- ======================================================= --%>
    <%-- 📌 JSTL <c:choose> - 맛집 데이터 유무에 따른 분기          --%>
    <%-- restaurants 변수는 Controller가 Model에 담아서 전달한 데이터--%>
    <%-- 비유: 냉장고에 재료가 있으면 요리하고, 없으면 "비었다" 표시 --%>
    <%-- ======================================================= --%>
    <c:choose>
        <%-- 맛집 데이터가 있을 때 (restaurants 리스트가 비어있지 않을 때) --%>
        <c:when test="${not empty restaurants}">

            <%-- ======================================================= --%>
            <%-- 📌 JSTL <c:forEach> - 반복문 (맛집 목록을 하나씩 출력)    --%>
            <%-- var="restaurant" → 반복할 때 각 항목을 'restaurant'로 접근--%>
            <%-- items="${restaurants}" → 반복할 리스트 (Controller에서 전달)--%>
            <%-- 비유: 바구니(restaurants)에서 사과(restaurant)를 하나씩 꺼냄--%>
            <%-- ======================================================= --%>
            <c:forEach var="restaurant" items="${restaurants}">
                <%-- col-md-6 → 중간화면에서 한 줄에 2개 (12/6=2) --%>
                <%-- col-lg-4 → 큰 화면에서 한 줄에 3개 (12/4=3) --%>
                <div class="col-md-6 col-lg-4">
                    <%-- card h-100: 카드 컴포넌트, 높이 100% (같은 줄 카드 높이 통일) --%>
                    <div class="card h-100">
                        <%-- card-body: 카드 내부 패딩이 있는 영역 --%>
                        <div class="card-body">
                            <%-- d-flex: 가로 배치 --%>
                            <%-- justify-content-between: 양쪽 끝으로 배치 (이름↔카테고리) --%>
                            <%-- align-items-start: 위쪽 정렬 --%>
                            <%-- mb-2: 아래 여백 8px --%>
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <%-- card-title: 카드 제목 스타일 --%>
                                <%-- mb-0: 아래 여백 제거 --%>
                                <h5 class="card-title mb-0">
                                    <%-- ${restaurant.id}: 맛집 고유번호 (URL에 사용) --%>
                                    <%-- ${restaurant.name}: 맛집 이름 --%>
                                    <a href="/restaurants/${restaurant.id}"
                                       class="text-decoration-none text-dark">
                                        ${restaurant.name}
                                    </a>
                                </h5>
                                <%-- badge bg-primary: 파란색 뱃지 (라벨/태그) --%>
                                <%-- ${restaurant.categoryDisplayName}: 카테고리 한글명 (예: "한식") --%>
                                <span class="badge bg-primary">
                                    ${restaurant.categoryDisplayName}
                                </span>
                            </div>

                            <%-- 맛집 주소 표시 --%>
                            <%-- card-text: 카드 본문 텍스트 --%>
                            <%-- text-muted: 회색 글자, small: 작은 글씨 --%>
                            <p class="card-text text-muted small mb-2">
                                <%-- bi-geo-alt: 위치 핀 아이콘 --%>
                                <i class="bi bi-geo-alt"></i> ${restaurant.address}
                            </p>

                            <%-- 맛집 설명 --%>
                            <p class="card-text">
                                ${restaurant.description}
                            </p>

                            <%-- 별점 + 작성자 영역 --%>
                            <div class="d-flex justify-content-between align-items-center">
                                <%-- rating-stars: 커스텀 CSS (노란색 별) --%>
                                <div class="rating-stars">
                                    <%-- ======================================= --%>
                                    <%-- 📌 별점 표시 반복문                       --%>
                                    <%-- begin="1" end="5" → 1부터 5까지 반복     --%>
                                    <%-- var="star" → 현재 반복 번호 (1,2,3,4,5) --%>
                                    <%-- ======================================= --%>
                                    <c:forEach begin="1" end="5" var="star">
                                        <%-- 📌 <c:choose>로 채워진 별/빈 별 결정 --%>
                                        <%-- star <= averageRating이면 채워진 별  --%>
                                        <%-- 예: 평점 3이면 ★★★☆☆              --%>
                                        <c:choose>
                                            <c:when test="${star <= restaurant.averageRating}">
                                                <%-- bi-star-fill: 채워진 별(★) --%>
                                                <i class="bi bi-star-fill"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <%-- bi-star: 빈 별(☆) --%>
                                                <i class="bi bi-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <%-- ms-1: margin-start(왼쪽 여백) 1단위 (4px) --%>
                                    <span class="text-muted small ms-1">
                                        (${restaurant.averageRating})
                                    </span>
                                </div>
                                <%-- 등록자 닉네임 --%>
                                <small class="text-muted">
                                    by ${restaurant.memberNickname}
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>

        <%-- 맛집 데이터가 없을 때 (restaurants가 비어있을 때) --%>
        <c:otherwise>
            <div class="col-12">
                <%-- alert alert-info: Bootstrap 정보 알림 (하늘색 박스) --%>
                <%-- text-center: 가운데 정렬 --%>
                <div class="alert alert-info text-center">
                    <i class="bi bi-info-circle"></i>
                    아직 등록된 맛집이 없습니다. 첫 번째 맛집을 등록해보세요!
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%-- 공통 푸터 포함 (</main>, <footer>, Bootstrap JS, </body></html>) --%>
<jsp:include page="common/footer.jsp"/>
