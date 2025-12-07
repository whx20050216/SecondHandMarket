<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的发布</title>
    <link href="${pageContext.request.contextPath}/css/my_items.css" rel="stylesheet">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">二手交易平台</a>
        <ul class="navbar-nav">
            <li><a class="nav-link" href="${pageContext.request.contextPath}/">首页</a></li>
            <li><a class="nav-link" href="${pageContext.request.contextPath}/item/publish">发布物品</a></li>
            <li><a class="nav-link" href="${pageContext.request.contextPath}/user/logout">退出</a></li>
        </ul>
    </div>
</nav>

<div class="main-container mt-4">
    <h2 class="mb-4">我的发布</h2>
    <div class="row">
        <c:forEach items="${items}" var="item">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">${item.title}</h5>
                        <p class="card-text">¥${item.price}</p>
                        <p class="card-text">
                                <span class="badge ${item.status == 'on_sale' ? 'bg-success' : 'bg-secondary'}">
                                        ${item.status == 'on_sale' ? '在售' : '已售出'}
                                </span>
                        </p>

                        <!-- 只有"在售"状态才显示编辑和标记售出按钮 -->
                        <c:if test="${item.status == 'on_sale'}">
                            <a href="${pageContext.request.contextPath}/item/edit?id=${item.id}" class="btn btn-warning btn-sm">编辑</a>
                            <button class="btn btn-info btn-sm" onclick="markAsSold(${item.id})">标记售出</button>
                        </c:if>

                        <!-- 删除按钮始终显示 -->
                        <button class="btn btn-danger btn-sm" onclick="deleteItem(${item.id})">删除</button>
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