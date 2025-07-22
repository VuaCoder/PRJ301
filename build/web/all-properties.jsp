<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Tất cả tài sản</title>
        <link rel="stylesheet" href="css/style_result.css">
        <link rel="icon" type="image/x-icon" href="img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>
    <body>
        <div class="container">
            <div class="search-header">
                <h1>Tất cả tài sản hiện có</h1>
                <p>Hiển thị toàn bộ phòng đang hoạt động trên hệ thống.</p>
            </div>
            <div class="room-listing">
                <c:choose>
                    <c:when test="${not empty searchResults}">
                        <div class="room-list-grid">
                            <c:forEach var="room" items="${searchResults}">
                                <div class="room-card">
                                    <c:set var="imgArr" value="${fn:split(room.images, ',')}" />
                                    <c:set var="imgRaw" value="${imgArr[0]}" />
                                    <img src="${imgRaw}" alt="Room Image" class="room-img"/>
                                    <div class="room-info">
                                        <h3>${room.title}</h3>
                                        <p class="room-city"><i class="fa-solid fa-location-dot"></i> ${room.city}</p>
                                        <p class="room-desc">${room.description}</p>
                                        <p class="room-price">
                                            <fmt:formatNumber value="${room.price}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ
                                        </p>
                                        <a href="detail?id=${room.roomId}" class="btn btn-primary">Xem chi tiết</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="error">
                            <h2>Không có phòng nào!</h2>
                            <a href="home">Quay lại trang chủ</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div style="margin-top: 32px; text-align: center;">
                <a href="home" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Quay lại trang chủ</a>
            </div>
        </div>
    </body>
</html>
<style>
.room-list-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
    gap: 32px;
    margin-top: 32px;
}
.room-card {
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    overflow: hidden;
    display: flex;
    flex-direction: column;
    transition: box-shadow 0.2s, transform 0.2s;
}
.room-card:hover {
    box-shadow: 0 6px 24px #0002;
    transform: translateY(-6px) scale(1.03);
}
.room-img {
    width: 100%;
    height: 200px;
    object-fit: cover;
    display: block;
}
.room-info {
    padding: 18px 18px 14px 18px;
    display: flex;
    flex-direction: column;
    gap: 8px;
}
.room-info h3 {
    font-size: 1.2rem;
    font-weight: 700;
    color: #222;
    margin: 0 0 2px 0;
    line-height: 1.3;
    min-height: 2.6em;
    max-height: 2.6em;
    overflow: hidden;
    text-overflow: ellipsis;
}
.room-city {
    color: #888;
    font-size: 0.97rem;
    margin: 0 0 2px 0;
    font-weight: 400;
    line-height: 1.2;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.room-desc {
    color: #555;
    font-size: 0.98rem;
    margin: 0 0 2px 0;
    font-weight: 400;
    line-height: 1.3;
    overflow: hidden;
    text-overflow: ellipsis;
}
.room-price {
    font-size: 1.08rem;
    font-weight: 600;
    color: #2563eb;
    margin-top: 4px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.btn {
    display: inline-block;
    padding: 10px 24px;
    border-radius: 8px;
    background: #2563eb;
    color: #fff;
    font-weight: 600;
    text-decoration: none;
    margin-top: 10px;
    transition: background 0.2s;
}
.btn:hover {
    background: #1a2340;
}
.btn-secondary {
    background: #888;
    color: #fff;
    margin-top: 0;
}
.btn-secondary:hover {
    background: #222;
}
.error {
    background: #fef2f2;
    color: #dc2626;
    padding: 20px;
    border-radius: 8px;
    border: 1px solid #fecaca;
    text-align: center;
    margin: 20px 0;
}
</style> 