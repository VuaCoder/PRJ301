<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Kết quả tìm kiếm</title>
        <link rel="stylesheet" href="css/style_result.css">
        <link rel="icon" type="image/x-icon" href="img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Noto Sans', Arial, sans-serif;
                background: #f8fafc;
                color: #333;
                line-height: 1.6;
            }
            
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }
            
            /* Header */
            .search-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 40px 0;
                margin-bottom: 30px;
            }
            
            .search-header h1 {
                font-size: 2.5rem;
                margin-bottom: 10px;
                font-weight: 700;
            }
            
            .search-header p {
                font-size: 1.1rem;
                opacity: 0.9;
            }
            
            /* Debug section */
            .debug {
                background: #f1f5f9;
                padding: 20px;
                margin: 20px 0;
                border-radius: 8px;
                border-left: 4px solid #3b82f6;
            }
            
            .debug h3 {
                color: #1e40af;
                margin-bottom: 15px;
            }
            
            .debug p {
                margin: 5px 0;
            }
            
            /* Error state */
            .error {
                background: #fef2f2;
                color: #dc2626;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid #fecaca;
                text-align: center;
                margin: 20px 0;
            }
            
            .error h2 {
                margin-bottom: 10px;
            }
            
            .error a {
                color: #dc2626;
                text-decoration: underline;
            }
            
            /* Room cards */
            .room-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 0;
                margin: 20px 0;
                transition: all 0.3s ease;
                border: 1px solid #e2e8f0;
                overflow: hidden;
            }
            
            .room-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            }
            
            .room-layout {
                display: flex;
                height: 300px;
            }
            
            /* Hình ảnh bên trái */
            .room-image {
                position: relative;
                width: 400px;
                height: 300px;
                flex-shrink: 0;
                overflow: hidden;
            }
            
            .room-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.3s ease;
            }
            
            .room-card:hover .room-image img {
                transform: scale(1.05);
            }
            
            .image-placeholder {
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 3rem;
            }
            
            .image-badge {
                position: absolute;
                top: 15px;
                right: 15px;
            }
            
            /* Thông tin bên phải */
            .room-info {
                flex: 1;
                padding: 25px;
                display: flex;
                flex-direction: column;
            }
            
            .room-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 15px;
            }
            
            .room-header h3 {
                color: #1f2937;
                font-size: 1.4rem;
                margin: 0;
                font-weight: 700;
                flex: 1;
                margin-right: 15px;
            }
            
            .room-details {
                margin-bottom: 15px;
            }
            
            .detail-item {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 12px;
                color: #4b5563;
                font-size: 1.1rem;
            }
            
            .detail-item i {
                width: 18px;
                color: #6b7280;
                font-size: 1.1rem;
            }
            
            .detail-item span {
                color: #4b5563;
                font-size: 1.1rem;
            }
            
            .detail-item strong {
                color: #1f2937;
                font-weight: 600;
                font-size: 1.1rem;
            }
            
            /* Price styling */
            .price {
                color: #059669;
                font-weight: 700;
                font-size: 1.1rem;
            }
            
            /* Status badges */
            .status-available {
                color: #059669;
                background: #d1fae5;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 0.8rem;
                font-weight: 600;
            }
            
            .status-unavailable {
                color: #dc2626;
                background: #fee2e2;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 0.8rem;
                font-weight: 600;
            }
            

            
            /* Room actions */
            .room-actions {
                text-align: right;
                margin-top: 20px;
                display: flex;
                justify-content: flex-end;
            }
            
            /* Buttons */
            .btn {
                display: inline-block;
                padding: 12px 24px;
                background: #3b82f6;
                color: white;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                font-size: 1rem;
                width: auto;
                min-width: 140px;
            }
            
            .btn:hover {
                background: #2563eb;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
            }
            
            .btn-secondary {
                background: #6b7280;
            }
            
            .btn-secondary:hover {
                background: #4b5563;
            }
            
            /* Back button */
            .back-button {
                margin: 30px 0 20px 0;
                padding: 20px 0;
                text-align: center;
                border-top: 1px solid #e5e7eb;
            }
            
            /* Responsive */
            @media (max-width: 768px) {
                .search-header h1 {
                    font-size: 2rem;
                }
                
                .room-layout {
                    flex-direction: column;
                    height: auto;
                }
                
                .room-image {
                    width: 100%;
                    height: 250px;
                }
                
                .room-info {
                    padding: 20px;
                }
                
                .room-header {
                    flex-direction: column;
                    gap: 10px;
                }
                
                .room-header h3 {
                    margin-right: 0;
                }
                
                .room-actions {
                    text-align: center;
                    margin-top: 15px;
                }
                
                .container {
                    padding: 0 15px;
                }
            }
        </style>
        <style>
            /* Modern Search Results Styles */
            .search-results-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 40px 0;
                margin-bottom: 30px;
            }
            
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }
            
            .search-results-header h1 {
                font-size: 2.5rem;
                margin-bottom: 10px;
                font-weight: 700;
            }
            
            .search-results-header p {
                font-size: 1.1rem;
                opacity: 0.9;
            }
            
            .property-list {
                min-height: 60vh;
            }
            
            .empty-state {
                text-align: center;
                padding: 80px 20px;
                color: #666;
            }
            
            .empty-icon {
                font-size: 4rem;
                color: #ddd;
                margin-bottom: 20px;
            }
            
            .empty-state h2 {
                font-size: 1.8rem;
                margin-bottom: 10px;
                color: #333;
            }
            
            .empty-state p {
                font-size: 1.1rem;
                margin-bottom: 30px;
                color: #666;
            }
            
            .empty-actions {
                display: flex;
                gap: 15px;
                justify-content: center;
                flex-wrap: wrap;
            }
            
            .btn-primary, .btn-secondary {
                padding: 12px 24px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }
            
            .btn-primary {
                background: #2563eb;
                color: white;
            }
            
            .btn-primary:hover {
                background: #1d4ed8;
                transform: translateY(-2px);
            }
            
            .btn-secondary {
                background: #6b7280;
                color: white;
            }
            
            .btn-secondary:hover {
                background: #4b5563;
                transform: translateY(-2px);
            }
            
            .results-grid {
                display: flex;
                flex-direction: column;
                gap: 20px;
                padding: 20px 0;
            }
            
            .property-card {
                background: white;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                overflow: hidden;
                transition: all 0.3s ease;
                cursor: pointer;
                display: flex;
                height: 200px;
            }
            
            .property-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            }
            
            .card-image {
                position: relative;
                width: 280px;
                height: 200px;
                overflow: hidden;
                flex-shrink: 0;
            }
            
            .card-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.3s ease;
            }
            
            .property-card:hover .card-image img {
                transform: scale(1.05);
            }
            
            .image-placeholder {
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 3rem;
            }
            
            .card-badge {
                position: absolute;
                top: 15px;
                right: 15px;
            }
            
            .badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
            }
            
            .badge.available {
                background: #10b981;
                color: white;
            }
            
            .badge.unavailable {
                background: #ef4444;
                color: white;
            }
            
            .card-content {
                padding: 20px;
                flex: 1;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }
            
            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 15px;
            }
            
            .card-title {
                font-size: 1.4rem;
                font-weight: 700;
                color: #1f2937;
                margin: 0;
                line-height: 1.3;
                flex: 1;
                margin-right: 15px;
            }
            
            .card-price {
                font-size: 1.3rem;
                font-weight: 700;
                color: #2563eb;
                text-align: right;
                white-space: nowrap;
            }
            
            .price-unit {
                font-size: 0.9rem;
                color: #6b7280;
                font-weight: 400;
            }
            
            .card-details {
                display: flex;
                gap: 30px;
                margin-bottom: 15px;
            }
            
            .detail-item {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #6b7280;
                font-size: 0.95rem;
            }
            
            .detail-item i {
                width: 16px;
                color: #9ca3af;
            }
            
            .card-actions {
                text-align: right;
            }
            
            .btn-view {
                background: #2563eb;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 0.9rem;
            }
            
            .btn-view:hover {
                background: #1d4ed8;
                transform: translateY(-2px);
            }
            
            @media (max-width: 768px) {
                .search-results-header h1 {
                    font-size: 2rem;
                }
                
                .property-card {
                    flex-direction: column;
                    height: auto;
                }
                
                .card-image {
                    width: 100%;
                    height: 200px;
                }
                
                .card-content {
                    padding: 15px;
                }
                
                .card-details {
                    flex-direction: column;
                    gap: 10px;
                }
                
                .card-actions {
                    text-align: center;
                    margin-top: 15px;
                }
                
                .btn-view {
                    width: 100%;
                    justify-content: center;
                }
                
                .empty-actions {
                    flex-direction: column;
                    align-items: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="search-header">
            <div class="container">
                <c:choose>
                    <c:when test="${searchType == 'typeSearch'}">
                        <h1><i class="fas fa-building"></i> Danh sách phòng thuộc loại: <strong>${type}</strong></h1>
                        <p>Tìm thấy <strong>${fn:length(searchResults)}</strong> phòng phù hợp</p>
                    </c:when>
                    <c:when test="${searchType == 'citySearch'}">
                        <h1><i class="fas fa-map-marker-alt"></i> Kết quả tìm kiếm tại: <strong>${city}</strong></h1>
                        <p>Tìm thấy <strong>${fn:length(searchResults)}</strong> phòng phù hợp</p>
                    </c:when>
                    <c:when test="${searchType == 'fullSearch'}">
                        <h1><i class="fas fa-search"></i> Kết quả tìm kiếm tại <strong>${location}</strong> cho <strong>${guests}</strong> khách</h1>
                        <p>Tìm thấy <strong>${fn:length(searchResults)}</strong> phòng phù hợp</p>
                    </c:when>
                    <c:otherwise>
                        <h1><i class="fas fa-list"></i> Kết quả tìm kiếm</h1>
                        <p>Tìm thấy <strong>${fn:length(searchResults)}</strong> phòng phù hợp</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="container">
            <c:choose>
                <c:when test="${empty searchResults}">
                    <div class="error">
                        <h2><i class="fas fa-search"></i> Không tìm thấy phòng nào phù hợp</h2>
                        <p>Hãy thử thay đổi tiêu chí tìm kiếm hoặc quay lại trang chủ</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn">Về trang chủ</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="room" items="${searchResults}" varStatus="status">
                        <div class="room-card">
                            <div class="room-layout">
                                <!-- Hình ảnh bên trái -->
                                <div class="room-image">
                                    <c:choose>
                                        <c:when test="${not empty room.images}">
                                            <c:set var="imgArr" value="${fn:split(room.images, ',')}" />
                                            <c:set var="imgRaw" value="${imgArr[0]}" />
                                            <img src="${imgRaw}" alt="Room Image">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="image-placeholder">
                                                <i class="fas fa-bed"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <!-- Thông tin bên phải -->
                                <div class="room-info">
                                    <div class="room-header">
                                        <h3>${room.title}</h3>
                                        <span class="price">
                                            <fmt:formatNumber value="${room.price}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ
                                        </span>
                                    </div>
                                    
                                    <div class="room-details">
                                        <div class="detail-item">
                                            <i class="fas fa-users"></i>
                                            <span><strong>Sức chứa:</strong> ${room.capacity} khách</span>
                                        </div>
                                        <c:if test="${room.propertyId != null}">
                                            <div class="detail-item">
                                                <i class="fas fa-home"></i>
                                                <span><strong>Property:</strong> ${room.propertyId.name}</span>
                                            </div>
                                            <div class="detail-item">
                                                <i class="fas fa-map-marker-alt"></i>
                                                <span><strong>Thành phố:</strong> ${room.propertyId.city}</span>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <div class="room-actions">
                                        <a href="${pageContext.request.contextPath}/detail?id=${room.roomId}" class="btn">
                                            <i class="fas fa-eye"></i> Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <div class="back-button">
                        <a href="${pageContext.request.contextPath}/home" class="btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại trang chủ
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Debug section (có thể ẩn sau) -->
        <div class="debug" style="display: none;">
            <h3>Debug Information:</h3>
            <p>SearchType: <strong>${searchType}</strong></p>
            <p>Results Count: <strong>${fn:length(searchResults)}</strong></p>
            <p>Type Parameter: <strong>${type}</strong></p>
            <p>City Parameter: <strong>${city}</strong></p>
            <p>Location Parameter: <strong>${location}</strong></p>
            <p>Guests Parameter: <strong>${guests}</strong></p>
        </div>

        <jsp:include page="view/common/footer.jsp"/>
    </body>
</html>