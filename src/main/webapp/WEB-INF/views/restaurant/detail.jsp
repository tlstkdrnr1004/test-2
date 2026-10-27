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
<%-- 📌 JSTL Functions 태그 라이브러리 선언                          --%>
<%-- prefix="fn" → fn:length(), fn:contains() 등 함수 사용 가능    --%>
<%-- fn:length(리스트) → 리스트의 항목 수를 반환                    --%>
<%-- 비유: 바구니 안의 사과 개수를 세는 함수                        --%>
<%-- ============================================================ --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%-- ============================================================ --%>
<%-- [detail.jsp] 맛집 상세 정보 페이지                               --%>
<%-- ============================================================ --%>
<%-- URL: http://localhost:8080/restaurants/{id}                     --%>
<%--      예: http://localhost:8080/restaurants/5                    --%>
<%-- Controller: RestaurantController → detail() 메서드             --%>
<%-- 역할: 특정 맛집의 상세 정보, 리뷰 목록, 리뷰 작성 폼을 표시    --%>
<%--       찜하기/찜 취소, 수정/삭제 기능 제공                       --%>
<%-- 비유: 배달앱에서 특정 음식점을 클릭했을 때 나오는 상세 화면     --%>
<%--                                                               --%>
<%-- ★ 이 페이지의 특징:                                           --%>
<%--   1. 가장 많은 JavaScript 함수가 있는 페이지                   --%>
<%--   2. 찜 토글, 리뷰 등록/삭제, 맛집 삭제 등 다양한 fetch 호출   --%>
<%--   3. 작성자 확인을 JavaScript로 처리 (수정/삭제 버튼 표시 여부)--%>
<%-- ============================================================ --%>

<%-- 브라우저 탭 제목: 맛집 이름으로 설정 --%>
<c:set var="pageTitle" value="${restaurant.name}" scope="request"/>

<%-- 공통 헤더 포함 --%>
<jsp:include page="../common/header.jsp"/>

