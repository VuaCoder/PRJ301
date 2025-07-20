<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page import="model.UserAccount"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đặt phòng của tôi - Staytion</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_home.css" />
        <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .bookings-container {
                max-width: 1200px;
                margin: 50px auto;
                padding: 30px;
            }
            
            .bookings-header {
                text-align: center;
                margin-bottom: 40px;
            }
            
            .bookings-header h1 {
                color: #2563eb;
                font-size: 2.5rem;
                margin-bottom: 10px;
            }
            
            .bookings-header p {
                color: #6b7280;
                font-size: 1.1rem;
            }
            
            .booking-card {
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                margin-bottom: 30px;
                overflow: hidden;
                transition: transform 0.2s, box-shadow 0.2s;
            }
            
            .booking-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            }
            
            .booking-header {
                background: linear-gradient(135deg, #2563eb, #1d4ed8);
                color: white;
                padding: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .booking-id {
                font-size: 1.2rem;
                font-weight: 700;
            }
            
            .booking-status {
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.9rem;
            }
            
            .status-pending {
                background: #fef3c7;
                color: #d97706;
            }
            
            .status-confirmed {
                background: #d1fae5;
                color: #059669;
            }
            
            .status-cancelled {
                background: #fee2e2;
                color: #dc2626;
            }
            
            .booking-content {
                padding: 30px;
                display: grid;
                grid-template-columns: 1fr 2fr 1fr;
                gap: 30px;
                align-items: start;
            }
            
            .room-image {
                width: 200px;
                height: 150px;
                object-fit: cover;
                border-radius: 12px;
            }
            
            .booking-details h3 {
                color: #1f2937;
                margin-bottom: 15px;
                font-size: 1.3rem;
            }
            
            .detail-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                padding: 8px 0;
                border-bottom: 1px solid #f3f4f6;
            }
            
            .detail-row:last-child {
                border-bottom: none;
            }
            
            .detail-label {
                font-weight: 600;
                color: #374151;
            }
            
            .detail-value {
                color: #6b7280;
            }
            
            .booking-actions {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }
            
            .action-btn {
                padding: 12px 20px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
                text-decoration: none;
                text-align: center;
            }
            
            .btn-primary {
                background: #2563eb;
                color: white;
            }
            
            .btn-primary:hover {
                background: #1d4ed8;
            }
            
            .btn-danger {
                background: #dc2626;
                color: white;
            }
            
            .btn-danger:hover {
                background: #b91c1c;
            }
            
            .btn-secondary {
                background: #6b7280;
                color: white;
            }
            
            .btn-secondary:hover {
                background: #4b5563;
            }
            
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #6b7280;
            }
            
            .empty-state i {
                font-size: 4rem;
                margin-bottom: 20px;
                color: #d1d5db;
            }
            
            .message {
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            
            .message-success {
                background: #f0fdf4;
                color: #16a34a;
                border: 1px solid #bbf7d0;
            }
            
            .message-error {
                background: #fef2f2;
                color: #dc2626;
                border: 1px solid #fecaca;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />
        
        <div class="bookings-container">
            <div class="bookings-header">
                <h1><i class="fas fa-calendar-alt"></i> Đặt phòng của tôi</h1>
                <p>Quản lý tất cả các đặt phòng của bạn</p>
            </div>
            
            <c:if test="${param.message == 'booking-cancelled'}">
                <div class="message message-success">
                    <i class="fas fa-check-circle"></i> Đã hủy đặt phòng thành công!
                </div>
            </c:if>
            
            <c:if test="${param.message == 'review-success'}">
                <div class="message message-success">
                    <i class="fas fa-star"></i> Đánh giá của bạn đã được gửi thành công!
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="message message-error">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>
            
            <c:choose>
                <c:when test="${empty bookings}">
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <h2>Chưa có đặt phòng nào</h2>
                        <p>Bạn chưa có đặt phòng nào. Hãy khám phá các phòng tuyệt vời và đặt ngay!</p>
                        <a href="${pageContext.request.contextPath}/home" class="action-btn btn-primary">
                            <i class="fas fa-search"></i> Tìm phòng
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="booking" items="${bookings}">
                        <div class="booking-card">
                            <div class="booking-header">
                                <span class="booking-id">#${booking.bookingId}</span>
                                <span class="booking-status status-${fn:toLowerCase(booking.status)}">
                                    <c:choose>
                                        <c:when test="${booking.status == 'Pending'}">
                                            <i class="fas fa-clock"></i> Chờ xác nhận
                                        </c:when>
                                        <c:when test="${booking.status == 'Confirmed'}">
                                            <i class="fas fa-check"></i> Đã xác nhận
                                        </c:when>
                                        <c:when test="${booking.status == 'Cancelled'}">
                                            <i class="fas fa-times"></i> Đã hủy
                                        </c:when>
                                        <c:otherwise>
                                            ${booking.status}
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            
                            <div class="booking-content">
                                <div class="room-image-container">
                                    <c:if test="${not empty booking.roomId.images}">
                                        <c:set var="imgArr" value="${fn:split(booking.roomId.images, ',')}" />
                                        <c:set var="imgRaw" value="${imgArr[0]}" />
                                        <img src="${imgRaw}" alt="Room Image" class="room-image">
                                    </c:if>
                                </div>
                                
                                <div class="booking-details">
                                    <h3>${booking.roomId.title}</h3>
                                    
                                    <div class="detail-row">
                                        <span class="detail-label">Địa điểm:</span>
                                        <span class="detail-value">${booking.roomId.city}</span>
                                    </div>
                                    
                                    <div class="detail-row">
                                        <span class="detail-label">Ngày nhận phòng:</span>
                                        <span class="detail-value">
                                            <fmt:formatDate value="${booking.checkinDate}" pattern="dd/MM/yyyy"/>
                                        </span>
                                    </div>
                                    
                                    <div class="detail-row">
                                        <span class="detail-label">Ngày trả phòng:</span>
                                        <span class="detail-value">
                                            <fmt:formatDate value="${booking.checkoutDate}" pattern="dd/MM/yyyy"/>
                                        </span>
                                    </div>
                                    
                                    <div class="detail-row">
                                        <span class="detail-label">Số khách:</span>
                                        <span class="detail-value">${booking.guests} người</span>
                                    </div>
                                    
                                                                    <div class="detail-row">
                                    <span class="detail-label">Tổng tiền:</span>
                                    <span class="detail-value">
                                        <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ
                                    </span>
                                </div>
                                    
                                    <div class="detail-row">
                                        <span class="detail-label">Ngày đặt:</span>
                                        <span class="detail-value">
                                            <fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="booking-actions">
                                    <c:if test="${booking.status == 'Pending'}">
                                        <form method="POST" action="${pageContext.request.contextPath}/booking" 
                                              style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đặt phòng này?')">
                                            <input type="hidden" name="action" value="cancel-booking">
                                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                            <button type="submit" class="action-btn btn-danger">
                                                <i class="fas fa-times"></i> Hủy đặt phòng
                                            </button>
                                        </form>
                                    </c:if>
                                    
                                    <a href="${pageContext.request.contextPath}/detail?id=${booking.roomId.roomId}" 
                                       class="action-btn btn-secondary">
                                        <i class="fas fa-eye"></i> Xem chi tiết phòng
                                    </a>
                                    
                                    <c:if test="${booking.status == 'Confirmed'}">
                                        <a href="${pageContext.request.contextPath}/review?bookingId=${booking.bookingId}" 
                                           class="action-btn btn-primary">
                                            <i class="fas fa-star"></i> Đánh giá
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        
        <jsp:include page="../common/footer.jsp" />
    </body>
</html> 