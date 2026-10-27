<%-- ============================================================ --%>
<%-- 📌 JSP 페이지 기본 설정 (Page Directive)                      --%>
<%-- contentType="text/html;charset=UTF-8" → HTML 문서, 한글 지원  --%>
<%-- language="java" → JSP 내부에서 Java 코드 사용 가능            --%>
<%-- ============================================================ --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- ============================================================ --%>
<%-- 📌 JSTL Core 태그 라이브러리 선언                               --%>
<%-- ============================================================ --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- ============================================================ --%>
<%-- [form.jsp] 맛집 등록/수정 페이지 (등록과 수정을 하나로 통합)     --%>
<%-- ============================================================ --%>
<%-- URL (등록): http://localhost:8080/restaurants/new               --%>
<%-- URL (수정): http://localhost:8080/restaurants/{id}/edit         --%>
<%-- Controller: RestaurantController                               --%>
<%--   → 등록: createForm() 메서드                                  --%>
<%--   → 수정: editForm() 메서드                                    --%>
<%-- 역할: 맛집 이름, 카테고리, 주소, 전화번호, 설명을 입력/수정     --%>
<%--                                                               --%>
<%-- ★ 이 페이지의 핵심 아이디어:                                   --%>
<%--   등록(새로 만들기)과 수정(기존 데이터 변경)을 하나의 JSP에서   --%>
<%--   처리합니다. 'restaurant' 변수의 유무로 구분합니다.            --%>
<%--   - restaurant가 없으면 → 등록 모드 (빈 폼)                   --%>
<%--   - restaurant가 있으면 → 수정 모드 (기존 데이터로 채워진 폼)  --%>
<%-- 비유: 같은 신청서(폼)를 "신규 가입"과 "정보 수정"에 재사용     --%>
<%-- ============================================================ --%>

<%-- ============================================================ --%>
<%-- 📌 페이지 제목 동적 설정                                       --%>
<%-- ${not empty restaurant ? '맛집 수정' : '맛집 등록'}            --%>
<%--   → restaurant 객체가 존재하면(수정 모드) '맛집 수정'          --%>
<%--   → restaurant 객체가 없으면(등록 모드) '맛집 등록'            --%>
<%-- ============================================================ --%>
<c:set var="pageTitle" value="${not empty restaurant ? '맛집 수정' : '맛집 등록'}" scope="request"/>

<%-- ============================================================ --%>
<%-- 📌 편의 변수 'isEdit' 설정                                      --%>
<%-- 수정 모드인지 아닌지를 boolean(참/거짓)으로 저장                --%>
<%-- 이후 코드에서 ${isEdit}만으로 간단하게 모드를 확인할 수 있음   --%>
<%-- 비유: "수정 모드입니까?" 라는 질문에 대한 답(Yes/No)을 저장    --%>
<%-- ============================================================ --%>
<c:set var="isEdit" value="${not empty restaurant}"/>

<%-- 공통 헤더 포함 --%>
<jsp:include page="../common/header.jsp"/>

