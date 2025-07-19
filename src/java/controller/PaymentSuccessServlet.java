package controller;

import dao.BookingDAO;
import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Booking;
import model.Room;
import model.UserAccount;

@WebServlet("/payment-success")
public class PaymentSuccessServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");

        try {
            // Lấy thông tin từ form thanh toán hoặc session
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            Date checkin = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("checkin"));
            Date checkout = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("checkout"));
            int guests = Integer.parseInt(request.getParameter("guests"));
            BigDecimal total = new BigDecimal(request.getParameter("totalPrice"));

            Room room = new RoomDAO().findById(roomId); // Đảm bảo bạn có RoomDAO

            Booking booking = new Booking();
            booking.setRoomId(room);
            booking.setCustomerId(user.getCustomer());
            booking.setCheckinDate(checkin);
            booking.setCheckoutDate(checkout);
            booking.setGuests(guests);
            booking.setTotalPrice(total);
            booking.setCreatedAt(new Date());
            booking.setStatus("Paid");

            boolean success = new BookingDAO().createBooking(booking);

            if (success) {
                response.sendRedirect("my-bookings?status=PAID");
            } else {
                response.sendRedirect("payment-error.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("payment-error.jsp");
        }
    }
}
