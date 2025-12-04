<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>二手交易平台</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">二手交易平台</a>
        <div class="navbar-nav ms-auto">
            <c:if test="${empty sessionScope.loginUser}">
                <a class="nav-link" href="${pageContext.request.contextPath}/user/login">登录</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/user/register">注册</a>
            </c:if>
            <c:if test="${not empty sessionScope.loginUser}">
                <a class="nav-link" href="${pageContext.request.contextPath}/item/publish">发布物品</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/item/my">我的发布</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/user/logout">退出</a>
            </c:if>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2 class="mb-4">物品列表</h2>

    <!-- 搜索栏 -->
    <form action="${pageContext.request.contextPath}/item/list" method="get" class="row mb-4">
        <div class="col-md-8">
            <input type="text" name="keyword" class="form-control" placeholder="搜索标题或描述" value="${param.keyword}">
        </div>
        <div class="col-md-4">
            <button type="submit" class="btn btn-primary">搜索</button>
            <a href="${pageContext.request.contextPath}/item/list" class="btn btn-secondary">重置</a>
        </div>
    </form>

    <!-- 物品列表 -->
    <div class="row">
        <c:forEach items="${items}" var="item">
            <div class="col-md-4 mb-3">
                <div class="card h-100">
                    <div class="card-body">
                        <h5 class="card-title">${item.title}</h5>
                        <p class="card-text">¥${item.price}</p>
                        <p class="card-text">
                            <span class="badge ${item.status == 'on_sale' ? 'bg-success' : 'bg-secondary'}">
                                    ${item.status == 'on_sale' ? '在售' : '已售出'}
                            </span>
                        </p>
                        <a href="${pageContext.request.contextPath}/item/detail?id=${item.id}" class="btn btn-primary btn-sm">查看详情</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>