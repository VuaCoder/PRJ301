<%@page import="model.UserAccount"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Staytion</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    </head>
    <body class="bg-gray-50 font-sans">

        <jsp:include page="/view/common/header_admin.jsp" />

        <div class="max-w-7xl mx-auto p-6">

            <!-- Header -->
            <div class="bg-gradient-to-r from-blue-600 via-purple-600 to-indigo-600 text-white p-8 rounded-xl shadow-lg mb-8">
                <div class="flex justify-between items-center">
                    <div>
                        <h1 class="text-3xl font-bold mb-2">Admin Dashboard</h1>
                        <p class="text-lg opacity-90">User Management</p>
                    </div>
                </div>
            </div>

            <!-- Stats -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">

                <!-- Total Account -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-blue-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-users text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold text-gray-800">
                                <c:out value="${fn:length(users)}"/>
                            </h3>
                            <p class="text-gray-600">Total Account</p>
                        </div>
                    </div>
                </div>

                <!-- Active Users -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-green-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-check-circle text-xl"></i>
                        </div>
                        <div>
                            <c:set var="activeCount" value="0" scope="page"/>
                            <c:forEach var="u" items="${users}">
                                <c:if test="${u.status eq 'Active'}">
                                    <c:set var="activeCount" value="${activeCount + 1}" scope="page"/>
                                </c:if>
                            </c:forEach>
                            <h3 class="text-2xl font-bold text-gray-800">${activeCount}</h3>
                            <p class="text-gray-600">Active Users</p>
                        </div>
                    </div>
                </div>

                <!-- Pending Host Apply -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-yellow-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-user-check text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-xl font-bold text-blue-600">
                                <!-- ĐIỀU CHỈNH LINK -->
                                <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=host" class="hover:underline">
                                    Pending Host Apply
                                </a>
                            </h3>
                            <p class="text-gray-600 mt-1">
                                <c:choose>
                                    <c:when test="${pendingHostCount gt 0}">
                                        <span class="bg-red-500 text-white px-2 py-1 rounded-full text-sm">
                                            ${pendingHostCount}
                                        </span>
                                    </c:when>
                                    <c:otherwise>No pending</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Pending Room -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-purple-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-bed text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-xl font-bold text-blue-600">
                                <!-- ĐIỀU CHỈNH LINK -->
                                <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=room" class="hover:underline">
                                    Pending Room
                                </a>
                            </h3>
                            <p class="text-gray-600 mt-1">
                                <c:choose>
                                    <c:when test="${pendingRoomsCount gt 0}">
                                        <span class="bg-red-500 text-white px-2 py-1 rounded-full text-sm">
                                            ${pendingRoomsCount}
                                        </span>
                                    </c:when>
                                    <c:otherwise>No pending</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>

            </div>

            <!-- User Management Table -->
            <div class="bg-white p-6 rounded-xl shadow-lg border">
                <h2 class="text-2xl font-bold mb-4 text-gray-800">User Accounts</h2>
                <table class="table-auto w-full border-collapse border border-gray-300 text-left">
                    <thead class="bg-gray-100">
                        <tr>
                            <th class="border border-gray-300 px-4 py-2">ID</th>
                            <th class="border border-gray-300 px-4 py-2">Username</th>
                            <th class="border border-gray-300 px-4 py-2">Email</th>
                            <th class="border border-gray-300 px-4 py-2">Phone</th>
                            <th class="border border-gray-300 px-4 py-2">Role</th>
                            <th class="border border-gray-300 px-4 py-2">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="usr" items="${users}">
                            <c:set var="roleName" value="Unknown" />
                            <c:set var="roleClass" value="bg-gray-100 text-gray-800" />
                            <c:choose>
                                <c:when test="${usr.roleId.roleId == 1}">
                                    <c:set var="roleName" value="Customer" />
                                    <c:set var="roleClass" value="bg-blue-100 text-blue-800" />
                                </c:when>
                                <c:when test="${usr.roleId.roleId == 2}">
                                    <c:set var="roleName" value="Host" />
                                    <c:set var="roleClass" value="bg-green-100 text-green-800" />
                                </c:when>
                                <c:when test="${usr.roleId.roleId == 3}">
                                    <c:set var="roleName" value="Admin" />
                                    <c:set var="roleClass" value="bg-purple-100 text-purple-800" />
                                </c:when>
                            </c:choose>
                            <tr class="hover:bg-gray-50">
                                <td class="border border-gray-300 px-4 py-2">${usr.userId}</td>
                                <td class="border border-gray-300 px-4 py-2">${usr.username}</td>
                                <td class="border border-gray-300 px-4 py-2">${usr.email}</td>
                                <td class="border border-gray-300 px-4 py-2">${usr.phone}</td>
                                <td class="border border-gray-300 px-4 py-2">
                                    <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="inline">
                                        <input type="hidden" name="action" value="updateRole" />
                                        <input type="hidden" name="id" value="${usr.userId}" />
                                        <select name="roleId"
                                                onchange="if (confirm('Bạn có chắc muốn đổi role của user này không?')) {
                                                            this.form.submit();
                                                        } else {
                                                            this.value = '${usr.roleId.roleId}';
                                                        }"
                                                class="border rounded px-2 py-1 focus:outline-none focus:ring-2 focus:ring-purple-500">
                                            <option value="1" ${usr.roleId.roleId == 1 ? 'selected' : ''}>Customer</option>
                                            <option value="2" ${usr.roleId.roleId == 2 ? 'selected' : ''}>Host</option>
                                            <option value="3" ${usr.roleId.roleId == 3 ? 'selected' : ''}>Admin</option>
                                        </select>
                                    </form>
                                </td>

                                <td class="border border-gray-300 px-4 py-2">
                                    <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="inline">
                                        <input type="hidden" name="action" value="updateStatus" />
                                        <input type="hidden" name="id" value="${usr.userId}" />
                                        <select name="status" onchange="this.form.submit()" 
                                                class="border rounded px-2 py-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
                                            <option value="Active"   ${usr.status == 'Active'   ? 'selected' : ''}>Active</option>
                                            <option value="Inactive" ${usr.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

        </div>
    </body>
</html>
