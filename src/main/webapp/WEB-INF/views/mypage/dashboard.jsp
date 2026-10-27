<%-- ============================================================ --%>
<%-- [dashboard.jsp] 마이페이지 대시보드                             --%>
<%-- ============================================================ --%>
<%-- URL: http://localhost:8080/mypage                              --%>
<%-- Controller: MyPageViewController → dashboard() 메서드          --%>
<%-- 역할: 내 프로필, 내 맛집, 내 리뷰를 탭으로 구분하여 보여줌      --%>
<%--       모든 데이터는 JavaScript fetch API로 서버에서 가져옴       --%>
<%-- ============================================================ --%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- 브라우저 탭 제목 설정 --%>
<c:set var="pageTitle" value="마이페이지" scope="request"/>

<%-- 공통 헤더 포함 --%>
<jsp:include page="../common/header.jsp"/>

<%-- ============================================================ --%>
<%-- 프로필 정보 섹션                                               --%>
<%-- 로그인한 사용자의 닉네임, 이메일, 역할, 가입일을 표시           --%>
<%-- ============================================================ --%>
<div class="row mb-4">
    <div class="col-md-12">
        <div class="card shadow-sm">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <%-- 프로필 아이콘 --%>
                    <div class="me-4">
                        <i class="bi bi-person-circle" style="font-size: 4rem; color: #0d6efd;"></i>
                    </div>
                    <%-- 프로필 텍스트 정보 --%>
                    <div>
                        <h3 class="mb-1" id="profileNickname">
                            ${loginMember.nickname}님
                        </h3>
                        <p class="text-muted mb-1">
                            <i class="bi bi-envelope"></i> ${loginMember.email}
                        </p>
                        <p class="text-muted mb-0">
                            <i class="bi bi-shield-check"></i>
                            <span class="badge bg-primary">${loginMember.role.displayName}</span>
                        </p>
                    </div>
                </div>

                <%-- 통계 카드 영역 --%>
                <div class="row mt-4" id="statsArea">
                    <%-- 내 맛집 수 --%>
                    <div class="col-md-4">
                        <div class="card text-center bg-light">
                            <div class="card-body py-3">
                                <h5 class="card-title text-primary mb-0" id="statRestaurants">-</h5>
                                <small class="text-muted">등록한 맛집</small>
                            </div>
                        </div>
                    </div>
                    <%-- 내 리뷰 수 --%>
                    <div class="col-md-4">
                        <div class="card text-center bg-light">
                            <div class="card-body py-3">
                                <h5 class="card-title text-success mb-0" id="statReviews">-</h5>
                                <small class="text-muted">작성한 리뷰</small>
                            </div>
                        </div>
                    </div>
                    <%-- 내 찜 수 --%>
                    <div class="col-md-4">
                        <div class="card text-center bg-light">
                            <div class="card-body py-3">
                                <h5 class="card-title text-danger mb-0" id="statWishlists">-</h5>
                                <small class="text-muted">찜한 맛집</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- ============================================================ --%>
<%-- 탭 네비게이션                                                   --%>
<%-- Bootstrap 5의 Nav Tabs를 사용하여 3개의 탭을 구성               --%>
<%-- 내 맛집 / 내 리뷰 / 프로필 수정                                --%>
<%-- ============================================================ --%>
<ul class="nav nav-tabs mb-4" id="myTab" role="tablist">
    <%-- 탭 1: 내 맛집 --%>
    <li class="nav-item" role="presentation">
        <button class="nav-link active" id="restaurants-tab" data-bs-toggle="tab"
                data-bs-target="#restaurants-pane" type="button" role="tab">
            <i class="bi bi-shop"></i> 내 맛집
        </button>
    </li>
    <%-- 탭 2: 내 리뷰 --%>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="reviews-tab" data-bs-toggle="tab"
                data-bs-target="#reviews-pane" type="button" role="tab">
            <i class="bi bi-chat-dots"></i> 내 리뷰
        </button>
    </li>
    <%-- 탭 3: 프로필 수정 --%>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="profile-tab" data-bs-toggle="tab"
                data-bs-target="#profile-pane" type="button" role="tab">
            <i class="bi bi-gear"></i> 프로필 수정
        </button>
    </li>
