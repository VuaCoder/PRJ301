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
        body {
            font-family: 'Noto Sans', Arial, sans-serif;
            text-align: center;
            padding: 0;
            margin: 0;
            min-height: 100vh;
            background: linear-gradient(135deg, #f9fafc 0%, #e3e9f7 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .thankyou-box {
            border: none;
            padding: 48px 36px 40px 36px;
            display: flex;
            flex-direction: column;
            align-items: center;
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 8px 32px rgba(44,62,80,0.13);
            min-width: 340px;
            max-width: 95vw;
            margin: 0 auto;
        }
        h2 {
            color: #21b573;
            font-size: 2.2rem;
            margin-bottom: 10px;
            font-weight: 800;
            letter-spacing: 1px;
        }
        p {
            font-size: 1.18rem;
            margin-top: 18px;
            color: #333;
            line-height: 1.6;
        }
        .action-btn {
            margin-top: 38px;
            padding: 14px 38px;
            background: linear-gradient(90deg, #1976d2 0%, #21b6f6 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 700;
            font-size: 1.1rem;
            box-shadow: 0 2px 12px rgba(33,182,246,0.10);
            transition: background 0.2s, box-shadow 0.2s, transform 0.13s;
            display: inline-block;
        }
        .action-btn:hover {
            background: linear-gradient(90deg, #1565c0 0%, #1e88e5 100%);
            box-shadow: 0 4px 16px rgba(33,182,246,0.15);
            transform: translateY(-2px) scale(1.03);
        }
        #autoRedirect {
            margin-top: 22px;
            color: #e74c3c;
            font-weight: 700;
            font-size: 1.05rem;
        }
        .email-status {
            margin-top: 18px;
            padding: 12px 18px;
            border-radius: 7px;
            font-size: 1rem;
            width: 100%;
            max-width: 420px;
            box-sizing: border-box;
            text-align: center;
        }
        .email-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .email-sending {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        .email-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        @media (max-width: 600px) {
            .thankyou-box {
                padding: 24px 8vw 24px 8vw;
                min-width: unset;
                max-width: 99vw;
            }
            h2 { font-size: 1.4rem; }
            p { font-size: 1rem; }
            .action-btn { padding: 12px 18px; font-size: 1rem; }
        }
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

        <a class="action-btn" href="<c:url value='/my-bookings' />">Xem phòng đã đặt</a>
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