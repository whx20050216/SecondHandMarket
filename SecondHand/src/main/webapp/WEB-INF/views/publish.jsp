<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>发布物品</title>
    <link href="${pageContext.request.contextPath}/css/publish.css" rel="stylesheet">
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
    <div class="publish-box">
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
</div>

<script>
    let isSubmitting = false;  // 提交状态锁

    document.getElementById('publishForm').addEventListener('submit', async (e) => {
        e.preventDefault();

        if (isSubmitting) return;  // 如果正在提交，直接返回，防止重复

        isSubmitting = true;  // 上锁
        const submitBtn = e.target.querySelector('button[type="submit"]');
        submitBtn.disabled = true;  // 禁用按钮，防止重复点击

        try {
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

            if (result.success) {
                location.href = "${pageContext.request.contextPath}/item/list";
            } else {
                // 失败时解锁，允许重新提交
                isSubmitting = false;
                submitBtn.disabled = false;
            }
        } catch (error) {
            alert('网络错误，请重试');
            isSubmitting = false;  // 异常时也要解锁
            submitBtn.disabled = false;
        }
    });
</script>
</body>
</html>