<%-- ============================================================ --%>
<%-- 📌 맛집 상세 정보 카드                                          --%>
<%-- card mb-4: 카드 컴포넌트 + 아래 여백 24px                      --%>
<%-- ============================================================ --%>
<div class="card mb-4">
    <div class="card-body">
        <%-- ======================================================= --%>
        <%-- 📌 상단 영역: 맛집 이름(왼쪽) + 찜 버튼(오른쪽)            --%>
        <%-- d-flex → 가로 배치                                        --%>
        <%-- justify-content-between → 양쪽 끝으로 배치                --%>
        <%-- align-items-start → 위쪽 정렬                              --%>
        <%-- ======================================================= --%>
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <%-- 맛집 이름 (h2 = 큰 제목) --%>
                <h2 class="mb-1">${restaurant.name}</h2>
                <%-- badge bg-primary fs-6: 파란색 뱃지, 글씨 크기 약간 큼 --%>
                <span class="badge bg-primary fs-6">${restaurant.categoryDisplayName}</span>
            </div>
            <div class="text-end">
                <%-- ======================================================= --%>
                <%-- 📌 찜(하트) 버튼 - 로그인한 사용자만 표시                  --%>
                <%-- ${isWished}: Controller가 전달한 변수 (이미 찜했는지 여부) --%>
                <%-- isWished가 true면 → 빨간 배경(btn-danger) + 채운 하트     --%>
                <%-- isWished가 false면 → 빨간 테두리(btn-outline-danger) + 빈 하트 --%>
                <%-- onclick="toggleWish(${restaurant.id})"                    --%>
                <%--   → 클릭 시 toggleWish 함수 호출 (찜 추가/취소)           --%>
                <%-- ======================================================= --%>
                <c:if test="${not empty loginMember}">
                    <button id="wishBtn" class="btn ${isWished ? 'btn-danger' : 'btn-outline-danger'} mb-2"
                            onclick="toggleWish(${restaurant.id})">
                        <i class="bi ${isWished ? 'bi-heart-fill' : 'bi-heart'}"></i>
                        <span id="wishText">${isWished ? '찜 취소' : '찜하기'}</span>
                    </button>
                </c:if>
            </div>
        </div>

        <%-- 수평 구분선 --%>
        <hr>

        <%-- ======================================================= --%>
        <%-- 📌 맛집 상세 정보 영역 (2열 레이아웃)                      --%>
        <%-- col-md-8: 왼쪽 8칸 (주소, 전화, 설명)                     --%>
        <%-- col-md-4: 오른쪽 4칸 (평균 별점)                          --%>
        <%-- ======================================================= --%>
        <div class="row">
            <div class="col-md-8">
                <%-- 주소 정보 --%>
                <%-- text-primary: 파란색 아이콘 --%>
                <p><i class="bi bi-geo-alt text-primary"></i> <strong>주소:</strong> ${restaurant.address}</p>

                <%-- 전화번호: 값이 있을 때만 표시 --%>
                <c:if test="${not empty restaurant.phone}">
                    <p><i class="bi bi-telephone text-primary"></i> <strong>전화:</strong> ${restaurant.phone}</p>
                </c:if>

                <%-- 설명: 값이 있을 때만 표시 --%>
                <c:if test="${not empty restaurant.description}">
                    <p><i class="bi bi-chat-text text-primary"></i> <strong>설명:</strong> ${restaurant.description}</p>
                </c:if>

                <%-- 등록자 + 등록일 (text-muted small: 회색 작은 글씨) --%>
                <p class="text-muted small">
                    등록자: ${restaurant.memberNickname} | 등록일: ${restaurant.createdAt}
                </p>
            </div>

            <%-- ======================================================= --%>
            <%-- 📌 평균 별점 표시 영역 (오른쪽)                           --%>
            <%-- text-center: 가운데 정렬                                  --%>
            <%-- bg-light: 연한 회색 배경                                  --%>
            <%-- rounded: 둥근 모서리                                      --%>
            <%-- ======================================================= --%>
            <div class="col-md-4 text-center">
                <div class="bg-light rounded p-3">
                    <%-- fs-1: 가장 큰 글씨 (별을 크게 표시) --%>
                    <div class="fs-1 rating-stars">
                        <%-- 1~5까지 반복하며 별점 표시 --%>
                        <c:forEach begin="1" end="5" var="star">
                            <%-- averageRating: Controller가 전달한 평균 별점 --%>
                            <i class="bi ${star <= averageRating ? 'bi-star-fill' : 'bi-star'}"></i>
                        </c:forEach>
                    </div>
                    <%-- fs-3 fw-bold: 큰 굵은 글씨로 평점 숫자 표시 --%>
                    <div class="fs-3 fw-bold">${averageRating}</div>
                    <div class="text-muted">평균 별점</div>
                </div>
            </div>
        </div>

        <%-- ======================================================= --%>
        <%-- 📌 수정/삭제 버튼 (작성자 또는 관리자만 표시)                --%>
        <%-- style="display:none;" → 처음에는 숨김                      --%>
        <%-- JavaScript에서 로그인한 사용자가 작성자인지 확인 후 표시    --%>
        <%-- 비유: 자물쇠가 걸린 문 → 열쇠(작성자)가 맞으면 열림       --%>
        <%-- ======================================================= --%>
        <div id="ownerActions" class="mt-3" style="display:none;">
            <%-- btn-outline-warning: 노란색 테두리 버튼 (수정) --%>
            <%-- btn-sm: 작은 사이즈 버튼 --%>
            <a id="editBtn" href="/restaurants/${restaurant.id}/edit" class="btn btn-outline-warning btn-sm">
                <i class="bi bi-pencil"></i> 수정
            </a>
            <%-- btn-outline-danger: 빨간색 테두리 버튼 (삭제) --%>
            <%-- onclick: 클릭 시 deleteRestaurant 함수 호출 --%>
            <button class="btn btn-outline-danger btn-sm" onclick="deleteRestaurant(${restaurant.id})">
                <i class="bi bi-trash"></i> 삭제
            </button>
        </div>
    </div>
