<%-- ============================================================ --%>
<%-- 📌 JSP 페이지 기본 설정 (Page Directive)                      --%>
<%-- contentType="text/html;charset=UTF-8" → HTML 문서, 한글 지원  --%>
<%-- language="java" → JSP 내부에서 Java 코드 사용 가능            --%>
<%-- ============================================================ --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- ============================================================ --%>
<%-- 📌 JSTL Core 태그 라이브러리 선언                               --%>
<%-- <c:set> 태그를 사용하기 위해 필요                              --%>
<%-- ============================================================ --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- ============================================================ --%>
<%-- [signup.jsp] 회원가입 페이지                                    --%>
<%-- ============================================================ --%>
<%-- URL: http://localhost:8080/members/signup                      --%>
<%-- Controller: MemberController → signupPage() 메서드             --%>
<%-- 역할: 이메일, 비밀번호, 닉네임을 입력받아 회원가입 처리         --%>
<%--       가입 성공 시 로그인 페이지로 자동 이동                    --%>
<%--       가입 실패 시 에러 메시지 표시                             --%>
<%-- 비유: 놀이공원 연간 회원권 등록 창구                           --%>
<%--                                                               --%>
<%-- ★ 이 페이지의 특징:                                           --%>
<%--   login.jsp와 마찬가지로 fetch API를 사용하여 서버에 요청       --%>
<%--   성공 시 1.5초 후 로그인 페이지로 자동 이동 (setTimeout 사용) --%>
<%-- ============================================================ --%>

<%-- 브라우저 탭에 표시될 제목 설정 --%>
<c:set var="pageTitle" value="회원가입" scope="request"/>

<%-- 공통 헤더 포함 --%>
<jsp:include page="../common/header.jsp"/>

<%-- ============================================================ --%>
<%-- 📌 회원가입 폼 레이아웃                                        --%>
<%-- row justify-content-center → 가운데 정렬된 행                 --%>
<%-- col-md-5 → 중간화면에서 화면의 약 42% 너비                    --%>
<%-- ============================================================ --%>
<div class="row justify-content-center">
    <div class="col-md-5">
        <%-- card shadow-sm: 그림자 있는 카드 박스 --%>
        <div class="card shadow-sm">
            <%-- card-body p-4: 안쪽 여백 24px --%>
            <div class="card-body p-4">
                <h3 class="card-title text-center mb-4">
                    <i class="bi bi-person-plus"></i> 회원가입
                </h3>

                <%-- ======================================================= --%>
                <%-- 📌 메시지 표시 영역 (에러/성공)                            --%>
                <%-- 두 개의 알림 박스가 있으며, 처음에는 둘 다 숨김(d-none)    --%>
                <%-- JavaScript에서 상황에 따라 하나를 보여줌                   --%>
                <%-- alert-danger: 빨간색 (에러), alert-success: 초록색 (성공) --%>
                <%-- ======================================================= --%>
                <div id="errorMsg" class="alert alert-danger d-none"></div>
                <div id="successMsg" class="alert alert-success d-none"></div>

                <%-- ======================================================= --%>
                <%-- 📌 회원가입 폼                                            --%>
                <%-- id="signupForm": JavaScript에서 폼을 찾기 위한 고유 ID   --%>
                <%-- ======================================================= --%>
                <form id="signupForm">
                    <%-- 이메일 입력 필드 --%>
                    <div class="mb-3">
                        <label for="email" class="form-label">이메일</label>
                        <%-- type="email": 브라우저가 자동으로 이메일 형식 검사 --%>
                        <%-- required: 빈칸이면 제출 불가 --%>
                        <input type="email" class="form-control" id="email" name="email"
                               placeholder="example@test.com" required>
                    </div>

                    <%-- 비밀번호 입력 필드 --%>
                    <div class="mb-3">
                        <label for="password" class="form-label">비밀번호</label>
                        <%-- minlength="4": 최소 4자 이상 --%>
                        <%-- maxlength="20": 최대 20자 이하 --%>
                        <%-- 브라우저가 자동으로 글자 수 검사를 해줌 --%>
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="4~20자" minlength="4" maxlength="20" required>
                    </div>

                    <%-- 닉네임 입력 필드 --%>
                    <div class="mb-3">
                        <label for="nickname" class="form-label">닉네임</label>
                        <%-- minlength="2" maxlength="10": 2~10자 제한 --%>
                        <input type="text" class="form-control" id="nickname" name="nickname"
                               placeholder="2~10자" minlength="2" maxlength="10" required>
                    </div>

                    <%-- 가입하기 버튼 --%>
                    <%-- btn-primary w-100: 파란색 버튼, 너비 100% --%>
                    <button type="submit" class="btn btn-primary w-100 mb-3">
                        <i class="bi bi-person-plus"></i> 가입하기
                    </button>
                </form>

                <%-- 로그인 페이지로의 링크 --%>
                <div class="text-center">
                    <span class="text-muted">이미 계정이 있으신가요?</span>
                    <a href="/members/login">로그인</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- ============================================================ --%>
