package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import model.Booking;
import model.UserAccount;
import service.AdminService;
import service.BookingService;

@WebServlet("/admin/admin-customer-detail")
public class AdminCustomerDetailServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int customerId = Integer.parseInt(request.getParameter("customerId"));

            // Lấy thông tin customer
            UserAccount customer = adminService.getUserById(customerId);
            request.setAttribute("customer", customer);

            // Lấy lịch sử booking của customer
            List<Booking> bookings = bookingService.getBookingsByCustomerId(customer.getCustomer().getCustomerId());
            request.setAttribute("bookings", bookings);

            request.getRequestDispatcher("/view/admin/admin-customer-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID");
        }
    }
}
