<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的发布</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">二手交易平台</a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="${pageContext.request.contextPath}/">首页</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/item/publish">发布物品</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/user/logout">退出</a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2 class="mb-4">我的发布</h2>
    <div class="row">
        <c:forEach items="${items}" var="item">
            <div class="col-md-6 mb-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">${item.title}</h5>
                        <p class="card-text">¥${item.price}</p>
                        <p class="card-text">
                            <span class="badge ${item.status == 'on_sale' ? 'bg-success' : 'bg-secondary'}">
                                    ${item.status == 'on_sale' ? '在售' : '已售出'}
                            </span>
                        </p>
                        <a href="${pageContext.request.contextPath}/item/edit?id=${item.id}" class="btn btn-sm btn-warning">编辑</a>
                        <button class="btn btn-sm btn-danger" onclick="deleteItem(${item.id})">删除</button>
                        <c:if test="${item.status == 'on_sale'}">
                            <button class="btn btn-sm btn-info" onclick="markAsSold(${item.id})">标记售出</button>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    function deleteItem(itemId) {
        if (!confirm('确定删除该物品吗？')) return;

        fetch("${pageContext.request.contextPath}/item/delete", {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'id=' + itemId
        })
            .then(res => res.json())
            .then(result => {
                alert(result.message);
                if (result.success) location.reload();
            });
    }

    function markAsSold(itemId) {
        if (!confirm('确定标记为已售出吗？')) return;

        fetch("${pageContext.request.contextPath}/item/mark-sold", {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'id=' + itemId
        })
            .then(res => res.json())
            .then(result => {
                alert(result.message);
                if (result.success) location.reload();
            });
    }
</script>
</body>
</html>