/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.HostDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Host;
import model.Room;
import model.UserAccount;
import service.RoomService;
import service.BookingService;

/**
 *
 * @author quangminhnguyen
 */
@WebServlet("/host/dashboard")
public class HostDashboardServlet extends HttpServlet {
    private final RoomService roomService = new RoomService();
    private final HostDAO hostDAO = new HostDAO();
    private final BookingService bookingService = new BookingService();

    //chưa chặn được nếu là người dùng thì vẫn có thể vào dashboard
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserAccount user = (UserAccount) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Host host = hostDAO.getHostByUserId(user.getUserId());
        if (host == null) {
            response.sendRedirect(request.getContextPath() + "/view/host/become_host.jsp");
            return;
        }

        List<Room> rooms = roomService.getRoomsByHostId(host.getHostId());
        
        // Lấy thống kê booking
        List<model.Booking> allBookings = bookingService.getBookingsByHostId(host.getHostId());
        long pendingBookings = allBookings.stream().filter(b -> "Pending".equals(b.getStatus())).count();
        long confirmedBookings = allBookings.stream().filter(b -> "Confirmed".equals(b.getStatus())).count();
        long cancelledBookings = allBookings.stream().filter(b -> "Cancelled".equals(b.getStatus())).count();
        long totalBookings = allBookings.size();
        
        request.setAttribute("rooms", rooms);
        request.setAttribute("host", host);
        request.setAttribute("pendingBookings", pendingBookings);
        request.setAttribute("confirmedBookings", confirmedBookings);
        request.setAttribute("cancelledBookings", cancelledBookings);
        request.setAttribute("totalBookings", totalBookings);
        request.getRequestDispatcher("/view/host/dashboard.jsp").forward(request, response);
    }
}

