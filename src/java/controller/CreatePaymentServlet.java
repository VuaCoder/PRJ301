package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet("/create-payment")
public class CreatePaymentServlet extends HttpServlet {

    private static final String CLIENT_ID = "48e7127a-1620-4f70-b49a-9ee88ef8f0d9";
    private static final String API_KEY = "2d66588d-5c95-46a2-ac30-9f3ea8ac5bca";
    private static final String ENDPOINT = "https://api.payos.vn/v1/payment-requests";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int amount = 500000; // VNĐ — có thể lấy từ DB phòng
        String description = "Thanh toán đặt phòng khách sạn";
        String returnUrl = "http://localhost:8080/home/my-bookings";
        String cancelUrl = "http://localhost:8080/home";

        JSONObject json = new JSONObject();
        json.put("amount", amount);
        json.put("description", description);
        json.put("returnUrl", returnUrl);
        json.put("cancelUrl", cancelUrl);

        URL url = new URL(ENDPOINT);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("x-client-id", CLIENT_ID);
        conn.setRequestProperty("x-api-key", API_KEY);
        conn.setDoOutput(true);

        OutputStream os = conn.getOutputStream();
        os.write(json.toString().getBytes("UTF-8"));
        os.close();

        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String inputLine;
        StringBuilder responseText = new StringBuilder();
        while ((inputLine = in.readLine()) != null) {
            responseText.append(inputLine);
        }
        in.close();

        JSONObject responseJson = new JSONObject(responseText.toString());
        String checkoutUrl = responseJson.getString("checkoutUrl");

        response.sendRedirect(checkoutUrl); // chuyển hướng sang trang thanh toán
    }
}
