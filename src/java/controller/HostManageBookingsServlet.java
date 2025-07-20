package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.BookingService;
import model.UserAccount;
import model.Host;
import model.Role;
import dao.HostDAO;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HostManageBookingsServlet", urlPatterns = {"/host/manage-bookings"})
public class HostManageBookingsServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final HostDAO hostDAO = new HostDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("../../view/auth/login.jsp");
            return;
        }
        
        // Kiểm tra role an toàn hơn
        Role userRole = user.getRoleId();
        if (userRole == null || !"host".equalsIgnoreCase(userRole.getRoleName())) {
            response.sendRedirect("../../view/auth/login.jsp");
            return;
        }

        try {
            System.out.println("=== HostManageBookingsServlet doGet ===");
            System.out.println("User: " + user.getUsername());
            System.out.println("User Role: " + (user.getRoleId() != null ? user.getRoleId().getRoleName() : "null"));
            
            // Lấy host từ database thay vì từ user object
            Host host = hostDAO.getHostByUserId(user.getUserId());
            System.out.println("Host: " + (host != null ? "Found, ID: " + host.getHostId() : "null"));
            
            if (host == null) {
                System.out.println("ERROR: Host is null for user ID: " + user.getUserId());
                request.setAttribute("error", "Không tìm thấy thông tin host. Vui lòng đăng ký làm host trước.");
                request.getRequestDispatcher("/view/common/error.jsp").forward(request, response);
                return;
            }
            
            // Lấy danh sách booking cho phòng của host
            List<model.Booking> bookings = bookingService.getBookingsByHostId(host.getHostId());
            System.out.println("Bookings found: " + bookings.size());
            
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/view/host/manage-bookings.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách đặt phòng.");
            request.getRequestDispatcher("/view/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("../../view/auth/login.jsp");
            return;
        }
        
        // Kiểm tra role an toàn hơn
        Role userRole = user.getRoleId();
        if (userRole == null || !"host".equalsIgnoreCase(userRole.getRoleName())) {
            response.sendRedirect("../../view/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String bookingId = request.getParameter("bookingId");

        if (bookingId == null || action == null) {
            response.sendRedirect("manage-bookings");
            return;
        }

        try {
            int bookingIdInt = Integer.parseInt(bookingId);
            boolean success = false;

            if ("confirm-booking".equals(action)) {
                success = bookingService.confirmBooking(bookingIdInt);
                if (success) {
                    response.sendRedirect("manage-bookings?message=booking-confirmed");
                } else {
                    request.setAttribute("error", "Không thể xác nhận đặt phòng.");
                    request.getRequestDispatcher("/view/common/error.jsp").forward(request, response);
                }
            } else if ("reject-booking".equals(action)) {
                success = bookingService.cancelBooking(bookingIdInt);
                if (success) {
                    response.sendRedirect("manage-bookings?message=booking-cancelled");
                } else {
                    request.setAttribute("error", "Không thể từ chối đặt phòng.");
                    request.getRequestDispatcher("/view/common/error.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect("manage-bookings");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý đặt phòng.");
            request.getRequestDispatcher("/view/common/error.jsp").forward(request, response);
        }
    }
} 