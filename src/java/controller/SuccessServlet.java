package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/success")
public class SuccessServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        String transactionId = request.getParameter("transactionId");
        String amount = request.getParameter("amount");

        if ("PAID".equalsIgnoreCase(status)) {
            request.setAttribute("message", "✅ Thanh toán thành công!");
        } else {
            request.setAttribute("message", "❌ Thanh toán thất bại hoặc bị hủy.");
        }

        request.getRequestDispatcher("payment_result.jsp").forward(request, response);
    }
}