</ul>

<%-- ============================================================ --%>
<%-- 탭 내용 영역                                                   --%>
<%-- 각 탭 버튼을 누르면 해당 내용이 표시됩니다.                     --%>
<%-- ============================================================ --%>
<div class="tab-content" id="myTabContent">

    <%-- ━━━ 탭 1: 내 맛집 ━━━ --%>
    <div class="tab-pane fade show active" id="restaurants-pane" role="tabpanel">
        <%-- 맛집 카드 그리드 (JavaScript로 동적 생성) --%>
        <div class="row" id="myRestaurantsList"></div>
        <%-- 페이지네이션 --%>
        <nav id="restaurantsPagination" class="mt-3">
            <ul class="pagination justify-content-center"></ul>
        </nav>
    </div>

    <%-- ━━━ 탭 2: 내 리뷰 ━━━ --%>
    <div class="tab-pane fade" id="reviews-pane" role="tabpanel">
        <%-- 리뷰 목록 (JavaScript로 동적 생성) --%>
        <div id="myReviewsList"></div>
        <%-- 페이지네이션 --%>
        <nav id="reviewsPagination" class="mt-3">
            <ul class="pagination justify-content-center"></ul>
        </nav>
    </div>

    <%-- ━━━ 탭 3: 프로필 수정 ━━━ --%>
    <div class="tab-pane fade" id="profile-pane" role="tabpanel">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <%-- 닉네임 변경 폼 --%>
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="card-title mb-3">
                            <i class="bi bi-person"></i> 닉네임 변경
                        </h5>
                        <%-- 결과 메시지 표시 영역 --%>
                        <div id="nicknameMsg" class="alert d-none"></div>
                        <form id="nicknameForm">
                            <div class="mb-3">
                                <label for="newNickname" class="form-label">새 닉네임</label>
                                <input type="text" class="form-control" id="newNickname"
                                       placeholder="새 닉네임을 입력하세요" required>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i> 닉네임 변경
                            </button>
                        </form>
                    </div>
                </div>

                <%-- 비밀번호 변경 폼 --%>
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title mb-3">
                            <i class="bi bi-lock"></i> 비밀번호 변경
                        </h5>
                        <%-- 결과 메시지 표시 영역 --%>
                        <div id="passwordMsg" class="alert d-none"></div>
                        <form id="passwordForm">
                            <div class="mb-3">
                                <label for="currentPassword" class="form-label">현재 비밀번호</label>
                                <input type="password" class="form-control" id="currentPassword"
                                       placeholder="현재 비밀번호" required>
                            </div>
                            <div class="mb-3">
                                <label for="newPassword" class="form-label">새 비밀번호</label>
                                <input type="password" class="form-control" id="newPassword"
                                       placeholder="새 비밀번호" required>
                            </div>
                            <button type="submit" class="btn btn-warning">
                                <i class="bi bi-check-circle"></i> 비밀번호 변경
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- ============================================================ --%>
<%-- JavaScript — 마이페이지 데이터 로딩 및 폼 처리                   --%>
<%-- ============================================================ --%>
<script>
// ★ 페이지 로드 시 통계와 내 맛집 데이터를 가져옵니다.
document.addEventListener('DOMContentLoaded', function() {
    loadStats();
    loadMyRestaurants(0);
});

// ★ 탭 전환 시 해당 탭의 데이터를 로드합니다.
document.getElementById('restaurants-tab').addEventListener('shown.bs.tab', function() {
    loadMyRestaurants(0);
});
document.getElementById('reviews-tab').addEventListener('shown.bs.tab', function() {
    loadMyReviews(0);
});

// ── 통계 로드 ────────────────────────────────────────────────
// /api/mypage/stats API를 호출하여 내 맛집/리뷰/찜 수를 가져옴
function loadStats() {
    fetch('/api/mypage/stats')
        .then(function(response) { return response.json(); })
        .then(function(data) {
            document.getElementById('statRestaurants').textContent = data.restaurantCount;
            document.getElementById('statReviews').textContent = data.reviewCount;
            document.getElementById('statWishlists').textContent = data.wishlistCount;
        })
        .catch(function() {
            console.error('통계 로드 실패');
        });
}