</div>

<%-- ============================================================ --%>
<%-- 📌 리뷰 섹션                                                   --%>
<%-- ============================================================ --%>
<div class="card">
    <%-- ======================================================= --%>
    <%-- 📌 카드 헤더: 리뷰 제목 + 리뷰 개수 뱃지                    --%>
    <%-- card-header: 카드 상단 영역 (배경색이 약간 다름)              --%>
    <%-- ======================================================= --%>
    <div class="card-header d-flex justify-content-between align-items-center">
        <h4 class="mb-0"><i class="bi bi-chat-dots"></i> 리뷰</h4>
        <%-- badge bg-secondary: 회색 뱃지 --%>
        <%-- fn:length(reviews): JSTL 함수 - reviews 리스트의 항목 수 --%>
        <span class="badge bg-secondary" id="reviewCount">${fn:length(reviews)}개</span>
    </div>

    <div class="card-body">
        <%-- ======================================================= --%>
        <%-- 📌 리뷰 작성 폼 (로그인한 사용자만 표시)                    --%>
        <%-- bg-light rounded: 연한 회색 배경 + 둥근 모서리              --%>
        <%-- ======================================================= --%>
        <c:if test="${not empty loginMember}">
            <div class="mb-4 p-3 bg-light rounded">
                <h5>리뷰 작성</h5>

                <%-- ======================================= --%>
                <%-- 별점 선택 UI                               --%>
                <%-- 1~5까지 빈 별을 표시하고, 클릭하면         --%>
                <%-- selectRating() 함수가 별을 채움            --%>
                <%-- style="cursor:pointer;" → 마우스 커서를    --%>
                <%--   손가락 모양으로 (클릭 가능함을 표시)     --%>
                <%-- ======================================= --%>
                <div class="mb-2">
                    <label class="form-label">별점</label>
                    <div id="starSelector">
                        <%-- 1부터 5까지 반복하며 클릭 가능한 별 아이콘 생성 --%>
                        <%-- id="star-${i}": 각 별에 고유 ID 부여 (star-1, star-2, ...) --%>
                        <%-- onclick="selectRating(${i})": 클릭 시 해당 별점 선택 --%>
                        <c:forEach begin="1" end="5" var="i">
                            <i id="star-${i}" class="bi bi-star text-warning fs-4" style="cursor:pointer;"
                               onclick="selectRating(${i})"></i>
                        </c:forEach>
                    </div>
                    <%-- 선택된 별점 값을 저장하는 숨겨진 입력 필드 --%>
                    <%-- type="hidden": 화면에 보이지 않지만 값을 저장 --%>
                    <%-- JavaScript에서 이 값을 읽어서 서버에 전송 --%>
                    <input type="hidden" id="rating" value="0">
                </div>

                <%-- 리뷰 내용 입력 --%>
                <div class="mb-2">
                    <textarea id="reviewContent" class="form-control" rows="3"
                              placeholder="맛집 후기를 남겨주세요!"></textarea>
                </div>

                <%-- 리뷰 등록 버튼 --%>
                <%-- btn-sm: 작은 크기 버튼 --%>
                <button class="btn btn-primary btn-sm" onclick="submitReview(${restaurant.id})">
                    <i class="bi bi-send"></i> 리뷰 등록
                </button>
            </div>
        </c:if>

        <%-- ======================================================= --%>
        <%-- 📌 리뷰 목록                                              --%>
        <%-- id="reviewList": JavaScript에서 리뷰 추가/삭제 시 사용    --%>
        <%-- ======================================================= --%>
        <div id="reviewList">
            <c:choose>
                <%-- 리뷰가 있을 때: 목록 표시 --%>
                <c:when test="${not empty reviews}">
                    <%-- 각 리뷰를 반복하며 표시 --%>
                    <c:forEach var="review" items="${reviews}">
                        <%-- border-bottom: 아래쪽 테두리선 --%>
                        <%-- pb-3 mb-3: 아래쪽 안쪽/바깥 여백 16px --%>
                        <%-- id="review-${review.id}": 삭제 시 해당 리뷰를 찾기 위한 ID --%>
                        <div class="border-bottom pb-3 mb-3" id="review-${review.id}">
                            <%-- 리뷰 상단: 작성자+별점(왼쪽), 날짜+삭제(오른쪽) --%>
                            <div class="d-flex justify-content-between">
                                <div>
                                    <%-- 작성자 닉네임 (굵은 글씨) --%>
                                    <strong>${review.memberNickname}</strong>
                                    <%-- 별점 표시 --%>
                                    <span class="rating-stars ms-2">
                                        <c:forEach begin="1" end="5" var="star">
                                            <i class="bi ${star <= review.rating ? 'bi-star-fill' : 'bi-star'} small"></i>
                                        </c:forEach>
                                    </span>
                                </div>
                                <div>
                                    <%-- 작성일 --%>
                                    <small class="text-muted">${review.createdAt}</small>

                                    <%-- ======================================= --%>
                                    <%-- 📌 리뷰 삭제 버튼 (본인 리뷰만)           --%>
                                    <%-- 조건: 로그인 상태 AND 로그인한 사용자의    --%>
                                    <%--       ID가 리뷰 작성자 ID와 같을 때       --%>
                                    <%-- loginMember.id: 로그인한 사용자 ID --%>
                                    <%-- review.memberId: 리뷰 작성자 ID           --%>
                                    <%-- ======================================= --%>
                                    <c:if test="${not empty loginMember && loginMember.id == review.memberId}">
                                        <button class="btn btn-outline-danger btn-sm ms-2"
                                                onclick="deleteReview(${review.id})">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                            <%-- 리뷰 내용 --%>
                            <p class="mt-2 mb-1">${review.content}</p>

                            <%-- 대댓글(답글) 영역 --%>
                            <div class="mt-2">
                                <button class="btn btn-outline-secondary btn-sm" onclick="toggleReplies(${review.id})">
                                    <i class="bi bi-chat-left-text"></i> <span id="replyToggleText-${review.id}">답글 보기</span>
                                </button>
                                <c:if test="${not empty loginMember && loginMember.id != review.memberId}">
                                    <button class="btn btn-outline-warning btn-sm ms-1" onclick="reportReview(${review.id})">
                                        <i class="bi bi-flag"></i> 신고
                                    </button>
                                </c:if>

                                <div id="repliesArea-${review.id}" style="display:none;" class="mt-2 ms-4">
                                    <div id="repliesList-${review.id}"></div>
                                    <c:if test="${not empty loginMember}">
                                        <div class="input-group input-group-sm mt-2">
                                            <input type="text" class="form-control" id="replyContent-${review.id}"
                                                   placeholder="답글을 입력하세요...">
                                            <button class="btn btn-primary" onclick="submitReply(${review.id})">
                                                <i class="bi bi-send"></i>
                                            </button>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>

                <%-- 리뷰가 없을 때: 안내 메시지 --%>
                <c:otherwise>
                    <p class="text-muted text-center" id="noReview">아직 리뷰가 없습니다. 첫 리뷰를 남겨보세요!</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%-- ======================================================= --%>
