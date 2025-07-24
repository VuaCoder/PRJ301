package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import model.UserAccount;
import service.AdminService;

/**
 * Admin Dashboard: thống kê + tab Customer/Host có phân trang.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();

    // Số dòng mỗi trang cho bảng Customer / Host
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ==== 1. Kiểm tra đăng nhập & quyền ====
        HttpSession session = request.getSession(false);
        UserAccount currentUser = (session != null) ? (UserAccount) session.getAttribute("user") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
            return;
        }
        if (currentUser.getRoleId() == null || currentUser.getRoleId().getRoleId() != 3) { // 3 = admin
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // ==== 2. Lấy tham số tab + page + pending/allRooms ====
        String tab = request.getParameter("tab");
        if (tab == null || (!"host".equals(tab) && !"customer".equals(tab))) {
            tab = "customer"; // mặc định
        }

        int currentPage = 1;
        try {
            currentPage = Integer.parseInt(request.getParameter("page"));
            if (currentPage < 1) {
                currentPage = 1;
            }
        } catch (NumberFormatException ignore) {
        }

        // ==== 3. Load toàn bộ user từ DB ====
        List<UserAccount> allUsers = adminService.getAllUsers();

        // ==== 4. Tách Customer & Host ====
        List<UserAccount> allCustomers = new ArrayList<>();
        List<UserAccount> allHosts = new ArrayList<>();
        for (UserAccount u : allUsers) {
            if (u.getRoleId() == null) {
                continue;
            }
            int rid = u.getRoleId().getRoleId();
            if (rid == 1) {
                allCustomers.add(u);
            } else if (rid == 2) {
                allHosts.add(u);
            }
        }

        int totalCustomerCount = allCustomers.size();
        int totalHostCount = allHosts.size();

        // ==== 5. Tính tổng trang cho cả 2 loại (để dùng trong badge/pagination) ====
        int totalCustomerPages = (int) Math.ceil((double) totalCustomerCount / PAGE_SIZE);
        int totalHostPages = (int) Math.ceil((double) totalHostCount / PAGE_SIZE);

        // ==== 6. Chọn danh sách đang active theo tab ====
        List<UserAccount> targetList;
        int totalPagesForActiveTab;
        if ("host".equals(tab)) {
            targetList = allHosts;
            totalPagesForActiveTab = totalHostPages;
        } else {
            targetList = allCustomers;
            totalPagesForActiveTab = totalCustomerPages;
        }

        // Nếu không có dữ liệu -> totalPages = 0. Giữ currentPage = 1 để JSP không bị lỗi.
        if (totalPagesForActiveTab == 0) {
            currentPage = 1;
        } else if (currentPage > totalPagesForActiveTab) {
            currentPage = totalPagesForActiveTab;
        }

        // ==== 7. Cắt list theo trang ====
        List<UserAccount> pagedList;
        if (targetList.isEmpty()) {
            pagedList = targetList; // empty
        } else {
            int from = (currentPage - 1) * PAGE_SIZE;
            if (from >= targetList.size()) {
                from = 0; // fallback
            }
            int to = Math.min(from + PAGE_SIZE, targetList.size());
            pagedList = targetList.subList(from, to);
        }

        // ==== 8. Đặt attribute list tương ứng tab ====
        if ("host".equals(tab)) {
            request.setAttribute("hosts", pagedList);
        } else {
            request.setAttribute("customers", pagedList);
        }

        // Các attribute tổng (dùng cho badge & stats)
        request.setAttribute("tab", tab);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalCustomerCount", totalCustomerCount);
        request.setAttribute("totalHostCount", totalHostCount);
        request.setAttribute("totalCustomerPages", totalCustomerPages);
        request.setAttribute("totalHostPages", totalHostPages);

        // ==== 9. Các số thống kê phần card ====
        long totalAccounts = adminService.countAllUsers();
        long activeUsers = adminService.countActiveUsers();
        long pendingHostCount = adminService.countPendingHosts();
        long pendingRoomsCount = adminService.countPendingRooms();
        long allRoomsCount = adminService.countAllRooms();
        long totalBookings = adminService.countAllBookings();
        java.math.BigDecimal totalRevenue = adminService.getTotalRevenue();

        request.setAttribute("totalAccounts", totalAccounts);
        request.setAttribute("activeUsers", activeUsers);
        request.setAttribute("pendingHostCount", pendingHostCount);
        request.setAttribute("pendingRoomsCount", pendingRoomsCount);
        request.setAttribute("allRoomsCount", allRoomsCount);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalRevenue", totalRevenue);

        // ==== 10. Quản lý pending host/phòng và all rooms (forward sang trang riêng nếu có request) ====
        String pendingType = request.getParameter("pendingType");
        String allRooms = request.getParameter("allRooms");
        if (pendingType != null) {
            // Forward sang trang quản lý pending (giữ lại giao diện dashboard)
            response.sendRedirect(request.getContextPath() + "/admin-pending?action=list&type=" + pendingType);
            return;
        }
        if (allRooms != null) {
            response.sendRedirect(request.getContextPath() + "/admin-pending?action=list&type=allRooms");
            return;
        }
        // ==== 11. Forward về dashboard như cũ ====
        request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        String tab = request.getParameter("tab");
        String page = request.getParameter("page");
        String idParam = request.getParameter("id");
        int id = -1;
        try {
            id = Integer.parseInt(idParam);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=" + (tab != null ? tab : "customer") + "&page=" + (page != null ? page : "1"));
            return;
        }

        UserAccount user = adminService.getUserById(id);
        if (tab == null) {
            tab = "customer";
        }
        if (page == null) {
            page = "1";
        }

        if ("delete".equals(action)) {
            adminService.deleteUser(id);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=" + tab + "&page=" + page);
            return;
        } else if ("updateStatus".equals(action)) {
            String status = request.getParameter("status");
            if (user != null) {
                user.setStatus(status);
                adminService.updateUser(user);
            }
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=" + tab + "&page=" + page);
            return;
        } else if ("updateRole".equals(action)) {
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            adminService.updateNewRole(id, roleId);
            HttpSession session = request.getSession();
            UserAccount sessionUser = (UserAccount) session.getAttribute("user");
            if (sessionUser != null && sessionUser.getUserId() == id) {
                session.setAttribute("user", adminService.getUserById(id));
            }
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=" + tab + "&page=" + page);
            return;
        }
        // ==== Xử lý các action duyệt/từ chối host/phòng, xóa phòng, lọc phòng theo trạng thái ====
        String pendingAction = request.getParameter("pendingAction");
        String pendingType = request.getParameter("pendingType");
        if (pendingAction != null && pendingType != null) {
            if ("approve".equals(pendingAction)) {
                if ("host".equals(pendingType)) {
                    adminService.approveHost(id);
                } else if ("room".equals(pendingType)) {
                    adminService.approveRoom(id);
                }
            } else if ("reject".equals(pendingAction)) {
                if ("host".equals(pendingType)) {
                    adminService.rejectHost(id);
                } else if ("room".equals(pendingType)) {
                    adminService.rejectRoom(id);
                }
            } else if ("deleteRoom".equals(pendingAction) && "room".equals(pendingType)) {
                adminService.deleteRoom(id);
            }
            // Sau khi thao tác, redirect về trang quản lý pending tương ứng
            response.sendRedirect(request.getContextPath() + "/admin-pending?action=list&type=" + pendingType);
            return;
        }
        // fallback
        response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=" + tab + "&page=" + page);
    }

    @Override
    public String getServletInfo() {
        return "Admin Dashboard";
    }
}
