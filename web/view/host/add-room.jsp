<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserAccount" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Property" %>
<%@ page import="model.Amenity" %>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
        return;
    }
    List<Property> properties = (List<Property>) request.getAttribute("properties");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add New Room - Staytion</title>
        <link rel="stylesheet" href="../../css/style.css" />
        <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body>
        <!-- Header (giữ nguyên như cũ) -->


        <!-- Main Content -->
        <div class="min-h-screen bg-gray-50 py-8">
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="mb-8">
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-3xl font-bold text-gray-800">Thêm phòng </h1>
                            <p class="text-gray-600 mt-2">Thêm phòng mới cho cơ sở lưu trú của bạn</p>
                        </div>
                        <a href="<%=request.getContextPath()%>/host/dashboard" class="bg-gray-100 text-gray-700 px-6 py-3 rounded-lg flex items-center gap-2 hover:bg-gray-200 transition-all duration-200">
                            <i class="fas fa-arrow-left"></i> Trở lại Dashboard
                        </a>
                    </div>
                </div>
                <div class="bg-white rounded-xl shadow-lg border border-gray-100 overflow-hidden">
                    <div class="px-8 py-6 border-b border-gray-200">
                        <h2 class="text-xl font-semibold text-gray-800">Thông tin </h2>
                        <p class="text-gray-600 text-sm mt-1">Điền thông tin dưới đây để thêm phòng mới</p>
                    </div>
                    <form action="<%=request.getContextPath()%>/host/room?action=create" method="post" class="p-8" id="addRoomForm" enctype="multipart/form-data">
                        <!-- Error Message -->
                        <% if (request.getAttribute("error") != null) {%>
                        <div class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
                            <i class="fas fa-exclamation-triangle mr-2"></i>
                            <%= request.getAttribute("error")%>
                        </div>
                        <% } %>

                        <!-- Basic Information Section -->
                        <div class="mb-8">
                            <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                                <i class="fas fa-info-circle text-gray-600 mr-2"></i>
                                Thông tin cơ bản
                            </h3>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <!-- Room Title -->
                                <div class="col-span-2">
                                    <label for="title" class="block text-sm font-medium text-gray-700 mb-2">
                                        Tiêu đề phòng <span class="text-red-500">*</span>
                                    </label>
                                    <input type="text" id="title" name="title" required placeholder="e.g., Cozy Studio in City Center" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                                    <p class="text-sm text-gray-500 mt-1">Chọn một tiêu đề đặc biệt cho căn phòng của bạn</p>
                                </div>
                                <!-- Description -->
                                <div class="col-span-2">
                                    <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                                        Mô tả phòng <span class="text-red-500">*</span>
                                    </label>
                                    <textarea id="description" name="description" required rows="4" placeholder="Chọn phòng, tiện nghi, vị trí, và điều gì khiến nó đặc biệt..." class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200 resize-none"></textarea>
                                    <p class="text-sm text-gray-500 mt-1">Cung cấp thông tin và tính năng về phòng của bạn</p>
                                </div>
                                <!-- Select Property -->
                                <div class="col-span-2">
                                    <label for="propertyId" class="block text-sm font-medium text-gray-700 mb-2">
                                        Thuộc cơ sở lưu trú <span class="text-red-500">*</span>
                                    </label>
                                    <select name="propertyId" id="propertyId" required class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                                        <option value="">-- Chọn cơ sở lưu trú --</option>
                                        <% if (properties != null) {
                                                for (Property p : properties) {%>
                                        <option value="<%=p.getPropertyId()%>"><%=p.getName()%></option>
                                        <%  }
                                            } %>
                                    </select>
                                    <p class="text-sm text-gray-500 mt-1">Chọn cơ sở lưu trú mà phòng này thuộc về</p>
                                </div>
                            </div>
                        </div>

                        <!-- Room Details Section -->
                        <div class="mb-8">
                            <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                                <i class="fas fa-bed text-gray-600 mr-2"></i>
                                Chi tiết phòng
                            </h3>

                            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                                <!-- Capacity -->
                                <div>
                                    <label for="capacity" class="block text-sm font-medium text-gray-700 mb-2">
                                        Sức chứa (số khách) <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <input type="number" 
                                               id="capacity" 
                                               name="capacity" 
                                               required
                                               min="1"
                                               max="20"
                                               placeholder="2"
                                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                                        <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                                            <i class="fas fa-users text-gray-400"></i>
                                        </div>
                                    </div>
                                    <p class="text-sm text-gray-500 mt-1">Maximum number of guests</p>
                                </div>

                                <!-- Price -->
                                <div>
                                    <label for="price" class="block text-sm font-medium text-gray-700 mb-2">
                                        Price per Night <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <span class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                            <span class="text-gray-500 sm:text-sm">$</span>
                                        </span>
                                        <input type="number" 
                                               id="price" 
                                               name="price" 
                                               required
                                               step="0.01"
                                               min="0"
                                               placeholder="100.00"
                                               class="w-full pl-8 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                                    </div>
                                    <p class="text-sm text-gray-500 mt-1">Set your nightly rate in USD</p>
                                </div>

                                <!-- Status -->
                                <div>
                                    <label for="status" class="block text-sm font-medium text-gray-700 mb-2">
                                        Availability Status <span class="text-red-500">*</span>
                                    </label>
                                    <select id="status" 
                                            name="status" 
                                            required
                                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                                        <option value="">Select status</option>
                                        <option value="active">Available</option>
                                        <option value="inactive">Unavailable</option>
                                    </select>
                                    <p class="text-sm text-gray-500 mt-1">Choose if the room is ready for booking</p>
                                </div>
                            </div>
                        </div>

                        <!-- Image Upload Section -->
                        <div class="mb-8">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Upload Images</label>

                            <!-- ✅ input file đã sửa: không dùng class="hidden" nữa -->
                            <input type="file" name="images" id="images" multiple accept="image/*" style="display: none;">

                            <!-- ✅ button gọi input file -->
                            <button type="button" onclick="document.getElementById('images').click()"
                                    class="bg-gray-100 text-gray-700 px-6 py-3 rounded-lg hover:bg-gray-200">
                                <i class="fas fa-upload mr-2"></i> Chọn Files
                            </button>

                            <p class="text-sm text-gray-500 mt-2">Bạn có thể chọn nhiều ảnh. Tối đa 5MB cho mỗi ảnh.</p>

                            <!-- ✅ preview container: dùng style="display:none;" thay vì class hidden -->
                            <div id="imagePreview" class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-4" style="display: none;"></div>
                        </div>

