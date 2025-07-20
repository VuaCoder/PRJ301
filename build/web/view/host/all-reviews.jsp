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
        <title>Đánh giá - Staytion</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_home.css" />
        <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .review-container {
                max-width: 800px;
                margin: 50px auto;
                padding: 30px;
            }
            
            .review-header {
                text-align: center;
                margin-bottom: 40px;
            }
            
            .review-header h1 {
                color: #2563eb;
                font-size: 2.5rem;
                margin-bottom: 10px;
            }
            
            .review-header p {
                color: #6b7280;
                font-size: 1.1rem;
            }
            
            .booking-info {
                background: #f8fafc;
                border-radius: 16px;
                padding: 30px;
                margin-bottom: 30px;
                border: 1px solid #e2e8f0;
            }
            
            .booking-info h3 {
                color: #1f2937;
                margin-bottom: 20px;
                font-size: 1.3rem;
            }
            
            .info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
            
            .info-item {
                display: flex;
                justify-content: space-between;
                padding: 10px 0;
                border-bottom: 1px solid #e2e8f0;
            }
            
            .info-item:last-child {
                border-bottom: none;
            }
            
            .info-label {
                font-weight: 600;
                color: #374151;
            }
            
            .info-value {
                color: #6b7280;
            }
            
            .room-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 12px;
                margin-bottom: 20px;
            }
            
            .review-form {
                background: #fff;
                border-radius: 16px;
                padding: 40px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            }
            
            .form-group {
                margin-bottom: 30px;
            }
            
            .form-label {
                display: block;
                font-weight: 600;
                color: #1f2937;
                margin-bottom: 10px;
                font-size: 1.1rem;
            }
            
            .star-rating {
                display: flex;
                gap: 10px;
                align-items: center;
            }
            
            .star {
                font-size: 2rem;
                color: #d1d5db;
                cursor: pointer;
                transition: color 0.2s;
            }
            
            .star:hover,
            .star.active {
                color: #fbbf24;
            }
            
            .star.filled {
                color: #fbbf24;
            }
            
            .rating-text {
                margin-left: 15px;
                font-weight: 600;
                color: #374151;
            }
            
            .form-textarea {
                width: 100%;
                min-height: 120px;
                padding: 15px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-family: inherit;
                font-size: 1rem;
                resize: vertical;
                transition: border-color 0.2s;
            }
            
            .form-textarea:focus {
                outline: none;
                border-color: #2563eb;
            }
            
            .char-count {
                text-align: right;
                color: #6b7280;
                font-size: 0.9rem;
                margin-top: 5px;
            }
            
            .form-actions {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 40px;
            }
            
            .btn {
                padding: 12px 30px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
                text-decoration: none;
                text-align: center;
                font-size: 1rem;
            }
            
            .btn-primary {
                background: #2563eb;
                color: white;
            }
            
            .btn-primary:hover {
                background: #1d4ed8;
            }
            
            .btn-secondary {
                background: #6b7280;
                color: white;
            }
            
            .btn-secondary:hover {
                background: #4b5563;
            }
            
            .error-message {
                background: #fef2f2;
                color: #dc2626;
                border: 1px solid #fecaca;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            
            .success-message {
                background: #f0fdf4;
                color: #16a34a;
                border: 1px solid #bbf7d0;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />

        <div class="review-container">
            <div class="review-header">
                <h1><i class="fas fa-star"></i> Đánh giá trải nghiệm</h1>
                <p>Chia sẻ trải nghiệm của bạn về chuyến đi này</p>
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

            <div class="booking-info">
                <h3><i class="fas fa-info-circle"></i> Thông tin đặt phòng</h3>

                <c:if test="${not empty booking.roomId.images}">
                    <c:set var="imgArr" value="${fn:split(booking.roomId.images, ',')}" />
                    <c:set var="imgRaw" value="${imgArr[0]}" />
                    <img src="${imgRaw}" alt="Room Image" class="room-image">
                </c:if>

                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Phòng:</span>
                        <span class="info-value">${booking.roomId.title}</span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Địa điểm:</span>
                        <span class="info-value">${booking.roomId.city}</span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Ngày nhận phòng:</span>
                        <span class="info-value">
                            <fmt:formatDate value="${booking.checkinDate}" pattern="dd/MM/yyyy"/>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Ngày trả phòng:</span>
                        <span class="info-value">
                            <fmt:formatDate value="${booking.checkoutDate}" pattern="dd/MM/yyyy"/>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Số khách:</span>
                        <span class="info-value">${booking.guests} người</span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Tổng tiền:</span>
                        <span class="info-value">
                            <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ
                        </span>
                    </div>
                </div>
            </div>

            <c:choose>
                <c:when test="${hasReviewed}">
                    <div class="success-message" style="text-align:center; font-size:1.2rem; margin: 30px 0;">
                        <i class="fas fa-check-circle"></i> Bạn đã đánh giá phòng này!
                    </div>
                    <div class="reviewed-info" style="margin: 20px auto; max-width: 500px; background: #f8fafc; border-radius: 12px; padding: 24px; border: 1px solid #e2e8f0;">
                        <div style="margin-bottom: 12px;">
                            <span style="font-weight:600; color:#374151;">Số sao đã đánh giá:</span>
                            <span style="color:#fbbf24; font-size:1.3rem;">
                                <c:forEach var="i" begin="1" end="5">
                                    <i class="fa-star fa ${i <= review.rating ? 'fas' : 'far'}"></i>
                                </c:forEach>
                                (${review.rating}/5)
                            </span>
                        </div>
                        <div>
                            <span style="font-weight:600; color:#374151;">Nội dung đánh giá:</span>
                            <div style="margin-top:6px; color:#374151; background:#fff; border-radius:8px; padding:12px; border:1px solid #e2e8f0;">${review.comment}</div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <form class="review-form" method="POST" action="${pageContext.request.contextPath}/review">
                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                        <div class="form-group">
                            <label class="form-label">Đánh giá của bạn <span style="color: #dc2626;">*</span></label>
                            <div class="star-rating">
                                <i class="fas fa-star star" data-rating="1"></i>
                                <i class="fas fa-star star" data-rating="2"></i>
                                <i class="fas fa-star star" data-rating="3"></i>
                                <i class="fas fa-star star" data-rating="4"></i>
                                <i class="fas fa-star star" data-rating="5"></i>
                                <span class="rating-text">Chọn điểm đánh giá</span>
                            </div>
                            <input type="hidden" name="rating" id="rating-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nhận xét của bạn <span style="color: #dc2626;">*</span></label>
                            <textarea 
                                class="form-textarea" 
                                name="comment" 
                                placeholder="Chia sẻ trải nghiệm của bạn về chuyến đi này (tối thiểu 10 ký tự)..."
                                required
                                minlength="10"
                                maxlength="500"
                                id="comment-textarea"></textarea>
                            <div class="char-count">
                                <span id="char-count">0</span>/500 ký tự
                            </div>
                        </div>
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/my-bookings" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                            <button type="submit" class="btn btn-primary" id="submit-btn" disabled>
                                <i class="fas fa-paper-plane"></i> Gửi đánh giá
                            </button>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="../common/footer.jsp" />

        <script>
            // Star rating functionality
            const stars = document.querySelectorAll('.star');
            const ratingInput = document.getElementById('rating-input');
            const ratingText = document.querySelector('.rating-text');
            const submitBtn = document.getElementById('submit-btn');
            const commentTextarea = document.getElementById('comment-textarea');
            const charCount = document.getElementById('char-count');
            
            let selectedRating = 0;
            
            stars.forEach(star => {
                star.addEventListener('click', function() {
                    const rating = parseInt(this.getAttribute('data-rating'));
                    selectedRating = rating;
                    ratingInput.value = rating;
                    
                    // Update star display
                    stars.forEach((s, index) => {
                        if (index < rating) {
                            s.classList.add('filled');
                        } else {
                            s.classList.remove('filled');
                        }
                    });
                    
                    // Update rating text
                    const ratingLabels = ['', 'Rất tệ', 'Tệ', 'Bình thường', 'Tốt', 'Tuyệt vời'];
                    ratingText.textContent = ratingLabels[rating];
                    
                    checkFormValidity();
                });
                
                star.addEventListener('mouseenter', function() {
                    const rating = parseInt(this.getAttribute('data-rating'));
                    stars.forEach((s, index) => {
                        if (index < rating) {
                            s.classList.add('active');
                        } else {
                            s.classList.remove('active');
                        }
                    });
                });
                
                star.addEventListener('mouseleave', function() {
                    stars.forEach(s => s.classList.remove('active'));
                });
            });
            
            // Character count for comment
            commentTextarea.addEventListener('input', function() {
                const length = this.value.length;
                charCount.textContent = length;
                
                if (length < 10) {
                    charCount.style.color = '#dc2626';
                } else {
                    charCount.style.color = '#6b7280';
                }
                
                checkFormValidity();
            });
            
            // Check form validity
            function checkFormValidity() {
                const commentLength = commentTextarea.value.trim().length;
                const isValid = selectedRating > 0 && commentLength >= 10;
                submitBtn.disabled = !isValid;
            }
            
            // Form validation
            document.querySelector('form').addEventListener('submit', function(e) {
                if (selectedRating === 0) {
                    e.preventDefault();
                    alert('Vui lòng chọn điểm đánh giá!');
                    return;
                }
                
                const comment = commentTextarea.value.trim();
                if (comment.length < 10) {
                    e.preventDefault();
                    alert('Nội dung đánh giá phải có ít nhất 10 ký tự!');
                    return;
                }
            });
        </script>
    </body>
</html> 