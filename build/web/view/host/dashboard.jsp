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
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css"/>
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
        <style>
            .swiper-pagination-bullet {
                background-color: #000 !important;
                opacity: 0.5;
                transition: all 0.4s cubic-bezier(0.4,0,0.2,1);
                box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            }
            .swiper-pagination-bullet-active {
                opacity: 1;
                transform: scale(1.4) rotate(10deg);
                box-shadow: 0 4px 16px rgba(0,0,0,0.25);
            }
            .swiper-pagination-bullet.white {
                background-color: #fff !important;
                box-shadow: 0 2px 8px rgba(255,255,255,0.15);
            }
            .swiper-pagination-bullet-active.white {
                box-shadow: 0 4px 16px rgba(255,255,255,0.25);
            }
        </style>
    </head>
    <body class="bg-gray-50 font-sans">
        <jsp:include page="/view/common/header.jsp" />
        <div class="max-w-7xl mx-auto p-6">
            <c:choose>
                <c:when test="${not empty rooms}">
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:forEach var="r" items="${rooms}" varStatus="loop">
                            <div class="bg-white rounded-xl shadow-lg border hover:shadow-xl transition overflow-hidden">
                                <div class="relative w-full h-56 rounded-t-xl overflow-hidden">
                                    <c:choose>
                                        <c:when test="${not empty r.images}">
                                            <c:set var="imgArr" value="${fn:split(r.images, ',')}" />
                                            <div class="swiper swiper-room-${loop.index} w-full h-full">
                                                <div class="swiper-wrapper">
                                                    <c:forEach var="img" items="${imgArr}">
                                                        <div class="swiper-slide">
                                                            <c:choose>
                                                                <c:when test="${fn:startsWith(img, 'http')}">
                                                                    <img src="${img}" class="w-full h-full object-cover transition duration-500 ease-in-out" alt="Room Image">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${pageContext.request.contextPath}/img/${img}" class="w-full h-full object-cover transition duration-500 ease-in-out" alt="Room Image">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="swiper-pagination mt-2 flex justify-center z-50"></div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="h-full bg-gradient-to-br from-blue-400 to-purple-500 flex justify-center items-center">
                                                <i class="fas fa-bed text-6xl text-white opacity-50"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="absolute top-3 right-3 z-30">
                                        <span class="px-3 py-1 rounded-full text-xs font-semibold text-white
                                            ${r.status eq 'Available' || r.status eq 'active' || r.status eq 'Active' ? 'bg-green-500' : 'bg-red-500'}">
                                            ${r.status eq 'Available' || r.status eq 'active' || r.status eq 'Active' ? 'Available' : 'Unavailable'}
                                        </span>
                                    </div>
                                </div>
                                <div class="p-6 relative flex flex-col gap-3">
                                    <h3 class="text-xl font-bold text-gray-800 mb-1">${r.title}</h3>
                                    <c:if test="${not empty r.description}">
                                        <p class="text-sm text-gray-500 mb-2 line-clamp-2">${r.description}</p>
                                    </c:if>
                                    <div class="flex items-center justify-between text-sm text-gray-600 mb-2">
                                        <div class="flex items-center gap-2">
                                            <i class="fas fa-users"></i>
                                            <span>${r.capacity} khách</span>
                                        </div>
                                        <div class="flex items-center gap-2">
                                            <span class="text-2xl font-bold text-gray-800">
                                                <fmt:formatNumber value="${r.price}" type="number" maxFractionDigits="0"/>
                                            </span>
                                            <span class="text-xs text-gray-500">VNĐ/đêm</span>
                                        </div>
                                    </div>
                                    <div class="flex gap-3 mt-2">
                                        <a href="${pageContext.request.contextPath}/host/room?action=edit&id=${r.roomId}" class="flex-1 text-center bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600">
                                            <i class="fas fa-edit"></i> Sửa
                                        </a>
                                        <a href="${pageContext.request.contextPath}/host/room?action=delete&id=${r.roomId}"
                                           onclick="return confirm('Bạn chắc chắn muốn xóa phòng này?');"
                                           class="flex-1 text-center bg-red-500 text-white px-4 py-2 rounded-lg hover:bg-red-600">
                                            <i class="fas fa-trash"></i> Xóa
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
        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const swipers = document.querySelectorAll('.swiper');
                swipers.forEach((swiperEl) => {
                    new Swiper(swiperEl, {
                        loop: true,
                        autoplay: {
                            delay: 2000,
                            disableOnInteraction: false,
                            pauseOnMouseEnter: true
                        },
                        pagination: {
                            el: swiperEl.querySelector('.swiper-pagination'),
                            clickable: true
                        },
                        speed: 600
                    });

                    // Đổi màu pagination nếu ảnh đầu tiên là nền tối
                    const firstImg = swiperEl.querySelector('.swiper-slide img');
                    if (firstImg) {
                        const img = new window.Image();
                        img.crossOrigin = 'Anonymous';
                        img.src = firstImg.src;
                        img.onload = function() {
                            const canvas = document.createElement('canvas');
                            canvas.width = 10; canvas.height = 10;
                            const ctx = canvas.getContext('2d');
                            ctx.drawImage(img, 0, 0, 10, 10);
                            let r=0,g=0,b=0,count=0;
                            const data = ctx.getImageData(0,0,10,10).data;
                            for(let i=0;i<data.length;i+=4){
                                r+=data[i];g+=data[i+1];b+=data[i+2];count++;
                            }
                            r/=count;g/=count;b/=count;
                            if(r+g+b<380){
                                const pag = swiperEl.querySelectorAll('.swiper-pagination-bullet');
                                pag.forEach(bullet=>bullet.classList.add('white'));
                            }
                        };
                    }
                });
            });
        </script>
        <jsp:include page="/view/common/footer.jsp" />
    </body>
</html>