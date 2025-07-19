<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Danh sách phòng - ${type}</title>
</head>
<body>

    <c:if test="${empty rooms}">
        <p>Không có phòng nào thuộc loại này.</p>
    </c:if>

    <c:forEach var="room" items="${rooms}">
        <div class="card" onclick="window.location.href='detail?id=${room.roomId}'">
            <div class="heart-icon"><i class="fa-regular fa-heart"></i></div>
            <div class="card-footer">
                <div class="image-placeholder"></div>
                <h4>${room.title}</h4>
                <p>${room.propertyId.city}</p>
            </div>
        </div>
    </c:forEach>

</body>
</html>
