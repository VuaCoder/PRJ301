<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
    </head>
    <body>

        <jsp:include page="view/common/header.jsp"/>

        <c:choose>
            <c:when test="${searchType == 'typeSearch'}">
                <h2 style="margin: 20px;">Danh sách phòng thuộc loại: <strong>${type}</strong></h2>
            </c:when>
            <c:when test="${searchType == 'citySearch'}">
                <h2 style="margin: 20px;">Kết quả tìm kiếm tại: <strong>${city}</strong></h2>
            </c:when>
            <c:when test="${searchType == 'fullSearch'}">
                <h2 style="margin: 20px;">Kết quả tìm kiếm tại <strong>${location}</strong> cho <strong>${guests}</strong> khách</h2>
            </c:when>
            <c:otherwise>
                <h2 style="margin: 20px;">Kết quả tìm kiếm</h2>
            </c:otherwise>
        </c:choose>

        <main class="property-list ${empty searchResults ? 'empty' : ''}">
            <c:choose>
                <c:when test="${empty searchResults}">
                    <div class="centered-message">
                        <h1>Không tìm thấy phòng nào phù hợp với yêu cầu của bạn :(</h1>
                        <a href="/home">Quay lại trang chính</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="room" items="${searchResults}">
                        <div class="property-card">
                            <div class="card-image">
                                <c:if test="${not empty room.images}">
                                    <img src="${room.images}" alt="Room Image">
                                </c:if>
                            </div>
                            <div class="card-info">
                                <div class="price">
                                    <fmt:formatNumber value="${room.price}" type="number" groupingUsed="true"/> VNĐ
                                </div>
                            </div>
                            <div class="card-title">${room.title}</div>
                            <div class="card-location">
                                ${room.propertyId.name} - ${room.propertyId.city}
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </main>

        <jsp:include page="view/common/footer.jsp"/>

    </body>
</html>