<%-- 📌 "목록으로" 돌아가기 버튼                                 --%>
<%-- mt-3: 위쪽 여백 16px                                       --%>
<%-- btn-outline-secondary: 회색 테두리 버튼                     --%>
<%-- ======================================================= --%>
<div class="mt-3">
    <a href="/restaurants" class="btn btn-outline-secondary">
        <i class="bi bi-arrow-left"></i> 목록으로
    </a>
</div>

<%-- ============================================================ --%>
<%-- 📌 JavaScript - 맛집 상세 페이지의 모든 동적 기능               --%>
<%-- ============================================================ --%>
<%-- ★ JSP EL과 JavaScript 혼합 사용 설명:                          --%>
<%--   아래 코드에서 '${loginMember.id}',              --%>
<%--   '${restaurant.memberNickname}' 등은 JSP EL입니다.            --%>
<%--   서버에서 페이지를 생성할 때 실제 값으로 치환됩니다.            --%>
<%--   예: const loginMemberId = '${...id}'; → const loginMemberId = '3'; --%>
<%--   따옴표(' ') 안에 넣어서 JavaScript 문자열로 만듭니다.         --%>
<%--                                                                --%>
<%--   주의: ${loginMember != null ? ... : ""}         --%>
<%--   → 로그인하지 않은 경우 null 에러를 방지하기 위한 안전 코드    --%>
<%-- ============================================================ --%>
<script>
// ★ fetch API 패턴 설명 (비전공자용):
// fetch('URL', {옵션}) = 서버에 요청을 보내는 함수 (비유: 전화 걸기)
//   .then(response => ...) = 서버 응답을 받으면 실행 (비유: 전화 받기)
//   .then(data => ...)     = 응답 데이터를 처리    (비유: 통화 내용 메모)
//   .catch(err => ...)     = 에러 발생 시 실행     (비유: 통화 실패 시 재시도)

