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
    <body class="min-h-screen flex items-center justify-center bg-gray-100" style="position: relative; z-index: 1000;">

        <%-- Hiển thị thông báo thành công nếu có --%>
        <%
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
        <div class="absolute top-4 text-green-600 font-semibold"><%= message%></div>
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
        <% }%>

        <form id="loginForm" class="bg-white rounded-lg shadow-md border border-gray-200 p-6 w-[360px]"
              action="${pageContext.request.contextPath}/login" method="post" 
              style="position: relative; z-index: 1001;" onsubmit="console.log('Form submitted')">
            <div class="flex justify-between items-center mb-4">
                <h2 class="font-semibold text-gray-900 text-base leading-6">Login</h2>
            </div>
            <hr class="border-gray-300 mb-5" />

            <div class="mb-4">
                <label for="email" class="text-xs font-semibold text-gray-700 mb-1 block">Email</label>
                <input type="email" name="email" id="email" required
                       value="<%= email%>"
                       class="w-full border rounded-full px-4 py-2 text-xs font-semibold text-gray-900"
                       placeholder="Enter your email">
            </div>

            <div class="mb-4">
                <label for="password" class="text-xs font-semibold text-gray-700 mb-1 block">Password</label>
                <input type="password" name="password" id="password" required
                       value="<%= password%>"
                       class="w-full border rounded-full px-4 py-2 text-xs font-semibold text-gray-900"
                       placeholder="Enter your password">
            </div>

            <div class="mb-4 flex items-center">
                <input type="checkbox" name="remember" id="remember" class="mr-2">
                <label for="remember" class="text-xs text-gray-700">Remember me</label>
            </div>


            <button type="submit"
                    class="bg-gray-500 text-white px-6 py-2 rounded-full text-xs font-semibold w-full">
                Login
            </button>
            <div class="mt-4 text-center">
                <a href="${pageContext.request.contextPath}/login-google"
                   class="bg-red-500 hover:bg-red-600 text-white px-6 py-2 rounded-full text-xs font-semibold inline-block w-full">
                    <i class="fab fa-google mr-2"></i> Đăng nhập bằng Google
                </a>
            </div>
            <div class="text-center mt-4 text-sm">
                <span>Chưa có tài khoản? </span>
                <a href="${pageContext.request.contextPath}/view/auth/register.jsp" class="text-blue-600 hover:underline">Đăng ký ngay</a>
            </div>

        </form>

    </body>
</html>
