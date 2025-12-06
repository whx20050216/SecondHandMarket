<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>二手交易平台</title>
    <link href="${pageContext.request.contextPath}/css/index.css" rel="stylesheet">
</head>
<body>

<nav class="navbar">
    <div class="container" style="display: flex; align-items: center;">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">二手交易平台</a>
        <ul class="navbar-nav">
            <c:if test="${empty sessionScope.loginUser}">
                <li><a class="nav-link" href="${pageContext.request.contextPath}/user/login">登录</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/user/register">注册</a></li>
            </c:if>
            <c:if test="${not empty sessionScope.loginUser}">
                <li><a class="nav-link" href="${pageContext.request.contextPath}/item/publish">发布物品</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/item/my">我的发布</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/user/logout">退出</a></li>
            </c:if>
        </ul>
    </div>
</nav>

<div class="container main-container">
    <h2>物品列表</h2>

    <!-- 搜索栏 -->
    <form action="${pageContext.request.contextPath}/item/list" method="get" class="search-form">
        <input type="text" name="keyword" class="search-input" placeholder="搜索标题或描述" value="${param.keyword}">
        <button type="submit" class="btn btn-primary">搜索</button>
        <a href="${pageContext.request.contextPath}/item/list" class="btn btn-secondary">重置</a>
    </form>

    <!-- 物品列表 -->
    <div class="items-grid">
        <c:forEach items="${items}" var="item">
            <div class="item-card">
                <h5 class="item-title">${item.title}</h5>
                <p class="item-price">¥${item.price}</p>
                <p>
                    <span class="status-badge ${item.status == 'on_sale' ? 'status-on-sale' : 'status-sold'}">
                            ${item.status == 'on_sale' ? '在售' : '已售出'}
                    </span>
                </p>
                <a href="${pageContext.request.contextPath}/item/detail?id=${item.id}" class="btn btn-primary btn-sm">查看详情</a>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    let refreshInterval;
    let isPageVisible = true;

    // 页面可见性检测（切到后台时暂停刷新）
    document.addEventListener('visibilitychange', () => {
        isPageVisible = !document.hidden;
    });

    // AJAX 刷新函数
    function refreshItems() {
        if (!isPageVisible) return; // 页面不可见时不刷新

        fetch('${pageContext.request.contextPath}/item/list?ajax=true')
            .then(response => response.text())
            .then(html => {
                // 找到物品列表容器，更新内容
                const parser = new DOMParser();
                const newDoc = parser.parseFromString(html, 'text/html');
                const newItemsGrid = newDoc.querySelector('.items-grid');
                const currentItemsGrid = document.querySelector('.items-grid');

                if (newItemsGrid && currentItemsGrid) {
                    currentItemsGrid.innerHTML = newItemsGrid.innerHTML;
                    console.log('物品列表已自动刷新 - ' + new Date().toLocaleTimeString());
                }
            })
            .catch(error => console.error('刷新失败:', error));
    }

    // 页面加载完成后启动定时器（每10秒）
    document.addEventListener('DOMContentLoaded', () => {
        refreshItems(); // 立即刷新一次
        refreshInterval = setInterval(refreshItems, 10000);

        // 用户主动操作时暂停刷新（避免干扰）
        ['click', 'keypress', 'scroll'].forEach(event => {
            document.addEventListener(event, () => {
                clearInterval(refreshInterval);
                refreshInterval = setInterval(refreshItems, 10000); // 重置计时器
            });
        });
    });
</script>
</body>
</html>