<!--                         Amenities Section 
                        <div class="mb-8">
                            <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                                <i class="fas fa-star text-gray-600 mr-2"></i>
                                Amenities (Optional)
                            </h3>

                            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                                <%
                                    List<Amenity> amenities = (List<Amenity>) request.getAttribute("amenities");
                                    if (amenities != null) {
                                        for (Amenity amenity : amenities) {
                                %>
                                <label class="flex items-center space-x-3 cursor-pointer">
                                    <input type="checkbox" name="amenities" value="<%= amenity.getAmenityId()%>" class="rounded text-gray-600 focus:ring-gray-500">
                                    <span class="text-gray-700"><%= amenity.getName()%></span>
                                </label>
                                <%
                                        }
                                    }
                                %>
                            </div>
                        </div>-->

                        <!-- Form Actions -->
                        <div class="flex flex-col sm:flex-row gap-4 pt-6 border-t border-gray-200">
                            <button type="submit" 
                                    class="flex-1 bg-gray-700 text-white px-8 py-4 rounded-lg hover:bg-gray-800 transition-all duration-200 shadow-lg flex items-center justify-center gap-2">
                                <i class="fas fa-plus"></i>
                                Tạo phòng
                            </button>
                            <button type="button" 
                                    onclick="window.location.href = '<%=request.getContextPath()%>/host/dashboard'"
                                    class="px-8 py-4 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all duration-200">
                                Huỷ thao tác
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Tips Section -->
                <div class="mt-8 bg-blue-50 border border-blue-200 rounded-lg p-6">
                    <h3 class="text-lg font-semibold text-blue-800 mb-3 flex items-center">
                        <i class="fas fa-lightbulb text-blue-600 mr-2"></i>
                        Mẹo để đăng phòng hiệu quả
                    </h3>
                    <ul class="space-y-2 text-blue-700">
                        <li class="flex items-start">
                            <i class="fas fa-check text-blue-600 mr-2 mt-1 text-sm"></i>
                            <span>Sử dụng ảnh rõ nét, chất lượng cao để thu hút người xem</span>
                        </li>
                        <li class="flex items-start">
                            <i class="fas fa-check text-blue-600 mr-2 mt-1 text-sm"></i>
                            <span> Mô tả chi tiết về tiện nghi, điểm nổi bật và vị trí</span>
                        </li>
                        <li class="flex items-start">
                            <i class="fas fa-check text-blue-600 mr-2 mt-1 text-sm"></i>
                            <span>Đặt mức giá hợp lý so với các phòng tương tự</span>
                        </li>
                        <li class="flex items-start">
                            <i class="fas fa-check text-blue-600 mr-2 mt-1 text-sm"></i>
                            <span>Trung thực về sức chứa và tiện ích</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>



        <script>
            // Toggle account menu
            document.addEventListener('DOMContentLoaded', function () {
                const avatar = document.querySelector('.avatar');
                const accountInterface = document.querySelector('.account-interface');
                if (avatar && accountInterface) {
                    avatar.addEventListener('click', function () {
                        accountInterface.classList.toggle('active');
                    });
                    // Close menu when clicking outside
                    document.addEventListener('click', function (event) {
                        if (!avatar.contains(event.target) && !accountInterface.contains(event.target)) {
                            accountInterface.classList.remove('active');
                        }
                    });
                }

                // Form validation
                const form = document.getElementById('addRoomForm');
                if (form) {
                    form.addEventListener('submit', function (e) {
                        const title = document.getElementById('title').value.trim();
                        const description = document.getElementById('description').value.trim();
                        const capacity = document.getElementById('capacity').value;
                        const price = document.getElementById('price').value;
                        const status = document.getElementById('status').value;
                        const propertyId = document.getElementById('propertyId').value;
                        if (!title || !description || !capacity || !price || !status || !propertyId) {
                            e.preventDefault();
                            alert('Please fill in all required fields.');
                            return false;
                        }

                        if (capacity < 1 || capacity > 20) {
                            e.preventDefault();
                            alert('Capacity must be between 1 and 20 guests.');
                            return false;
                        }

                        if (price <= 0) {
                            e.preventDefault();
                            alert('Price must be greater than 0.');
                            return false;
                        }
                    });
                }
                // Image preview
                const imageInput = document.getElementById('images');
                const previewContainer = document.getElementById('imagePreview');

                imageInput.addEventListener('change', function (event) {
                    const files = event.target.files;
                    previewContainer.innerHTML = '';

                    if (files.length === 0) {
                        previewContainer.style.display = 'none';
                        return;
                    }

                    previewContainer.style.display = 'grid';
                    console.log("Selected files:", files.length);

                    for (let i = 0; i < files.length; i++) {
                        const file = files[i];

                        if (!file.type.startsWith('image/'))
                            continue;

                        const reader = new FileReader();
                        reader.onload = function (e) {
                            const img = document.createElement('img');
                            img.src = e.target.result;
                            img.className = 'object-cover w-full h-40 rounded-lg border';
                            previewContainer.appendChild(img);
                        };
                        reader.readAsDataURL(file);
                    }
                });
            });
        </script>
    </body>
</html> 