package controller;

import dao.BookingDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Booking;

import java.io.IOException;
import java.util.List;
import model.UserAccount;
//@WebServlet("/home/my-bookings")
//public class MyBookingsServlet extends HttpServlet {
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        UserAccount user = (UserAccount) session.getAttribute("user");
//
//        if (user == null || user.getCustomer() == null) {
//            response.sendRedirect("view/auth/login.jsp");
//            return;
//        }
//
//        int customerId = user.getCustomer().getCustomerId();
//
//        String bookingIdStr = request.getParameter("bookingId");
//        if (bookingIdStr != null) {
//            int bookingId = Integer.parseInt(bookingIdStr);
//            Booking booking = new BookingDAO().findById(bookingId);
//            request.setAttribute("booking", booking);
//            request.getRequestDispatcher("/view/customer/booking_detail.jsp").forward(request, response);
//            return;
//        }
//
//        List<Booking> bookings = new BookingDAO().getBookingsByCustomerId(customerId);
//        request.setAttribute("bookings", bookings);
//        request.getRequestDispatcher("/view/customer/my_bookings.jsp").forward(request, response);
//    }
//}
@WebServlet("/home/my-bookings")
public class MyBookingsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (user == null || user.getCustomer() == null) {
            response.sendRedirect("view/auth/login.jsp");
            return;
        }

        int customerId = user.getCustomer().getCustomerId();
        List<Booking> bookings = new BookingDAO().getBookingsByCustomerId(customerId);

        request.setAttribute("bookings", bookings);

        String status = request.getParameter("status");
        if ("PAID".equalsIgnoreCase(status)) {
            request.setAttribute("message", "✅ Đặt phòng thành công!");
        }

        request.getRequestDispatcher("/view/customer/my_bookings.jsp").forward(request, response);
    }
}
