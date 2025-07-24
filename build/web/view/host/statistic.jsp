<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thống kê - Staytion Host</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body class="bg-gray-100 font-sans">
        <jsp:include page="/view/common/header_admin.jsp" />
        <div class="max-w-6xl mx-auto px-6 py-10">
            <!-- Booking Statistics Section -->
            <div class="bg-white rounded-xl shadow-lg border p-6 mb-8">
                <h2 class="text-2xl font-bold text-gray-800 mb-6">Thống kê đặt phòng</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                    <!-- Phòng đang cho thuê -->
                    <div class="bg-blue-50 rounded-lg p-6 text-center shadow">
                        <div class="text-4xl mb-2 text-blue-600"><i class="fas fa-door-open"></i></div>
                        <div class="text-3xl font-bold">
                            <c:choose>
                                <c:when test="${not empty activeRoomCount}">${activeRoomCount}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="text-gray-700 font-semibold">Phòng đang cho thuê</div>
                    </div>

                    <!-- Phòng trống -->
                    <div class="bg-yellow-50 rounded-lg p-6 text-center shadow">
                        <div class="text-4xl mb-2 text-yellow-600"><i class="fas fa-bed"></i></div>
                        <div class="text-3xl font-bold">
                            <c:choose>
                                <c:when test="${not empty emptyRoomCount}">${emptyRoomCount}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="text-gray-700 font-semibold">Phòng trống</div>
                    </div>
                </div>

                <!-- Revenue Chart Section -->
                <div class="bg-purple-50 rounded-lg p-6 text-center shadow">
                    <h3 class="text-xl font-semibold text-gray-700 mb-4">Biểu đồ doanh thu theo tháng</h3>
                    <c:choose>
                        <c:when test="${not empty monthlyRevenue}">
                            <canvas id="revenueChart" height="100"></canvas>
                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    const revenueMap = {};
                                <c:forEach var="entry" items="${monthlyRevenue}">
                                revenueMap["${entry.key}"] = ${entry.value};
                                </c:forEach>
                                    const labels = Object.keys(revenueMap);
                                    const values = Object.values(revenueMap);
                                    const ctx = document.getElementById('revenueChart').getContext('2d');
                                    new Chart(ctx, {
                                        type: 'line',
                                        data: {
                                            labels: labels,
                                            datasets: [{
                                                    label: 'Doanh thu (VNĐ)',
                                                    data: values,
                                                    borderColor: '#7c3aed',
                                                    backgroundColor: 'rgba(124,58,237,0.1)',
                                                    fill: true,
                                                    tension: 0.3
                                                }]
                                        },
                                        options: {
                                            responsive: true,
                                            plugins: {
                                                legend: {display: false}
                                            },
                                            scales: {
                                                y: {
                                                    ticks: {
                                                        callback: function (value) {
                                                            return new Intl.NumberFormat('vi-VN').format(value) + ' VND';
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    });
                                });
                            </script>

                            <!-- Tổng doanh thu -->
                            <div class="mt-4 text-lg font-semibold text-gray-800">
                                Tổng doanh thu: 
                                <span class="text-purple-600">
                                    <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" />
                                </span> VND
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-gray-500 italic">Không có dữ liệu doanh thu trong khoảng thời gian này.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <jsp:include page="/view/common/footer.jsp" />
    </body>
</html>