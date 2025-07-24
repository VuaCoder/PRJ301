<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Tất cả phòng - Staytion</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    </head>
    <body class="bg-gray-50 font-sans">

        <jsp:include page="/view/common/header_admin.jsp"/>

        <c:set var="CTX" value="${pageContext.request.contextPath}" />
        <c:set var="flt" value="${empty filter ? 'All' : filter}" />

        <div class="max-w-7xl mx-auto p-6">

            <!-- Banner -->
            <div class="bg-gradient-to-r from-indigo-600 via-purple-600 to-blue-600 text-white p-8 rounded-xl shadow-lg mb-8">
                <h1 class="text-3xl font-bold mb-2">All Rooms</h1>
                <p class="opacity-90">Browse, inspect, or delete any room listing on the platform.</p>
            </div>

            <!-- Session flash -->
            <c:if test="${not empty sessionScope.adminRoomsMsg}">
                <div class="mb-6 p-4 rounded-lg bg-blue-100 text-blue-800">
                    ${sessionScope.adminRoomsMsg}
                </div>
                <c:remove var="adminRoomsMsg" scope="session"/>
            </c:if>

            <!-- Status filter chips -->
            <div class="flex flex-wrap gap-3 mb-6 items-center text-sm">
                <a href="${CTX}/admin-pending?action=list&type=allRooms&filter=All&page=1"
                   class="inline-flex items-center gap-2 px-4 py-2 rounded-full border
                   ${flt eq 'All' ? 'bg-indigo-600 text-white border-indigo-600' : 'bg-white text-indigo-600 hover:bg-indigo-50 border-indigo-300'}">
                    <i class="fa-solid fa-layer-group"></i>
                    All (${countAll})
                </a>

                <a href="${CTX}/admin-pending?action=list&type=allRooms&filter=Pending&page=1"
                   class="inline-flex items-center gap-2 px-4 py-2 rounded-full border
                   ${flt eq 'Pending' ? 'bg-yellow-500 text-white border-yellow-500' : 'bg-white text-yellow-600 hover:bg-yellow-50 border-yellow-300'}">
                    <i class="fa-solid fa-clock"></i>
                    Pending (${countPending})
                </a>

                <a href="${CTX}/admin-pending?action=list&type=allRooms&filter=Approved&page=1"
                   class="inline-flex items-center gap-2 px-4 py-2 rounded-full border
                   ${flt eq 'Approved' ? 'bg-green-600 text-white border-green-600' : 'bg-white text-green-600 hover:bg-green-50 border-green-300'}">
                    <i class="fa-solid fa-circle-check"></i>
                    Approved (${countApproved})
                </a>

                <a href="${CTX}/admin-pending?action=list&type=allRooms&filter=Rejected&page=1"
                   class="inline-flex items-center gap-2 px-4 py-2 rounded-full border
                   ${flt eq 'Rejected' ? 'bg-red-600 text-white border-red-600' : 'bg-white text-red-600 hover:bg-red-50 border-red-300'}">
                    <i class="fa-solid fa-circle-xmark"></i>
                    Rejected (${countRejected})
                </a>
            </div>

            <!-- Table -->
            <div class="bg-white p-6 rounded-xl shadow-lg border">
                <h2 class="text-2xl font-bold mb-4">Room List</h2>

                <c:choose>
                    <c:when test="${empty allRooms}">
                        <div class="flex flex-col items-center justify-center py-10 text-gray-500">
                            <i class="fas fa-door-open text-4xl mb-3 text-gray-400"></i>
                            <p class="text-lg font-semibold">No rooms found</p>
                            <p class="text-sm">Try another status filter.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="overflow-x-auto">
                            <table class="min-w-full border-collapse border border-gray-300 text-left text-sm">
                                <thead class="bg-gray-100 text-gray-700 text-xs uppercase tracking-wider">
                                    <tr>
                                        <th class="border px-4 py-2">ID</th>
                                        <th class="border px-4 py-2">Title</th>
                                        <th class="border px-4 py-2">Property</th>
                                        <th class="border px-4 py-2">Host</th>
                                        <th class="border px-4 py-2">Guests</th>
                                        <th class="border px-4 py-2">Price</th>
                                        <th class="border px-4 py-2">Status</th>
                                        <th class="border px-4 py-2 text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="r" items="${allRooms}">
                                        <tr class="hover:bg-gray-50 room-row"
                                            data-roomid="${r.roomId}"
                                            data-title="${fn:escapeXml(r.title)}"
                                            data-desc="${fn:escapeXml(r.description)}"
                                            data-prop="${fn:escapeXml(r.propertyId.name)}"
                                            data-host="${fn:escapeXml(r.propertyId.hostId.userId.fullName)}"
                                            data-cap="${r.capacity}"
                                            data-price="${r.price}"
                                            data-status="${r.approvalStatus}"
                                            data-images="${fn:escapeXml(r.images)}">
                                            <td class="border px-4 py-2">${r.roomId}</td>
                                            <td class="border px-4 py-2">
                                                <button type="button"
                                                        class="text-blue-600 underline"
                                                        onclick="openRoomDetail(this.closest('tr'))">
                                                    ${r.title}
                                                </button>
                                            </td>
                                            <td class="border px-4 py-2">${r.propertyId.name}</td>
                                            <td class="border px-4 py-2">${r.propertyId.hostId.userId.fullName}</td>
                                            <td class="border px-4 py-2">${r.capacity}</td>
                                            <td class="border px-4 py-2">$${r.price}</td>
                                            <td class="border px-4 py-2">
                                                <c:choose>
                                                    <c:when test="${r.approvalStatus eq 'Approved'}">
                                                        <span class="text-green-600 font-semibold">Approved</span>
                                                    </c:when>
                                                    <c:when test="${r.approvalStatus eq 'Rejected'}">
                                                        <span class="text-red-600 font-semibold">Rejected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-yellow-600 font-semibold">Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="border px-4 py-2 text-center">
                                                <a href="${CTX}/admin-pending?action=delete&type=allRooms&id=${r.roomId}&filter=${flt}&page=${currentPage}"
                                                   class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600"
                                                   onclick="return confirm('Delete room #${r.roomId}? This cannot be undone.');">
                                                    Delete
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="flex justify-center mt-4 text-sm">
                            <c:if test="${currentPage > 1}">
                                <a href="${CTX}/admin-pending?action=list&type=allRooms&filter=${flt}&page=${currentPage-1}"
                                   class="mx-1 px-3 py-1 rounded border bg-gray-100 hover:bg-gray-200">Prev</a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <a href="${CTX}/admin-pending?action=list&type=allRooms&filter=${flt}&page=${p}"
                                   class="mx-1 px-3 py-1 rounded border
                                   ${currentPage eq p ? 'bg-indigo-600 text-white' : 'bg-gray-100 hover:bg-gray-200'}">${p}</a>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="${CTX}/admin-pending?action=list&type=allRooms&filter=${flt}&page=${currentPage+1}"
                                   class="mx-1 px-3 py-1 rounded border bg-gray-100 hover:bg-gray-200">Next</a>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div> <!-- /container -->

        <!-- ========== ROOM DETAIL MODAL ========== -->
        <div id="roomDetailModal"
             class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white w-full max-w-2xl mx-4 rounded-lg shadow-lg p-6 relative">
                <button type="button" onclick="closeRoomDetail()"
                        class="absolute top-3 right-3 text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times"></i>
                </button>

                <h3 id="rd_title" class="text-2xl font-bold mb-4 text-gray-800">Room Title</h3>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-x-6 gap-y-2 text-sm text-gray-700">
                    <div><span class="font-semibold">Property:</span> <span id="rd_property"></span></div>
                    <div><span class="font-semibold">Host:</span> <span id="rd_host"></span></div>
                    <div><span class="font-semibold">Guests:</span> <span id="rd_capacity"></span></div>
                    <div><span class="font-semibold">Price / Night:</span> $<span id="rd_price"></span></div>
                    <div class="sm:col-span-2"><span class="font-semibold">Status:</span> <span id="rd_status_badge" class="font-semibold"></span></div>
                </div>

                <div class="pt-4 border-t mt-4">
                    <span class="font-semibold text-sm text-gray-700">Description:</span>
                    <p id="rd_desc" class="mt-1 text-gray-600 text-sm leading-relaxed max-h-48 overflow-y-auto"></p>
                </div>

                <div class="mt-4">
                    <span class="font-semibold text-sm text-gray-700">Images:</span>
                    <div id="rd_images" class="mt-2 grid grid-cols-3 sm:grid-cols-4 gap-2 max-h-48 overflow-y-auto"></div>
                </div>

            </div>
        </div>

        <script>
    const CTX_JS = '<c:out value="${CTX}"/>'; // safe for JS

    function openRoomDetail(rowElem) {
        const title = rowElem.dataset.title || '';
        const desc = rowElem.dataset.desc || '';
        const prop = rowElem.dataset.prop || '';
        const host = rowElem.dataset.host || '';
        const cap = rowElem.dataset.cap || '';
        const price = rowElem.dataset.price || '';
        const status = rowElem.dataset.status || 'Pending';
        const imagesRaw = rowElem.dataset.images || '';

        document.getElementById('rd_title').textContent = title;
        document.getElementById('rd_property').textContent = prop;
        document.getElementById('rd_host').textContent = host;
        document.getElementById('rd_capacity').textContent = cap;
        document.getElementById('rd_price').textContent = price;
        document.getElementById('rd_desc').textContent = desc;

        const badge = document.getElementById('rd_status_badge');
        badge.textContent = status;
        badge.className = 'font-semibold ' +
                (status === 'Approved' ? 'text-green-600' :
                        status === 'Rejected' ? 'text-red-600' : 'text-yellow-600');

        const imgWrap = document.getElementById('rd_images');
        imgWrap.innerHTML = '';
        const imgs = imagesRaw.split(',').map(s => s.trim()).filter(Boolean);
        if (imgs.length === 0) {
            imgWrap.innerHTML = '<div class="text-xs text-gray-400 col-span-3">No images.</div>';
        } else {
            imgs.forEach(src => {
                let url = src;
                if (!/^https?:/i.test(src)) {
                    url = CTX_JS + '/img/' + src;
                }
                const img = document.createElement('img');
                img.src = url;
                img.alt = 'room';
                img.className = 'w-full h-20 object-cover rounded border';
                imgWrap.appendChild(img);
            });
        }

        document.getElementById('roomDetailModal').classList.remove('hidden');
    }

    function closeRoomDetail() {
        document.getElementById('roomDetailModal').classList.add('hidden');
    }
        </script>

    </body>
</html>
