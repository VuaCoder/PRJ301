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
        <title>Đặt phòng - Staytion</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_home.css" />
        <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .booking-container {
                max-width: 800px;
                margin: 50px auto;
                padding: 30px;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            }
            
            .booking-header {
                text-align: center;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 2px solid #f0f0f0;
            }
            
            .booking-header h1 {
                color: #2563eb;
                font-size: 2rem;
                margin-bottom: 10px;
            }
            
            .room-info {
                display: flex;
                gap: 20px;
                margin-bottom: 30px;
                padding: 20px;
                background: #f8fafc;
                border-radius: 12px;
            }
            
            .room-image {
                width: 200px;
                height: 150px;
                object-fit: cover;
                border-radius: 8px;
            }
            
            .room-details h3 {
                color: #1f2937;
                margin-bottom: 10px;
            }
            
            .room-details p {
                color: #6b7280;
                margin-bottom: 5px;
            }
            
            .booking-form {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 30px;
            }
            
            .form-group {
                display: flex;
                flex-direction: column;
            }
            
            .form-group label {
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
            }
            
            .form-group input, .form-group select {
                padding: 12px;
                border: 2px solid #e5e7eb;
                border-radius: 8px;
                font-size: 16px;
                transition: border-color 0.2s;
            }
            
            .form-group input:focus, .form-group select:focus {
                outline: none;
                border-color: #2563eb;
            }
            
            .price-summary {
                background: #f0f9ff;
                padding: 20px;
                border-radius: 12px;
                margin-bottom: 30px;
            }
            
            .price-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                padding: 8px 0;
                border-bottom: 1px solid #e0f2fe;
            }
            
            .price-row:last-child {
                border-bottom: none;
                font-weight: 700;
                font-size: 1.1rem;
                color: #2563eb;
            }
            
            .submit-btn {
                width: 100%;
                padding: 16px;
                background: #2563eb;
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 18px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.2s;
            }
            
            .submit-btn:hover {
                background: #1d4ed8;
            }
            
            .submit-btn:disabled {
                background: #9ca3af;
                cursor: not-allowed;
            }
            
            .error-message {
                background: #fef2f2;
                color: #dc2626;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
                border: 1px solid #fecaca;
            }
            
            .success-message {
                background: #f0fdf4;
                color: #16a34a;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
                border: 1px solid #bbf7d0;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />
        
        <div class="booking-container">
            <div class="booking-header">
                <h1><i class="fas fa-calendar-check"></i> Đặt phòng</h1>
                <p>Vui lòng kiểm tra thông tin trước khi xác nhận đặt phòng</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="success-message">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
            </c:if>
            
            <div class="room-info">
                <c:if test="${not empty room.images}">
                    <c:set var="imgArr" value="${fn:split(room.images, ',')}" />
                    <c:set var="imgRaw" value="${imgArr[0]}" />
                    <img src="${imgRaw}" alt="Room Image" class="room-image">
                </c:if>
                <div class="room-details">
                    <h3>${room.title}</h3>
                    <p><i class="fas fa-map-marker-alt"></i> ${room.city}</p>
                    <p><i class="fas fa-users"></i> Tối đa ${room.capacity} khách</p>
                                            <p><i class="fas fa-money-bill-wave"></i> <fmt:formatNumber value="${room.price}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ/đêm</p>
                </div>
            </div>
            
            <form method="POST" action="${pageContext.request.contextPath}/booking" id="bookingForm">
                <input type="hidden" name="action" value="create-booking">
                <input type="hidden" name="roomId" value="${room.roomId}">
                <input type="hidden" name="checkin" value="${checkin}">
                <input type="hidden" name="checkout" value="${checkout}">
                <input type="hidden" name="guests" value="${guests}">
                
                <div class="booking-form">
                    <div class="form-group">
                        <label for="checkin">Ngày nhận phòng</label>
                        <input type="date" id="checkin" name="checkin" value="${checkin}" required 
                               min="${java.time.LocalDate.now()}" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label for="checkout">Ngày trả phòng</label>
                        <input type="date" id="checkout" name="checkout" value="${checkout}" required 
                               min="${checkin}" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label for="guests">Số lượng khách</label>
                        <input type="number" id="guests" name="guests" value="${guests}" required 
                               min="1" max="${room.capacity}" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label for="customerName">Tên khách hàng</label>
                        <input type="text" id="customerName" value="${user.fullName}" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label for="customerEmail">Email</label>
                        <input type="email" id="customerEmail" value="${user.email}" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label for="customerPhone">Số điện thoại</label>
                        <input type="tel" id="customerPhone" value="${user.phone}" readonly>
                    </div>
                </div>
                
                <div class="price-summary">
                    <h3><i class="fas fa-calculator"></i> Tóm tắt chi phí</h3>
                    
                    <div class="price-row">
                        <span>Giá phòng/đêm:</span>
                                                        <span><fmt:formatNumber value="${room.price}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ</span>
                    </div>
                    
                    <div class="price-row">
                        <span>Số đêm:</span>
                        <span id="nights">Đang tính...</span>
                    </div>
                    
                    <div class="price-row">
                        <span>Phí dịch vụ:</span>
                        <span>0 ₫</span>
                    </div>
                    
                    <div class="price-row">
                        <span>Tổng cộng:</span>
                                                    <span id="totalPrice"><fmt:formatNumber value="${totalPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ</span>
                    </div>
                </div>
                
                <button type="submit" class="submit-btn" id="submitBtn">
                    <i class="fas fa-credit-card"></i> Tiến hành thanh toán
                </button>
            </form>
        </div>
        
        <jsp:include page="../common/footer.jsp" />
        
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Tính số đêm
                const checkin = new Date('${checkin}');
                const checkout = new Date('${checkout}');
                const nights = Math.ceil((checkout - checkin) / (1000 * 60 * 60 * 24));
                document.getElementById('nights').textContent = nights + ' đêm';
                
                // Validate form
                const form = document.getElementById('bookingForm');
                const submitBtn = document.getElementById('submitBtn');
                
                form.addEventListener('submit', function(e) {
                    if (!confirm('Bạn có chắc chắn muốn đặt phòng này?')) {
                        e.preventDefault();
                        return;
                    }
                    
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                });
            });
        </script>
    </body>
</html> 