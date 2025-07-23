<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserAccount" %>
<%@ page import="model.Room" %>
<%@ page import="model.Property" %>
<%@ page import="model.Amenity" %>
<%@ page import="java.util.List" %>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
        return;
    }
    Room room = (Room) request.getAttribute("room");
    List<Property> properties = (List<Property>) request.getAttribute("properties");
    List<Amenity> amenities = (List<Amenity>) request.getAttribute("amenities");
    if (room == null) {
        response.sendRedirect(request.getContextPath() + "/host/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Room - Staytion</title>
        <link rel="stylesheet" href="../../css/style.css" />
        <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body>
        <div class="min-h-screen bg-gray-50 py-8">
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="mb-8">
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-3xl font-bold text-gray-800">Sửa thông tin phòng</h1>
                            <p class="text-gray-600 mt-2">Cập nhật thông tin phòng của bạn</p>
                        </div>
                        <a href="<%=request.getContextPath()%>/host/dashboard" class="bg-gray-100 text-gray-700 px-6 py-3 rounded-lg flex items-center gap-2 hover:bg-gray-200 transition-all duration-200">
                            <i class="fas fa-arrow-left"></i> Trở lại Dashboard
                        </a>
                    </div>
                </div>
                <div class="bg-white rounded-xl shadow-lg border border-gray-100 overflow-hidden">
                    <div class="px-8 py-6 border-b border-gray-200">
                        <h2 class="text-xl font-semibold text-gray-800">Cập nhật thông tin phòng</h2>
                        <p class="text-gray-600 text-sm mt-1">Chỉnh sửa thông tin bên dưới để cập nhập lại phòng của bạn</p>
                    </div>
                    <form action="<%=request.getContextPath()%>/host/room?action=edit" method="post" class="p-8" id="editRoomForm" enctype="multipart/form-data">
                        <input type="hidden" name="id" value="<%= room.getRoomId()%>">
                        <input type="hidden" name="status" value="${room.status}" />
                        <!-- Room Title -->
                        <div class="mb-6">
                            <label for="title" class="block text-sm font-medium text-gray-700 mb-2">Tiêu đề Phòng <span class="text-red-500">*</span></label>
                            <input type="text" id="title" name="title" required value="<%= room.getTitle() != null ? room.getTitle() : ""%>" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                        </div>
                        <!-- Description -->
                        <div class="mb-6">
                            <label for="description" class="block text-sm font-medium text-gray-700 mb-2">Mô tả <span class="text-red-500">*</span></label>
                            <textarea id="description" name="description" required rows="4" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200 resize-none"><%= room.getDescription() != null ? room.getDescription() : ""%></textarea>
                        </div>
                        <!-- Property (không cho sửa property khi edit, chỉ hiển thị) -->
                        <div class="mb-6">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Cơ sở lưu trú</label>
                            <input type="text" value="<%= room.getPropertyName()%>" class="w-full px-4 py-3 border border-gray-200 rounded-lg bg-gray-100" readonly>
                        </div>
                        <!-- Capacity -->
                        <div class="mb-6">
                            <label for="capacity" class="block text-sm font-medium text-gray-700 mb-2">Số người có thể ở <span class="text-red-500">*</span></label>
                            <input type="number" id="capacity" name="capacity" required min="1" max="20" value="<%= room.getCapacity()%>" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                        </div>
                        <!-- Price -->
                        <div class="mb-6">
                            <label for="price" class="block text-sm font-medium text-gray-700 mb-2">Giá <span class="text-red-500">*</span></label>
                            <input type="number" id="price" name="price" required step="0.01" min="0" value="<%= room.getPrice() != null ? room.getPrice() : ""%>" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                        </div>
                        <!-- Status -->
                        <div class="mb-6">
                            <label for="status" class="block text-sm font-medium text-gray-700 mb-2">Trạng thái <span class="text-red-500">*</span></label>
                            <select id="status" name="status" required class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                                <option value="Available" <%= "Available".equalsIgnoreCase(room.getStatus()) ? "selected" : ""%>>Available</option>
                                <option value="Unavailable" <%= "Unavailable".equalsIgnoreCase(room.getStatus()) ? "selected" : ""%>>Unavailable</option>
                            </select>
                        </div>
                        <!-- Amenities (nếu muốn show, cần truyền amenityList của room) -->
                        <div class="mb-8">
                            <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                                <i class="fas fa-star text-gray-600 mr-2"></i>
                                Tiện nghi (Optional)
                            </h3>
                            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                                <% if (amenities != null) {
                                        List<Amenity> selectedAmenities = room.getAmenityList();
                                        for (Amenity amenity : amenities) {
                                            boolean checked = false;
                                            if (selectedAmenities != null) {
                                                for (Amenity a : selectedAmenities) {
                                                    if (a.getAmenityId().equals(amenity.getAmenityId())) {
                                                        checked = true;
                                                        break;
                                                    }
                                                }
                                            }
                                %>
                                <label class="flex items-center space-x-3 cursor-pointer">
                                    <input type="checkbox" name="amenities" value="<%= amenity.getAmenityId()%>" class="rounded text-gray-600 focus:ring-gray-500" <%= checked ? "checked" : ""%>>
                                    <span class="text-gray-700"><%= amenity.getName()%></span>
                                </label>
                                <%      }
                                    }
                                %>
                            </div>
                        </div>
                        <!-- Hiển thị ảnh hiện tại nếu có -->
                        <% String[] images = room.getImages() != null ? room.getImages().split(",") : new String[0];
                        if (images.length > 0 && !images[0].isEmpty()) { %>
                        <div class="mb-6">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Ảnh hiện tại</label>
                            <input type="hidden" name="oldImages" value="<%= room.getImages() %>">
                            <input type="hidden" id="oldImagesToDelete" name="oldImagesToDelete">
                            <input type="hidden" id="selectedReplaceIndexOld" name="replaceIndex">
                            <div id="oldImagesPreview" style="display:flex;gap:12px;flex-wrap:wrap;">
                                <% for (int i = 0; i < images.length; i++) { 
                                    String img = images[i].trim();
                                    String imgUrl = (img.startsWith("http")) ? img : (request.getContextPath() + "/img/" + img);
                                %>
                                    <div class="old-img-wrapper" data-index="<%=i%>" style="display:flex;flex-direction:column;align-items:center;cursor:pointer;position:relative;">
                                        <img src="<%= imgUrl %>" style="width:120px;height:90px;object-fit:cover;border-radius:10px;box-shadow:0 2px 8px #0001;">
                                        <span class="delete-old-img" data-index="<%=i%>" style="position:absolute;top:2px;right:6px;background:#fff;border-radius:50%;width:20px;height:20px;display:flex;align-items:center;justify-content:center;font-weight:bold;color:#d00;cursor:pointer;box-shadow:0 1px 4px #0002;z-index:2;">×</span>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                        <% }%>
                        <!-- Preview New Images -->
                        <div class="mb-6" id="previewNewImagesContainer" style="display:none;">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Preview New Images</label>
                            <div id="previewNewImages" style="display:flex;gap:12px;flex-wrap:wrap;"></div>
                            <input type="hidden" id="selectedReplaceIndex" name="replaceIndex">
                        </div>
                        <!-- Input upload ảnh mới -->
                        <div class="mb-6">
                            <label for="images" class="block text-sm font-medium text-gray-700 mb-2">Cập nhật ảnh mới</label>
                            <input type="file" id="images" name="images" multiple accept="image/*" class="block w-full text-sm text-gray-500">
                            <h4 class="text-xs text-gray-400 mt-1">Bỏ qua để giữ ảnh hiện tại.</h4>
                        </div>
                        <!-- Form Actions -->
                        <div class="flex flex-col sm:flex-row gap-4 pt-6 border-t border-gray-200">
                            <button type="submit" class="flex-1 bg-gray-700 text-white px-8 py-4 rounded-lg hover:bg-gray-800 transition-all duration-200 shadow-lg flex items-center justify-center gap-2">
                                <i class="fas fa-save"></i> Cập nhật phòng của bạn
                            </button>
                            <button type="button" onclick="window.location.href = '<%=request.getContextPath()%>/host/dashboard'" class="px-8 py-4 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all duration-200">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script>
            // Preview new images, ẩn tickbox, cho phép chọn ảnh để thay, và xóa ảnh preview
            const imageInput = document.getElementById('images');
            const previewNewImages = document.getElementById('previewNewImages');
            const previewNewImagesContainer = document.getElementById('previewNewImagesContainer');
            const replaceLabels = document.querySelectorAll('.replace-label');
            const selectedReplaceIndex = document.getElementById('selectedReplaceIndex');
            let previewFiles = [];
            if(imageInput) {
                imageInput.addEventListener('change', function(event) {
                    const files = Array.from(event.target.files);
                    previewFiles = files;
                    previewNewImages.innerHTML = '';
                    if (files.length === 0) {
                        previewNewImagesContainer.style.display = 'none';
                        replaceLabels.forEach(lab => lab.style.display = '');
                        selectedReplaceIndex.value = '';
                        return;
                    }
                    previewNewImagesContainer.style.display = '';
                    replaceLabels.forEach(lab => lab.style.display = 'none');
                    files.forEach((file, idx) => {
                        if (!file.type.startsWith('image/')) return;
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            const wrapper = document.createElement('div');
                            wrapper.style.position = 'relative';
                            wrapper.style.display = 'inline-block';
                            wrapper.style.marginRight = '8px';
                            wrapper.style.cursor = 'pointer';
                            wrapper.className = 'preview-img-wrapper';
                            const img = document.createElement('img');
                            img.src = e.target.result;
                            img.style.width = '120px';
                            img.style.height = '90px';
                            img.style.objectFit = 'cover';
                            img.style.borderRadius = '10px';
                            img.style.boxShadow = '0 2px 8px #0001';
                            img.title = 'Click để chọn thay ảnh cũ';
                            // Highlight nếu được chọn
                            img.addEventListener('click', function() {
                                document.querySelectorAll('.preview-img-wrapper').forEach(w => w.style.outline = 'none');
                                wrapper.style.outline = '2px solid #007bff';
                                selectedReplaceIndex.value = idx;
                            });
                            // Nút x xoá ảnh
                            const closeBtn = document.createElement('span');
                            closeBtn.textContent = '×';
                            closeBtn.style.position = 'absolute';
                            closeBtn.style.top = '2px';
                            closeBtn.style.right = '6px';
                            closeBtn.style.background = '#fff';
                            closeBtn.style.borderRadius = '50%';
                            closeBtn.style.width = '20px';
                            closeBtn.style.height = '20px';
                            closeBtn.style.display = 'flex';
                            closeBtn.style.alignItems = 'center';
                            closeBtn.style.justifyContent = 'center';
                            closeBtn.style.fontWeight = 'bold';
                            closeBtn.style.color = '#d00';
                            closeBtn.style.cursor = 'pointer';
                            closeBtn.style.boxShadow = '0 1px 4px #0002';
                            closeBtn.title = 'Xoá ảnh này';
                            closeBtn.onclick = function(ev) {
                                ev.stopPropagation();
                                previewFiles.splice(idx, 1);
                                // Tạo lại FileList mới
                                const dataTransfer = new DataTransfer();
                                previewFiles.forEach(f => dataTransfer.items.add(f));
                                imageInput.files = dataTransfer.files;
                                imageInput.dispatchEvent(new Event('change'));
                            };
                            wrapper.appendChild(img);
                            wrapper.appendChild(closeBtn);
                            previewNewImages.appendChild(wrapper);
                        };
                        reader.readAsDataURL(file);
                    });
                });
            }
        </script>
        <script>
            // Click vào ảnh cũ để chọn vị trí thay thế
            const oldImagesPreview = document.getElementById('oldImagesPreview');
            const selectedReplaceIndexOld = document.getElementById('selectedReplaceIndexOld');
            const oldImagesToDelete = document.getElementById('oldImagesToDelete');
            if (oldImagesPreview) {
                oldImagesPreview.querySelectorAll('.old-img-wrapper').forEach(div => {
                    div.addEventListener('click', function(e) {
                        // Nếu click vào nút x thì không chọn thay thế
                        if (e.target.classList.contains('delete-old-img')) return;
                        oldImagesPreview.querySelectorAll('.old-img-wrapper').forEach(w => w.style.outline = 'none');
                        div.style.outline = '2px solid #007bff';
                        selectedReplaceIndexOld.value = div.getAttribute('data-index');
                    });
                });
                // Xoá ảnh cũ khỏi preview và đánh dấu vào hidden input
                oldImagesPreview.querySelectorAll('.delete-old-img').forEach(btn => {
                    btn.addEventListener('click', function(e) {
                        e.stopPropagation();
                        const idx = btn.getAttribute('data-index');
                        // Ẩn ảnh khỏi preview
                        btn.parentElement.style.display = 'none';
                        // Cập nhật hidden input oldImagesToDelete
                        let toDelete = oldImagesToDelete.value ? oldImagesToDelete.value.split(',') : [];
                        if (!toDelete.includes(idx)) toDelete.push(idx);
                        oldImagesToDelete.value = toDelete.join(',');
                    });
                });
            }
        </script>
    </body>
</html> 