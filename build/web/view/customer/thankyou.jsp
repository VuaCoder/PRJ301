<%@page import="model.UserAccount"%>
<%@page import="service.MailSender"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    String emailStatus = "sending";
    String emailMessage = "Đang gửi email xác nhận...";
    
    // Gửi email trực tiếp trong JSP
    if (user != null && user.getEmail() != null) {
        try {
            MailSender.sendPaymentConfirmation(user.getEmail(), user.getUsername());
            emailStatus = "success";
            emailMessage = "Email xác nhận đã được gửi thành công!";
            System.out.println("✅ Email sent to: " + user.getEmail());
        } catch (Exception e) {
            emailStatus = "error";
            emailMessage = "Lỗi gửi email: " + e.getMessage();
            System.err.println("❌ Email error: " + e.getMessage());
            e.printStackTrace();
        }
    } else {
        emailStatus = "error";
        emailMessage = "Không tìm thấy thông tin email";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Thanh toán thành công</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; background-color: #f9f9f9; }
        .thankyou-box { border: 1px solid #ccc; padding: 30px; display: inline-block; border-radius: 10px; background-color: white; }
        h2 { color: green; }
        p { font-size: 18px; margin-top: 15px; }
        .action-btn { margin-top: 40px; padding: 12px 25px; background-color: #007BFF; color: white; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .action-btn:hover { background-color: #0056b3; }
        #autoRedirect { margin-top: 20px; color: red; font-weight: bold; }
        .email-status { margin-top: 15px; padding: 10px; border-radius: 5px; font-size: 14px; }
        .email-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .email-sending { background-color: #fff3cd; color: #856404; border: 1px solid #ffeaa7; }
        .email-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>

    <script>
        let countdown = 30;

        function updateCountdown() {
            const el = document.getElementById("autoRedirect");
            el.innerText = "Bạn sẽ được chuyển về trang chủ sau " + countdown + " giây...";
            if (countdown > 0) {
                countdown--;
                setTimeout(updateCountdown, 1000);
            } else {
                window.location.href = "<c:url value='/home' />";
            }
        }

        window.onload = function() {
            console.log("🚀 Thank you page loaded");
            updateCountdown();
        };
    </script>
</head>
<body>
    <div class="thankyou-box">
        <h2>✅ Thanh toán thành công!</h2>
        <p>Cảm ơn bạn, <strong>${user.username}</strong>, đã thanh toán.</p>
        
        <!-- Hiển thị trạng thái email -->
        <div id="email-status" class="email-status email-<%=emailStatus%>">
            <% if ("success".equals(emailStatus)) { %>
                ✅ <%=emailMessage%>
            <% } else if ("error".equals(emailStatus)) { %>
                ⚠️ <%=emailMessage%>
            <% } else { %>
                📧 <%=emailMessage%>
            <% } %>
        </div>

        <a class="action-btn" href="<c:url value='/view/customer/my-bookings.jsp' />">Xem phòng đã đặt</a>
        <p id="autoRedirect"></p>
    </div>

    <!-- DEBUG INFO - chỉ hiện nếu có lỗi -->
    <% if ("error".equals(emailStatus)) { %>
    <div style="position: fixed; top: 20px; right: 20px; background: #000; color: #fff; padding: 15px; border: 2px solid #ff0000; border-radius: 8px; font-family: monospace; z-index: 9999;">
        <div style="color: #ff0000; font-weight: bold; margin-bottom: 10px;">❌ EMAIL ERROR</div>
        <div>User Email: <span style="color: #ffff00;">${user.email}</span></div>
        <div>Error: <span style="color: #ff6666;"><%=emailMessage%></span></div>
        <button onclick="this.parentElement.remove()" style="margin-top: 10px; padding: 5px 10px; background: red; color: white; border: none; border-radius: 3px; cursor: pointer;">Ẩn</button>
    </div>
    <% } %>
</body>
</html>