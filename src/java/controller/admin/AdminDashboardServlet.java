package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Role;
import model.UserAccount;
import service.AdminService;

/**
 * Admin Dashboard: thống kê user + badge pending host/room.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        UserAccount currentUser = (session != null) ? (UserAccount) session.getAttribute("user") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
            return;
        }
        // (khuyến nghị) kiểm tra quyền admin:
        if (currentUser.getRoleId() == null || currentUser.getRoleId().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // load user list
        List<UserAccount> users = adminService.getAllUsers();
        request.setAttribute("users", users);

        long pendingHostCount = adminService.countPendingHosts();
        long pendingRoomsCount = adminService.countPendingRooms();
        request.setAttribute("pendingHostCount", pendingHostCount);
        request.setAttribute("pendingRoomsCount", pendingRoomsCount);

        // forward
        request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");

        int id = Integer.parseInt(request.getParameter("id"));
        UserAccount user = adminService.getUserById(id);

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/view/admin/dashboard.jsp");
            return;
        }

        switch (action) {
            case "updateStatus":
                String status = request.getParameter("status");
                if (user != null) {
                    user.setStatus(status);
                    adminService.updateUser(user);
                }
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
            case "updateRole":
                int roleId = Integer.parseInt(request.getParameter("roleId"));
                adminService.updateNewRole(id, roleId);
                //Cai lai session user khi bi doi role
                UserAccount sessionUser = (UserAccount) request.getSession().getAttribute("user");
                if (sessionUser != null && sessionUser.getUserId() == id) {
                    // load lại user từ DB
                    UserAccount fresh = adminService.getUserById(id);
                    request.getSession().setAttribute("user", fresh);
                }

                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Admin Dashboard";
    }
}
