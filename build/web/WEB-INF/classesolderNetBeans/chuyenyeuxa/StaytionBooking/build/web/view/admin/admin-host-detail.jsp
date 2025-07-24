<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Thông tin chủ phòng - Staytion</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 font-sans">
        <jsp:include page="/view/common/header_admin.jsp"/>

        <div class="max-w-5xl mx-auto p-6">
            <h1 class="text-3xl font-bold mb-4">Thông tin chủ phòng</h1>

            <c:if test="${empty hostAccount}">
                <p class="text-red-500">Không tìm thấy host nào!</p>
            </c:if>

            <c:if test="${not empty hostAccount}">
                <div class="bg-white p-6 rounded-xl shadow-lg border mb-8">
                    <p><strong>ID:</strong> ${hostAccount.userId}</p>
                    <p><strong>Username:</strong> ${hostAccount.username}</p>
                    <p><strong>Email:</strong> ${hostAccount.email}</p>
                    <p><strong>Status:</strong> ${hostAccount.status}</p>
                </div>

                <h2 class="text-2xl font-bold mb-4">Phòng</h2>
                <c:if test="${empty roomStats}">
                    <p class="text-gray-500">Không tìm thấy phòng nào.</p>
                </c:if>
                <c:if test="${not empty roomStats}">
                    <table class="table-auto w-full border border-gray-300 text-left">
                        <thead class="bg-gray-100">
                            <tr>
                                <th class="border px-4 py-2">Tên phòng</th>
                                <th class="border px-4 py-2">Đặt vào</th>
                                <th class="border px-4 py-2">Lợi nhuận</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="rs" items="${roomStats}">
                                <tr>
                                    <td class="border px-4 py-2">${rs.roomName}</td>
                                    <td class="border px-4 py-2">${rs.bookingCount}</td>
                                    <td class="border px-4 py-2">${rs.totalRevenue}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <h2 class="text-2xl font-bold mt-8 mb-4">Lịch sử đặt phòng của host</h2>
                <c:if test="${empty bookings}">
                    <p class="text-gray-500">Chưa có lịch sử đặt phòng nào.</p>
                </c:if>
                <c:if test="${not empty bookings}">
                    <table class="table-auto w-full border border-gray-300 text-left">
                        <thead class="bg-gray-100">
                            <tr>
                                <th class="border px-4 py-2">ID</th>
                                <th class="border px-4 py-2">Khách hàng</th>
                                <th class="border px-4 py-2">Phòng</th>
                                <th class="border px-4 py-2">Ngày nhận</th>
                                <th class="border px-4 py-2">Ngày trả</th>
                                <th class="border px-4 py-2">Tổng tiền</th>
                                <th class="border px-4 py-2">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td class="border px-4 py-2">${b.bookingId}</td>
                                    <td class="border px-4 py-2">${b.customerId.userId.username}</td>
                                    <td class="border px-4 py-2">${b.roomId.title}</td>
                                    <td class="border px-4 py-2">${b.checkinDate}</td>
                                    <td class="border px-4 py-2">${b.checkoutDate}</td>
                                    <td class="border px-4 py-2">${b.totalPrice}</td>
                                    <td class="border px-4 py-2">${b.status}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </c:if>

            <div class="mt-6">
                <a href="${pageContext.request.contextPath}/admin/dashboard?tab=host"
                   class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Quay lại trang chinh</a>
            </div>
        </div>

    </body>
</html>
