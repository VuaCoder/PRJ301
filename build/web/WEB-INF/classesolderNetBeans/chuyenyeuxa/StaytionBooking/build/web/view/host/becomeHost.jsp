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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Become a Host - Staytion</title>
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
    <div class="become-host-title">Become a Host</div>
    <div class="become-host-desc">
        Share your space, earn extra income, and join our trusted host community.<br>
        Please provide your information and property details below.
    </div>
    <form class="become-host-form" method="post" action="${pageContext.request.contextPath}/becomeHost">
        <label for="hostDescription">Host Description <span style="color:red;">*</span></label>
        <textarea name="description" id="hostDescription" required placeholder="Tell us about yourself or your hosting style..."></textarea>
        <label for="propertyName">Property Name <span style="color:red;">*</span></label>
        <input type="text" name="propertyName" id="propertyName" required placeholder="e.g. Dalat Cozy Homestay">
        <label for="propertyDescription">Property Description <span style="color:red;">*</span></label>
        <textarea name="propertyDescription" id="propertyDescription" required placeholder="Describe your property, amenities, and what makes it special..."></textarea>
        <label for="propertyAddress">Address <span style="color:red;">*</span></label>
        <input type="text" name="propertyAddress" id="propertyAddress" required placeholder="e.g. 12 Tran Hung Dao, Da Lat">
        <label for="propertyCity">City <span style="color:red;">*</span></label>
        <input type="text" name="propertyCity" id="propertyCity" required placeholder="e.g. Da Lat">
        <label for="propertyLatitude">Latitude</label>
        <input type="number" step="any" name="propertyLatitude" id="propertyLatitude" placeholder="e.g. 11.9411">
        <label for="propertyLongitude">Longitude</label>
        <input type="number" step="any" name="propertyLongitude" id="propertyLongitude" placeholder="e.g. 108.4380">
        <button type="submit">Become a Host</button>
    </form>
</div>
<jsp:include page="/view/common/footer.jsp" />
</body>
</html> 