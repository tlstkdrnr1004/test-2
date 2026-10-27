<%-- ============================================================ --%>
<%-- 📌 JSP 페이지 기본 설정 (Page Directive)                      --%>
<%-- contentType="text/html;charset=UTF-8" → HTML 문서, 한글 지원  --%>
<%-- language="java" → JSP 내부에서 Java 코드 사용 가능            --%>
<%-- ============================================================ --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- ============================================================ --%>
<%-- 📌 JSTL Core 태그 라이브러리 선언                               --%>
<%-- <c:set> 등 JSTL 태그를 사용하기 위해 반드시 선언               --%>
<%-- ============================================================ --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- ============================================================ --%>
<%-- [login.jsp] 로그인 페이지                                       --%>
<%-- ============================================================ --%>
<%-- URL: http://localhost:8080/members/login                       --%>
<%-- Controller: MemberController → loginPage() 메서드              --%>
<%-- 역할: 이메일과 비밀번호를 입력받아 로그인 처리                  --%>
<%--       로그인 성공 시 홈(/)으로 이동                             --%>
<%--       로그인 실패 시 에러 메시지 표시                           --%>
<%-- 비유: 건물 출입문의 비밀번호 입력 패드                         --%>
<%--                                                               --%>
<%-- ★ 이 페이지의 특징:                                           --%>
<%--   일반적인 <form> 제출(submit) 대신, JavaScript의 fetch API를 --%>
<%--   사용하여 서버에 로그인 요청을 보냅니다.                      --%>
<%--   이유: 페이지 새로고침 없이 에러 메시지를 표시하기 위함       --%>
<%-- ============================================================ --%>

<%-- 브라우저 탭에 표시될 제목 설정 (header.jsp의 <title>에서 사용) --%>
<c:set var="pageTitle" value="로그인" scope="request"/>

<%-- 공통 헤더 포함 (../은 상위 폴더를 의미. member폴더 → views폴더 → common폴더) --%>
<jsp:include page="../common/header.jsp"/>

<%-- ============================================================ --%>
<%-- 📌 로그인 폼 레이아웃                                          --%>
<%-- row justify-content-center: 행을 만들고, 내용을 가운데 정렬    --%>
<%-- col-md-5: 중간화면(768px+)에서 12칸 중 5칸 차지                --%>
<%--           (= 화면의 약 42% 너비, 로그인 폼에 적당한 크기)      --%>
<%-- ============================================================ --%>
<div class="row justify-content-center">
    <div class="col-md-5">
        <%-- card: 카드 컴포넌트 (둥근 테두리 박스) --%>
        <%-- shadow-sm: 작은 그림자 효과 (살짝 떠 있는 느낌) --%>
        <div class="card shadow-sm">
            <%-- card-body: 카드 안쪽 내용 영역 --%>
            <%-- p-4: padding 4단위 (24px 안쪽 여백) --%>
            <div class="card-body p-4">
                <%-- card-title: 카드 제목 스타일 --%>
                <%-- text-center: 가운데 정렬 --%>
                <%-- mb-4: 아래 여백 24px --%>
                <h3 class="card-title text-center mb-4">
                    <i class="bi bi-box-arrow-in-right"></i> 로그인
                </h3>

                <%-- ======================================================= --%>
                <%-- 📌 에러 메시지 표시 영역                                   --%>
                <%-- alert alert-danger: Bootstrap 빨간색 경고 박스            --%>
                <%-- d-none: display: none (처음에는 숨김 상태)                --%>
                <%-- JavaScript에서 로그인 실패 시 d-none을 제거하여 표시       --%>
                <%-- 비유: "비밀번호가 틀렸습니다" 같은 에러를 빨간 박스로 표시 --%>
                <%-- ======================================================= --%>
                <div id="errorMsg" class="alert alert-danger d-none"></div>

                <%-- ======================================================= --%>
                <%-- 📌 로그인 폼                                              --%>
                <%-- id="loginForm": JavaScript에서 이 폼을 찾기 위한 고유 ID  --%>
                <%-- action 속성이 없음 → JavaScript(fetch API)로 직접 전송    --%>
                <%-- 일반 form은 action="/url"로 서버에 전송하지만,            --%>
                <%-- 여기서는 fetch를 사용하므로 action이 필요 없음            --%>
                <%-- ======================================================= --%>
                <form id="loginForm">
                    <%-- mb-3: margin-bottom 3단위 (16px) → 입력 필드 간격 --%>
                    <div class="mb-3">
                        <%-- form-label: Bootstrap 폼 라벨 스타일 --%>
                        <%-- for="email": 라벨 클릭 시 id="email" 입력칸에 포커스 --%>
                        <label for="email" class="form-label">이메일</label>
                        <%-- form-control: Bootstrap 입력 필드 스타일 (테두리, 패딩 등) --%>
                        <%-- type="email": 이메일 형식 유효성 검사 자동 적용 --%>
                        <%-- required: 필수 입력 (비어있으면 제출 불가) --%>
                        <input type="email" class="form-control" id="email" name="email"
                               placeholder="example@test.com" required>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">비밀번호</label>
                        <%-- type="password": 입력한 글자가 ●●●로 표시됨 (보안) --%>
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="비밀번호 입력" required>
                    </div>

                    <%-- btn btn-primary: 파란색 버튼 --%>
                    <%-- w-100: width 100% (버튼이 폼 전체 너비를 차지) --%>
                    <%-- mb-3: 아래 여백 16px --%>
                    <button type="submit" class="btn btn-primary w-100 mb-3">
                        <i class="bi bi-box-arrow-in-right"></i> 로그인
                    </button>
                </form>

                <%-- 회원가입 페이지로의 링크 --%>
                <div class="text-center">
                    <span class="text-muted">계정이 없으신가요?</span>
                    <a href="/members/signup">회원가입</a>
                </div>

                <%-- 수평선(구분선) --%>
                <hr>
                <%-- 테스트용 계정 정보 안내 (개발 중에만 사용) --%>
                <p class="text-muted small text-center mb-0">
                    테스트 계정: admin@test.com / 1234
                </p>
            </div>
        </div>
    </div>