// ======================================================
// ★ 작성자 확인 → 수정/삭제 버튼 표시 여부 결정
// JSP EL로 서버에서 값을 받아와 JavaScript 변수에 저장
// ======================================================

// 로그인한 사용자의 ID (비로그인 시 빈 문자열)
const loginMemberId = '${loginMember != null ? loginMember.id : ""}';
// 맛집 등록자의 닉네임
const restaurantMemberNickname = '${restaurant.memberNickname}';
// 로그인한 사용자의 닉네임
const loginMemberNickname = '${loginMember != null ? loginMember.nickname : ""}';
// 로그인한 사용자의 권한 (USER 또는 ADMIN)
const loginMemberRole = '${loginMember != null ? loginMember.role : ""}';

// ★ 작성자 본인이거나 관리자(ADMIN)이면 수정/삭제 버튼 표시
// display = 'block' → 숨겨진 요소를 보이게 함
if (loginMemberNickname === restaurantMemberNickname || loginMemberRole === 'ADMIN') {
    document.getElementById('ownerActions').style.display = 'block';
}

// ======================================================
// ★ 별점 선택 함수
// rating: 사용자가 클릭한 별의 번호 (1~5)
// 비유: 5개의 전구 중 클릭한 번호까지 불을 켜는 것
// ======================================================
function selectRating(rating) {
    // 숨겨진 input에 선택한 별점 값 저장
    document.getElementById('rating').value = rating;

    // 1~5까지 반복하며 별 아이콘 업데이트
    for (let i = 1; i <= 5; i++) {
        const star = document.getElementById('star-' + i);
        // i가 선택한 rating 이하이면 채워진 별, 초과이면 빈 별
        star.className = i <= rating ? 'bi bi-star-fill text-warning fs-4' : 'bi bi-star text-warning fs-4';
        star.style.cursor = 'pointer';
    }
}

