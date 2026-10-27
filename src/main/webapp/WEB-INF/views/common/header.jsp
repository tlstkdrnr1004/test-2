<%-- ============================================================ --%>
<%-- 📌 JSP 페이지 기본 설정 (Page Directive)                      --%>
<%-- contentType="text/html;charset=UTF-8"                        --%>
<%--   → 이 페이지가 HTML 문서이며, 한글(UTF-8)을 사용함을 선언     --%>
<%-- language="java"                                               --%>
<%--   → 이 JSP 안에서 사용하는 프로그래밍 언어가 Java임을 선언      --%>
<%-- ============================================================ --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- ============================================================ --%>
<%-- 📌 JSTL 태그 라이브러리 선언 (Taglib Directive)                --%>
<%-- prefix="c" → JSTL 태그를 사용할 때 <c:태그명> 형식으로 사용    --%>
<%-- uri="jakarta.tags.core" → JSTL의 핵심(Core) 기능 모음을 가져옴 --%>
<%--   비유: 워드프로세서에서 "도구 모음"을 불러오는 것과 같음       --%>
<%--   이걸 선언해야 <c:if>, <c:forEach>, <c:choose> 등을 쓸 수 있음--%>
<%-- ============================================================ --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- ============================================================ --%>
<%-- [header.jsp] 모든 페이지에 포함되는 공통 헤더                    --%>
<%-- ============================================================ --%>
<%-- 역할: HTML 시작태그, Bootstrap CSS 로드, 네비게이션 바를 정의     --%>
<%--                                                               --%>
<%-- 사용 방법: 다른 JSP에서 <jsp:include page="common/header.jsp"/> --%>
<%--           로 이 파일을 포함시킵니다.                            --%>
<%--                                                               --%>
<%-- 비유: 편지봉투의 "보내는 사람 주소" 스티커처럼,                  --%>
<%--       모든 페이지에 동일한 상단 메뉴가 자동으로 붙음             --%>
<%--                                                               --%>
<%-- 이 파일은 단독으로 사용되지 않으며, 반드시 다른 JSP에서          --%>
<%-- <jsp:include>로 포함되어야 합니다.                              --%>
<%-- Controller: 별도 컨트롤러 없음 (포함되는 파일)                  --%>
<%-- ============================================================ --%>

<%-- HTML5 문서 타입 선언 - 모든 웹페이지는 이것으로 시작해야 함 --%>
<!DOCTYPE html>

<%-- lang="ko" → 이 문서가 한국어(Korean)로 작성되었음을 브라우저에 알림 --%>
<html lang="ko">
<head>
    <%-- charset="UTF-8" → 한글, 일본어, 중국어 등 모든 문자를 올바르게 표시 --%>
    <meta charset="UTF-8">

    <%-- 반응형 웹: 모바일 기기에서도 화면이 올바르게 보이도록 설정 --%>
    <%-- width=device-width → 기기 화면 너비에 맞춤 --%>
    <%-- initial-scale=1.0 → 처음 로드 시 확대/축소 없이 원본 크기로 표시 --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <%-- ============================================================ --%>
    <%-- 📌 JSP EL(Expression Language) 사용 예시                      --%>
    <%-- ${not empty pageTitle ? pageTitle : '팀 맛집 리스트'}          --%>
    <%--   → 삼항연산자: pageTitle 변수가 비어있지 않으면 그 값을,      --%>
    <%--     비어있으면 '팀 맛집 리스트'를 기본값으로 사용               --%>
    <%-- 비유: "이름표가 있으면 이름표를 붙이고, 없으면 '기본' 이름표"  --%>
    <%-- ============================================================ --%>
    <title>${not empty pageTitle ? pageTitle : '팀 맛집 리스트'}</title>

    <%-- ============================================================ --%>
    <%-- Bootstrap 5 CSS 파일 로드 (CDN에서 가져옴)                    --%>
    <%-- CDN(Content Delivery Network): 외부 서버에서 파일을 가져오는 방식--%>
    <%-- 비유: 편의점에서 물건을 사는 것처럼, 인터넷에서 CSS를 빌려 씀  --%>
    <%-- Bootstrap: 웹 디자인을 쉽게 해주는 CSS/JS 라이브러리          --%>
    <%--   → 버튼, 카드, 네비게이션 등 미리 만들어진 디자인 사용 가능  --%>
    <%-- ============================================================ --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <%-- ============================================================ --%>
    <%-- Bootstrap Icons 로드 - 아이콘 폰트 라이브러리                  --%>
    <%-- 사용법: <i class="bi bi-아이콘이름"></i>                       --%>
    <%-- 예시: bi-shop(가게), bi-heart(하트), bi-search(돋보기)        --%>
    <%-- ============================================================ --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
          rel="stylesheet">

    <%-- ============================================================ --%>
    <%-- 📌 커스텀 CSS 스타일 (프로젝트 전용 디자인)                    --%>
    <%-- Bootstrap 기본 디자인 위에 추가로 우리만의 스타일을 정의       --%>
    <%-- ============================================================ --%>
    <style>
        /* ========================================================= */
        /* body: 전체 페이지 설정                                     */
        /* min-height: 100vh → 최소 높이를 화면 전체로 (vh=viewport height) */
        /* display: flex + flex-direction: column                     */
        /*   → 세로 방향으로 요소를 쌓음 (헤더-본문-푸터 순서)         */
        /* background-color: #f8f9fa → 연한 회색 배경 (Bootstrap 밝은 회색) */
        /* ========================================================= */
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f8f9fa;
        }

        /* main: 본문 영역 - flex: 1은 남은 공간을 모두 차지 */
        /* 비유: 샌드위치에서 빵(헤더/푸터) 사이의 속재료 부분 */
        /* 이렇게 하면 내용이 적어도 푸터가 항상 바닥에 위치함 */
        main {
            flex: 1;
        }

        /* 네비게이션 바의 브랜드(로고) 텍스트 스타일 */
        /* font-weight: 700 → 굵은 글씨 (bold보다 세밀한 지정) */
        /* font-size: 1.3rem → 기본 글자보다 1.3배 크게 */
        .navbar-brand {
            font-weight: 700;
            font-size: 1.3rem;
        }

        /* 별점 표시 색상: 노란색(금색) */
        /* #ffc107은 Bootstrap의 warning 색상(노란색)과 동일 */
        .rating-stars {
            color: #ffc107;
        }

        /* 카드에 마우스를 올리면(hover) 살짝 위로 떠오르는 효과 */
        /* translateY(-2px) → 위로 2px 이동 */
        /* box-shadow → 그림자 효과 추가 (입체감) */
        /* transition → 효과가 0.2초 동안 부드럽게 전환 */
        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.2s ease;
        }
    </style>
