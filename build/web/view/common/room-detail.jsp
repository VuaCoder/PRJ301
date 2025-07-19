<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>Room Detail</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style_room_detail.css">
    <link rel="icon" type="image/x-icon" href="img/favicon.ico">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.js"></script>
    <style>
        body { background: #f5f6fa; }
    </style>
</head>
<body>
<jsp:include page="header.jsp"/>
<div class="lux-room-detail-container">
    <div class="lux-room-main">
        <!-- Slider ảnh lớn -->
        <div class="lux-room-slider">
            <%-- Tách mảng ảnh --%>
            <c:set var="imgArr" value="${fn:split(room.images, ',')}" />
            <c:choose>
                <c:when test="${not empty room.images}">
                    <div class="swiper lux-swiper-room-detail w-full h-full">
                        <div class="swiper-wrapper">
                            <c:forEach var="img" items="${imgArr}">
                                <c:set var="imgRaw" value="${fn:trim(img)}" />
                                <c:if test="${not empty imgRaw}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(imgRaw, 'http')}">
                                            <div class="swiper-slide"><img src="${imgRaw}" class="lux-room-img-slide" alt="Room Image"></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="swiper-slide"><img src="${pageContext.request.contextPath}/img/${imgRaw}" class="lux-room-img-slide" alt="Room Image"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </c:forEach>
                        </div>
                        <div class="swiper-pagination lux-swiper-pagination"></div>
                        <div class="swiper-button-next"></div>
                        <div class="swiper-button-prev"></div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="h-full bg-gradient-to-br from-blue-400 to-purple-500 flex justify-center items-center lux-room-img-slide">
                        <i class="fas fa-bed text-6xl text-white opacity-50"></i>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <!-- Thông tin chính -->
        <div class="lux-room-info-block">
            <h1 class="lux-room-title">${room.title}</h1>
            <div class="lux-room-meta">
                <span><i class="fas fa-map-marker-alt"></i> ${room.propertyId.city}</span>
                <span><i class="fas fa-home"></i> ${room.propertyId.name}</span>
                <span><i class="fas fa-users"></i> ${room.capacity} guests</span>
            </div>
            <div class="lux-room-price">
                <span class="lux-room-price-label">Giá mỗi đêm</span>
                <span class="lux-room-price-value">
                    <fmt:formatNumber value="${room.price}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ
                </span>
            </div>
            <a href="${pageContext.request.contextPath}/qr-payment?roomId=${room.roomId}" class="lux-btn lux-btn-primary lux-btn-large">
                <i class="fas fa-credit-card"></i> Đặt phòng ngay
            </a>
        </div>
    </div>
    <!-- Section mô tả -->
    <div class="lux-room-section">
        <h2><i class="fas fa-align-left"></i> Mô tả phòng</h2>
        <p class="lux-room-desc">${room.description}</p>
    </div>
    <!-- Section tiện nghi nếu có -->
    <c:if test="${not empty amenities}">
        <div class="lux-room-section">
            <h2><i class="fas fa-concierge-bell"></i> Tiện nghi nổi bật</h2>
            <div class="lux-amenities-grid">
                <c:forEach var="am" items="${amenities}">
                    <div class="lux-amenity-item">
                        <i class="fa fa-check-circle"></i> ${am.name}
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
    <!-- Section chính sách, có thể bổ sung thêm -->
    <div class="lux-room-section lux-room-policy">
        <h2><i class="fas fa-info-circle"></i> Chính sách & Lưu ý</h2>
        <ul>
            <li>Nhận phòng sau 14:00, trả phòng trước 12:00</li>
            <li>Không hút thuốc trong phòng</li>
            <li>Vui lòng giữ yên tĩnh sau 22:00</li>
        </ul>
    </div>
    <a href="/home" class="lux-btn lux-btn-outline lux-btn-large lux-btn-back"><i class="fas fa-arrow-left"></i> Về trang chủ</a>
</div>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        new Swiper('.lux-swiper-room-detail', {
            loop: true,
            autoplay: {
                delay: 2500,
                disableOnInteraction: false,
                pauseOnMouseEnter: true
            },
            pagination: {
                el: '.lux-swiper-pagination',
                clickable: true,
            },
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
            slidesPerView: 1,
            spaceBetween: 0,
            effect: 'fade',
            fadeEffect: { crossFade: true },
        });
    });
</script>
<jsp:include page="footer.jsp"/>
</body>
</html>
