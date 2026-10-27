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
<%-- [wishlist/list.jsp] 내 찜 목록 페이지                            --%>
<%-- ============================================================ --%>
<%-- URL: http://localhost:8080/wishlists                            --%>
<%-- Controller: WishlistController → wishlistPage() 메서드         --%>
<%-- 역할: 로그인한 사용자가 찜한 맛집 목록을 카드로 표시            --%>
<%--       찜 취소 기능 제공                                        --%>
<%-- 비유: 쇼핑몰의 "관심 상품" 또는 "찜한 목록" 페이지             --%>
<%--                                                               --%>
<%-- ★ 이 페이지의 특징:                                           --%>
<%--   서버에서 HTML을 생성하지 않고, 페이지 로드 후                 --%>
<%--   JavaScript fetch API로 찜 목록을 조회하여                     --%>
<%--   동적으로 카드를 생성합니다 (Client-Side Rendering).           --%>
<%--   JSTL(<c:forEach>)을 사용하지 않고 순수 JavaScript로 렌더링   --%>
<%--                                                               --%>
<%-- ★ JSP EL vs JavaScript ${} 충돌이 발생하는 파일:               --%>
<%--   JavaScript 템플릿 리터럴(백틱 ``) 안에서 \${}를 사용         --%>
<%-- ============================================================ --%>

<%-- 브라우저 탭 제목 설정 --%>
<c:set var="pageTitle" value="내 찜 목록" scope="request"/>

<%-- 공통 헤더 포함 --%>
<jsp:include page="../common/header.jsp"/>

<%-- ============================================================ --%>
<%-- 📌 페이지 제목                                                  --%>
<%-- mb-4: 아래 여백 24px                                           --%>
<%-- text-danger: 빨간색 (하트 아이콘에 적용)                       --%>
<%-- ============================================================ --%>
<h2 class="mb-4"><i class="bi bi-heart-fill text-danger"></i> 내 찜 목록</h2>

<%-- ============================================================ --%>
<%-- 📌 찜 목록 카드 컨테이너 (처음에는 비어있음)                     --%>
<%-- id="wishlistContainer": JavaScript가 이 안에 카드를 채워넣음   --%>
<%-- row g-4: Bootstrap 그리드 행 + 카드 간격 24px                  --%>
<%-- ★ 서버가 아닌 JavaScript가 내용을 채우므로 처음에는 비어있음    --%>
<%-- ============================================================ --%>
<div class="row g-4" id="wishlistContainer">
</div>

<%-- ============================================================ --%>
<%-- 📌 빈 목록 안내 메시지 (처음에는 숨김)                           --%>
<%-- d-none: 숨김 상태 → JavaScript에서 찜 목록이 비어있으면 표시   --%>
<%-- alert-info: 하늘색 정보 박스                                   --%>
<%-- alert-link: 알림 박스 안의 링크 스타일 (진한 색상)             --%>
<%-- ============================================================ --%>
<div id="emptyMsg" class="alert alert-info text-center d-none">
    <i class="bi bi-info-circle"></i> 찜한 맛집이 없습니다.
    <a href="/restaurants" class="alert-link">맛집 둘러보기</a>
</div>

