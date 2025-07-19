package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/thankyou")
public class ThankYouServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu cần truyền thêm thông tin như bookingId thì có thể dùng request.setAttribute
        request.getRequestDispatcher("view/customer/thankyou.jsp").forward(request, response);
    }
}
