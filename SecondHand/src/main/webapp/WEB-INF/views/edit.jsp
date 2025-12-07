<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>编辑物品</title>
    <link href="${pageContext.request.contextPath}/css/edit.css" rel="stylesheet">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">二手交易平台</a>
        <ul class="navbar-nav">
            <li><a class="nav-link" href="${pageContext.request.contextPath}/">首页</a></li>
            <li><a class="nav-link" href="${pageContext.request.contextPath}/item/my">我的发布</a></li>
            <li><a class="nav-link" href="${pageContext.request.contextPath}/user/logout">退出</a></li>
        </ul>
    </div>
</nav>

<div class="container mt-4">
    <div class="edit-box">
        <h2 class="mb-4">编辑物品</h2>
        <form id="editForm">
            <input type="hidden" name="id" value="${item.id}">
            <div class="mb-3">
                <label class="form-label">物品标题</label>
                <input type="text" name="title" class="form-control" value="${item.title}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">价格（元）</label>
                <input type="number" name="price" class="form-control" step="0.01" value="${item.price}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">物品描述</label>
                <textarea name="description" class="form-control" rows="5" required>${item.description}</textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">状态</label>
                <select name="status" class="form-control">
                    <option value="on_sale" ${item.status == 'on_sale' ? 'selected' : ''}>在售</option>
                    <option value="sold" ${item.status == 'sold' ? 'selected' : ''}>已售出</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">保存修改</button>
            <a href="${pageContext.request.contextPath}/item/my" class="btn btn-secondary">取消</a>
        </form>
    </div>
</div>

<script>
    document.getElementById('editForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);
        data.price = parseFloat(data.price);
        data.id = parseInt(data.id);

        const response = await fetch("${pageContext.request.contextPath}/item/update", {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        });

        const result = await response.json();
        alert(result.message);
        if (result.success) location.href = "${pageContext.request.contextPath}/item/my";
    });
</script>
</body>
</html>