<%-- ============================================================ --%>
<%-- 📌 JavaScript - 찜 목록 조회 및 관리                            --%>
<%-- ============================================================ --%>
<%-- ★ JSP EL vs JavaScript ${} 충돌 상세 설명:                     --%>
<%--                                                                --%>
<%-- 이 파일의 JavaScript에서는 백틱(`)으로 감싼 템플릿 리터럴을    --%>
<%-- 사용합니다. 템플릿 리터럴 안의 ${변수}는 JavaScript 변수를     --%>
<%-- 참조하지만, JSP 서버가 먼저 이것을 자신의 EL로 해석합니다.     --%>
<%--                                                                --%>
<%-- 예를 들어 ${w.restaurant.id}라고 쓰면:                          --%>
<%--   JSP 서버: "w라는 서버 변수를 찾아야지" → 없으므로 빈값 출력  --%>
<%--   결과: 빈 문자열이 되어 JavaScript가 제대로 동작하지 않음      --%>
<%--                                                                --%>
<%-- \${w.restaurant.id}라고 쓰면:                                   --%>
<%--   JSP 서버: "앞에 \가 있으니 내가 처리할 게 아니구나" → 그대로 통과 --%>
<%--   브라우저: "${w.restaurant.id}" → JavaScript 변수 w의 값 사용  --%>
<%--                                                                --%>
<%-- 한줄 요약: JSP 파일 안 JS 템플릿 리터럴에서는 \${}를 써야 함   --%>
<%-- ============================================================ --%>
<script>
// ★ fetch API 패턴 설명 (비전공자용):
// fetch('URL', {옵션}) = 서버에 요청을 보내는 함수 (비유: 전화 걸기)
//   .then(response => ...) = 서버 응답을 받으면 실행 (비유: 전화 받기)
//   .then(data => ...)     = 응답 데이터를 처리    (비유: 통화 내용 메모)
//   .catch(err => ...)     = 에러 발생 시 실행     (비유: 통화 실패 시 재시도)

// ======================================================
// ★ DOMContentLoaded 이벤트
// 페이지의 HTML이 모두 로드된 후에 함수를 실행
// 비유: "건물 공사가 끝난 후에 가구를 배치해라"
// 이렇게 해야 getElementById로 요소를 안전하게 찾을 수 있음
// ======================================================
document.addEventListener('DOMContentLoaded', function() {
    // 페이지 로드 시 찜 목록을 서버에서 가져옴
    loadWishlist();
});

// ======================================================
// ★ 찜 목록 조회 함수
// 서버에서 찜 목록 데이터를 가져와 카드로 표시
// ======================================================
function loadWishlist() {
    // ★ GET 요청 (기본 method이므로 별도 지정 불필요)
    // '/api/wishlists' → 로그인한 사용자의 찜 목록 API
    fetch('/api/wishlists')
        .then(res => {
            // ★ 응답 상태 확인: 서버가 에러를 반환하면 처리
            if (!res.ok) {
                // 401(로그인 필요) → 로그인 페이지로 이동
                if (res.status === 401) {
                    alert('로그인이 필요합니다.');
                    window.location.href = '/members/login';
                    return;
                }
                throw new Error('서버 오류: ' + res.status);
            }
            return res.json();  // 응답을 JSON 배열로 변환
        })
        .then(data => {
            if (!data) return; // 401 리다이렉트 처리 후에는 data가 없을 수 있음
            // 카드 컨테이너와 빈 목록 메시지 요소 가져오기
            const container = document.getElementById('wishlistContainer');
            const emptyMsg = document.getElementById('emptyMsg');

            // ★ 찜 목록이 비어있을 때
            if (data.length === 0) {
                // 빈 목록 안내 메시지 표시
                emptyMsg.classList.remove('d-none');
                // 컨테이너 내용 비우기
                container.innerHTML = '';
                return; // 함수 종료
            }

            // ★ 찜 목록이 있을 때: 안내 메시지 숨기기
            emptyMsg.classList.add('d-none');

            // ★ ============================================================
            // ★ 찜 목록 데이터를 HTML 카드로 변환
            // .map(w => `...`) → 각 찜 항목을 HTML 카드 문자열로 변환
            // .join('') → 모든 카드를 하나의 문자열로 합침
            //
            // ★★★ \${} 사용 이유 (매우 중요) ★★★
            // 이 코드는 JSP 파일 안에 있는 JavaScript입니다.
            // 백틱(`) 템플릿 리터럴 안의 \${w.restaurant.id}는
            // JavaScript 변수를 참조하려는 의도이지만,
            // JSP 서버가 먼저 \${}를 해석하려고 합니다.
            //
            // \${w.restaurant.id}로 쓰면:
            //   1. JSP 서버 단계: \를 보고 건너뜀 → \${w.restaurant.id} 그대로 출력
            //   2. 브라우저 단계: JavaScript가 \${w.restaurant.id}를 해석
            //   → 정상 동작!
            //
            // \${w.restaurant.id}로 쓰면 (백슬래시 없이):
            //   1. JSP 서버 단계: w.restaurant.id를 JSP 변수로 찾음 → 없음 → 빈값
            //   2. 브라우저 단계: 빈 문자열이 이미 고정됨
            //   → 동작 안 함! (링크, 삭제 등이 모두 깨짐)
            // ★ ============================================================
            container.innerHTML = data.map(w => `
                <div class="col-md-6 col-lg-4" id="wish-\${w.restaurant.id}">
                    <div class="card h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start">
                                <h5 class="card-title">
                                    <a href="/restaurants/\${w.restaurant.id}" class="text-decoration-none text-dark">
                                        \${w.restaurant.name}
                                    </a>
                                </h5>
                                <button class="btn btn-sm btn-outline-danger"
                                        onclick="removeWish(\${w.restaurant.id})">
                                    <i class="bi bi-heart-fill"></i> 취소
                                </button>
                            </div>
                            <p class="text-muted small mb-0">
                                <i class="bi bi-geo-alt"></i> \${w.restaurant.address || ''}
                            </p>
                        </div>
                    </div>
                </div>
            `).join('');
        })
        .catch(err => {
            // ★ 네트워크 오류 또는 JSON 파싱 실패 시 에러 메시지 표시
            console.error('찜 목록 조회 오류:', err);
            const container = document.getElementById('wishlistContainer');
            container.innerHTML = '<div class="col-12"><div class="alert alert-danger text-center">'
                + '<i class="bi bi-exclamation-triangle"></i> 찜 목록을 불러오는 중 오류가 발생했습니다.<br>'
                + '<small class="text-muted">' + err.message + '</small>'
                + '</div></div>';
        });
}

// ======================================================
// ★ 찜 취소(삭제) 함수
// restaurantId: 찜을 취소할 맛집의 ID
// 비유: "관심 상품" 목록에서 하트를 해제하는 것
// ======================================================
function removeWish(restaurantId) {
    // ★ 삭제 확인 대화상자
    if (!confirm('찜을 취소하시겠습니까?')) return;

    // ★ 서버에 찜 삭제 요청 (DELETE)
    fetch('/api/wishlists/' + restaurantId, { method: 'DELETE' })
        .then(res => {
            if (res.ok) {
                // ★ 성공 시: 해당 카드를 화면에서 즉시 제거
                // getElementById로 카드 요소를 찾아서 삭제
                // 비유: 포스트잇을 떼어내는 것
                const el = document.getElementById('wish-' + restaurantId);
                if (el) el.remove(); // .remove() → DOM에서 요소 제거

                // ★ 남은 카드가 없으면 빈 목록 안내 메시지 표시
                const container = document.getElementById('wishlistContainer');
                // children.length: 자식 요소의 수
                if (container.children.length === 0) {
                    document.getElementById('emptyMsg').classList.remove('d-none');
                }
            } else {
                // 실패 시 에러 알림
                return res.json().then(err => alert(err.error));
            }
        });
}
</script>

<%-- 공통 푸터 포함 --%>
<jsp:include page="../common/footer.jsp"/>