</div>

<%-- ============================================================ --%>
<%-- 📌 JavaScript - 로그인 처리 로직                                --%>
<%-- ============================================================ --%>
<%-- ★ 이 <script> 블록 안에서는 JSP EL(${})을 사용하지 않습니다.   --%>
<%--   만약 JavaScript 안에서 ${}를 사용하면 JSP 서버가              --%>
<%--   먼저 해석해버리므로, JavaScript 변수로 인식되지 않습니다.      --%>
<%--   JavaScript의 템플릿 리터럴에서 ${}를 쓰려면 \${}로 이스케이프 --%>
<%--   해야 합니다. (이 파일에서는 템플릿 리터럴을 사용하지 않음)    --%>
<%-- ============================================================ --%>
<script>
// ★ fetch API 패턴 설명 (비전공자용):
// fetch('URL', {옵션}) = 서버에 요청을 보내는 함수 (비유: 전화 걸기)
//   .then(response => ...) = 서버 응답을 받으면 실행 (비유: 전화 받기)
//   .then(data => ...)     = 응답 데이터를 처리    (비유: 통화 내용 메모)
//   .catch(err => ...)     = 에러 발생 시 실행     (비유: 통화 실패 시 재시도)

// ★ getElementById('loginForm') → HTML에서 id="loginForm"인 요소를 찾음
// ★ addEventListener('submit', function(e) {...})
//   → 'submit'(폼 제출) 이벤트가 발생하면 함수 실행
//   비유: 초인종(submit 버튼)이 눌리면 → 문을 여는 동작(함수) 실행
document.getElementById('loginForm').addEventListener('submit', function(e) {
    // ★ e.preventDefault()
    // → 폼의 기본 동작(페이지 새로고침 + 서버 전송)을 막음
    // 이유: 우리는 fetch API로 직접 서버에 요청을 보낼 것이기 때문
    // 비유: 자동문을 끄고, 수동으로 문을 여는 것
    e.preventDefault();

    // ★ 사용자가 입력한 값을 JavaScript 객체(Object)로 만듦
    // document.getElementById('email').value → 이메일 입력칸의 값을 가져옴
    const data = {
        email: document.getElementById('email').value,
        password: document.getElementById('password').value
    };

    // ★ fetch API를 사용하여 서버에 로그인 요청 전송
    // '/api/members/login' → 서버의 로그인 API 주소
    // method: 'POST' → 데이터를 서버에 "보내는" 방식 (GET은 "받는" 방식)
    // headers → 서버에게 "JSON 형식으로 보낸다"고 알림
    // body: JSON.stringify(data) → JavaScript 객체를 JSON 문자열로 변환
    //   비유: 편지(data)를 봉투(JSON)에 넣어서 우체통(서버)에 넣음
    fetch('/api/members/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(response => {
        // ★ response.ok → 서버 응답이 성공(200번대)인지 확인
        if (response.ok) {
            // ★ 로그인 성공 → 홈페이지('/')로 이동
            // window.location.href → 브라우저의 주소창을 변경 (페이지 이동)
            window.location.href = '/';
        } else {
            // ★ 로그인 실패 → 에러 메시지를 화면에 표시
            // response.json() → 서버가 보낸 에러 정보를 JSON으로 변환
            return response.json().then(err => {
                // 에러 메시지 텍스트 설정
                document.getElementById('errorMsg').textContent = err.error;
                // d-none 클래스를 제거하여 에러 메시지를 화면에 보여줌
                // d-none = display: none(숨김) → 제거하면 보임
                document.getElementById('errorMsg').classList.remove('d-none');
            });
        }
    })
    .catch(() => {
        // ★ 네트워크 오류 등 예외 상황 처리
        // 서버에 연결조차 못 했을 때 (인터넷 끊김 등)
        document.getElementById('errorMsg').textContent = '서버 오류가 발생했습니다.';
        document.getElementById('errorMsg').classList.remove('d-none');
    });
});
</script>

<%-- 공통 푸터 포함 --%>
<jsp:include page="../common/footer.jsp"/>
