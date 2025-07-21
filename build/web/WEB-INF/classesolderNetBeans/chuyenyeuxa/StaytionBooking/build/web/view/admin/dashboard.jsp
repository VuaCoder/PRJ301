<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Staytion</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 font-sans">
        <jsp:include page="/view/common/header_admin.jsp"/>

        <div class="max-w-7xl mx-auto p-6">

            <!-- Banner -->
            <div class="bg-gradient-to-r from-blue-600 via-indigo-500 to-purple-500 text-white p-8 rounded-xl shadow-lg mb-8">
                <h1 class="text-3xl font-bold mb-2">Admin Dashboard</h1>
                <p class="opacity-90">Manage users, hosts, and rooms.</p>
            </div>

            <!-- Stats -->
            <div class="grid grid-cols-4 gap-6 mb-8">
                <!-- Total Accounts -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-blue-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-users text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-xl font-bold">Total Account</h3>
                            <p class="text-gray-600 mt-1">
                                <span class="font-semibold text-lg">${totalAccounts}</span>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Active Users -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-green-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-user-check text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-xl font-bold">Active Users</h3>
                            <p class="text-gray-600 mt-1">
                                <span class="font-semibold text-lg">${activeUsers}</span>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Pending Requests -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-yellow-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-clock text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-xl font-bold text-blue-600">
                                <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=host" class="hover:underline">
                                    Pending Requests
                                </a>
                            </h3>
                            <p class="text-gray-600 mt-1">
                                <c:set var="totalPending" value="${pendingHostCount + pendingRoomsCount}" />
                                <c:choose>
                                    <c:when test="${totalPending gt 0}">
                                        <span class="bg-red-500 text-white px-2 py-1 rounded-full text-sm">
                                            ${totalPending} requests
                                        </span>
                                    </c:when>
                                    <c:otherwise>No pending</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- All Rooms -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-blue-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-home text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-xl font-bold text-blue-600">
                                <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=allRooms" class="hover:underline">
                                    All Rooms
                                </a>
                            </h3>
                            <p class="text-gray-600 mt-1">
                                <c:choose>
                                    <c:when test="${allRoomsCount gt 0}">
                                        <span class="bg-green-500 text-white px-2 py-1 rounded-full text-sm">
                                            ${allRoomsCount} rooms
                                        </span>
                                    </c:when>
                                    <c:otherwise>No rooms</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ==== TABS ==== -->
            <div class="mb-6 flex space-x-4">
                <a href="${pageContext.request.contextPath}/admin/dashboard?tab=customer&page=1"
                   class="px-4 py-2 rounded-lg text-white font-semibold
                   ${tab eq 'customer' ? 'bg-blue-600' : 'bg-gray-400 hover:bg-gray-500'}">
                    Customer Accounts
                    <c:if test="${totalCustomerCount gt 0}">
                        <span class="ml-2 bg-white text-blue-600 px-2 py-0.5 rounded-full text-xs font-bold">
                            ${totalCustomerCount}
                        </span>
                    </c:if>
                </a>

                <a href="${pageContext.request.contextPath}/admin/dashboard?tab=host&page=1"
                   class="px-4 py-2 rounded-lg text-white font-semibold
                   ${tab eq 'host' ? 'bg-green-600' : 'bg-gray-400 hover:bg-gray-500'}">
                    Host Accounts
                    <c:if test="${totalHostCount gt 0}">
                        <span class="ml-2 bg-white text-green-600 px-2 py-0.5 rounded-full text-xs font-bold">
                            ${totalHostCount}
                        </span>
                    </c:if>
                </a>
            </div>

            <!-- ==== CUSTOMER TABLE ==== -->
            <c:if test="${tab eq 'customer'}">
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <h2 class="text-2xl font-bold mb-4">Customer Accounts</h2>
                    <c:if test="${empty customers}">
                        <div class="text-center text-gray-500 py-6">No customer accounts</div>
                    </c:if>
                    <c:if test="${not empty customers}">
                        <table class="table-auto w-full border border-gray-300 text-left">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="border px-4 py-2">ID</th>
                                    <th class="border px-4 py-2">Username</th>
                                    <th class="border px-4 py-2">Email</th>
                                    <th class="border px-4 py-2">Status</th>
                                    <th class="border px-4 py-2">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cst" items="${customers}">
                                    <tr class="hover:bg-gray-50">
                                        <td class="border px-4 py-2">${cst.userId}</td>
                                        <td class="border px-4 py-2">${cst.username}</td>
                                        <td class="border px-4 py-2">${cst.email}</td>
                                        <td class="border border-gray-300 px-4 py-2">
                                            <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="inline">
                                                <input type="hidden" name="action" value="updateStatus" />
                                                <input type="hidden" name="id" value="${cst.userId}" />
                                                <input type="hidden" name="tab" value="customer" />
                                                <input type="hidden" name="page" value="${currentPage}" />
                                                <select name="status" onchange="this.form.submit()"
                                                        class="border rounded px-2 py-1 focus:outline-none focus:ring-2 focus:ring-blue-500">
                                                    <option value="Active"   ${cst.status == 'Active'   ? 'selected' : ''}>Active</option>
                                                    <option value="Inactive" ${cst.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </form>
                                        </td>
                                        <td class="border px-4 py-2 space-x-2">
                                            <a href="${pageContext.request.contextPath}/admin/admin-customer-detail?customerId=${cst.userId}"
                                               class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600">View</a>


                                            <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" style="display:inline;"
                                                  onsubmit="return confirm('Are you sure you want to delete this customer?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${cst.userId}">
                                                <input type="hidden" name="tab" value="customer">
                                                <input type="hidden" name="page" value="${currentPage}">
                                                <button type="submit"
                                                        class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Pagination -->
                        <div class="flex justify-center mt-4">
                            <c:forEach begin="1" end="${totalCustomerPages}" var="p">
                                <a href="${pageContext.request.contextPath}/admin/dashboard?tab=customer&page=${p}"
                                   class="mx-1 px-3 py-1 rounded border
                                   ${currentPage eq p ? 'bg-blue-600 text-white' : 'bg-gray-100 hover:bg-gray-200'}">${p}</a>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </c:if>

            <!-- ==== HOST TABLE ==== -->
            <c:if test="${tab ne 'customer'}">
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <h2 class="text-2xl font-bold mb-4">Host Accounts</h2>
                    <c:if test="${empty hosts}">
                        <div class="text-center text-gray-500 py-6">No host accounts</div>
                    </c:if>
                    <c:if test="${not empty hosts}">
                        <table class="table-auto w-full border border-gray-300 text-left">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="border px-4 py-2">ID</th>
                                    <th class="border px-4 py-2">Username</th>
                                    <th class="border px-4 py-2">Email</th>
                                    <th class="border px-4 py-2">Status</th>
                                    <th class="border px-4 py-2">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="hst" items="${hosts}">
                                    <tr class="hover:bg-gray-50">
                                        <td class="border px-4 py-2">${hst.userId}</td>
                                        <td class="border px-4 py-2">${hst.username}</td>
                                        <td class="border px-4 py-2">${hst.email}</td>
                                        <td class="border border-gray-300 px-4 py-2">
                                            <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="inline">
                                                <input type="hidden" name="action" value="updateStatus" />
                                                <input type="hidden" name="id" value="${hst.userId}" />
                                                <input type="hidden" name="tab" value="host" />
                                                <input type="hidden" name="page" value="${currentPage}" />
                                                <select name="status" onchange="this.form.submit()"
                                                        class="border rounded px-2 py-1 focus:outline-none focus:ring-2 focus:ring-green-500">
                                                    <option value="Active"   ${hst.status == 'Active'   ? 'selected' : ''}>Active</option>
                                                    <option value="Inactive" ${hst.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </form>
                                        </td>
                                        <td class="border px-4 py-2 space-x-2">
                                            <a href="${pageContext.request.contextPath}/admin/admin-host-detail?userId=${hst.userId}"
                                               class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600">View</a>

                                            <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" style="display:inline;"
                                                  onsubmit="return confirm('Are you sure you want to delete this host?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${hst.userId}">
                                                <input type="hidden" name="tab" value="host">
                                                <input type="hidden" name="page" value="${currentPage}">
                                                <button type="submit"
                                                        class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Pagination -->
                        <div class="flex justify-center mt-4">
                            <c:forEach begin="1" end="${totalHostPages}" var="p">
                                <a href="${pageContext.request.contextPath}/admin/dashboard?tab=host&page=${p}"
                                   class="mx-1 px-3 py-1 rounded border
                                   ${currentPage eq p ? 'bg-green-600 text-white' : 'bg-gray-100 hover:bg-gray-200'}">${p}</a>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </c:if>

        </div>
    </body>
</html>
