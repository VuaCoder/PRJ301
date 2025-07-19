<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>Register</title>
        <link rel="stylesheet" href="../../css/style.css" />
        <link rel="icon" type="image/x-icon" href="../../img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="bg-gray-100 min-h-screen flex items-center justify-center">

        <form id="signupForm" class="bg-white rounded-lg shadow-md border border-gray-200 p-6 w-[360px]"
              action="${pageContext.request.contextPath}/register" method="post">
            <c:if test="${not empty error}">
                <div class="text-red-600 text-sm mb-3">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="text-green-600 text-sm mb-3">${message}</div>
            </c:if>
            <div class="flex justify-between items-center mb-4">

                <h2 class="font-semibold text-gray-900 text-base leading-6">Sign Up</h2>

            </div>
            <hr class="border-gray-300 mb-5" />

            <div class="mb-4">
                <label for="fullName" class="text-xs font-semibold text-gray-700 mb-1 block">Full Name</label>
                <input type="text" name="fullName" id="fullName" required
                       class="w-full border rounded-full px-4 py-2 text-xs font-semibold text-gray-900"
                       placeholder="Enter your name">
            </div>

            <div class="mb-4">
                <label for="email" class="text-xs font-semibold text-gray-700 mb-1 block">Email</label>
                <input type="email" name="email" id="emailReg" required
                       class="w-full border rounded-full px-4 py-2 text-xs font-semibold text-gray-900"
                       placeholder="Enter your email">
            </div>

            <div class="mb-4">
                <label for="password" class="text-xs font-semibold text-gray-700 mb-1 block">Password</label>
                <input type="password" name="password" id="passwordReg" required
                       class="w-full border rounded-full px-4 py-2 text-xs font-semibold text-gray-900"
                       placeholder="Enter password">
            </div>

            <button type="submit"
                    class="bg-gray-500 text-white px-6 py-2 rounded-full text-xs font-semibold w-full">Register</button>
            <div class="text-center mt-4 text-sm">
    <span>Bạn đã có tài khoản? </span>
<a href="${pageContext.request.contextPath}/view/auth/login.jsp" class="text-blue-600 hover:underline">Đăng nhập</a>
</div>

        </form>

    </body>
</html>
