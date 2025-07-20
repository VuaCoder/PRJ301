package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Room;
import dao.RoomDAO;
import model.UserAccount;

@WebServlet(name = "QRPaymentServlet", urlPatterns = ("/qr-payment"))
public class QRPaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("view/auth/login.jsp");
            return;
        }

        String roomIdRaw = request.getParameter("roomId");
        try {
            int roomId = Integer.parseInt(roomIdRaw);
            Room room = new RoomDAO().findById(roomId);
            if (room == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy phòng");
                return;
            }

            String checkin = request.getParameter("checkin");
            String checkout = request.getParameter("checkout");
            String guests = request.getParameter("guests");
            String totalPrice = request.getParameter("totalPrice");

            request.setAttribute("room", room);
            request.setAttribute("checkin", checkin);
            request.setAttribute("checkout", checkout);
            request.setAttribute("guests", guests);
            request.setAttribute("totalPrice", totalPrice);
            request.getRequestDispatcher("qr_payment.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "roomId không hợp lệ");
        }
    }
}
