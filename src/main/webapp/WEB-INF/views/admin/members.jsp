<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="회원 관리" scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2><i class="bi bi-person-gear"></i> 회원 관리</h2>
    <a href="/admin" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left"></i> 대시보드
    </a>
</div>

<div class="card shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>이메일</th>
                        <th>닉네임</th>
                        <th>역할</th>
                        <th>가입일</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody id="memberTableBody">
                    <tr><td colspan="6" class="text-center">로딩 중...</td></tr>
                </tbody>
            </table>
        </div>
        <nav id="membersPagination" class="mt-3">
            <ul class="pagination justify-content-center"></ul>
        </nav>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    loadMembers(0);
});

function loadMembers(page) {
    fetch('/api/admin/members?page=' + page + '&size=20')
        .then(function(res) { return res.json(); })
        .then(function(data) {
            var tbody = document.getElementById('memberTableBody');

            if (data.content.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="text-center text-muted">회원이 없습니다.</td></tr>';
                return;
            }

            var html = '';
            data.content.forEach(function(m) {
                html += '<tr>' +
                    '<td>' + m.id + '</td>' +
                    '<td>' + m.email + '</td>' +
                    '<td>' + m.nickname + '</td>' +
                    '<td>' +
                        '<select class="form-select form-select-sm d-inline-block" style="width:auto;" ' +
                        'onchange="changeRole(' + m.id + ', this.value)">' +
                        '<option value="USER"' + (m.role === 'USER' ? ' selected' : '') + '>일반회원</option>' +
                        '<option value="ADMIN"' + (m.role === 'ADMIN' ? ' selected' : '') + '>관리자</option>' +
                        '</select>' +
                    '</td>' +
                    '<td>' + m.createdAt + '</td>' +
                    '<td>' +
                        '<button class="btn btn-outline-danger btn-sm" onclick="deleteMember(' + m.id + ')">' +
                        '<i class="bi bi-trash"></i></button>' +
                    '</td>' +
                    '</tr>';
            });
            tbody.innerHTML = html;

            renderPagination('membersPagination', data.totalPages, data.currentPage, loadMembers);
        })
        .catch(function() {
            document.getElementById('memberTableBody').innerHTML =
                '<tr><td colspan="6" class="text-center text-danger">데이터를 불러올 수 없습니다.</td></tr>';
        });
}

function changeRole(memberId, role) {
    fetch('/api/admin/members/' + memberId + '/role', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ role: role })
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.message) {
            alert(data.message);
        } else if (data.error) {
            alert(data.error);
            loadMembers(0);
        }
    });
}

function deleteMember(memberId) {
    if (!confirm('이 회원을 삭제하시겠습니까?')) return;

    fetch('/api/admin/members/' + memberId, { method: 'DELETE' })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.message) {
                alert(data.message);
                loadMembers(0);
            } else if (data.error) {
                alert(data.error);
            }
        });
}

function renderPagination(navId, totalPages, currentPage, loadFunction) {
    var paginationUl = document.getElementById(navId).querySelector('ul');
    if (totalPages <= 1) { paginationUl.innerHTML = ''; return; }

    var html = '';
    html += '<li class="page-item ' + (currentPage === 0 ? 'disabled' : '') + '">' +
        '<a class="page-link" href="#" data-page="' + (currentPage - 1) + '">&laquo;</a></li>';

    for (var i = 0; i < totalPages; i++) {
        html += '<li class="page-item ' + (i === currentPage ? 'active' : '') + '">' +
            '<a class="page-link" href="#" data-page="' + i + '">' + (i + 1) + '</a></li>';
    }

    html += '<li class="page-item ' + (currentPage === totalPages - 1 ? 'disabled' : '') + '">' +
        '<a class="page-link" href="#" data-page="' + (currentPage + 1) + '">&raquo;</a></li>';

    paginationUl.innerHTML = html;

    paginationUl.querySelectorAll('a.page-link').forEach(function(link) {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            var pageNum = parseInt(this.getAttribute('data-page'));
            if (pageNum >= 0 && pageNum < totalPages) { loadFunction(pageNum); }
        });
    });
}
</script>

<jsp:include page="../common/footer.jsp"/>
