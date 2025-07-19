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
        <link rel="icon" type="image/x-icon" href="../../img/favicon.ico">
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
                            <h1 class="text-3xl font-bold text-gray-800">Edit Room</h1>
                            <p class="text-gray-600 mt-2">Update your room listing information</p>
                        </div>
                        <a href="<%=request.getContextPath()%>/host/dashboard" class="bg-gray-100 text-gray-700 px-6 py-3 rounded-lg flex items-center gap-2 hover:bg-gray-200 transition-all duration-200">
                            <i class="fas fa-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>
                </div>
                <div class="bg-white rounded-xl shadow-lg border border-gray-100 overflow-hidden">
                    <div class="px-8 py-6 border-b border-gray-200">
                        <h2 class="text-xl font-semibold text-gray-800">Update Room Information</h2>
                        <p class="text-gray-600 text-sm mt-1">Modify the details below to update your room listing</p>
                    </div>
                    <form action="<%=request.getContextPath()%>/host/room?action=edit" method="post" class="p-8" id="editRoomForm" enctype="multipart/form-data">
                        <input type="hidden" name="id" value="<%= room.getRoomId()%>">
                        <input type="hidden" name="status" value="${room.status}" />
                        <!-- Room Title -->
                        <div class="mb-6">
                            <label for="title" class="block text-sm font-medium text-gray-700 mb-2">Room Title <span class="text-red-500">*</span></label>
                            <input type="text" id="title" name="title" required value="<%= room.getTitle() != null ? room.getTitle() : ""%>" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                        </div>
                        <!-- Description -->
                        <div class="mb-6">
                            <label for="description" class="block text-sm font-medium text-gray-700 mb-2">Description <span class="text-red-500">*</span></label>
                            <textarea id="description" name="description" required rows="4" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200 resize-none"><%= room.getDescription() != null ? room.getDescription() : ""%></textarea>
                        </div>
                        <!-- Property (không cho sửa property khi edit, chỉ hiển thị) -->
                        <div class="mb-6">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Property</label>
                            <input type="text" value="<%= room.getPropertyName()%>" class="w-full px-4 py-3 border border-gray-200 rounded-lg bg-gray-100" readonly>
                        </div>
                        <!-- Capacity -->
                        <div class="mb-6">
                            <label for="capacity" class="block text-sm font-medium text-gray-700 mb-2">Guest Capacity <span class="text-red-500">*</span></label>
                            <input type="number" id="capacity" name="capacity" required min="1" max="20" value="<%= room.getCapacity()%>" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                        </div>
                        <!-- Price -->
                        <div class="mb-6">
                            <label for="price" class="block text-sm font-medium text-gray-700 mb-2">Price per Night <span class="text-red-500">*</span></label>
                            <input type="number" id="price" name="price" required step="0.01" min="0" value="<%= room.getPrice() != null ? room.getPrice() : ""%>" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                        </div>
                        <!-- Status -->
                        <div class="mb-6">
                            <label for="status" class="block text-sm font-medium text-gray-700 mb-2">Availability Status <span class="text-red-500">*</span></label>
                            <select id="status" name="status" required class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-500 focus:border-transparent transition-all duration-200">
                                <option value="Available" <%= "Available".equalsIgnoreCase(room.getStatus()) ? "selected" : ""%>>Available</option>
                                <option value="Unavailable" <%= "Unavailable".equalsIgnoreCase(room.getStatus()) ? "selected" : ""%>>Unavailable</option>
                            </select>
                        </div>
                        <!-- Amenities (nếu muốn show, cần truyền amenityList của room) -->
                        <div class="mb-8">
                            <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                                <i class="fas fa-star text-gray-600 mr-2"></i>
                                Amenities (Optional)
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
                            <label class="block text-sm font-medium text-gray-700 mb-2">Current Images</label>
                            <div style="display:flex;gap:8px;flex-wrap:wrap;">
                                <% for (String img : images) {%>
                                <img src="<%= request.getContextPath() + "/img/" + img%>" style="width:100px;border-radius:8px;">
                                <% } %>
                            </div>
                        </div>
                        <% }%>
                        <!-- Input upload ảnh mới -->
                        <div class="mb-6">
                            <label for="images" class="block text-sm font-medium text-gray-700 mb-2">Upload New Images</label>
                            <input type="file" id="images" name="images" multiple accept="image/*" class="block w-full text-sm text-gray-500">
                            <h4 class="text-xs text-gray-400 mt-1">Leave blank to keep current images.</h4>
                        </div>
                        <!-- Form Actions -->
                        <div class="flex flex-col sm:flex-row gap-4 pt-6 border-t border-gray-200">
                            <button type="submit" class="flex-1 bg-gray-700 text-white px-8 py-4 rounded-lg hover:bg-gray-800 transition-all duration-200 shadow-lg flex items-center justify-center gap-2">
                                <i class="fas fa-save"></i> Update Room Listing
                            </button>
                            <button type="button" onclick="window.location.href = '<%=request.getContextPath()%>/host/dashboard'" class="px-8 py-4 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all duration-200">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html> 