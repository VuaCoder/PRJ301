<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Host Dashboard - Staytion</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
            />
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css"
            />
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
        <style>
            /* Đảm bảo pagination hiển thị */
            .swiper-pagination {
                position: relative !important;
                bottom: 0 !important;
                z-index: 10 !important;
            }
            
            .swiper-pagination-bullet {
                background: #000 !important;
                opacity: 0.5 !important;
                transition: all 0.3s ease !important;
            }
            
            .swiper-pagination-bullet-active {
                opacity: 1 !important;
                background: #000 !important;
            }
            
            /* Đảm bảo swiper container có position relative */
            .swiper {
                position: relative !important;
            }
        </style>
    </head>
    <body class="bg-gray-50 font-sans">
        <jsp:include page="/view/common/header.jsp" />

        <div class="max-w-7xl mx-auto p-6">
            <!-- Quick Actions Section -->
            <div class="mb-8 bg-white rounded-xl shadow-lg border p-6">
                <h2 class="text-2xl font-bold text-gray-800 mb-4">Quản lý nhanh</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <a href="${pageContext.request.contextPath}/host/manage-bookings" 
                       class="flex items-center p-4 bg-blue-50 rounded-lg hover:bg-blue-100 transition-colors">
                        <i class="fas fa-calendar-check text-2xl text-blue-600 mr-4"></i>
                        <div>
                            <h3 class="font-semibold text-gray-800">Xem đặt phòng</h3>
                            <p class="text-sm text-gray-600">Quản lý và xác nhận đặt phòng</p>
                        </div>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/host/room?action=create" 
                       class="flex items-center p-4 bg-green-50 rounded-lg hover:bg-green-100 transition-colors">
                        <i class="fas fa-plus text-2xl text-green-600 mr-4"></i>
                        <div>
                            <h3 class="font-semibold text-gray-800">Thêm phòng mới</h3>
                            <p class="text-sm text-gray-600">Tạo phòng mới để cho thuê</p>
                        </div>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/host/dashboard" 
                       class="flex items-center p-4 bg-purple-50 rounded-lg hover:bg-purple-100 transition-colors">
                        <i class="fas fa-chart-line text-2xl text-purple-600 mr-4"></i>
                        <div>
                            <h3 class="font-semibold text-gray-800">Thống kê</h3>
                            <p class="text-sm text-gray-600">Xem báo cáo và thống kê</p>
                        </div>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/host/reviews" 
                       class="flex items-center p-4 bg-yellow-50 rounded-lg hover:bg-yellow-100 transition-colors">
                        <i class="fas fa-star text-2xl text-yellow-600 mr-4"></i>
                        <div>
                            <h3 class="font-semibold text-gray-800">Xem đánh giá</h3>
                            <p class="text-sm text-gray-600">Xem đánh giá của khách hàng</p>
                        </div>
                    </a>
                </div>
            </div>
            <c:choose>
                <c:when test="${not empty rooms}">
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:forEach var="r" items="${rooms}" varStatus="loop">
                            <div class="bg-white rounded-xl shadow-lg border hover:shadow-xl transition overflow-hidden">

                                <!-- Swiper Image Carousel -->
                                <div class="relative w-full h-56 rounded-t-xl overflow-hidden">
                                    <c:choose>
                                        <c:when test="${not empty r.images}">
                                            <c:set var="imgArr" value="${fn:split(r.images, ',')}" />
                                            <div class="swiper swiper-room-${loop.index} w-full h-full">
                                                <div class="swiper-wrapper">
                                                    <c:forEach var="img" items="${imgArr}">
                                                        <div class="swiper-slide">
                                                            <img src="${img}" class="w-full h-full object-cover" alt="Room Image">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="h-full bg-gradient-to-br from-blue-400 to-purple-500 flex justify-center items-center">
                                                <i class="fas fa-bed text-6xl text-white opacity-50"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Room Status -->
                                    <div class="absolute top-3 right-3 z-30">
                                        <span class="px-3 py-1 rounded-full text-xs font-semibold text-white
                                              ${r.status eq 'Available' || r.status eq 'active' || r.status eq 'Active' ? 'bg-green-500' : 'bg-red-500'}">
                                            ${r.status eq 'Available' || r.status eq 'active' || r.status eq 'Active' ? 'Available' : 'Unavailable'}
                                        </span>
                                    </div>
                                </div>

                                <!-- Room Details -->
                                <div class="p-6 relative">
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
                                        <a href="${pageContext.request.contextPath}/host/reviews?roomId=${r.roomId}" class="text-center bg-yellow-500 text-white px-4 py-2 rounded-lg hover:bg-yellow-600">
                                            <i class="fas fa-star"></i> Reviews
                                        </a>
                                        <a href="${pageContext.request.contextPath}/host/room?action=delete&id=${r.roomId}"
                                           onclick="return confirm('Are you sure you want to delete this room?');"
                                           class="text-center bg-red-500 text-white px-4 py-2 rounded-lg hover:bg-red-600">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </div>

                                    <!-- Custom Swiper Pagination -->
                                    <div class="swiper-pagination swiper-pagination-${loop.index} mt-4 !z-50 flex justify-center gap-2"></div>
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
            
            <!-- Booking Statistics Section -->
            <div class="mt-8 bg-white rounded-xl shadow-lg border p-6">
                <h2 class="text-2xl font-bold text-gray-800 mb-4">Thống kê đặt phòng</h2>
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div class="text-center p-4 bg-yellow-50 rounded-lg">
                        <i class="fas fa-clock text-3xl text-yellow-600 mb-2"></i>
                        <h3 class="text-2xl font-bold text-gray-800">${pendingBookings}</h3>
                        <p class="text-sm text-gray-600">Chờ xác nhận</p>
                    </div>
                    
                    <div class="text-center p-4 bg-green-50 rounded-lg">
                        <i class="fas fa-check text-3xl text-green-600 mb-2"></i>
                        <h3 class="text-2xl font-bold text-gray-800">${confirmedBookings}</h3>
                        <p class="text-sm text-gray-600">Đã xác nhận</p>
                    </div>
                    
                    <div class="text-center p-4 bg-red-50 rounded-lg">
                        <i class="fas fa-times text-3xl text-red-600 mb-2"></i>
                        <h3 class="text-2xl font-bold text-gray-800">${cancelledBookings}</h3>
                        <p class="text-sm text-gray-600">Đã từ chối</p>
                    </div>
                    
                    <div class="text-center p-4 bg-blue-50 rounded-lg">
                        <i class="fas fa-calendar text-3xl text-blue-600 mb-2"></i>
                        <h3 class="text-2xl font-bold text-gray-800">${totalBookings}</h3>
                        <p class="text-sm text-gray-600">Tổng đặt phòng</p>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const swipers = document.querySelectorAll('[class^="swiper swiper-room-"]');
                swipers.forEach((swiperEl, index) => {
                    new Swiper(swiperEl, {
                        loop: true,
                        autoplay: {
                            delay: 5000, // Tăng lên 5 giây
                            disableOnInteraction: false,
                            pauseOnMouseEnter: true
                        },
                        pagination: {
                            el: `.swiper-pagination-${index}`,
                            clickable: true,
                            renderBullet: function (index, className) {
                                return `<span class="${className} bg-black opacity-50 transition-all duration-300 w-3 h-3 rounded-full mx-1 inline-block"></span>`;
                            }
                        },
                        // Thêm navigation nếu cần
                        navigation: {
                            nextEl: '.swiper-button-next',
                            prevEl: '.swiper-button-prev',
                        }
                    });
                });
            });
        </script>

        <jsp:include page="/view/common/footer.jsp" />
    </body>
</html>