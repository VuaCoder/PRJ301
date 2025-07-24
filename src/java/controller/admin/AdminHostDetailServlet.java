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
            Host host = null;

            if (uidParam != null) {
                int userId = Integer.parseInt(uidParam);
                host = adminService.getHostByUserId(userId);
                if (host != null) {
                    hostId = host.getHostId();
                    hostAccount = host.getUserId();
                }
            } else if (hidParam != null) {
                hostId = Integer.parseInt(hidParam);
                host = adminService.getHostById(hostId);
                if (host != null) {
                    hostAccount = host.getUserId();
                }
            }

            if (hostId == null || hostAccount == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid hostId/userId.");
                return;
            }

            List<RoomStat> roomStats = adminService.getRoomStatsByHost(hostId);
            List<model.Booking> bookings = adminService.getBookingsByHostId(hostId);

            request.setAttribute("hostAccount", hostAccount);
            request.setAttribute("hostId", hostId);
            request.setAttribute("roomStats", roomStats);
            request.setAttribute("bookings", bookings);

            request.getRequestDispatcher("/view/admin/admin-host-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid host ID");
        }
    }
}
