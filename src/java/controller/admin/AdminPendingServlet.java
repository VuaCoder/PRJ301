package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Host;
import model.Room;
import model.UserAccount;
import service.AdminService;

/**
 * Quản lý duyệt (Pending Host & Pending Room). URL:
 * /admin-pending?action=list&type=host|room URL:
 * /admin-pending?action=approve|reject&type=host|room&id=123
 */
@WebServlet("/admin-pending")
public class AdminPendingServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        adminService = new AdminService();
    }

    /* --------------------------------------------------
     * GET: hiển thị danh sách
     * -------------------------------------------------- */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!ensureAdminLoggedIn(request, response)) {
            return; // đã redirect
        }

        String action = nvl(request.getParameter("action"), "list");
        String type = nvl(request.getParameter("type"), "host"); // default host
        int page = parseIntSafe(request.getParameter("page"));
        if (page < 1) {
            page = 1;
        }

        switch (action) {
            case "approve":
            case "reject":
                // Với approve/reject qua GET (nếu bạn dùng link <a>); forward sang doPost xử lý.
                doPost(request, response);
                return;

            case "delete":
                // chỉ hỗ trợ xóa room
                if ("room".equals(type) || "allRooms".equals(type)) {
                    int id = parseIntSafe(request.getParameter("id"));
                    if (id > 0) {
                        try {
                            adminService.deleteRoom(id);
                            request.getSession().setAttribute("adminPendingMsg", "Deleted room #" + id);
                        } catch (Exception e) {
                            e.printStackTrace();
                            request.getSession().setAttribute("adminPendingMsg", "Failed to delete room #" + id);
                        }
                    } else {
                        request.getSession().setAttribute("adminPendingMsg", "Invalid room id.");
                    }

                    // quay về tab allRooms (vì xóa thường làm ở đó) – GIỮ page nếu bạn muốn
                    redirectList("allRooms", page, request, response);
                    return;
                } else {
                    request.getSession().setAttribute("adminPendingMsg", "Delete not supported for this type.");
                    redirectList(type, page, request, response);
                    return;
                }

            case "list":
            default:
                loadListsForType(type, request);
                forwardPage(request, response);
                break;
        }
    }

    /* --------------------------------------------------
     * POST: thực hiện approve / reject
     * -------------------------------------------------- */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!ensureAdminLoggedIn(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        String type = nvl(request.getParameter("type"), "host");
        int id = parseIntSafe(request.getParameter("id"));
        int page = parseIntSafe(request.getParameter("page"));
        if (page < 1) {
            page = 1;
        }

        if (id <= 0) {
            // ID sai -> quay lại list cùng type với thông báo
            request.getSession().setAttribute("adminPendingMsg", "Invalid ID.");
            redirectList(type, page, request, response);
            return;
        }

        boolean approve = "approve".equals(action);

        if ("host".equals(type)) {
            if (approve) {
                adminService.approveHost(id);
            } else {
                adminService.rejectHost(id);
            }
        } else if ("room".equals(type)) {
            if (approve) {
                adminService.approveRoom(id);
            } else {
                adminService.rejectRoom(id);
            }
        } else if ("allRooms".equals(type) && "delete".equals(action)) {
            try {
                adminService.deleteRoom(id);
                request.getSession().setAttribute("adminPendingMsg", "Deleted room #" + id);
            } catch (Exception e) {
                request.getSession().setAttribute("adminPendingMsg", "Failed to delete room #" + id);
            }
        }

        // Thông báo nhẹ
        request.getSession().setAttribute("adminPendingMsg",
                (approve ? "Approved " : "Rejected ") + type + " #" + id);

        redirectList(type, page, request, response);
    }

    /* --------------------------------------------------
     * Helpers
     * -------------------------------------------------- */
    /**
     * Tải đúng danh sách theo type và attach count badge.
     */
    private void loadListsForType(String type, HttpServletRequest request) {
        int page = parseIntSafe(request.getParameter("page"));
        if (page < 1) {
            page = 1;
        }
        final int pageSize = 10;

        long pendingHostCount = adminService.countPendingHosts();
        long pendingRoomCount = adminService.countPendingRooms();
        long allRoomsCount = adminService.countAllRooms();

        request.setAttribute("pendingHostCount", pendingHostCount);
        request.setAttribute("pendingRoomsCount", pendingRoomCount);
        request.setAttribute("allRoomsCount", allRoomsCount);

        if ("host".equals(type)) {
            int totalPages = (int) Math.ceil(pendingHostCount / (double) pageSize);
            if (totalPages == 0) {
                totalPages = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            request.setAttribute("pendingHosts", adminService.getPendingHostsPaginated(page, pageSize));
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);

        } else if ("room".equals(type)) {
            int totalPages = (int) Math.ceil(pendingRoomCount / (double) pageSize);
            if (totalPages == 0) {
                totalPages = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            request.setAttribute("pendingRooms", adminService.getPendingRoomsPaginated(page, pageSize));
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);

        } else if ("allRooms".equals(type)) {
            String filter = nvl(request.getParameter("filter"), "All");
            if (page < 1) {
                page = 1;
            }

            List<Room> list;
            long total;
            switch (filter) {
                case "Pending":
                    list = adminService.getRoomsByStatus("Pending", page, pageSize);
                    total = adminService.countRoomsByStatus("Pending");
                    break;
                case "Approved":
                    list = adminService.getRoomsByStatus("Approved", page, pageSize);
                    total = adminService.countRoomsByStatus("Approved");
                    break;
                case "Rejected":
                    list = adminService.getRoomsByStatus("Rejected", page, pageSize);
                    total = adminService.countRoomsByStatus("Rejected");
                    break;
                default:
                    list = adminService.getAllRoomsPaginated(page, pageSize);
                    total = adminService.countAllRooms();
            }

            int totalPages = (int) Math.ceil(total / (double) pageSize);

            request.setAttribute("allRooms", list);
            request.setAttribute("countAll", adminService.countAllRooms());
            request.setAttribute("countPending", adminService.countRoomsByStatus("Pending"));
            request.setAttribute("countApproved", adminService.countRoomsByStatus("Approved"));
            request.setAttribute("countRejected", adminService.countRoomsByStatus("Rejected"));
            request.setAttribute("filter", filter);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

        }

        request.setAttribute("type", type);
    }

    /**
     * Forward tới JSP chung.
     */
    private void forwardPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = (String) request.getAttribute("type");
        if ("allRooms".equals(type)) {
            request.getRequestDispatcher("/view/admin/all-rooms.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/view/admin/pending-management.jsp").forward(request, response);
        }
    }

    /**
     * Redirect về danh sách để tránh submit lại form.
     */
    private void redirectList(String type, int page, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin-pending?action=list&type=" + type);
    }

    /**
     * Đảm bảo đang đăng nhập và là admin (role_id=3). Có thể thay đổi tuỳ hệ
     * thống).
     */
    private boolean ensureAdminLoggedIn(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
            return false;
        }
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null || user.getRoleId() == null || user.getRoleId().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    private String nvl(String v, String dft) {
        return (v == null || v.isBlank()) ? dft : v;
    }

    private int parseIntSafe(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return -1;
        }
    }
}
