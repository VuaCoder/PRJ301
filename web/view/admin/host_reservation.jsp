<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pending Host Applications</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
<jsp:include page="/view/common/header_admin.jsp"/>

<div class="max-w-5xl mx-auto p-6">
    <h1 class="text-2xl font-bold text-gray-800 mb-6">Pending Host Applications</h1>

    <c:if test="${empty pendingHosts}">
        <p class="text-gray-600">No pending host applications.</p>
    </c:if>

    <c:if test="${not empty pendingHosts}">
        <table class="table-auto w-full border border-gray-300 bg-white shadow rounded-lg">
            <thead class="bg-gray-200">
            <tr>
                <th class="px-4 py-2 border">ID</th>
                <th class="px-4 py-2 border">Username</th>
                <th class="px-4 py-2 border">Email</th>
                <th class="px-4 py-2 border">Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="host" items="${pendingHosts}">
                <tr class="hover:bg-gray-50">
                    <td class="border px-4 py-2">${host.userId}</td>
                    <td class="border px-4 py-2">${host.username}</td>
                    <td class="border px-4 py-2">${host.email}</td>
                    <td class="border px-4 py-2 flex gap-2">
                        <form method="post" action="${pageContext.request.contextPath}/admin/host-reservation">
                            <input type="hidden" name="id" value="${host.userId}">
                            <input type="hidden" name="action" value="approve">
                            <button class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600">Approve</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/admin/host-reservation">
                            <input type="hidden" name="id" value="${host.userId}">
                            <input type="hidden" name="action" value="reject">
                            <button class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600">Reject</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

</body>
</html>
