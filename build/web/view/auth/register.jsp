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

    <body class="bg-gradient-to-br from-blue-200 via-blue-100 to-white min-h-screen flex items-center justify-center">

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
                <label for="fullName" class="text-xs font-semibold text-gray-700 mb-1 block">Họ và tên</label>
                <div class="relative">
                    <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"><i class="fas fa-user"></i></span>
                    <input type="text" name="fullName" id="fullName" required
                           class="w-full border border-gray-300 rounded-full pl-10 pr-4 py-2 text-sm font-semibold text-gray-900 focus:ring-2 focus:ring-blue-300 focus:border-blue-400 transition outline-none shadow-sm"
                           placeholder="Nhập họ và tên">
                </div>
            </div>

            <div class="mb-4">
                <label for="email" class="text-xs font-semibold text-gray-700 mb-1 block">Email</label>
                <div class="relative">
                    <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"><i class="fas fa-envelope"></i></span>
                    <input type="email" name="email" id="emailReg" required
                           class="w-full border border-gray-300 rounded-full pl-10 pr-4 py-2 text-sm font-semibold text-gray-900 focus:ring-2 focus:ring-blue-300 focus:border-blue-400 transition outline-none shadow-sm"
                           placeholder="Nhập email">
                </div>
            </div>

            <div class="mb-4">
                <label for="password" class="text-xs font-semibold text-gray-700 mb-1 block">Mật khẩu</label>
                <div class="relative">
                    <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"><i class="fas fa-lock"></i></span>
                    <input type="password" name="password" id="passwordReg" required
                           class="w-full border border-gray-300 rounded-full pl-10 pr-10 py-2 text-sm font-semibold text-gray-900 focus:ring-2 focus:ring-blue-300 focus:border-blue-400 transition outline-none shadow-sm"
                           placeholder="Nhập mật khẩu">
                    <span class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 cursor-pointer" onclick="togglePassword('passwordReg', this)"><i class="fas fa-eye"></i></span>
                </div>
            </div>

            <button type="submit"
                    class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-full text-sm font-semibold w-full shadow-md transition">Đăng ký</button>
            <div class="text-center mt-4 text-sm">
                <span>Bạn đã có tài khoản? </span>
                <a href="${pageContext.request.contextPath}/view/auth/login.jsp" class="text-blue-600 hover:underline font-semibold">Đăng nhập</a>
            </div>

        </form>

    </body>
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
</html>
