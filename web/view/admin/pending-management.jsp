<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Pending Management - Staytion</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    </head>
    <body class="bg-gray-50 font-sans">

        <jsp:include page="/view/common/header_admin.jsp"/>

        <div class="max-w-7xl mx-auto p-6">

            <!-- Banner -->
            <div class="bg-gradient-to-r from-yellow-600 via-orange-500 to-red-500 text-white p-8 rounded-xl shadow-lg mb-8">
                <h1 class="text-3xl font-bold mb-2">Pending Management</h1>
                <p class="opacity-90">Review and manage host applications & room listings.</p>
            </div>

            <!-- Session message -->
            <c:if test="${not empty sessionScope.adminPendingMsg}">
                <div class="mb-6 p-4 rounded-lg bg-blue-100 text-blue-800">
                    ${sessionScope.adminPendingMsg}
                </div>
                <c:remove var="adminPendingMsg" scope="session"/>
            </c:if>

            <!-- Tabs -->
            <div class="mb-6 flex space-x-4">
                <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=host&page=1"
                   class="px-4 py-2 rounded-lg text-white font-semibold
                   ${type eq 'host' ? 'bg-blue-600' : 'bg-gray-400 hover:bg-gray-500'}">
                    Pending Hosts
                    <c:if test="${pendingHostCount gt 0}">
                        <span class="ml-2 bg-white text-blue-600 px-2 py-0.5 rounded-full text-xs font-bold">${pendingHostCount}</span>
                    </c:if>
                </a>

                <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=room&page=1"
                   class="px-4 py-2 rounded-lg text-white font-semibold
                   ${type eq 'room' ? 'bg-green-600' : 'bg-gray-400 hover:bg-gray-500'}">
                    Pending Rooms
                    <c:if test="${pendingRoomsCount gt 0}">
                        <span class="ml-2 bg-white text-green-600 px-2 py-0.5 rounded-full text-xs font-bold">${pendingRoomsCount}</span>
                    </c:if>
                </a>

                <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=allRooms&page=1"
                   class="px-4 py-2 rounded-lg text-white font-semibold
                   ${type eq 'allRooms' ? 'bg-purple-600' : 'bg-gray-400 hover:bg-gray-500'}">
                    All Rooms
                    <c:if test="${allRoomsCount gt 0}">
                        <span class="ml-2 bg-white text-purple-600 px-2 py-0.5 rounded-full text-xs font-bold">${allRoomsCount}</span>
                    </c:if>
                </a>
            </div>

            <!-- ================= HOST TABLE ================= -->
            <c:if test="${type eq 'host'}">
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <h2 class="text-2xl font-bold mb-4">Pending Host Applications</h2>
                    <c:choose>
                        <c:when test="${empty pendingHosts}">
                            <div class="flex flex-col items-center justify-center py-10 text-gray-500">
                                <i class="fas fa-user-slash text-4xl mb-3 text-gray-400"></i>
                                <p class="text-lg font-semibold">No pending hosts</p>
                                <p class="text-sm">All host applications have been reviewed.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="table-auto w-full border-collapse border border-gray-300 text-left">
                                <thead class="bg-gray-100">
                                    <tr>
                                        <th class="border px-4 py-2">Host ID</th>
                                        <th class="border px-4 py-2">Name</th>
                                        <th class="border px-4 py-2">Email</th>
                                        <th class="border px-4 py-2">Description</th>
                                        <th class="border px-4 py-2 text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="h" items="${pendingHosts}">
                                        <tr class="hover:bg-gray-50">
                                            <td class="border px-4 py-2">${h.hostId}</td>
                                            <td class="border px-4 py-2">
                                                <c:out value="${h.userId.fullName != null ? h.userId.fullName : h.userId.username}"/>
                                            </td>
                                            <td class="border px-4 py-2">${h.userId.email}</td>
                                            <td class="border px-4 py-2">${h.description}</td>
                                            <td class="border px-4 py-2 text-center space-x-2">
                                                <a href="${pageContext.request.contextPath}/admin-pending?action=approve&type=host&id=${h.hostId}"
                                                   class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600">Approve</a>
                                                <a href="${pageContext.request.contextPath}/admin-pending?action=reject&type=host&id=${h.hostId}"
                                                   class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600"
                                                   onclick="return confirm('Reject this host?');">Reject</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <!-- Pagination -->
                            <div class="flex justify-center mt-4">
                                <c:if test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=${type}&page=${currentPage-1}"
                                       class="mx-1 px-3 py-1 rounded border bg-gray-100 hover:bg-gray-200">Prev</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=${type}&page=${p}"
                                       class="mx-1 px-3 py-1 rounded border
                                       ${currentPage eq p ? 'bg-blue-600 text-white' : 'bg-gray-100 hover:bg-gray-200'}">${p}</a>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=${type}&page=${currentPage+1}"
                                       class="mx-1 px-3 py-1 rounded border bg-gray-100 hover:bg-gray-200">Next</a>
                                </c:if>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- ================= PENDING ROOMS ================= -->
            <c:if test="${type eq 'room'}">
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <h2 class="text-2xl font-bold mb-4">Pending Rooms</h2>
                    <c:choose>
                        <c:when test="${empty pendingRooms}">
                            <div class="flex flex-col items-center justify-center py-10 text-gray-500">
                                <i class="fas fa-door-closed text-4xl mb-3 text-gray-400"></i>
                                <p class="text-lg font-semibold">No pending rooms</p>
                                <p class="text-sm">All rooms have been processed.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="table-auto w-full border-collapse border border-gray-300 text-left">
                                <thead class="bg-gray-100">
                                    <tr>
                                        <th class="border px-4 py-2">Room ID</th>
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
                                    <c:forEach var="r" items="${pendingRooms}">
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
                                                        onclick="openRoomDetail(this.closest('tr'))">${r.title}</button>
                                            </td>
                                            <td class="border px-4 py-2">${r.propertyId.name}</td>
                                            <td class="border px-4 py-2">${r.propertyId.hostId.userId.fullName}</td>
                                            <td class="border px-4 py-2">${r.capacity}</td>
                                            <td class="border px-4 py-2">$${r.price}</td>
                                            <td class="border px-4 py-2 text-yellow-600 font-semibold">Pending</td>
                                            <td class="border px-4 py-2 text-center space-x-2">
                                                <a href="${pageContext.request.contextPath}/admin-pending?action=approve&type=room&id=${r.roomId}"
                                                   class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600">Approve</a>
                                                <a href="${pageContext.request.contextPath}/admin-pending?action=reject&type=room&id=${r.roomId}"
                                                   class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600"
                                                   onclick="return confirm('Reject this room?');">Reject</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <!-- Pagination -->
                            <div class="flex justify-center mt-4">
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=${type}&page=${p}"
                                       class="mx-1 px-3 py-1 rounded border
                                       ${currentPage eq p ? 'bg-green-600 text-white' : 'bg-gray-100 hover:bg-gray-200'}">${p}</a>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- ================= ALL ROOMS ================= -->
            <c:if test="${type eq 'allRooms'}">
                <div class="bg-white p-6 rounded-xl shadow-lg border">
                    <h2 class="text-2xl font-bold mb-4">All Rooms</h2>
                    <c:choose>
                        <c:when test="${empty allRooms}">
                            <div class="flex flex-col items-center justify-center py-10 text-gray-500">
                                <i class="fas fa-door-open text-4xl mb-3 text-gray-400"></i>
                                <p class="text-lg font-semibold">No rooms found</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="table-auto w-full border-collapse border border-gray-300 text-left">
                                <thead class="bg-gray-100">
                                    <tr>
                                        <th class="border px-4 py-2">Room ID</th>
                                        <th class="border px-4 py-2">Title</th>
                                        <th class="border px-4 py-2">Property</th>
                                        <th class="border px-4 py-2">Host</th>
                                        <th class="border px-4 py-2">Guests</th>
                                        <th class="border px-4 py-2">Price</th>
                                        <th class="border px-4 py-2">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="r" items="${allRooms}">
                                        <tr class="hover:bg-gray-50">
                                            <td class="border px-4 py-2">${r.roomId}</td>
                                            <td class="border px-4 py-2">${r.title}</td>
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
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <!-- Pagination -->
                            <div class="flex justify-center mt-4">
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <a href="${pageContext.request.contextPath}/admin-pending?action=list&type=${type}&page=${p}"
                                       class="mx-1 px-3 py-1 rounded border
                                       ${currentPage eq p ? 'bg-purple-600 text-white' : 'bg-gray-100 hover:bg-gray-200'}">${p}</a>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

        </div>

        <!-- ========== ROOM DETAIL MODAL ========== -->
        <div id="roomDetailModal"
             class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white w-full max-w-lg mx-4 rounded-lg shadow-lg p-6 relative">
                <button type="button" onclick="closeRoomDetail()"
                        class="absolute top-3 right-3 text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times"></i>
                </button>
                <h3 id="rd_title" class="text-2xl font-bold mb-4 text-gray-800">Room Title</h3>
                <div class="space-y-2 text-sm text-gray-700">
                    <div><span class="font-semibold">Property:</span> <span id="rd_property"></span></div>
                    <div><span class="font-semibold">Host:</span> <span id="rd_host"></span></div>
                    <div><span class="font-semibold">Guests:</span> <span id="rd_capacity"></span></div>
                    <div><span class="font-semibold">Price / Night:</span> $<span id="rd_price"></span></div>
                    <div><span class="font-semibold">Status:</span> <span id="rd_status_badge" class="font-semibold"></span></div>
                    <div class="pt-2"><span class="font-semibold">Description:</span>
                        <p id="rd_desc" class="mt-1 text-gray-600 text-sm leading-relaxed max-h-48 overflow-y-auto"></p>
                    </div>
                </div>
                <div class="mt-4">
                    <span class="font-semibold text-sm text-gray-700">Images:</span>
                    <div id="rd_images" class="mt-2 grid grid-cols-3 gap-2 max-h-40 overflow-y-auto"></div>
                </div>
                <div id="rd_actions" class="mt-6 text-right hidden">
                    <a id="rd_btnApprove" href="#"
                       class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700 mr-2">Approve</a>
                    <a id="rd_btnReject" href="#"
                       class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700"
                       onclick="return confirm('Reject this room?');">Reject</a>
                </div>
            </div>
        </div>

        <script>
    const CTX = '${pageContext.request.contextPath}';
    function openRoomDetail(rowElem) {
        const title = rowElem.dataset.title || '';
        const desc = rowElem.dataset.desc || '';
        const prop = rowElem.dataset.prop || '';
        const host = rowElem.dataset.host || '';
        const cap = rowElem.dataset.cap || '';
        const price = rowElem.dataset.price || '';
        const status = rowElem.dataset.status || 'Pending';
        const roomId = rowElem.dataset.roomid;
        const imagesRaw = rowElem.dataset.images || '';

        document.getElementById('rd_title').textContent = title;
        document.getElementById('rd_property').textContent = prop;
        document.getElementById('rd_host').textContent = host;
        document.getElementById('rd_capacity').textContent = cap;
        document.getElementById('rd_price').textContent = price;
        document.getElementById('rd_desc').textContent = desc;

        const badge = document.getElementById('rd_status_badge');
        badge.textContent = status;
        badge.className = 'font-semibold ' + (status === 'Approved' ? 'text-green-600' :
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
                    url = CTX + '/img/' + src;
                }
                const img = document.createElement('img');
                img.src = url;
                img.alt = 'room';
                img.className = 'w-full h-20 object-cover rounded border';
                imgWrap.appendChild(img);
            });
        }

        const actionDiv = document.getElementById('rd_actions');
        const btnApprove = document.getElementById('rd_btnApprove');
        const btnReject = document.getElementById('rd_btnReject');
        if (status === 'Pending') {
            actionDiv.classList.remove('hidden');
            btnApprove.href = `${CTX}/admin-pending?action=approve&type=room&id=${roomId}`;
                        btnReject.href = `${CTX}/admin-pending?action=reject&type=room&id=${roomId}`;
                                } else {
                                    actionDiv.classList.add('hidden');
                                }

                                document.getElementById('roomDetailModal').classList.remove('hidden');
                            }

                            function closeRoomDetail() {
                                document.getElementById('roomDetailModal').classList.add('hidden');
                            }
        </script>

        <jsp:include page="/view/common/footer.jsp"/>

    </body>
</html>
