<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page import="model.UserAccount"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <title>Đánh giá của khách hàng - Staytion</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_home.css" />
        <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .reviews-container {
                max-width: 1000px;
                margin: 50px auto;
                padding: 30px;
            }
            
            .reviews-header {
                text-align: center;
                margin-bottom: 40px;
            }
            
            .reviews-header h1 {
                color: #2563eb;
                font-size: 2.5rem;
                margin-bottom: 10px;
            }
            
            .reviews-header p {
                color: #6b7280;
                font-size: 1.1rem;
            }
            
            .review-item {
                background: #fff;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                border: 1px solid #e2e8f0;
            }
            
            .review-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 15px;
            }
            
            .reviewer-info {
                display: flex;
                align-items: center;
                gap: 12px;
            }
            
            .reviewer-avatar {
                width: 45px;
                height: 45px;
                border-radius: 50%;
                background: #2563eb;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: 600;
                font-size: 1.1rem;
            }
            
            .reviewer-details h4 {
                color: #1f2937;
                font-weight: 600;
                margin-bottom: 5px;
            }
            
            .review-date {
                color: #6b7280;
                font-size: 0.9rem;
            }
            
            .review-rating {
                display: flex;
                gap: 3px;
                align-items: center;
            }
            
            .review-rating .fa-star {
                color: #fbbf24;
                font-size: 1.1rem;
            }
            
            .room-info {
                background: #f8fafc;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                border: 1px solid #e2e8f0;
            }
            
            .room-title {
                font-weight: 600;
                color: #1f2937;
                margin-bottom: 8px;
            }
            
            .room-location {
                color: #6b7280;
                font-size: 0.9rem;
            }
            
            .review-content {
                color: #374151;
                line-height: 1.6;
                font-size: 1rem;
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
            
            .back-btn {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 12px 20px;
                background: #6b7280;
                color: white;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 600;
                transition: background 0.2s;
            }
            
            .back-btn:hover {
                background: #4b5563;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../common/header_admin.jsp" />
        
        <div class="reviews-container">
            <div class="reviews-header">
                <h1><i class="fas fa-star"></i> Đánh giá của khách hàng</h1>
                <p>Xem tất cả đánh giá về các phòng của bạn</p>
            </div>
            
            <c:choose>
                <c:when test="${empty reviews}">
                    <div class="empty-state">
                        <i class="fas fa-star-o"></i>
                        <h2>Chưa có đánh giá nào</h2>
                        <p>Khách hàng chưa đánh giá phòng nào của bạn. Hãy chờ đợi đánh giá từ khách hàng!</p>
                        <a href="${pageContext.request.contextPath}/host/dashboard" class="back-btn">
                            <i class="fas fa-arrow-left"></i> Về Dashboard
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Danh sách đánh giá -->
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-item">
                            <div class="review-header">
                                <div class="reviewer-info">
                                    <div class="reviewer-avatar">
                                        <c:choose>
                                            <c:when test="${not empty review.bookingId.customerId.fullName}">
                                                ${fn:substring(review.bookingId.customerId.fullName, 0, 1)}
                                            </c:when>
                                            <c:otherwise>U</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="reviewer-details">
                                        <h4>
                                            <c:choose>
                                                <c:when test="${not empty review.bookingId.customerId.fullName}">
                                                    ${review.bookingId.customerId.fullName}
                                                </c:when>
                                                <c:otherwise>Unknown User</c:otherwise>
                                            </c:choose>
                                        </h4>
                                        <div class="review-date">
                                            <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="review-rating">
                                    <c:forEach var="i" begin="1" end="5">
                                        <c:choose>
                                            <c:when test="${i <= review.rating}">
                                                <i class="fas fa-star"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="far fa-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <span style="margin-left: 8px; font-weight: 600; color: #374151;">
                                        ${review.rating}/5
                                    </span>
                                </div>
                            </div>
                            
                            <div class="room-info">
                                <div class="room-title">
                                    <c:choose>
                                        <c:when test="${not empty review.bookingId.roomId.title}">
                                            ${review.bookingId.roomId.title}
                                        </c:when>
                                        <c:otherwise>Unknown Room</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="room-location">
                                    <i class="fas fa-map-marker-alt"></i> 
                                    <c:choose>
                                        <c:when test="${not empty review.bookingId.roomId.city}">
                                            ${review.bookingId.roomId.city}
                                        </c:when>
                                        <c:otherwise>Unknown Location</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="review-content">
                                ${review.comment}
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        
        <jsp:include page="../common/footer_admin.jsp" />
    </body>
</html> 