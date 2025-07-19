<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Room Detail</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style_room_detail.css">
        <link rel="icon" type="image/x-icon" href="img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <!-- FontAwesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet" />
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div class="room-container">

            <c:forEach var="img" items="${imageList}">
                <img src="${pageContext.request.contextPath}/${img}" alt="Room Image" class="room-image"/>
            </c:forEach>

            <div class="room-title">${room.title}</div>

            <div class="room-info">
                <p><strong>Location:</strong> ${room.propertyId.city}</p>
                <p><strong>Type:</strong> ${room.propertyId.name}</p>
                <%-- Chia giá theo đơn vị phù hợp --%>
                <c:choose>
                    <c:when test="${room.price < 1000000}">
                        <c:set var="convertedPrice" value="${(room.price - (room.price % 1000))}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="convertedPrice" value="${(room.price - (room.price % 1000000))}" />
                    </c:otherwise>
                </c:choose>

                <p><strong>Price:</strong>
                    <fmt:formatNumber value="${convertedPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ/đêm
                </p>


                <p><strong>Description:</strong> ${room.description}</p>
                <p><strong>Guests:</strong> ${room.capacity}</p>
            </div>
            <a href="${pageContext.request.contextPath}/qr-payment?roomId=${room.roomId}" class="qr-btn">
                🧾 Thanh toán bằng QR
            </a>
            <a href="/home" class="back-btn">← Back to Home</a>

        </div>
        <jsp:include page="footer.jsp"/>
    </body>
</html>
