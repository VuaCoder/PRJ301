package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import model.Booking;
import model.Customer;
import service.AdminService;

@WebServlet("/admin/admin-customer-detail")
public class AdminCustomerDetailServlet extends HttpServlet {
    private final AdminService adminService = new AdminService();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int customerId = Integer.parseInt(req.getParameter("customerId"));
        int page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;

        Customer customer = adminService.getCustomerById(customerId); // Lấy theo customerId
        if (customer == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
            return;
        }
        long totalBookings = adminService.countBookingsByCustomerId(customerId);
        List<Booking> bookings = adminService.getBookingsByCustomerIdWithReviews(customerId, page, PAGE_SIZE);

        req.setAttribute("customer", customer);
        req.setAttribute("bookings", bookings);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", (int) Math.ceil((double) totalBookings / PAGE_SIZE));
        req.getRequestDispatcher("/view/admin/admin-customer-detail.jsp").forward(req, resp);
    }
}

