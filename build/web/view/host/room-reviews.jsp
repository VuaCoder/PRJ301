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
    
    // Kiểm tra xem user có phải là host không
    if (user.getHost() == null) {
        response.sendRedirect(request.getContextPath() + "/view/host/become_host.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đánh giá phòng - Staytion</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_home.css" />
        <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .room-reviews-container {
                max-width: 1000px;
                margin: 50px auto;
                padding: 30px;
            }
            
            .room-header {
                background: #fff;
                border-radius: 16px;
                padding: 30px;
                margin-bottom: 30px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                border: 1px solid #e2e8f0;
            }
            
            .room-title {
                color: #1f2937;
                font-size: 2rem;
                margin-bottom: 15px;
                font-weight: 700;
            }
            
            .room-location {
                color: #6b7280;
                font-size: 1.1rem;
                margin-bottom: 20px;
            }
            
            .room-stats {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }
            
            .stat-item {
                text-align: center;
                padding: 15px;
                background: #f8fafc;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }
            
            .stat-number {
                font-size: 1.8rem;
                font-weight: 700;
                color: #2563eb;
                margin-bottom: 5px;
            }
            
            .stat-label {
                color: #6b7280;
                font-size: 0.9rem;
            }
            
            .rating-display {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 20px;
            }
            
            .stars {
                display: flex;
                gap: 3px;
            }
            
            .stars .fa-star {
                color: #fbbf24;
                font-size: 1.5rem;
            }
            
            .rating-score {
                font-size: 1.5rem;
                font-weight: 700;
                color: #1f2937;
            }
            
            .rating-count {
                color: #6b7280;
                font-size: 1rem;
            }
            
            .reviews-header {
                text-align: center;
                margin-bottom: 30px;
            }
            
            .reviews-header h2 {
                color: #2563eb;
                font-size: 2rem;
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
            
            .room-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 12px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../common/header_admin.jsp" />

        <div class="room-reviews-container">
            <!-- Thông tin phòng -->
            <div class="room-header">
                <c:if test="${not empty room.images}">
                    <c:set var="imgArr" value="${fn:split(room.images, ',')}" />
                    <c:set var="imgRaw" value="${imgArr[0]}" />
                    <img src="${imgRaw}" alt="Room Image" class="room-image">
                </c:if>

                <h1 class="room-title">${room.title}</h1>
                <div class="room-location">
                    <i class="fas fa-map-marker-alt"></i> ${room.city}
                </div>

                <c:if test="${reviewCount > 0}">
                    <div class="rating-display">
                        <div class="stars">
                            <c:forEach var="i" begin="1" end="5">
                                <c:choose>
                                    <c:when test="${i <= averageRating}">
                                        <i class="fas fa-star"></i>
                                    </c:when>
                                    <c:when test="${i - averageRating < 1 && i - averageRating > 0}">
                                        <i class="fas fa-star-half-alt"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="far fa-star"></i>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <div class="rating-score">${averageRating}</div>
                        <div class="rating-count">(${reviewCount} đánh giá)</div>
                    </div>
                </c:if>

                <div class="room-stats">
                    <div class="stat-item">
                        <div class="stat-number">${reviewCount}</div>
                        <div class="stat-label">Tổng đánh giá</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">
                            <c:set var="fiveStarCount" value="0"/>
                            <c:forEach var="review" items="${reviews}">
                                <c:if test="${review.rating == 5}">
                                    <c:set var="fiveStarCount" value="${fiveStarCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${fiveStarCount}
                        </div>
                        <div class="stat-label">5 sao</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">
                            <c:set var="fourStarCount" value="0"/>
                            <c:forEach var="review" items="${reviews}">
                                <c:if test="${review.rating == 4}">
                                    <c:set var="fourStarCount" value="${fourStarCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${fourStarCount}
                        </div>
                        <div class="stat-label">4 sao</div>
                    </div>
                </div>
            </div>

            <!-- Danh sách đánh giá -->
            <div class="reviews-header">
                <h2><i class="fas fa-star"></i> Đánh giá của khách hàng</h2>
                <p>Xem tất cả đánh giá về phòng ${room.title}</p>
            </div>

            <c:choose>
                <c:when test="${empty reviews}">
                    <div class="empty-state">
                        <i class="fas fa-star-o"></i>
                        <h2>Chưa có đánh giá nào</h2>
                        <p>Khách hàng chưa đánh giá phòng này. Hãy chờ đợi đánh giá từ khách hàng!</p>
                        <a href="${pageContext.request.contextPath}/host/reviews" class="back-btn">
                            <i class="fas fa-arrow-left"></i> Về tất cả đánh giá
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-item">
                            <div class="review-header">
                                <div class="reviewer-info">
                                    <div class="reviewer-avatar">
                                        ${fn:substring(review.bookingId.customerId.fullName, 0, 1)}
                                    </div>
                                    <div class="reviewer-details">
                                        <h4>${review.bookingId.customerId.fullName}</h4>
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