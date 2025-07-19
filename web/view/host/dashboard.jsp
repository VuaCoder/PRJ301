<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Host Dashboard - Staytion</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    </head>
    <body class="bg-gray-50 font-sans">

        <jsp:include page="/view/common/header.jsp" />

        <div class="max-w-7xl mx-auto p-6">

            <!-- Header -->
            <div class="bg-gradient-to-r from-blue-600 via-purple-600 to-indigo-600 text-white p-8 rounded-xl shadow-lg mb-8">
                <div class="flex justify-between items-center">
                    <div>
                        <h1 class="text-3xl font-bold mb-2">Host Dashboard</h1>
                        <p class="text-lg opacity-90">Manage your properties and track your performance</p>

                        <c:if test="${not empty host and host.verified}">
                            <div class="flex items-center mt-3">
                                <i class="fas fa-check-circle text-green-300 mr-2"></i>
                                <span class="text-sm">Verified Host</span>
                            </div>
                        </c:if>
                    </div>
                    <div class="text-right">
                        <div class="text-4xl font-bold">
                            <c:out value="${fn:length(rooms)}"/>
                        </div>
                        <div class="text-sm opacity-75">Total Properties</div>
                    </div>
                </div>
            </div>

            <!-- Stats -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">

                <!-- Total Rooms -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-blue-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-home text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold text-gray-800">
                                <c:out value="${fn:length(rooms)}"/>
                            </h3>
                            <p class="text-gray-600">Total Rooms</p>
                        </div>
                    </div>
                </div>

                <!-- Active Rooms -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-green-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-check-circle text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold text-gray-800">
                                <c:set var="activeCount" value="0"/>
                                <c:forEach var="r" items="${rooms}">
                                    <c:if test="${r.status eq 'active'}">
                                        <c:set var="activeCount" value="${activeCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${activeCount}
                            </h3>
                            <p class="text-gray-600">Active Listings</p>
                        </div>
                    </div>
                </div>

                <!-- Average Price -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-yellow-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-dollar-sign text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold text-gray-800">
                                $<fmt:formatNumber value="${avgPrice}" type="number" maxFractionDigits="0"/>
                            </h3>
                            <p class="text-gray-600">Average Price</p>
                        </div>
                    </div>
                </div>

                <!-- Placeholder for Rating -->
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <div class="flex items-center">
                        <div class="bg-purple-600 p-3 rounded-lg text-white mr-4">
                            <i class="fas fa-star text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold text-gray-800">4.8</h3>
                            <p class="text-gray-600">Average Rating</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Room Management Actions -->
            <div class="flex justify-between items-center mb-8 bg-white p-6 rounded-xl shadow-lg border">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">Room Management</h2>
                    <p class="text-gray-600 mt-1">Manage your property listings and bookings</p>
                </div>
                <div class="flex space-x-3">
                    <a href="${pageContext.request.contextPath}/host/room?action=create" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700">
                        <i class="fas fa-plus"></i> Add New Room
                    </a>
                    <a href="${pageContext.request.contextPath}/view/host/bookings.jsp" class="bg-gray-200 text-gray-700 px-6 py-3 rounded-lg hover:bg-gray-300">
                        <i class="fas fa-calendar-alt"></i> View Bookings
                    </a>
                </div>
            </div>

            <!-- Rooms List -->
            <c:choose>
                <c:when test="${not empty rooms}">
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:forEach var="r" items="${rooms}">
                            <div class="bg-white rounded-xl shadow-lg border hover:shadow-xl transition overflow-hidden">
                                <div class="relative">
                                    <c:choose>
                                        <c:when test="${not empty r.images}">
                                            <%-- Hiển thị tất cả ảnh --%>
                                            <c:set var="imgArr" value="${fn:split(r.images, ',')}" />
                                            <c:forEach var="img" items="${imgArr}">
                                                <img src="${pageContext.request.contextPath}/img/${img}" alt="${r.title}" class="w-full h-48 object-cover mb-1"/>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="h-48 bg-gradient-to-br from-blue-400 to-purple-500 flex justify-center items-center">
                                                <i class="fas fa-bed text-6xl text-white opacity-50"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="absolute top-4 right-4">
                                        <span class="px-3 py-1 rounded-full text-xs font-semibold text-white
                                              ${r.status eq 'active' ? 'bg-green-500' : 'bg-red-500'}">
                                            ${r.status eq 'active' ? 'Available' : 'Unavailable'}
                                        </span>
                                    </div>
                                </div>

                                <div class="p-6">
                                    <h3 class="text-xl font-bold text-gray-800 mb-2">${r.title}</h3>
                                    <c:if test="${not empty r.description}">
                                        <p class="text-sm text-gray-600 mb-4">${r.description}</p>
                                    </c:if>

                                    <div class="grid grid-cols-2 gap-4 text-sm text-gray-500 mb-4">
                                        <div><i class="fas fa-users mr-1"></i> ${r.capacity} guests</div>
                                    </div>

                                    <div class="text-2xl font-bold text-gray-800 mb-4">
                                        <fmt:formatNumber value="${r.price}" type="number" maxFractionDigits="0"/> VNĐ
                                        <span class="text-sm text-gray-500">/đêm</span>
                                    </div>

                                    <div class="flex gap-3">
                                        <a href="${pageContext.request.contextPath}/host/room?action=edit&id=${r.roomId}" class="flex-1 text-center bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <a href="${pageContext.request.contextPath}/host/room?action=delete&id=${r.roomId}"
                                           onclick="return confirm('Are you sure you want to delete this room?');"
                                           class="text-center bg-red-500 text-white px-4 py-2 rounded-lg hover:bg-red-600">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center p-12 bg-white rounded-xl shadow-lg border">
                        <i class="fas fa-home text-6xl text-gray-300 mb-4"></i>
                        <h3 class="text-2xl font-bold text-gray-700 mb-2">No rooms yet</h3>
                        <p class="text-gray-500 text-lg">Start by adding your first room to begin hosting guests</p>
                        <div class="mt-6 flex justify-center gap-4">
                            <a href="${pageContext.request.contextPath}/host/room?action=create" class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700">
                                <i class="fas fa-plus"></i> Add Your First Room
                            </a>
                            <a href="${pageContext.request.contextPath}/view/host/become_host.jsp" class="bg-gray-200 text-gray-700 px-8 py-3 rounded-lg hover:bg-gray-300">
                                <i class="fas fa-info-circle"></i> Learn More
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="/view/common/footer.jsp" />

    </body>
</html>
