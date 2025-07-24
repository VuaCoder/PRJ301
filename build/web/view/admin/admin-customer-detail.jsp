<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="/view/common/header_admin.jsp"/>

<style>
    body {
        background: #f4f6f9;
        font-family: "Segoe UI", Tahoma, sans-serif;
        color: #333;
    }
    .container {
        max-width: 1100px;
        margin: 30px auto;
        background: #fff;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    h2, h3 {
        margin-bottom: 10px;
        color: #444;
        border-bottom: 2px solid #007bff;
        padding-bottom: 5px;
    }
    .info p {
        margin: 4px 0;
        font-size: 15px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
        font-size: 14px;
        background: #fff;
    }
    table thead {
        background: #007bff;
        color: #fff;
    }
    table th, table td {
        padding: 10px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    table tr:nth-child(even) {
        background-color: #f9f9f9;
    }
    .pagination {
        margin-top: 20px;
        text-align: center;
    }
    .pagination a, .pagination span {
        display: inline-block;
        margin: 0 5px;
        padding: 6px 12px;
        text-decoration: none;
        color: #007bff;
        border: 1px solid #ddd;
        border-radius: 4px;
        transition: 0.3s;
    }
    .pagination a:hover {
        background-color: #007bff;
        color: #fff;
    }
    .pagination span {
        font-weight: bold;
        background-color: #007bff;
        color: #fff;
    }
    ul.review-list {
        margin: 0;
        padding-left: 16px;
    }
    ul.review-list li {
        list-style: disc;
        margin-bottom: 2px;
    }
</style>

<div class="container">
    <h2>Chi tiết khách hàng</h2>
    <div class="info">
        <p><b>ID:</b> ${customer.userId.userId}</p>
        <p><b>Tên:</b> ${customer.userId.fullName}</p>
        <p><b>Email:</b> ${customer.userId.email}</p>
    </div>

    <h3>Lịch sử Booking</h3>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Phòng</th>
                <th>Check-in</th>
                <th>Check-out</th>
                <th>Trạng thái</th>
                <th>Đánh giá</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="b" items="${bookings}">
                <tr>
                    <td>${b.bookingId}</td>
                    <td>${b.roomId.title}</td>
                    <td><fmt:formatDate value="${b.checkinDate}" pattern="dd/MM/yyyy"/></td>
                    <td><fmt:formatDate value="${b.checkoutDate}" pattern="dd/MM/yyyy"/></td>
                    <td>${b.status}</td>
                    <td>
                        <c:if test="${not empty b.reviewList}">
                            <ul class="review-list">
                                <c:forEach var="rv" items="${b.reviewList}">
                                    <li>${rv.rating}★ - ${rv.comment}</li>
                                    </c:forEach>
                            </ul>
                        </c:if>
                        <c:if test="${empty b.reviewList}">
                            <i>Chưa có đánh giá</i>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty bookings}">
                <tr><td colspan="6" style="text-align:center">Không có booking</td></tr>
            </c:if>
        </tbody>
    </table>

    <div class="pagination">
        <c:forEach var="i" begin="1" end="${totalPages}">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <span>${i}</span>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/admin/admin-customer-detail?customerId=${customer.customerId}&page=${i}">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>
</div>

<jsp:include page="/view/common/footer.jsp"/>
