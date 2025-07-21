package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.BookingService;
import model.UserAccount;
import model.Customer;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyBookingsServlet", urlPatterns = {"/my-bookings"})
public class MyBookingsServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("view/auth/login.jsp");
            return;
        }

        try {
            System.out.println("=== MyBookingsServlet called ===");
            System.out.println("User: " + user.getFullName());
            
            // Lấy customer từ user
            Customer customer = user.getCustomer();
            System.out.println("Customer: " + (customer != null ? customer.getCustomerId() : "null"));
            
            if (customer == null) {
                System.out.println("Customer not found");
                request.setAttribute("error", "Không tìm thấy thông tin khách hàng.");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
                return;
            }
            
            // Lấy danh sách booking của customer
            List<model.Booking> bookings = bookingService.getBookingsByCustomerId(customer.getCustomerId());
            System.out.println("Found " + bookings.size() + " bookings");

            // Phân trang
            int pageSize = 5;
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException ignored) {}
            }
            int totalBookings = bookings.size();
            int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
            // Đảm bảo page nằm trong khoảng hợp lệ
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;
            int fromIndex = (page - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalBookings);
            List<model.Booking> bookingsPage = (fromIndex < toIndex) ? bookings.subList(fromIndex, toIndex) : java.util.Collections.emptyList();

            request.setAttribute("bookings", bookingsPage);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.getRequestDispatcher("view/customer/my-bookings.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách đặt phòng.");
            request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