// ======================================================
// ★ 리뷰 등록 함수
// restaurantId: 리뷰를 작성할 맛집의 ID
// ======================================================
function submitReview(restaurantId) {
    // 선택된 별점 값 가져오기 (문자열 → 정수 변환)
    const rating = parseInt(document.getElementById('rating').value);
    // 리뷰 내용 가져오기 (앞뒤 공백 제거)
    const content = document.getElementById('reviewContent').value.trim();

    // ★ 유효성 검사: 별점을 선택하지 않았으면 경고
    if (rating === 0) { alert('별점을 선택해주세요.'); return; }
    // ★ 유효성 검사: 내용이 비어있으면 경고
    if (!content) { alert('리뷰 내용을 입력해주세요.'); return; }

    // ★ 서버에 리뷰 등록 요청 (POST)
    fetch('/api/reviews', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ content: content, rating: rating, restaurantId: restaurantId })
    })
    .then(res => {
        if (res.ok) {
            // 성공 → 페이지 새로고침 (새 리뷰가 목록에 표시됨)
            window.location.reload();
        }
        else {
            // 실패 → 에러 메시지 알림
            return res.json().then(err => alert(err.error));
        }
    });
}

// ======================================================
// ★ 리뷰 삭제 함수
// reviewId: 삭제할 리뷰의 ID
// ======================================================
function deleteReview(reviewId) {
    // ★ confirm(): 확인/취소 대화상자 표시
    // 사용자가 "취소"를 누르면 false 반환 → return으로 함수 종료
    if (!confirm('리뷰를 삭제하시겠습니까?')) return;

    // ★ 서버에 리뷰 삭제 요청 (DELETE)
    // DELETE 메서드: 서버에게 "이 리소스를 삭제해달라"고 요청
    fetch('/api/reviews/' + reviewId, { method: 'DELETE' })
    .then(res => {
        if (res.ok) { window.location.reload(); }
        else { return res.json().then(err => alert(err.error)); }
    });
}

// ======================================================
// ★ 맛집 삭제 함수
// id: 삭제할 맛집의 ID
// ======================================================
function deleteRestaurant(id) {
    // ★ 삭제 확인 대화상자 (관련 리뷰도 함께 삭제됨을 안내)
    if (!confirm('이 맛집을 삭제하시겠습니까? 관련 리뷰도 모두 삭제됩니다.')) return;

    // ★ 서버에 맛집 삭제 요청 (DELETE)
    fetch('/api/restaurants/' + id, { method: 'DELETE' })
    .then(res => {
        if (res.ok) {
            // 성공 → 맛집 목록 페이지로 이동
            window.location.href = '/restaurants';
        }
        else { return res.json().then(err => alert(err.error)); }
    });
}

// ======================================================
// ★ 찜(위시리스트) 토글 함수
// restaurantId: 찜할/취소할 맛집의 ID
// 비유: 전등 스위치 → 켜져 있으면 끄고, 꺼져 있으면 켬
// ======================================================
function toggleWish(restaurantId) {
    // 찜 버튼과 텍스트 요소 가져오기
    const btn = document.getElementById('wishBtn');
    const text = document.getElementById('wishText');

    // ★ 현재 찜 상태 확인
    // btn-danger 클래스가 있으면 = 이미 찜한 상태
    // btn-outline-danger 클래스가 있으면 = 찜하지 않은 상태
    const isWished = btn.classList.contains('btn-danger');

    // ★ 찜 상태에 따라 다른 HTTP 메서드 사용
    // 이미 찜함(isWished=true) → DELETE (찜 취소)
    // 찜 안 함(isWished=false) → POST (찜 추가)
    fetch('/api/wishlists/' + restaurantId, {
        method: isWished ? 'DELETE' : 'POST'
    })
    .then(res => {
        if (res.ok) {
            // ★ 성공 시 버튼의 외형(CSS 클래스)을 토글(전환)
            if (isWished) {
                // 찜 취소 → 빈 하트로 변경
                btn.classList.remove('btn-danger');          // 빨간 배경 제거
                btn.classList.add('btn-outline-danger');     // 빨간 테두리로 변경
                btn.querySelector('i').className = 'bi bi-heart';  // 빈 하트 아이콘
                text.textContent = '찜하기';                // 버튼 텍스트 변경
            } else {
                // 찜 추가 → 채운 하트로 변경
                btn.classList.remove('btn-outline-danger');  // 빨간 테두리 제거
                btn.classList.add('btn-danger');             // 빨간 배경으로 변경
                btn.querySelector('i').className = 'bi bi-heart-fill';  // 채운 하트 아이콘
                text.textContent = '찜 취소';               // 버튼 텍스트 변경
            }
        } else {
            // 실패 시 에러 알림
            return res.json().then(err => alert(err.error));
        }
    });
}

