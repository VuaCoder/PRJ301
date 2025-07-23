<%-- 
    Document   : header
    Created on : Jun 15, 2025, 1:31:39?PM
    Author     : quangminhnguyen
--%>
<%@page import="model.UserAccount"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    boolean isHost = user != null && user.getRoleId() != null && "host".equalsIgnoreCase(user.getRoleId().getRoleName());
    String uri = request.getRequestURI();
    boolean isHome = uri.endsWith("/home") || uri.endsWith("/home.jsp");
%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_header.css" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<div class="header<%= isHome ? " is-home-header" : "" %>">
    <div class="main-header">
        
        <div class="main-header-logo">
            <a href="${pageContext.request.contextPath}/home"><img class="site-logo" src="${pageContext.request.contextPath}/img/logo.png"></a>
        </div>
        <div class="main-header-option">
            <ul>
                <li><a href="#find-property-section">Find a Property</a></li>
                <li><a href="#rental-guides-section">Rental Guides</a></li>
                <li><a href="#download-mobile-app-section">Download Mobile App</a></li>
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
            <a href="#"><img src="<%= (user != null && user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) ? user.getAvatarUrl() : (request.getContextPath() + "/img/user.png") %>" alt="avatar" class="avatar" id="menuButton" style="left: 55px;top: 7px;"></a>
            <div id="menuDropdown" class="account-interface" >
                <ul class="account-menu">
                    <% if (user != null) { %>
                        <li style="font-weight: 600; color: #333; padding: 12px 16px; border-bottom: 1px solid #eee;">
                            Hello, <%= user.getFullName() != null ? user.getFullName() : user.getUsername() %>
                        </li>
                        
                        <%-- Chỉ hiển thị My Bookings cho guests/customers --%>
                        <% 
                            String userRole = user.getRoleId() != null ? user.getRoleId().getRoleName() : "";
                            boolean isGuest = "guest".equalsIgnoreCase(userRole) || "customer".equalsIgnoreCase(userRole);
                        %>
                        <% if (isGuest) { %>
                        <li>
                            <a href="${pageContext.request.contextPath}/my-bookings" style="display: block; padding: 12px 16px; color: #333; text-decoration: none; transition: background-color 0.2s;">
                                <i class="fas fa-calendar-alt" style="margin-right: 8px; width: 16px;"></i> 
                                My Bookings
                            </a>
                        </li>
                        <% } %>
                        
                        <% if (isHost) { %>
                        <li>
                            <a href="${pageContext.request.contextPath}/host/manage-bookings" style="display: block; padding: 12px 16px; color: #333; text-decoration: none; transition: background-color 0.2s;">
                                <i class="fas fa-tasks" style="margin-right: 8px; width: 16px;"></i> 
                                Manage Bookings
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/host/dashboard" style="display: block; padding: 12px 16px; color: #333; text-decoration: none; transition: background-color 0.2s;">
                                <i class="fas fa-chart-line" style="margin-right: 8px; width: 16px;"></i> 
                                Dashboard
                            </a>
                        </li>
                        <% } %>
                        
                        <% if (isGuest || isHost) { %>
                        <li>
                            <a href="${pageContext.request.contextPath}/view/auth/edit-profile.jsp" style="display: block; padding: 12px 16px; color: #333; text-decoration: none; transition: background-color 0.2s;">
                                <i class="fas fa-user-edit" style="margin-right: 8px; width: 16px;"></i> 
                                Edit Profile
                            </a>
                        </li>
                        <% } %>
                        
                        <li>
                            <a href="${pageContext.request.contextPath}/logout" style="display: block; padding: 12px 16px; color: #dc2626; text-decoration: none; transition: background-color 0.2s;">
                                <i class="fas fa-sign-out-alt" style="margin-right: 8px; width: 16px;"></i> 
                                Logout
                            </a>
                        </li>
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
                    <% } %>
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
