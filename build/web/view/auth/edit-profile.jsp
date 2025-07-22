<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserAccount" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
        return;
    }
    String role = user.getRoleId() != null ? user.getRoleId().getRoleName() : "";
    // Allow admin, host, customer, guest
    if (!"guest".equalsIgnoreCase(role) && !"customer".equalsIgnoreCase(role) && !"host".equalsIgnoreCase(role) && !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_home.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_header.css" />
    <style>
        .edit-profile-container {
            max-width: 500px;
            margin: 60px auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.10);
            padding: 32px 32px 24px 32px;
        }
        .edit-profile-container h2 {
            text-align: center;
            color: #2563eb;
            margin-bottom: 24px;
        }
        .edit-profile-tabs {
            display: flex;
            justify-content: center;
            margin-bottom: 24px;
        }
        .edit-profile-tab {
            padding: 10px 28px;
            border-radius: 8px 8px 0 0;
            background: #f3f6fa;
            color: #2563eb;
            font-weight: 600;
            cursor: pointer;
            margin: 0 2px;
            border: 1px solid #e5e7eb;
            border-bottom: none;
            transition: background 0.2s, color 0.2s;
        }
        .edit-profile-tab.active {
            background: #fff;
            color: #1d4ed8;
            border-bottom: 2px solid #fff;
        }
        .edit-profile-form {
            display: none;
        }
        .edit-profile-form.active {
            display: block;
        }
        .edit-profile-form label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        .edit-profile-form input[type="password"],
        .edit-profile-form input[type="file"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 16px;
            margin-bottom: 18px;
        }
        .edit-profile-form button {
            width: 100%;
            padding: 14px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .edit-profile-form button:hover {
            background: #1d4ed8;
        }
        .avatar-preview {
            display: flex !important;
            flex-direction: column !important;
            align-items: center !important;
        }
        .avatar-img-wrapper {
            position: relative !important;
            width: 68px !important;
            height: 68px !important;
            display: inline-block !important;
            border-radius: 50% !important;
            border: 2.5px solid #e5e7eb !important;
            background: #f8fafc !important;
            box-sizing: border-box !important;
            margin-bottom: 8px !important;
        }
        .avatar-img-wrapper img {
            width: 68px !important;
            height: 68px !important;
            border-radius: 50% !important;
            object-fit: cover !important;
            border: none !important;
            background: #f8fafc !important;
            display: block !important;
            cursor: pointer !important;
        }
        /* Remove avatar-modal and related styles */
        .delete-avatar-btn {
            position: absolute !important;
            top: 2px !important;
            right: 2px !important;
            width: 20px !important;
            height: 20px !important;
            padding: 0 !important;
            background: #fff !important;
            border: 1.5px solid #dc2626 !important;
            color: #dc2626 !important;
            border-radius: 50% !important;
            font-size: 1rem !important;
            line-height: 1 !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            z-index: 2 !important;
            transition: background 0.2s, color 0.2s !important;
            box-shadow: 0 1px 4px rgba(0,0,0,0.07) !important;
        }
        .delete-avatar-btn:hover {
            background: #dc2626 !important;
            color: #fff !important;
        }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp" />
<div class="edit-profile-container">
    <h2>Edit Profile</h2>
    <div class="edit-profile-tabs">
        <div class="edit-profile-tab active" id="tab-avatar">Update Avatar</div>
        <div class="edit-profile-tab" id="tab-password">Change Password</div>
    </div>
    <form class="edit-profile-form active" id="form-avatar" method="post" action="${pageContext.request.contextPath}/edit-profile" enctype="multipart/form-data">
        <div class="avatar-preview">
            <div class="avatar-img-wrapper">
                <c:choose>
                    <c:when test="${not empty user.avatarUrl}">
                        <img id="avatar-img-preview" src="${user.avatarUrl}" alt="Avatar" />
                        <button type="button" class="delete-avatar-btn" id="delete-avatar-btn" title="Delete avatar">&times;</button>
                    </c:when>
                    <c:otherwise>
                        <img id="avatar-img-preview" src="${pageContext.request.contextPath}/img/user.png" alt="Avatar" />
                    </c:otherwise>
                </c:choose>
            </div>
            <label for="avatar">Change Avatar</label>
            <input type="file" id="avatar" name="avatar" accept="image/*" />
            <input type="hidden" id="deleteAvatar" name="deleteAvatar" value="false" />
        </div>
        <button type="submit">Update Avatar</button>
    </form>
    <form class="edit-profile-form" id="form-password" method="post" action="${pageContext.request.contextPath}/edit-profile" enctype="multipart/form-data">
        <label for="currentPassword">Current Password</label>
        <input type="password" id="currentPassword" name="currentPassword" required />
        <label for="newPassword">New Password</label>
        <input type="password" id="newPassword" name="newPassword" required />
        <label for="confirmPassword">Confirm New Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword" required />
        <button type="submit">Change Password</button>
    </form>
</div>
<jsp:include page="../common/footer.jsp" />
<% if (request.getAttribute("avatarSuccess") != null) { %>
<script>alert("Đã update avatar thành công!");</script>
<% } %>
<% if (request.getAttribute("passwordSuccess") != null) { %>
<script>alert("Đã thay đổi mật khẩu thành công!");</script>
<% } %>
<% if (request.getAttribute("avatarDeleted") != null) { %>
<script>alert("Đã xoá avatar thành công!");</script>
<% } %>
<script>
    // Tab switching
    document.getElementById('tab-avatar').onclick = function() {
        document.getElementById('tab-avatar').classList.add('active');
        document.getElementById('tab-password').classList.remove('active');
        document.getElementById('form-avatar').classList.add('active');
        document.getElementById('form-password').classList.remove('active');
    };
    document.getElementById('tab-password').onclick = function() {
        document.getElementById('tab-password').classList.add('active');
        document.getElementById('tab-avatar').classList.remove('active');
        document.getElementById('form-password').classList.add('active');
        document.getElementById('form-avatar').classList.remove('active');
    };
    // Preview avatar before upload
    document.getElementById('avatar').onchange = function(e) {
        const [file] = e.target.files;
        if (file) {
            const url = URL.createObjectURL(file);
            document.getElementById('avatar-img-preview').src = url;
            document.getElementById('deleteAvatar').value = "false";
            // Hide delete button if preview is default
            setTimeout(function() {
                if (document.getElementById('avatar-img-preview').src.includes('/img/user.png')) {
                    document.getElementById('delete-avatar-btn').style.display = 'none';
                } else {
                    document.getElementById('delete-avatar-btn').style.display = 'flex';
                }
            }, 100);
        }
    };
    // Hide delete button if avatar is default on load
    window.addEventListener('DOMContentLoaded', function() {
        if (document.getElementById('avatar-img-preview').src.includes('/img/user.png')) {
            document.getElementById('delete-avatar-btn').style.display = 'none';
        } else {
            document.getElementById('delete-avatar-btn').style.display = 'flex';
        }
    });
    // Delete avatar button
    document.getElementById('delete-avatar-btn').onclick = function() {
        if (confirm('Are you sure you want to delete your avatar?')) {
            document.getElementById('avatar-img-preview').src = "${pageContext.request.contextPath}/img/user.png";
            document.getElementById('avatar').value = "";
            document.getElementById('deleteAvatar').value = "true";
            // Submit the form immediately
            document.getElementById('form-avatar').submit();
        }
    };
</script>
</body>
</html> 