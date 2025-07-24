<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>403 - Access Denied</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_header.css" />
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <style>
        body {
            background: #f8fafc;
            font-family: 'Noto Sans', Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .error403-container {
            max-width: 480px;
            margin: 80px auto 0 auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(44,62,80,0.10);
            padding: 40px 32px 32px 32px;
            text-align: center;
        }
        .error403-icon {
            font-size: 4.5rem;
            color: #f59e42;
            margin-bottom: 18px;
        }
        .error403-title {
            font-size: 2.2rem;
            font-weight: 800;
            color: #003B95;
            margin-bottom: 10px;
        }
        .error403-message {
            font-size: 1.15rem;
            color: #444;
            margin-bottom: 24px;
        }
        .error403-actions a {
            display: inline-block;
            margin: 0 10px;
            padding: 12px 28px;
            background: linear-gradient(90deg, #003B95 0%, #2563eb 100%);
            color: #fff;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            transition: background 0.2s, box-shadow 0.2s;
            box-shadow: 0 2px 8px rgba(44,62,80,0.10);
        }
        .error403-actions a:hover {
            background: linear-gradient(90deg, #2563eb 0%, #003B95 100%);
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="error403-container">
        <div class="error403-icon">
            <i class="fas fa-ban"></i>
        </div>
        <div class="error403-title">403 - Truy cập trái phép</div>
        <div class="error403-message">
            Bạn không đủ quyền để truy cập.<br>
            Vui lòng kiểm tra lại tài khoản.
        </div>
        <div class="error403-actions">
            <a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Về lại trang chủ</a>
            <a href="javascript:history.back()"><i class="fas fa-arrow-left"></i> Quay lại</a>
        </div>
    </div>
</body>
</html> 