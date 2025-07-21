<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Customer Detail - Admin</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 font-sans">
        <jsp:include page="/view/common/header_admin.jsp"/>

        <div class="max-w-5xl mx-auto p-6 bg-white rounded-xl shadow-lg mt-6">
            <h1 class="text-3xl font-bold mb-4">Customer Detail</h1>

            <c:if test="${not empty customer}">
                <div class="mb-6">
                    <p><strong>ID:</strong> ${customer.userId}</p>
                    <p><strong>Username:</strong> ${customer.username}</p>
                    <p><strong>Email:</strong> ${customer.email}</p>
                    <p><strong>Status:</strong> ${customer.status}</p>
                </div>
            </c:if>

            <h2 class="text-2xl font-semibold mb-3">Booking History</h2>
            <c:if test="${empty bookings}">
                <p class="text-gray-500">No booking history.</p>
            </c:if>
            <c:if test="${not empty bookings}">
                <table class="table-auto w-full border border-gray-300">
                    <thead class="bg-gray-100">
                        <tr>
                            <th class="border px-4 py-2">Booking ID</th>
                            <th class="border px-4 py-2">Room</th>
                            <th class="border px-4 py-2">Date</th>
                            <th class="border px-4 py-2">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td class="border px-4 py-2">${b.bookingId}</td>
                                <td class="border px-4 py-2">${b.room.roomName}</td>
                                <td class="border px-4 py-2">${b.bookingDate}</td>
                                <td class="border px-4 py-2">${b.status}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <div class="mt-6">
                <a href="${pageContext.request.contextPath}/admin/dashboard?tab=customer&page=1"
                   class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Back to Dashboard</a>
            </div>
        </div>

    </body>
</html>
