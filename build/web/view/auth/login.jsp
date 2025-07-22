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
    <link rel="stylesheet" href="../../css/style.css" />
    <link rel="icon" type="image/x-icon" href="../../img/favicon.ico">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-200 via-blue-100 to-white" style="position: relative; z-index: 1000;">

    <%-- Hiển thị thông báo thành công nếu có --%>
    <%
        String message = (String) request.getAttribute("message");
        if (message != null) {
    %>
        <div class="absolute top-4 text-green-600 font-semibold"><%= message %></div>
    <% } %>

    <%-- Hiển thị thông báo khi redirect từ booking --%>
    <%
        String redirect = request.getParameter("redirect");
        if ("booking".equals(redirect)) {
    %>
        <div class="absolute top-4 left-1/2 transform -translate-x-1/2 bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded">
            <i class="fas fa-info-circle mr-2"></i>
            Vui lòng đăng nhập để tiếp tục đặt phòng
        </div>
    <% } %>

    <%-- Hiển thị lỗi nếu có --%>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="absolute top-4 left-1/2 transform -translate-x-1/2 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
            <i class="fas fa-exclamation-circle mr-2"></i>
            <%= error %>
        </div>
    <% } %>

    <form id="loginForm" class="bg-white rounded-lg shadow-md border border-gray-200 p-6 w-[360px]"
          action="${pageContext.request.contextPath}/login" method="post" 
          style="position: relative; z-index: 1001;">
        <div class="flex justify-between items-center mb-4">
            <h2 class="font-semibold text-gray-900 text-base leading-6">Login</h2>
        </div>
        <hr class="border-gray-300 mb-5" />

        <div class="mb-4">
            <label for="email" class="text-xs font-semibold text-gray-700 mb-1 block">Email hoặc Tên đăng nhập</label>
            <div class="relative">
                <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"><i class="fas fa-user"></i></span>
                <input type="text" name="email" id="email" required
                       value="<%= email %>"
                       class="w-full border border-gray-300 rounded-full pl-10 pr-4 py-2 text-sm font-semibold text-gray-900 focus:ring-2 focus:ring-blue-300 focus:border-blue-400 transition outline-none shadow-sm"
                       placeholder="Nhập email hoặc tên đăng nhập">
            </div>
        </div>

        <div class="mb-4">
            <label for="password" class="text-xs font-semibold text-gray-700 mb-1 block">Mật khẩu</label>
            <div class="relative">
                <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"><i class="fas fa-lock"></i></span>
                <input type="password" name="password" id="password" required
                       value="<%= password %>"
                       class="w-full border border-gray-300 rounded-full pl-10 pr-10 py-2 text-sm font-semibold text-gray-900 focus:ring-2 focus:ring-blue-300 focus:border-blue-400 transition outline-none shadow-sm"
                       placeholder="Nhập mật khẩu">
                <span class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 cursor-pointer" onclick="togglePassword('password', this)"><i class="fas fa-eye"></i></span>
            </div>
        </div>

        <div class="mb-4 flex items-center">
            <input type="checkbox" name="remember" id="remember" class="mr-2 accent-blue-500">
            <label for="remember" class="text-xs text-gray-700">Ghi nhớ đăng nhập</label>
        </div>

        <button type="submit"
                class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-full text-sm font-semibold w-full shadow-md transition">Đăng nhập</button>

        <div class="mt-4 text-center">
            <a href="<%= googleLoginUrl %>"
               class="bg-red-500 hover:bg-red-600 text-white px-6 py-2 rounded-full text-sm font-semibold inline-block w-full shadow-md transition">
                <i class="fab fa-google mr-2"></i> Đăng nhập bằng Google
            </a>
        </div>

        <div class="text-center mt-4 text-sm">
            <span>Chưa có tài khoản? </span>
            <a href="${pageContext.request.contextPath}/view/auth/register.jsp" class="text-blue-600 hover:underline font-semibold">Đăng ký ngay</a>
        </div>

    </form>

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
