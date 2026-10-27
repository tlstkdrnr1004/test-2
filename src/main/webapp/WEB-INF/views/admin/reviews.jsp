<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="리뷰 관리" scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2><i class="bi bi-flag"></i> 리뷰 관리</h2>
    <a href="/admin" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left"></i> 대시보드
    </a>
</div>

<%-- [추가] 전체 / 신고된 리뷰만 보기 버튼 --%>
<div class="btn-group mb-3" role="group">
    <button type="button" id="btnAll" class="btn btn-primary btn-sm" onclick="loadReviews(false)">전체</button>
    <button type="button" id="btnReported" class="btn btn-outline-danger btn-sm" onclick="loadReviews(true)">신고된 리뷰</button>
</div>

<div class="card shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>내용</th>
                        <th>별점</th>
                        <th>작성자</th>
                        <th>맛집</th>
                        <th>작성일</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody id="reviewTableBody">
                    <tr><td colspan="7" class="text-center">로딩 중...</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
// [수정] 현재 보고 있는 목록 (false = 전체, true = 신고된 리뷰만)
var onlyReported = false;

document.addEventListener('DOMContentLoaded', function() {
    loadReviews(false);
});

function loadReviews(reportedOnly) {
    if (reportedOnly !== undefined) onlyReported = reportedOnly;
    document.getElementById('btnAll').className = 'btn btn-sm ' + (onlyReported ? 'btn-outline-primary' : 'btn-primary');
    document.getElementById('btnReported').className = 'btn btn-sm ' + (onlyReported ? 'btn-danger' : 'btn-outline-danger');
    fetch(onlyReported ? '/api/admin/reviews/reported' : '/api/admin/reviews')
        .then(function(res) { return res.json(); })
        .then(function(data) {
            var tbody = document.getElementById('reviewTableBody');

            if (data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">리뷰가 없습니다.</td></tr>';
                return;
            }

            var html = '';
            data.forEach(function(r) {
                // 별점 표시
                var stars = '';
                for (var i = 0; i < r.rating; i++) {
                    stars += '<i class="bi bi-star-fill text-warning"></i>';
                }

                // 내용이 길면 자르기
                var content = r.content.length > 50 ? r.content.substring(0, 50) + '...' : r.content;

                html += '<tr>' +
                    '<td>' + r.id + '</td>' +
                    '<td>' + (r.reported ? '<span class="badge bg-danger me-1">신고</span>' : '') + content + '</td>' +
                    '<td>' + stars + '</td>' +
                    '<td>' + r.memberNickname + '</td>' +
                    '<td>' + r.restaurantName + '</td>' +
                    '<td>' + r.createdAt + '</td>' +
                    '<td>' +
                        '<button class="btn btn-outline-danger btn-sm" onclick="deleteReview(' + r.id + ')">' +
                        '<i class="bi bi-trash"></i></button>' +
                    '</td>' +
                    '</tr>';
            });
            tbody.innerHTML = html;
        })
        .catch(function() {
            document.getElementById('reviewTableBody').innerHTML =
                '<tr><td colspan="7" class="text-center text-danger">데이터를 불러올 수 없습니다.</td></tr>';
        });
}

function deleteReview(id) {
    if (!confirm('이 리뷰를 삭제하시겠습니까?')) return;

    fetch('/api/admin/reviews/' + id, { method: 'DELETE' })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.message) {
                alert(data.message);
                loadReviews();
            } else if (data.error) {
                alert(data.error);
            }
        });
}
</script>

<jsp:include page="../common/footer.jsp"/>
