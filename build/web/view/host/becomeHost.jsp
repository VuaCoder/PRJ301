<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserAccount" %>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
        return;
    }
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trở thành Chủ nhà - Staytion</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_home.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        body { background: #f7f7fa; font-family: 'Noto Sans', sans-serif; }
        .become-host-container {
            max-width: 520px;
            margin: 60px auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px #0001;
            padding: 36px 32px 32px 32px;
        }
        .become-host-title {
            font-size: 2rem;
            font-weight: 700;
            color: #484848;
            margin-bottom: 12px;
            text-align: center;
        }
        .become-host-desc {
            color: #666;
            font-size: 1rem;
            margin-bottom: 28px;
            text-align: center;
        }
        .become-host-form label {
            font-weight: 600;
            color: #333;
            margin-bottom: 6px;
            display: block;
        }
        .become-host-form input, .become-host-form textarea {
            width: 100%;
            border-radius: 8px;
            border: 1px solid #ccc;
            padding: 10px;
            font-size: 1rem;
            margin-bottom: 18px;
        }
        .become-host-form textarea { min-height: 80px; resize: vertical; }
        .become-host-form button {
            background: #484848;
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 12px 0;
            width: 100%;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .become-host-form button:hover { background: #222; }
        .become-host-icon { display: flex; justify-content: center; margin-bottom: 18px; }
        .become-host-icon i { font-size: 2.5rem; color: #484848; }
    </style>
</head>
<body>
<jsp:include page="/view/common/header.jsp" />
<div class="become-host-container">
    <div class="become-host-icon"><i class="fas fa-house-user"></i></div>
    <div class="become-host-title">Đăng ký trở thành Chủ nhà</div>
    <div class="become-host-desc">
        Chia sẻ không gian của bạn, kiếm thêm thu nhập và trở thành một phần của cộng đồng Staytion.<br>
        Vui lòng cung cấp thông tin cá nhân và chi tiết nơi ở bên dưới.
    </div>
    <form class="become-host-form" method="post" action="${pageContext.request.contextPath}/becomeHost">
        <label for="hostDescription">Giới thiệu về bạn <span style="color:red;">*</span></label>
        <textarea name="description" id="hostDescription" required placeholder="Chia sẻ về bạn hoặc phong cách đón tiếp khách..."></textarea>

        <label for="propertyName">Tên chỗ ở <span style="color:red;">*</span></label>
        <input type="text" name="propertyName" id="propertyName" required placeholder="VD: Homestay ấm cúng Đà Lạt">

        <label for="propertyDescription">Mô tả chỗ ở <span style="color:red;">*</span></label>
        <textarea name="propertyDescription" id="propertyDescription" required placeholder="Mô tả tiện nghi, đặc điểm nổi bật, không gian..."></textarea>

        <label for="propertyAddress">Địa chỉ <span style="color:red;">*</span></label>
        <input type="text" name="propertyAddress" id="propertyAddress" required placeholder="VD: 12 Trần Hưng Đạo, Đà Lạt">

        <label for="propertyCity">Thành phố <span style="color:red;">*</span></label>
        <input type="text" name="propertyCity" id="propertyCity" required placeholder="VD: Đà Lạt">

        <button type="submit">Gửi đăng ký</button>
    </form>
</div>
<jsp:include page="/view/common/footer.jsp" />
</body>
</html>
