package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.*;

@WebServlet("/webhook")
public class WebhookServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BufferedReader reader = request.getReader();
        StringBuilder body = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            body.append(line);
        }

        JSONObject json = new JSONObject(body.toString());

        String status = json.getString("status");
        String orderCode = json.getString("orderCode");

        if ("PAID".equalsIgnoreCase(status)) {
            System.out.println("✅ Giao dịch " + orderCode + " đã thanh toán thành công (từ webhook)");
            // 👉 TODO: cập nhật trạng thái đơn hàng trong DB
        }

        response.setStatus(HttpServletResponse.SC_OK);
    }
}
