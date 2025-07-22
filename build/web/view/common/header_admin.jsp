<%@page import="model.UserAccount"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    boolean isAdmin = user != null && user.getRoleId() != null && "admin".equalsIgnoreCase(user.getRoleId().getRoleName());

%>
<head>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        .header {
            background-color: #003B95;
            display: flex;
            align-items: center;
            height: 70px;
            position: relative;
            z-index: 100;
        }
        .main-header-logo {
            flex: 0 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .account-container {
            display: flex;
            align-items: center;
            position: relative;
            background: #f5f6f8;
            border-radius: 20px;
            padding: 8px 16px;
            width: fit-content;
            box-shadow: 0 2px 8px rgba(0,0,0,0.10);
            margin-right: 32px;
        }
        .hamburger-label {
            cursor: pointer;
            display: inline-block;
            z-index: 20;
        }
        .hamburger {
            width: 40px;
            height: 40px;
            object-fit: contain;
            cursor: pointer;
            margin-right: 0;
        }
        .avatar {
            width: 36px !important;
            height: 36px !important;
            border-radius: 50% !important;
            object-fit: cover !important;
            display: block;
            margin: 0 !important;
            background: #f3f3f3;
            border: 2px solid #e5e7eb;
        }
        .account-interface {
            opacity: 0;
            transform: translateY(-10px);
            pointer-events: none;
            transition: opacity 0.3s, transform 0.3s;
            position: absolute;
            right: 0;
            top: 60px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 16px;
            z-index: 10;
            min-width: 180px;
        }
        .account-interface.active {
            opacity: 1;
            transform: translateY(0);
            pointer-events: auto;
        }
        .account-menu {
            list-style: none;
            margin: 0;
            padding: 0;
            min-width: 120px;
        }
        .account-menu li {
            padding: 8px 0;
            color: #444;
            font-size: 16px;
            cursor: pointer;
            transition: font-weight 0.3s ease;
        }
        .account-menu li:hover {
            font-weight: 700;
        }
        .account-menu li:not(:last-child) {
            margin-bottom: 4px;
        }
        .account-menu li a {
            color: #333;
            text-decoration: none;
            display: block;
            padding: 10px 16px;
            transition: background-color 0.2s;
        }
        .account-menu li a:hover {
            background: #f3f3f3;
        }
    </style>
</head>

<div class="header" style="background:#003B95;">
    <div style="flex:1"></div>
    <div class="main-header-logo flex items-center justify-center" style="flex:0 0 auto;">
        <img src="${pageContext.request.contextPath}/img/logo2.png" alt="Staytion Logo" style="height:200px;width:auto;object-fit:contain;filter:none;">
    </div>
    <div style="flex:1; display:flex; justify-content:flex-end; align-items:center;">
        <div class="account-container">
            <label for="toggle-account-menu" class="hamburger-label">
                <img src="${pageContext.request.contextPath}/img/hamburger-lines.png" alt="Menu" class="hamburger" id="menuButton">
            </label>
            <img src="<%= (user != null && user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) ? user.getAvatarUrl() : (request.getContextPath() + "/img/user.png")%>" alt="Avatar" class="avatar" id="avatarButton">
            <!-- Dropdown -->
            <div id="menuDropdown" class="account-interface" >
                <ul class="account-menu">
                    <% if (user != null) {%>
                    <li style="font-weight: 600; color: #333; padding: 12px 16px; border-bottom: 1px solid #eee;">
                        Hello, <%= user.getFullName() != null ? user.getFullName() : user.getUsername()%>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/view/auth/edit-profile.jsp?tab=password">Đổi thông tin</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        <% } else { %>
                    <li>
                        <a href="${pageContext.request.contextPath}/view/auth/register.jsp" style="display: block; padding: 12px 16px; color: #333; text-decoration: none; transition: background-color 0.2s;">
                            <i class="fas fa-user-plus" style="margin-right: 8px; width: 16px;"></i> 
                            Sign Up
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/view/auth/login.jsp" style="display: block; padding: 12px 16px; color: #333; text-decoration: none; transition: background-color 0.2s;">
                            <i class="fas fa-sign-in-alt" style="margin-right: 8px; width: 16px;"></i> 
                            Login
                        </a>
                    </li>
                    <% }%>
                </ul>
            </div>
        </div>
    </div>
</div>
<script>
    const menuButton = document.getElementById("menuButton");
    const menuDropdown = document.getElementById("menuDropdown");
    let fadeTimeout = null;
    menuButton?.addEventListener("click", (e) => {
        e.stopPropagation();
        if (menuDropdown.classList.contains("active")) {
            menuDropdown.classList.remove("active");
            menuDropdown.classList.add("fade-out");
            clearTimeout(fadeTimeout);
            fadeTimeout = setTimeout(() => {
                menuDropdown.classList.remove("fade-out");
            }, 350);
        } else {
            menuDropdown.classList.add("active");
            menuDropdown.classList.remove("fade-out");
        }
    });
    document.addEventListener("click", (e) => {
        if (!menuButton?.contains(e.target) && !menuDropdown?.contains(e.target)) {
            if (menuDropdown.classList.contains("active")) {
                menuDropdown.classList.remove("active");
                menuDropdown.classList.add("fade-out");
                clearTimeout(fadeTimeout);
                fadeTimeout = setTimeout(() => {
                    menuDropdown.classList.remove("fade-out");
                }, 350);
            }
        }
    });
</script>
