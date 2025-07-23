<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>Register</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_home.css" />
        <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>

    <body class="modern-auth-bg">
        <div class="modern-auth-card">
            <div style="margin-bottom: 18px;">
                <div class="modern-auth-sub" style="font-size:1.05rem;">START FOR FREE</div>
                <div class="modern-auth-title">Create new account<span style="color:#3fa9f5;">.</span></div>
            </div>
            <form id="signupForm" action="${pageContext.request.contextPath}/register" method="post">
                <label for="fullName">Họ và tên</label>
                <div style="position:relative;">
                    <span class="modern-auth-icon"><i class="fas fa-user"></i></span>
                    <input type="text" name="fullName" id="fullName" required class="modern-auth-input" placeholder="Nhập họ và tên">
                </div>
                <label for="email">Email</label>
                <div style="position:relative;">
                    <span class="modern-auth-icon"><i class="fas fa-envelope"></i></span>
                    <input type="email" name="email" id="emailReg" required class="modern-auth-input" placeholder="Nhập email">
                </div>
                <label for="password">Mật khẩu</label>
                <div style="position:relative;">
                    <span class="modern-auth-icon"><i class="fas fa-check"></i></span>
                    <input type="password" name="password" id="passwordReg" required class="modern-auth-input" placeholder="Nhập mật khẩu">
                    <span class="modern-auth-eye" onclick="togglePassword('passwordReg', this)"><i class="fas fa-eye"></i></span>
                </div>
                <button type="submit" class="modern-auth-btn">Đăng ký</button>
            </form>
            <div style="margin-top: 10px; text-align:center; color:#b0b8c9; font-size:0.98rem;">
                Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/view/auth/login.jsp" class="modern-auth-switch">Đăng nhập</a>
            </div>
            <c:if test="${not empty error}">
                <div style="color:#ff5252; margin-bottom:10px; font-weight:500;">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div style="color:#3fa9f5; margin-bottom:10px; font-weight:500;">${message}</div>
            </c:if>
        </div>
        <div class="modern-auth-side-bg"></div>
        <script>
            function togglePassword(inputId, el) {
                const input = document.getElementById(inputId);
                if (input.type === 'password') {
                    input.type = 'text';
                    el.querySelector('i').classList.remove('fa-eye');
                    el.querySelector('i').classList.add('fa-eye-slash');
                } else {
                    input.type = 'password';
                    el.querySelector('i').classList.remove('fa-eye-slash');
                    el.querySelector('i').classList.add('fa-eye');
                }
            }
        </script>
    </body>
</html>
