<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    // Tạo mã ngẫu nhiên cho nội dung chuyển khoản
    String randomCode = "TP" + (int)(Math.random() * 90000 + 10000); // ví dụ: TP48329
    request.setAttribute("paymentCode", randomCode);
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Thanh toán bằng VietQR</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                padding: 50px;
            }

            .qr-box {
                border: 1px solid #ccc;
                padding: 20px;
                display: inline-block;
                border-radius: 10px;
            }

            img {
                width: 250px;
                height: auto;
                margin-top: 20px;
            }

            .info {
                margin-top: 20px;
                font-size: 18px;
            }

            .back-btn, .booking-btn {
                display: inline-block;
                margin-top: 20px;
                margin-right: 10px;
                padding: 10px 20px;
                background-color: #333;
                color: white;
                text-decoration: none;
                border-radius: 5px;
            }

            .back-btn:hover, .booking-btn:hover {
                background-color: #555;
            }

            #countdown {
                color: red;
                font-size: 18px;
                margin-top: 15px;
                font-weight: bold;
            }
        </style>

        <script>
            let countdown = 180;
            const amount = ${room.price};  // lấy từ server
            const keyword = "<c:out value='ThanhToanPhong${paymentCode}' />"; // nội dung chuyển khoản riêng biệt
            const checkUrl = "https://script.google.com/macros/s/AKfycbxwQ3Czl0IQ0KHvI5-7yY9YE-Zx7FuyHVrLrg64A8h6JDAluz9rN9dFyuZ5Aj56PjyLAA/exec"; // API Google Sheet

            function updateTimer() {
                const timerDisplay = document.getElementById("countdown");
                timerDisplay.innerText = "Tự động kiểm tra thanh toán trong: " + countdown + " giây";

                if (countdown > 0) {
                    countdown--;
                    setTimeout(updateTimer, 1000);
                } else {
                    window.location.href = "<c:url value='/home' />";
                }
            }

            async function checkPayment() {
                try {
                    const res = await fetch(checkUrl);
                    const json = await res.json();

                    for (const tx of json.data) {
                        const txAmount = parseInt(tx["PRICE"]);
                        const txContent = (tx["CONTENT"] || "").trim();

                        if (txContent.includes(keyword) && txAmount === amount) {
                            // Giao dịch hợp lệ
                           window.location.href = "<c:url value='/thankyou' />";

                            return;
                        }
                    }

                    // Nếu chưa có, thử lại sau 3s
                    setTimeout(checkPayment, 3000);

                } catch (e) {
                    console.error("Lỗi khi kiểm tra thanh toán:", e);
                    setTimeout(checkPayment, 3000);
                }
            }

            window.onload = function () {
                updateTimer();
                checkPayment();
            };
        </script>
    </head>
    <body>
        <div class="qr-box">
            <h2>Thanh toán bằng VietQR</h2>

            <div class="info">
                <p><strong>Người nhận:</strong> DO VAN THANH CONG</p>
                <p><strong>Số tài khoản:</strong> 0775578504 (MB Bank)</p>

                <c:choose>
                    <c:when test="${room.price < 1000000}">
                        <c:set var="convertedPrice" value="${(room.price - (room.price % 1000))}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="convertedPrice" value="${(room.price - (room.price % 1000000))}" />
                    </c:otherwise>
                </c:choose>

                <p><strong>Số tiền:</strong>
                    <fmt:formatNumber value="${convertedPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ
                </p>

                <p><strong>Nội dung chuyển khoản:</strong> ThanhToanPhong${paymentCode}</p>
            </div>

            <img src="https://img.vietqr.io/image/MB-0775578504-compact2.png?amount=${room.price}&addInfo=ThanhToanPhong${paymentCode}&accountName=DO%20VAN%20THANH%20CONG"
                 alt="QR Code VietQR">

            <p>Vui lòng mở app ngân hàng để quét mã</p>

            <div id="countdown"></div>

            <a href="<c:url value='/home' />" class="back-btn">← Quay lại trang chủ</a>
           
        </div>
    </body>
</html>