<%-- 📌 JavaScript - 회원가입 처리 로직                              --%>
<%-- ============================================================ --%>
<%-- ★ JSP EL과 JavaScript의 ${} 충돌 설명:                         --%>
<%--   JSP에서 ${}는 서버 측 변수를 출력하는 EL(Expression Language) --%>
<%--   JavaScript에서 ${}는 템플릿 리터럴(백틱 `` 안)에서 변수 삽입 --%>
<%--   이 파일에서는 JavaScript에서 템플릿 리터럴을 사용하지 않으므로--%>
<%--   충돌이 발생하지 않습니다.                                     --%>
<%-- ============================================================ --%>
<script>
// ★ fetch API 패턴 설명 (비전공자용):
// fetch('URL', {옵션}) = 서버에 요청을 보내는 함수 (비유: 전화 걸기)
//   .then(response => ...) = 서버 응답을 받으면 실행 (비유: 전화 받기)
//   .then(data => ...)     = 응답 데이터를 처리    (비유: 통화 내용 메모)
//   .catch(err => ...)     = 에러 발생 시 실행     (비유: 통화 실패 시 재시도)

// ★ 회원가입 폼에 submit(제출) 이벤트 리스너 등록
// 비유: "가입하기 버튼이 눌리면 이 함수를 실행해라"라는 명령
document.getElementById('signupForm').addEventListener('submit', function(e) {
    // ★ 폼의 기본 동작(페이지 새로고침) 방지
    e.preventDefault();

    // ★ 에러/성공 메시지 요소를 변수에 저장 (여러 번 사용하므로)
    const errorMsg = document.getElementById('errorMsg');
    const successMsg = document.getElementById('successMsg');

    // ★ 이전에 표시되었던 메시지를 숨김 (새로 시도할 때마다 초기화)
    // classList.add('d-none') → d-none 클래스를 추가 → 숨김
    errorMsg.classList.add('d-none');
    successMsg.classList.add('d-none');

    // ★ 입력 필드에서 값을 가져와 객체로 구성
    const data = {
        email: document.getElementById('email').value,
        password: document.getElementById('password').value,
        nickname: document.getElementById('nickname').value
    };

    // ★ 서버의 회원가입 API에 POST 요청 전송
    // '/api/members/signup' → 회원가입을 처리하는 서버 주소
    fetch('/api/members/signup', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(response => {
        if (response.ok) {
            // ★ 가입 성공 → 초록색 성공 메시지 표시
            successMsg.textContent = '회원가입 성공! 로그인 페이지로 이동합니다.';
            successMsg.classList.remove('d-none');

            // ★ setTimeout → 일정 시간(1500ms = 1.5초) 후 함수 실행
            // 비유: "1.5초 뒤에 로그인 페이지로 이동해라"라는 예약
            // 사용자가 성공 메시지를 읽을 시간을 주기 위함
            setTimeout(() => window.location.href = '/members/login', 1500);
        } else {
            // ★ 가입 실패 → 빨간색 에러 메시지 표시
            // 서버가 보낸 에러 메시지를 파싱하여 표시
            return response.json().then(err => {
                errorMsg.textContent = err.error || '가입에 실패했습니다.';
                errorMsg.classList.remove('d-none');
            });
        }
    })
    .catch(() => {
        // ★ 네트워크 오류 등 서버 연결 실패 시
        errorMsg.textContent = '서버 오류가 발생했습니다.';
        errorMsg.classList.remove('d-none');
    });
});
</script>

<%-- 공통 푸터 포함 --%>
<jsp:include page="../common/footer.jsp"/>
