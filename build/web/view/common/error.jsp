<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lỗi - Staytion</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_home.css" />
        <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .error-container {
                max-width: 600px;
                margin: 100px auto;
                text-align: center;
                padding: 40px;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            }
            
            .error-icon {
                font-size: 4rem;
                color: #dc2626;
                margin-bottom: 20px;
            }
            
            .error-title {
                color: #1f2937;
                font-size: 2rem;
                margin-bottom: 15px;
            }
            
            .error-message {
                color: #6b7280;
                font-size: 1.1rem;
                margin-bottom: 30px;
                line-height: 1.6;
            }
            
            .error-actions {
                display: flex;
                gap: 15px;
                justify-content: center;
                flex-wrap: wrap;
            }
            
            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                text-decoration: none;
                cursor: pointer;
                transition: all 0.2s;
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
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        
        <div class="error-container">
            <div class="error-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            
            <h1 class="error-title">Đã xảy ra lỗi</h1>
            
            <p class="error-message">
                <c:choose>
                    <c:when test="${not empty error}">
                        ${error}
                    </c:when>
                    <c:otherwise>
                        Có lỗi xảy ra trong quá trình xử lý yêu cầu của bạn. 
                        Vui lòng thử lại sau hoặc liên hệ với chúng tôi nếu vấn đề vẫn tiếp tục.
                    </c:otherwise>
                </c:choose>
            </p>
            
            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                    <i class="fas fa-home"></i> Về trang chủ
                </a>
                <a href="javascript:history.back()" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>
        
        <jsp:include page="footer.jsp" />
    </body>
</html> 