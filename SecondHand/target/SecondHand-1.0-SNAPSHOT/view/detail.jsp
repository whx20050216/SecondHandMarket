<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>物品详情</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">二手交易平台</a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="${pageContext.request.contextPath}/">首页</a>
            <c:if test="${not empty sessionScope.loginUser}">
                <a class="nav-link" href="${pageContext.request.contextPath}/item/publish">发布物品</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/item/my">我的发布</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/user/logout">退出</a>
            </c:if>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-8">
            <h2>${item.title}</h2>
            <p><strong>价格：</strong>¥${item.price}</p>
            <p><strong>状态：</strong>
                <span class="badge ${item.status == 'on_sale' ? 'bg-success' : 'bg-secondary'}">
                    ${item.status == 'on_sale' ? '在售' : '已售出'}
                </span>
            </p>
            <hr>
            <h4>物品描述</h4>
            <p>${item.description}</p>
            <c:if test="${item.status == 'on_sale'}">
                <button class="btn btn-success btn-lg">立即购买</button>
            </c:if>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">返回首页</a>
        </div>
    </div>
</div>
</body>
</html>