<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Thanh toán thành công</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                padding: 50px;
                background-color: #f9f9f9;
            }

            .thankyou-box {
                border: 1px solid #ccc;
                padding: 30px;
                display: inline-block;
                border-radius: 10px;
                background-color: white;
            }

            h2 {
                color: green;
            }

            p {
                font-size: 18px;
                margin-top: 15px;
            }

            .action-btn {
                display: inline-block;
                margin-top: 25px;
                padding: 12px 25px;
                background-color: #007BFF;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                font-weight: bold;
            }

            .action-btn:hover {
                background-color: #0056b3;
            }

            #autoRedirect {
                margin-top: 20px;
                color: red;
                font-weight: bold;
            }
        </style>

        <script>
            let countdown = 30;

            function updateCountdown() {
                const countdownEl = document.getElementById("autoRedirect");
                countdownEl.innerText = "Bạn sẽ được chuyển về trang chủ sau " + countdown + " giây...";

                if (countdown > 0) {
                    countdown--;
                    setTimeout(updateCountdown, 1000);
                } else {
                    window.location.href = "<c:url value='/home' />";
                }
            }

            window.onload = function () {
                updateCountdown();
            }
        </script>
    </head>
    <body>
       
        <div class="thankyou-box">
            <h2>✅ Thanh toán thành công!</h2>
            <p>Cảm ơn bạn đã thanh toán. Đơn đặt phòng của bạn đã được ghi nhận.</p>

            <button onclick="window.location.href = '${pageContext.request.contextPath}/home/my-bookings ' ">
                Xem thông tin phòng đã đặt
            </button>


            <p id="autoRedirect"></p>
        </div>
    </body>
</html>
