<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>登录</title>
    <link href="${pageContext.request.contextPath}/css/login.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <div class="login-box">
        <h2 class="text-center mb-4">用户登录</h2>
        <form id="loginForm">
            <div class="mb-3">
                <label class="form-label">用户名</label>
                <input type="text" name="username" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">密码</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">登录</button>
            <p class="text-center mt-3">还没有账号？<a href="${pageContext.request.contextPath}/user/register">立即注册</a></p>
        </form>
    </div>
</div>

<script>
    document.getElementById('loginForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);

        const response = await fetch("${pageContext.request.contextPath}/user/login", {
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