<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="jakarta.servlet.http.Cookie"%>
<%
    String email = "";
    String password = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("email".equals(c.getName())) {
                email = java.net.URLDecoder.decode(c.getValue(), "UTF-8");
            }
            if ("password".equals(c.getName())) {
                password = java.net.URLDecoder.decode(c.getValue(), "UTF-8");
            }
        }
    }

    String googleLoginUrl = "https://accounts.google.com/o/oauth2/v2/auth"
            + "?scope=" + java.net.URLEncoder.encode("https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile", "UTF-8")
            + "&access_type=online"
            + "&include_granted_scopes=true"
            + "&response_type=code"
            + "&redirect_uri=" + java.net.URLEncoder.encode("http://localhost:9999/login", "UTF-8")
            + "&client_id=701939732906-jtaqhn70lb55hsk4iod5q66635s22gql.apps.googleusercontent.com";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_home.css" />
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body class="modern-auth-bg">
    <% String message = (String) request.getAttribute("message"); %>
    <% String error = (String) request.getAttribute("error"); %>
    <div class="modern-auth-card">
        <div style="margin-bottom: 18px;">
            <div class="modern-auth-title" >Welcome back<span style="color:#3fa9f5;">!</span></div>
            <div class="modern-auth-sub" style="margin-bottom:0;">Đăng nhập để tiếp tục</div>
        </div>
        <% if (message != null) { %>
            <div style="color:#3fa9f5; margin-bottom:10px; font-weight:500;"> <%= message %> </div>
        <% } %>
        <% if (error != null) { %>
            <div style="color:#ff5252; margin-bottom:10px; font-weight:500;"> <%= error %> </div>
        <% } %>
        <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post" autocomplete="off">
            <label for="email" style="margin-bottom: 10px">Email hoặc Tên đăng nhập</label>
            <div style="position:relative;">
                <span class="modern-auth-icon"><i class="fas fa-user"></i></span>
                <input type="text" name="email" id="email" required value="<%= email %>" class="modern-auth-input" placeholder="Nhập email hoặc tên đăng nhập">
            </div>
            <label for="password" style="margin-bottom: 10px">Mật khẩu</label>
            <div style="position:relative;">
                <span class="modern-auth-icon"><i class="fas fa-check"></i></span>
                <input type="password" name="password" id="password" required value="<%= password %>" class="modern-auth-input" placeholder="Nhập mật khẩu">
                <span class="modern-auth-eye" onclick="togglePassword('password', this)"><i class="fas fa-eye"></i></span>
            </div>
            <div style="margin: 8px 0 0 0; display: flex; align-items: center;">
                <input type="checkbox" name="remember" id="remember" style="margin-right:7px; accent-color:#3fa9f5;">
                <label for="remember" style="color:#b0b8c9; font-size:0.98rem;">Ghi nhớ đăng nhập</label>
            </div>
            <button type="submit" class="modern-auth-btn">Đăng nhập</button>
            
            <a href="<%= googleLoginUrl %>" class="modern-auth-google"><i class="fab fa-google"></i> Đăng nhập bằng Google</a>
        </form>
        <div style="margin-top: 10px; text-align:center; color:#b0b8c9; font-size:0.98rem;">
            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/view/auth/register.jsp" class="modern-auth-switch">Đăng ký ngay</a>
        </div>
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