// ── 내 맛집 목록 로드 ─────────────────────────────────────────
// /api/mypage/restaurants API를 호출하여 내가 등록한 맛집을 카드로 표시
function loadMyRestaurants(page) {
    fetch('/api/mypage/restaurants?page=' + page + '&size=6')
        .then(function(response) { return response.json(); })
        .then(function(data) {
            var container = document.getElementById('myRestaurantsList');

            // 맛집이 없는 경우
            if (data.content.length === 0) {
                container.innerHTML = '<div class="col-12 text-center py-5">' +
                    '<p class="text-muted"><i class="bi bi-shop"></i> 등록한 맛집이 없습니다.</p>' +
                    '<a href="/restaurants/new" class="btn btn-primary">맛집 등록하기</a></div>';
                document.getElementById('restaurantsPagination').querySelector('ul').innerHTML = '';
                return;
            }

            // 맛집 카드 생성
            var html = '';
            data.content.forEach(function(r) {
                html += '<div class="col-md-4 mb-3">' +
                    '<div class="card shadow-sm h-100">' +
                    '<div class="card-body">' +
                    '<h6 class="card-title"><a href="/restaurants/' + r.id + '">' + r.name + '</a></h6>' +
                    '<p class="card-text text-muted small mb-1">' +
                    '<i class="bi bi-tag"></i> ' + r.category + '</p>' +
                    '<p class="card-text text-muted small mb-0">' +
                    '<i class="bi bi-geo-alt"></i> ' + r.address + '</p>' +
                    '</div>' +
                    '<div class="card-footer text-muted small">' +
                    '<i class="bi bi-calendar"></i> ' + r.createdAt +
                    '</div></div></div>';
            });
            container.innerHTML = html;

            // 페이지네이션 생성
            renderPagination('restaurantsPagination', data.totalPages, data.currentPage, loadMyRestaurants);
        })
        .catch(function() {
            document.getElementById('myRestaurantsList').innerHTML =
                '<div class="col-12 text-center py-3 text-danger">데이터를 불러올 수 없습니다.</div>';
        });
}

// ── 내 리뷰 목록 로드 ─────────────────────────────────────────
// /api/mypage/reviews API를 호출하여 내가 작성한 리뷰를 목록으로 표시
function loadMyReviews(page) {
    fetch('/api/mypage/reviews?page=' + page + '&size=10')
        .then(function(response) { return response.json(); })
        .then(function(data) {
            var container = document.getElementById('myReviewsList');

            // 리뷰가 없는 경우
            if (data.content.length === 0) {
                container.innerHTML = '<div class="text-center py-5">' +
                    '<p class="text-muted"><i class="bi bi-chat-dots"></i> 작성한 리뷰가 없습니다.</p></div>';
                document.getElementById('reviewsPagination').querySelector('ul').innerHTML = '';
                return;
            }

            // 리뷰 목록 생성
            var html = '<div class="list-group">';
            data.content.forEach(function(r) {
                // 별점을 ★ 아이콘으로 표시
                var stars = '';
                for (var i = 0; i < r.rating; i++) {
                    stars += '<i class="bi bi-star-fill text-warning"></i>';
                }
                for (var j = r.rating; j < 5; j++) {
                    stars += '<i class="bi bi-star text-warning"></i>';
                }

                html += '<div class="list-group-item">' +
                    '<div class="d-flex justify-content-between align-items-start">' +
                    '<div>' +
                    '<h6 class="mb-1"><a href="/restaurants/' + r.restaurantId + '">' +
                    r.restaurantName + '</a></h6>' +
                    '<div class="mb-1">' + stars + '</div>' +
                    '<p class="mb-0 text-muted">' + r.content + '</p>' +
                    '</div>' +
                    '<small class="text-muted">' + r.createdAt + '</small>' +
                    '</div></div>';
            });
            html += '</div>';
            container.innerHTML = html;

            // 페이지네이션 생성
            renderPagination('reviewsPagination', data.totalPages, data.currentPage, loadMyReviews);
        })
        .catch(function() {
            document.getElementById('myReviewsList').innerHTML =
                '<div class="text-center py-3 text-danger">데이터를 불러올 수 없습니다.</div>';
        });
}

