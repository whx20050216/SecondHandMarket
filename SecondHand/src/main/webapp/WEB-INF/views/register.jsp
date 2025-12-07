<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>注册</title>
    <link href="${pageContext.request.contextPath}/css/register.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <div class="register-box">
        <h2 class="text-center mb-4">用户注册</h2>
        <form id="registerForm">
            <div class="mb-3">
                <label class="form-label">用户名</label>
                <input type="text" name="username" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">密码</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">邮箱</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">手机号</label>
                <input type="tel" name="phone" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-success w-100">注册</button>
            <p class="text-center mt-3">已有账号？<a href="${pageContext.request.contextPath}/user/login">立即登录</a></p>

            <p class="text-center mt-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary w-100">返回首页</a>
            </p>
        </form>
    </div>
</div>

<script>
    document.getElementById('registerForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);

        const response = await fetch("${pageContext.request.contextPath}/user/register", {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        });

        const result = await response.json();
        alert(result.message);
        if (result.success) location.href = "${pageContext.request.contextPath}/user/login";
    });
</script>
</body>
</html>