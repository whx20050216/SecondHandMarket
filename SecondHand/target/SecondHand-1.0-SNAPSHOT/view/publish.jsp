<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>发布物品</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">二手交易平台</a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="${pageContext.request.contextPath}/">首页</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/item/my">我的发布</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/user/logout">退出</a>
        </div>
    </div>
</nav>

<div class="container mt-4" style="max-width: 600px;">
    <h2 class="mb-4">发布二手物品</h2>
    <form id="publishForm">
        <div class="mb-3">
            <label class="form-label">物品标题</label>
            <input type="text" name="title" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">价格（元）</label>
            <input type="number" name="price" class="form-control" step="0.01" required>
        </div>
        <div class="mb-3">
            <label class="form-label">物品描述</label>
            <textarea name="description" class="form-control" rows="5" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">发布物品</button>
        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">返回首页</a>
    </form>
</div>

<script>
    document.getElementById('publishForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);
        data.price = parseFloat(data.price);

        const response = await fetch("${pageContext.request.contextPath}/item/publish", {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        });

        const result = await response.json();
        alert(result.message);
        if (result.success) location.href = "${pageContext.request.contextPath}/";
    });
</script>
</body>
</html>