// ── 페이지네이션 렌더링 공통 함수 ─────────────────────────────
// navId: 페이지네이션을 넣을 nav 요소의 id
// totalPages: 전체 페이지 수
// currentPage: 현재 페이지 번호 (0부터 시작)
// loadFunction: 페이지 번호를 받아 데이터를 로드하는 함수
function renderPagination(navId, totalPages, currentPage, loadFunction) {
    var paginationUl = document.getElementById(navId).querySelector('ul');

    if (totalPages <= 1) {
        paginationUl.innerHTML = '';
        return;
    }

    var html = '';

    // 이전 버튼
    html += '<li class="page-item ' + (currentPage === 0 ? 'disabled' : '') + '">' +
        '<a class="page-link" href="#" onclick="event.preventDefault();" ' +
        'data-page="' + (currentPage - 1) + '">&laquo;</a></li>';

    // 페이지 번호 버튼
    for (var i = 0; i < totalPages; i++) {
        html += '<li class="page-item ' + (i === currentPage ? 'active' : '') + '">' +
            '<a class="page-link" href="#" onclick="event.preventDefault();" ' +
            'data-page="' + i + '">' + (i + 1) + '</a></li>';
    }

    // 다음 버튼
    html += '<li class="page-item ' + (currentPage === totalPages - 1 ? 'disabled' : '') + '">' +
        '<a class="page-link" href="#" onclick="event.preventDefault();" ' +
        'data-page="' + (currentPage + 1) + '">&raquo;</a></li>';

    paginationUl.innerHTML = html;

    // 클릭 이벤트 등록
    paginationUl.querySelectorAll('a.page-link').forEach(function(link) {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            var pageNum = parseInt(this.getAttribute('data-page'));
            if (pageNum >= 0 && pageNum < totalPages) {
                loadFunction(pageNum);
            }
        });
    });
}

// ── 닉네임 변경 폼 처리 ──────────────────────────────────────
document.getElementById('nicknameForm').addEventListener('submit', function(e) {
    e.preventDefault();

    var newNickname = document.getElementById('newNickname').value;

    fetch('/api/mypage/nickname', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ nickname: newNickname })
    })
    .then(function(response) { return response.json().then(function(data) { return { ok: response.ok, data: data }; }); })
    .then(function(result) {
        var msgDiv = document.getElementById('nicknameMsg');
        if (result.ok) {
            // 성공 메시지 표시
            msgDiv.className = 'alert alert-success';
            msgDiv.textContent = result.data.message;
            // 프로필 닉네임 업데이트
            document.getElementById('profileNickname').textContent = newNickname + '님';
        } else {
            // 에러 메시지 표시
            msgDiv.className = 'alert alert-danger';
            msgDiv.textContent = result.data.error;
        }
    })
    .catch(function() {
        var msgDiv = document.getElementById('nicknameMsg');
        msgDiv.className = 'alert alert-danger';
        msgDiv.textContent = '서버 오류가 발생했습니다.';
    });
});

// ── 비밀번호 변경 폼 처리 ─────────────────────────────────────
document.getElementById('passwordForm').addEventListener('submit', function(e) {
    e.preventDefault();

    var currentPw = document.getElementById('currentPassword').value;
    var newPw = document.getElementById('newPassword').value;

    fetch('/api/mypage/password', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ currentPassword: currentPw, newPassword: newPw })
    })
    .then(function(response) { return response.json().then(function(data) { return { ok: response.ok, data: data }; }); })
    .then(function(result) {
        var msgDiv = document.getElementById('passwordMsg');
        if (result.ok) {
            msgDiv.className = 'alert alert-success';
            msgDiv.textContent = result.data.message;
            // 입력 필드 초기화
            document.getElementById('currentPassword').value = '';
            document.getElementById('newPassword').value = '';
        } else {
            msgDiv.className = 'alert alert-danger';
            msgDiv.textContent = result.data.error;
        }
    })
    .catch(function() {
        var msgDiv = document.getElementById('passwordMsg');
        msgDiv.className = 'alert alert-danger';
        msgDiv.textContent = '서버 오류가 발생했습니다.';
    });
});
</script>

<%-- 공통 푸터 포함 --%>
<jsp:include page="../common/footer.jsp"/>
