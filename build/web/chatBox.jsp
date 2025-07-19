<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Property Listings</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap & FontAwesome -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <!-- Custom CSS -->
    <style>
        body { font-family: Arial, sans-serif; }
        .property-card {
            border-radius: 10px;
            padding: 10px;
            transition: 0.3s;
            position: relative;
            height: 100%;
            border: 1px solid #eee;
        }
        .property-card:hover { box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .property-image {
            background-color: #eee;
            border-radius: 10px;
            height: 180px;
            margin-bottom: 10px;
            border: 2px solid #ddd;
        }
        .wishlist-icon {
            position: absolute;
            top: 15px;
            right: 15px;
            color: #ccc;
            cursor: pointer;
            font-size: 20px;
            transition: color 0.3s ease;
        }
        .wishlist-icon.liked { color: red; }
        .price { font-weight: bold; color: #666; }
        .rating-dots span {
            display: inline-block;
            width: 6px; height: 6px;
            background: #bbb;
            border-radius: 50%;
            margin-right: 4px;
        }

        /* Chatbox - IMPROVED VERSION */
       
    </style>
</head>

<body class="container py-5">

<!-- Chat Icon với hiệu ứng -->


<!-- Chatbox - IMPROVED -->

<!-- Menu - Giữ nguyên -->
<div class="d-flex justify-content-between align-items-center top-menu">
    <div>
        <a href="#" class="me-3">Apartments</a>
        <a href="#" class="me-3">Houses</a>
        <a href="#" class="me-3">Villas</a>
        <a href="#" class="me-3">Homestays</a>
        <a href="#" class="me-3">More</a>
    </div>
    <button class="btn btn-outline-secondary">Filters</button>
</div>

<!-- Property Listings - Giữ nguyên -->
<div class="row g-4">
    <%
        for (int i = 1; i <= 9; i++) {
    %>
    <div class="col-md-4">
        <div class="property-card">
            <div class="property-image">
                <span class="wishlist-icon"><i class="fa-regular fa-heart"></i></span>
            </div>
            <div class="price">$<%= 1000 + i * 100 %> - <%= 5000 + i * 200 %> USD</div>
            <div class="fw-bold">Property <%= i %></div>
            <div class="text-muted"><%= 100 + i %> Example Street, LA, USA</div>
            <div class="rating-dots mt-2">
                <span></span><span></span><span></span><span></span>
            </div>
        </div>
    </div>
    <% } %>
</div>

<!-- IMPROVED JavaScript -->
<jsp:include page="chatBoxElement.jsp" />

</body>
</html>