<%-- ============================================================ --%>
<%-- 📌 폼 레이아웃                                                 --%>
<%-- row justify-content-center → 가운데 정렬                      --%>
<%-- col-md-7 → 중간화면에서 12칸 중 7칸 (약 58% 너비)            --%>
<%-- ============================================================ --%>
<div class="row justify-content-center">
    <div class="col-md-7">
        <div class="card shadow-sm">
            <div class="card-body p-4">
                <%-- ======================================================= --%>
                <%-- 📌 제목: 모드에 따라 아이콘과 텍스트가 달라짐              --%>
                <%-- 수정 모드: 연필 아이콘(bi-pencil) + "맛집 수정"           --%>
                <%-- 등록 모드: 플러스 아이콘(bi-plus-circle) + "맛집 등록"    --%>
                <%-- ======================================================= --%>
                <h3 class="card-title text-center mb-4">
                    <i class="bi ${isEdit ? 'bi-pencil' : 'bi-plus-circle'}"></i>
                    ${isEdit ? '맛집 수정' : '맛집 등록'}
                </h3>

                <%-- 에러 메시지 표시 영역 (처음에는 숨김) --%>
                <div id="errorMsg" class="alert alert-danger d-none"></div>

                <%-- ======================================================= --%>
                <%-- 📌 맛집 등록/수정 폼                                      --%>
                <%-- id="restaurantForm": JavaScript에서 이벤트 리스너 등록용  --%>
                <%-- ======================================================= --%>
                <form id="restaurantForm">
                    <%-- ======================================= --%>
                    <%-- 맛집 이름 입력 필드                        --%>
                    <%-- <span class="text-danger">*</span>       --%>
                    <%--   → 빨간색 별표(*) = 필수 입력 표시       --%>
                    <%-- ======================================= --%>
                    <div class="mb-3">
                        <label for="name" class="form-label">맛집 이름 <span class="text-danger">*</span></label>
                        <%-- value="${isEdit ? restaurant.name : ''}" --%>
                        <%--   → 수정 모드면 기존 이름을 채워넣고, 등록 모드면 빈칸 --%>
                        <%-- maxlength="50": 최대 50자 --%>
                        <input type="text" class="form-control" id="name"
                               value="${isEdit ? restaurant.name : ''}"
                               placeholder="맛집 이름을 입력하세요" maxlength="50" required>
                    </div>

                    <%-- ======================================= --%>
                    <%-- 카테고리 선택 드롭다운                      --%>
                    <%-- form-select: Bootstrap 셀렉트(드롭다운) 스타일 --%>
                    <%-- ======================================= --%>
                    <div class="mb-3">
                        <label for="category" class="form-label">카테고리 <span class="text-danger">*</span></label>
                        <select class="form-select" id="category" required>
                            <%-- 기본 옵션 (value=""이므로 선택하지 않으면 유효성 검사 실패) --%>
                            <option value="">카테고리를 선택하세요</option>
                            <%-- 카테고리 목록을 반복하며 <option> 생성 --%>
                            <c:forEach var="cat" items="${categories}">
                                <%-- ======================================= --%>
                                <%-- ${isEdit && restaurant.category == cat ? 'selected' : ''} --%>
                                <%--   → 수정 모드이고 현재 카테고리가 기존 값과 같으면       --%>
                                <%--     'selected' 속성 추가 (= 기본 선택 상태로 표시)       --%>
                                <%-- 비유: 수정할 때 이전에 선택했던 항목이 미리 선택되어 있음 --%>
                                <%-- ======================================= --%>
                                <option value="${cat}"
                                    ${isEdit && restaurant.category == cat ? 'selected' : ''}>
                                    ${cat.displayName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <%-- 주소 입력 필드 --%>
                    <div class="mb-3">
                        <label for="address" class="form-label">주소 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="address"
                               value="${isEdit ? restaurant.address : ''}"
                               placeholder="서울시 강남구 역삼동 123-4" required>
                    </div>

                    <%-- 전화번호 입력 필드 (선택 사항 - required 없음) --%>
                    <div class="mb-3">
                        <label for="phone" class="form-label">전화번호</label>
                        <input type="text" class="form-control" id="phone"
                               value="${isEdit ? restaurant.phone : ''}"
                               placeholder="02-1234-5678">
                    </div>

                    <%-- ======================================= --%>
                    <%-- 설명 입력 (여러 줄 텍스트 영역)             --%>
                    <%-- textarea: 여러 줄 입력 가능한 텍스트 필드  --%>
                    <%-- rows="3": 기본 표시 높이 3줄              --%>
                    <%-- maxlength="500": 최대 500자              --%>
                    <%-- ★ textarea는 value 속성 대신 태그 사이에 값을 넣음 --%>
                    <%-- ======================================= --%>
                    <div class="mb-3">
                        <label for="description" class="form-label">설명</label>
                        <textarea class="form-control" id="description" rows="3"
                                  maxlength="500"
                                  placeholder="맛집을 소개해주세요 (500자 이내)">${isEdit ? restaurant.description : ''}</textarea>
                    </div>

                    <%-- ======================================= --%>
                    <%-- 버튼 영역                                  --%>
                    <%-- d-flex gap-2: 가로 배치 + 간격 8px        --%>
                    <%-- flex-grow-1: 남은 공간을 모두 차지         --%>
                    <%-- btn-outline-secondary: 회색 테두리 버튼    --%>
                    <%-- ======================================= --%>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary flex-grow-1">
                            <%-- 모드에 따라 아이콘과 텍스트 변경 --%>
                            <i class="bi ${isEdit ? 'bi-check-lg' : 'bi-plus-circle'}"></i>
                            ${isEdit ? '수정 완료' : '등록하기'}
                        </button>
                        <%-- 취소 버튼: 맛집 목록으로 이동 --%>
                        <a href="/restaurants" class="btn btn-outline-secondary">취소</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%-- ============================================================ --%>
<%-- 📌 JavaScript - 맛집 등록/수정 처리 로직                        --%>
<%-- ============================================================ --%>
<%-- ★ JSP EL과 JavaScript 변수의 혼합 사용 설명:                    --%>
<%--   아래 코드에서 ${isEdit}와 ${restaurant.id}는 JSP EL입니다.    --%>
<%--   서버에서 페이지를 생성할 때 실제 값으로 치환됩니다.            --%>
<%--   예: const isEdit = ${isEdit}; → const isEdit = true;         --%>
<%--       const restaurantId = '${restaurant.id}'; → '5'          --%>
<%--   이것은 의도적인 사용으로, \${}가 아닌 ${}를 사용합니다.       --%>
<%--   JSP 서버가 먼저 값을 채워넣고, 그 결과가 JavaScript로 실행됨  --%>
<%-- ============================================================ --%>
<script>
// ★ fetch API 패턴 설명 (비전공자용):
// fetch('URL', {옵션}) = 서버에 요청을 보내는 함수 (비유: 전화 걸기)
//   .then(response => ...) = 서버 응답을 받으면 실행 (비유: 전화 받기)
//   .then(data => ...)     = 응답 데이터를 처리    (비유: 통화 내용 메모)
//   .catch(err => ...)     = 에러 발생 시 실행     (비유: 통화 실패 시 재시도)

// ★ JSP EL ${isEdit} → 서버에서 true 또는 false 값으로 치환됨
// 수정 모드인지 여부를 JavaScript 변수에 저장
const isEdit = ${isEdit};

// ★ JSP EL ${restaurant.id} → 서버에서 맛집 ID 값으로 치환됨
// 수정 모드일 때만 ID가 필요 (등록 모드면 빈 문자열)
const restaurantId = '${isEdit ? restaurant.id : ""}';

// ★ 폼 제출 이벤트 리스너
document.getElementById('restaurantForm').addEventListener('submit', function(e) {
    // 폼의 기본 동작 방지 (fetch로 직접 전송)
    e.preventDefault();

    // 에러 메시지 숨기기 (이전 에러 초기화)
    const errorMsg = document.getElementById('errorMsg');
    errorMsg.classList.add('d-none');

    // ★ 폼 입력값을 JavaScript 객체로 구성
    // .trim() → 앞뒤 공백 제거
    const data = {
        name: document.getElementById('name').value.trim(),
        category: document.getElementById('category').value,
        address: document.getElementById('address').value.trim(),
        phone: document.getElementById('phone').value.trim(),
        description: document.getElementById('description').value.trim()
    };

    // ★ 모드에 따라 API 주소와 HTTP 메서드를 다르게 설정
    // 수정 모드: PUT /api/restaurants/5 (5번 맛집 수정)
    // 등록 모드: POST /api/restaurants  (새 맛집 생성)
    // PUT: 기존 데이터를 "덮어쓰기" (수정)
    // POST: 새로운 데이터를 "만들기" (등록)
    const url = isEdit ? '/api/restaurants/' + restaurantId : '/api/restaurants';
    const method = isEdit ? 'PUT' : 'POST';

    // ★ 서버에 등록/수정 요청 전송
    fetch(url, {
        method: method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(response => {
        if (response.ok) {
            // ★ 성공 → 서버가 반환한 맛집 정보에서 ID를 추출하여 상세 페이지로 이동
            return response.json().then(res => {
                // 예: /restaurants/5 → 5번 맛집 상세 페이지
                window.location.href = '/restaurants/' + res.id;
            });
        } else {
            // ★ 실패 → 에러 메시지 표시
            return response.json().then(err => {
                errorMsg.textContent = err.error || '저장에 실패했습니다.';
                errorMsg.classList.remove('d-none');
            });
        }
    })
    .catch(() => {
        // ★ 네트워크 오류 처리
        errorMsg.textContent = '서버 오류가 발생했습니다.';
        errorMsg.classList.remove('d-none');
    });
});
</script>

<%-- 공통 푸터 포함 --%>
<jsp:include page="../common/footer.jsp"/>
