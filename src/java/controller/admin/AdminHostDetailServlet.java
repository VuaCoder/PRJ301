package controller.admin;

import DTO.RoomStat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

import model.UserAccount;
import model.Host;
import service.AdminService;

@WebServlet(name="AdminHostDetailServlet", urlPatterns={"/admin/admin-host-detail"})
public class AdminHostDetailServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String hidParam = request.getParameter("hostId");
            String uidParam = request.getParameter("userId");

            Integer hostId = null;
            UserAccount hostAccount = null;

            if (hidParam != null) {
                hostId = Integer.parseInt(hidParam);
            } else if (uidParam != null) {
                int userId = Integer.parseInt(uidParam);
                hostAccount = adminService.getUserById(userId);
                if (hostAccount != null && hostAccount.getHost() != null) {
                    hostId = hostAccount.getHost().getHostId();
                }
            }

            if (hostId == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid hostId/userId.");
                return;
            }

            if (hostAccount == null) {
                // nếu truyền hostId thẳng mà bạn muốn xem user
                // AdminService cần hàm getUserByHostId nếu cần; tạm để null
            }

            // Lấy thống kê phòng (bạn đã thêm AdminService.getRoomStatsByHost)
            List<RoomStat> roomStats = adminService.getRoomStatsByHost(hostId);

            request.setAttribute("hostAccount", hostAccount);
            request.setAttribute("hostId", hostId);
            request.setAttribute("roomStats", roomStats);

            request.getRequestDispatcher("/view/admin/admin-host-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid host ID");
        }
    }
}
