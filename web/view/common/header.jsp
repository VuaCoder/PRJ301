<%-- 
    Document   : header
    Created on : Jun 15, 2025, 1:31:39?PM
    Author     : quangminhnguyen
--%>
<%@page import="model.UserAccount"%>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    boolean isHost = user != null && user.getRoleId() != null && "host".equalsIgnoreCase(user.getRoleId().getRoleName());
%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_home.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_header.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
.account-container { position: relative; }
.account-interface {
    display: none;
    position: absolute;
    right: 0;
    top: 60px;
    background: #fff;
    z-index: 9999;
    min-width: 180px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    border-radius: 8px;
}
.account-interface.active {
    display: block;
}
.account-menu { list-style: none; margin: 0; padding: 0; }
.account-menu li { padding: 10px 16px; cursor: pointer; }
.account-menu li a { color: #333; text-decoration: none; display: block; }
.account-menu li a:hover { background: #f3f3f3; }
</style>
<div class="header">
    <div class="main-header">
        
        <div class="main-header-logo">
            <a href="${pageContext.request.contextPath}/home"><img src="${pageContext.request.contextPath}/img/logo.png"></a>
        </div>
        <div class="main-header-option">
            <ul>
                <li><a href="#">Find a Property</a></li>
                <li><a href="#">Rental Guides</a></li>
                <li><a href="#">Download Mobile App</a></li>
                <% if (user != null && isHost) { %>
                    <li style="background-color: #484848; color: white; padding: 13px 40px; border-radius: 20px; display: inline-block;">Hello, Host <%= user.getFullName() %></li>
                <% } else { %>
                    <li><a href="${pageContext.request.contextPath}/view/host/becomeHost.jsp" id="become-a-host">Become a host</a></li>
                <% } %>
            </ul>
        </div>
        <div id="account" class="account-container">
            <label for="toggle-account-menu" class="hamburger-label">
                <img src="${pageContext.request.contextPath}/img/hamburger-lines.png" alt="hamburger" class="hamburger" id="menuButton">
            </label>
            <a href="#"><img src="${pageContext.request.contextPath}/img/user.png" alt="avatar" class="avatar" id="menuButton"></a>
            <div id="menuDropdown" class="account-interface">
                <ul class="account-menu">
                    <% if (user != null) { %>
                        <li class="font-semibold text-gray-800">Hello, <%= user.getFullName() %></li>
                        <li><a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 hover:bg-gray-100">Logout</a></li>
                    <% } else { %>
                        <li><a href="${pageContext.request.contextPath}/view/auth/register.jsp" class="w-full block text-left">Sign Up</a></li>
                        <li><a href="${pageContext.request.contextPath}/view/auth/login.jsp" class="w-full block text-left">Login</a></li>
                    <% } %>
                </ul>
            </div>
        </div>
    </div>
</div>
<script>
    const menuButton = document.getElementById("menuButton");
    const menuDropdown = document.getElementById("menuDropdown");
    menuButton?.addEventListener("click", (e) => {
        e.stopPropagation();
        menuDropdown?.classList.toggle("active");
    });
    document.addEventListener("click", (e) => {
        if (!menuButton?.contains(e.target) && !menuDropdown?.contains(e.target)) {
            menuDropdown?.classList.remove("active");
        }
    });
</script>
