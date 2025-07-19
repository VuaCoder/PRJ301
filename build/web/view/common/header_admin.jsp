<%@page import="model.UserAccount"%>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    boolean isAdmin = user != null && user.getRoleId() != null && "admin".equalsIgnoreCase(user.getRoleId().getRoleName());

%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    .header {
        display: flex;
        justify-content: center; /* logo gi?a */
        align-items: center;
        position: relative;
        height: 80px;
        border-bottom: 1px solid #e5e5e5;
        background: #fff;
        padding: 0 20px;
    }
    .main-header-logo img {
        max-height: 100px; /* gi? t? l? ??p */
        width: auto;
        object-fit: contain;
    }
    .account-container {
        position: absolute;
        right: 20px;
        display: flex;
        align-items: center;
        gap: 16px;
        background: #f5f6f8;
        padding: 8px 16px;
        border-radius: 20px;
    }
    .hamburger {
        width: 28px;
        height: 28px;
        object-fit: contain;
        cursor: pointer;
    }
    .avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
        cursor: pointer;
    }
    .account-interface {
        display: none;
        position: absolute;
        right: 0;
        top: 70px;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        min-width: 180px;
        z-index: 9999;
    }
    .account-interface.active {
        display: block;
    }
    .account-menu {
        list-style: none;
        margin: 0;
        padding: 10px 0;
    }
    .account-menu li {
        padding: 10px 16px;
        font-size: 14px;
        cursor: pointer;
    }
    .account-menu li a {
        text-decoration: none;
        color: #333;
        display: block;
    }
    .account-menu li a:hover {
        background: #f3f3f3;
    }
</style>

<div class="header">
    <!-- Logo chính gi?a -->
    <div class="main-header-logo">
        <a href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/img/logo.png" alt="Staytion Logo">
        </a>
    </div>

    <!-- Avatar + Hamburger bên ph?i -->
    <div class="account-container">
        <img src="${pageContext.request.contextPath}/img/hamburger-lines.png" alt="Menu" class="hamburger" id="menuToggle">
        <img src="${pageContext.request.contextPath}/img/user.png" alt="Avatar" class="avatar" id="menuButton">

        <!-- Dropdown -->
        <div id="menuDropdown" class="account-interface">
            <ul class="account-menu">
                <% if (user != null) {%>
                <li>Hi, <%= user.getFullName()%></li>
                <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                    <% } else { %>
                <li><a href="${pageContext.request.contextPath}/view/auth/register.jsp">Sign Up</a></li>
                <li><a href="${pageContext.request.contextPath}/view/auth/login.jsp">Login</a></li>
                    <% }%>
            </ul>
        </div>
    </div>
</div>

<script>
    const menuButton = document.getElementById("menuButton");
    const menuToggle = document.getElementById("menuToggle");
    const menuDropdown = document.getElementById("menuDropdown");

    [menuButton, menuToggle].forEach(btn => {
        btn.addEventListener("click", (e) => {
            e.stopPropagation();
            menuDropdown.classList.toggle("active");
        });
    });

    document.addEventListener("click", (e) => {
        if (!menuButton.contains(e.target) && !menuDropdown.contains(e.target) && !menuToggle.contains(e.target)) {
            menuDropdown.classList.remove("active");
        }
    });
</script>