// ======================================================
// ★ 대댓글(답글) 관련 함수들
// ======================================================

// 답글 영역 토글 (보기/숨기기)
function toggleReplies(reviewId) {
    var area = document.getElementById('repliesArea-' + reviewId);
    var toggleText = document.getElementById('replyToggleText-' + reviewId);

    if (area.style.display === 'none') {
        area.style.display = 'block';
        toggleText.textContent = '답글 숨기기';
        loadReplies(reviewId);
    } else {
        area.style.display = 'none';
        toggleText.textContent = '답글 보기';
    }
}

// 특정 리뷰의 답글 목록 로드
function loadReplies(reviewId) {
    fetch('/api/replies/review/' + reviewId)
        .then(function(res) { return res.json(); })
        .then(function(data) {
            var container = document.getElementById('repliesList-' + reviewId);

            if (data.length === 0) {
                container.innerHTML = '<p class="text-muted small">아직 답글이 없습니다.</p>';
                return;
            }

            var html = '';
            data.forEach(function(reply) {
                html += '<div class="border-start border-2 ps-2 mb-2 small" id="reply-' + reply.id + '">' +
                    '<div class="d-flex justify-content-between">' +
                    '<strong>' + reply.memberNickname + '</strong>' +
                    '<span class="text-muted">' + (reply.createdAt ? reply.createdAt.substring(0, 10) : '') + '</span>' +
                    '</div>' +
                    '<span>' + reply.content + '</span>';

                // 본인 답글이면 삭제 버튼 표시
                if (loginMemberId && parseInt(loginMemberId) === reply.memberId) {
                    html += ' <button class="btn btn-outline-danger btn-sm py-0 px-1" ' +
                        'onclick="deleteReply(' + reply.id + ', ' + reviewId + ')">' +
                        '<i class="bi bi-x"></i></button>';
                }

                html += '</div>';
            });
            container.innerHTML = html;
        })
        .catch(function() {
            document.getElementById('repliesList-' + reviewId).innerHTML =
                '<p class="text-danger small">답글을 불러올 수 없습니다.</p>';
        });
}

// 답글 작성
function submitReply(reviewId) {
    var input = document.getElementById('replyContent-' + reviewId);
    var content = input.value.trim();

    if (!content) { alert('답글 내용을 입력해주세요.'); return; }

    fetch('/api/replies', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ reviewId: reviewId, content: content })
    })
    .then(function(res) {
        if (res.ok) {
            input.value = '';
            loadReplies(reviewId);
        } else {
            return res.json().then(function(err) { alert(err.error); });
        }
    });
}

// 답글 삭제
function deleteReply(replyId, reviewId) {
    if (!confirm('답글을 삭제하시겠습니까?')) return;

    fetch('/api/replies/' + replyId, { method: 'DELETE' })
        .then(function(res) {
            if (res.ok) {
                loadReplies(reviewId);
            } else {
                return res.json().then(function(err) { alert(err.error); });
            }
        });
}

// 리뷰 신고
function reportReview(reviewId) {
    if (!confirm('이 리뷰를 신고하시겠습니까?')) return;

    fetch('/api/reviews/' + reviewId + '/report', { method: 'POST' })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.message) {
                alert(data.message);
            } else if (data.error) {
                alert(data.error);
            }
        });
}
</script>

<%-- 공통 푸터 포함 --%>
<jsp:include page="../common/footer.jsp"/>