</head>
<body>

<%-- ============================================================ --%>
<%-- 📌 네비게이션 바 (Navigation Bar = 상단 메뉴)                   --%>
<%-- Bootstrap 클래스 설명:                                         --%>
<%--   navbar → 네비게이션 바 기본 클래스                            --%>
<%--   navbar-expand-lg → 큰 화면(lg=992px 이상)에서 메뉴 펼침,     --%>
<%--                       작은 화면에서는 햄버거 메뉴(☰)로 접힘    --%>
<%--   navbar-dark → 어두운 배경에 맞는 밝은 글씨색 적용             --%>
<%--   bg-primary → Bootstrap 기본 파란색 배경 (#0d6efd)            --%>
<%--   mb-4 → margin-bottom 4단위 (아래쪽 여백 24px)                --%>
<%-- ============================================================ --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">

    <%-- container: 내용을 화면 중앙에 적절한 너비로 배치 --%>
    <%-- 비유: 액자 안에 사진을 넣듯, 컨텐츠를 정해진 너비 안에 배치 --%>
    <div class="container">

        <%-- navbar-brand: 사이트 로고/이름 (클릭하면 홈으로 이동) --%>
        <%-- href="/" → 루트 페이지(홈)로 이동 --%>
        <a class="navbar-brand" href="/">
            <%-- bi bi-shop: Bootstrap Icons의 "가게" 아이콘 --%>
            <i class="bi bi-shop"></i> 팀 맛집 리스트
        </a>

        <%-- ======================================================= --%>
        <%-- 📌 햄버거 메뉴 버튼 (모바일용)                            --%>
        <%-- navbar-toggler: 작은 화면에서만 보이는 토글 버튼           --%>
        <%-- data-bs-toggle="collapse": 클릭 시 접기/펼치기 동작       --%>
        <%-- data-bs-target="#navbarNav": 어떤 메뉴를 접고 펼 것인지    --%>
        <%-- 비유: 작은 화면에서 ☰ 버튼을 누르면 메뉴가 아래로 펼쳐짐  --%>
        <%-- ======================================================= --%>
        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <%-- navbar-toggler-icon: 햄버거 모양(☰) 아이콘 자동 생성 --%>
            <span class="navbar-toggler-icon"></span>
        </button>

        <%-- collapse navbar-collapse: 접었다 펼 수 있는 메뉴 영역 --%>
        <%-- id="navbarNav": 위의 버튼(data-bs-target)과 연결되는 ID --%>
        <div class="collapse navbar-collapse" id="navbarNav">

            <%-- ======================================================= --%>
            <%-- 📌 왼쪽 메뉴 영역                                        --%>
            <%-- navbar-nav: 네비게이션 메뉴 목록                          --%>
            <%-- me-auto: margin-end auto → 오른쪽 여백을 자동으로 채움    --%>
            <%--          (= 이 메뉴를 왼쪽으로 밀어붙임)                  --%>
            <%-- ======================================================= --%>
            <ul class="navbar-nav me-auto">
                <%-- nav-item: 네비게이션 메뉴 항목 하나 --%>
                <li class="nav-item">
                    <%-- nav-link: 네비게이션 안의 링크 스타일 --%>
                    <a class="nav-link" href="/restaurants">
                        <%-- bi-list-ul: 목록 아이콘 --%>
                        <i class="bi bi-list-ul"></i> 맛집 목록
                    </a>
                </li>

                <%-- ======================================================= --%>
                <%-- 📌 JSTL <c:if> 태그 - 조건부 렌더링                     --%>
                <%-- test="${not empty loginMember}"             --%>
                <%--   → 세션(로그인 정보 저장소)에 'loginMember'가 있는지 확인--%>
                <%--   → 즉, "로그인한 사용자만" 이 메뉴를 볼 수 있음        --%>
                <%-- 비유: VIP 전용 라운지처럼, 로그인한 사람만 입장 가능     --%>
                <%--                                                         --%>
                <%-- sessionScope란?                                          --%>
                <%--   → 서버가 사용자별로 관리하는 임시 저장소               --%>
                <%--   → 브라우저를 닫기 전까지 로그인 상태를 기억            --%>
                <%--   → 비유: 놀이공원 손목밴드 (입장 시 착용, 퇴장 시 반납) --%>
                <%-- ======================================================= --%>
                <c:if test="${not empty loginMember}">
                    <li class="nav-item">
                        <a class="nav-link" href="/restaurants/new">
                            <%-- bi-plus-circle: 플러스(+) 동그라미 아이콘 --%>
                            <i class="bi bi-plus-circle"></i> 맛집 등록
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/wishlists">
                            <%-- bi-heart: 하트 아이콘 --%>
                            <i class="bi bi-heart"></i> 찜 목록
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/mypage">
                            <i class="bi bi-person"></i> 마이페이지
                        </a>
                    </li>
                    <c:if test="${loginMember.role.name() == 'ADMIN'}">
                        <li class="nav-item">
                            <a class="nav-link" href="/admin">
                                <i class="bi bi-gear"></i> 관리자
                            </a>
                        </li>
                    </c:if>
                </c:if>
            </ul>

            <%-- ======================================================= --%>
            <%-- 📌 오른쪽 메뉴 영역 (로그인/로그아웃)                      --%>
            <%-- ======================================================= --%>
            <ul class="navbar-nav">

                <%-- ======================================================= --%>
                <%-- 📌 JSTL <c:choose> 태그 - if/else 분기                  --%>
                <%-- Java의 switch문 또는 if/else와 같은 역할                 --%>
                <%-- <c:when>: if 조건 (여러 개 가능)                         --%>
                <%-- <c:otherwise>: else (위 조건이 모두 거짓일 때)           --%>
                <%-- 비유: "회원이면 이름 표시, 비회원이면 로그인 버튼 표시"  --%>
                <%-- ======================================================= --%>
                <c:choose>
                    <%-- 로그인 상태일 때 (sessionScope에 loginMember가 있을 때) --%>
                    <c:when test="${not empty loginMember}">
                        <li class="nav-item">
                            <%-- text-light: 밝은(흰색) 글자색 --%>
                            <span class="nav-link text-light">
                                <%-- bi-person-circle: 사람 동그라미 아이콘 --%>
                                <i class="bi bi-person-circle"></i>
                                <%-- ${loginMember.nickname}: 로그인한 사용자의 닉네임 표시 --%>
                                <%-- 비유: "홍길동님 환영합니다" 같은 인사말 --%>
                                ${loginMember.nickname}님
                            </span>
                        </li>
                        <li class="nav-item">
                            <%-- 로그아웃 링크: /api/members/logout 주소로 이동 --%>
                            <a class="nav-link" href="/api/members/logout">
                                <%-- bi-box-arrow-right: 나가기 화살표 아이콘 --%>
                                <i class="bi bi-box-arrow-right"></i> 로그아웃
                            </a>
                        </li>
                    </c:when>

                    <%-- 비로그인 상태일 때 (로그인하지 않은 방문자) --%>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="/members/login">
                                <%-- bi-box-arrow-in-right: 들어오기 화살표 아이콘 --%>
                                <i class="bi bi-box-arrow-in-right"></i> 로그인
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/members/signup">
                                <%-- bi-person-plus: 사람+플러스 아이콘 --%>
                                <i class="bi bi-person-plus"></i> 회원가입
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<%-- ============================================================ --%>
<%-- 📌 메인 콘텐츠 영역 시작                                       --%>
<%-- container: 내용을 화면 중앙에 적절한 너비로 배치                --%>
<%-- mb-5: margin-bottom 5단위 (아래쪽 여백 48px)                   --%>
<%-- 주의: 여는 <main> 태그만 있고, 닫는 </main>은 footer.jsp에 있음--%>
<%--       header.jsp와 footer.jsp가 한 쌍으로 작동하기 때문         --%>
<%-- ============================================================ --%>
<main class="container mb-5">
