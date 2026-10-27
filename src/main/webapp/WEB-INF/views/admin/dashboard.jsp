<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="관리자 대시보드" scope="request"/>
<jsp:include page="../common/header.jsp"/>

<h2 class="mb-4"><i class="bi bi-speedometer2"></i> 관리자 대시보드</h2>

<%-- 통계 카드 --%>
<div class="row mb-4">
    <div class="col-md-4">
        <div class="card text-center shadow-sm">
            <div class="card-body">
                <i class="bi bi-people" style="font-size: 2rem; color: #0d6efd;"></i>
                <h3 class="mt-2" id="statMembers">-</h3>
                <p class="text-muted mb-0">전체 회원</p>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card text-center shadow-sm">
            <div class="card-body">
                <i class="bi bi-shop" style="font-size: 2rem; color: #198754;"></i>
                <h3 class="mt-2" id="statRestaurants">-</h3>
                <p class="text-muted mb-0">전체 맛집</p>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card text-center shadow-sm">
            <div class="card-body">
                <i class="bi bi-chat-dots" style="font-size: 2rem; color: #ffc107;"></i>
                <h3 class="mt-2" id="statReviews">-</h3>
                <p class="text-muted mb-0">전체 리뷰</p>
            </div>
        </div>
    </div>
</div>

<%-- 관리 메뉴 링크 --%>
<div class="row">
    <div class="col-md-4 mb-3">
        <a href="/admin/members" class="text-decoration-none">
            <div class="card shadow-sm h-100">
                <div class="card-body text-center">
                    <i class="bi bi-person-gear" style="font-size: 2rem;"></i>
                    <h5 class="mt-2">회원 관리</h5>
                    <p class="text-muted small">회원 목록 조회, 역할 변경, 삭제</p>
                </div>
            </div>
        </a>
    </div>
    <div class="col-md-4 mb-3">
        <a href="/admin/restaurants" class="text-decoration-none">
            <div class="card shadow-sm h-100">
                <div class="card-body text-center">
                    <i class="bi bi-building" style="font-size: 2rem;"></i>
                    <h5 class="mt-2">맛집 관리</h5>
                    <p class="text-muted small">맛집 목록 조회, 삭제</p>
                </div>
            </div>
        </a>
    </div>
    <div class="col-md-4 mb-3">
        <a href="/admin/reviews" class="text-decoration-none">
            <div class="card shadow-sm h-100">
                <div class="card-body text-center">
                    <i class="bi bi-flag" style="font-size: 2rem;"></i>
                    <h5 class="mt-2">리뷰 관리</h5>
                    <p class="text-muted small">리뷰 목록 조회, 삭제</p>
                </div>
            </div>
        </a>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    fetch('/api/admin/stats')
        .then(function(res) { return res.json(); })
        .then(function(data) {
            document.getElementById('statMembers').textContent = data.memberCount;
            document.getElementById('statRestaurants').textContent = data.restaurantCount;
            document.getElementById('statReviews').textContent = data.reviewCount;
        })
        .catch(function() {
            console.error('통계 로드 실패');
        });
});
</script>

<jsp:include page="../common/footer.jsp"/>
