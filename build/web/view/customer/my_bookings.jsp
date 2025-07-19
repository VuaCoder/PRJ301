<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Phòng đã đặt</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 40px;
            background-color: #f2f2f2;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        .message {
            background-color: #d4edda;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 25px;
            color: #155724;
            border: 1px solid #c3e6cb;
            font-weight: bold;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 0 5px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px 15px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #007BFF;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .back-btn {
            margin-top: 30px;
            display: inline-block;
            padding: 10px 20px;
            background-color: #555;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        .back-btn:hover {
            background-color: #333;
        }

        .no-data {
            text-align: center;
            font-size: 18px;
            margin-top: 30px;
            color: #666;
        }
    </style>
</head>
<body>

    <h2>Danh sách phòng đã đặt</h2>

    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>

    <c:choose>
        <c:when test="${not empty bookings}">
            <table>
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Tên phòng</th>
                        <th>Ngày nhận</th>
                        <th>Ngày trả</th>
                        <th>Số khách</th>
                        <th>Giá</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="booking" items="${bookings}">
                        <tr>
                            <td>${booking.bookingId}</td>
                            <td>${booking.roomId.roomName}</td>
                            <td><fmt:formatDate value="${booking.checkinDate}" pattern="dd/MM/yyyy"/></td>
                            <td><fmt:formatDate value="${booking.checkoutDate}" pattern="dd/MM/yyyy"/></td>
                            <td>${booking.guests}</td>
                            <td><fmt:formatNumber value="${booking.totalPrice}" type="currency"/></td>
                            <td>${booking.status}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="no-data">Bạn chưa có đơn đặt phòng nào.</div>
        </c:otherwise>
    </c:choose>

    <a href="<c:url value='/home' />" class="back-btn">← Về trang chủ</a>

</body>
</html>
