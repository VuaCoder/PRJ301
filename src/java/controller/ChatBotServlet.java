package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import service.ChatBotService;

@WebServlet("/chat")
public class ChatBotServlet extends HttpServlet {

    private ChatBotService chatBotService;

    @Override
    public void init() throws ServletException {
        super.init();
        chatBotService = new ChatBotService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String userMessage = null;
        String showMore = null;

        System.out.println("=== [ChatBotServlet] ===");
        System.out.println("Content-Type: " + request.getContentType());
        System.out.println("Method: " + request.getMethod());

        // Get form parameters
        userMessage = request.getParameter("message");
        showMore = request.getParameter("showMore");

        System.out.println("Form parameters - message: " + userMessage + ", showMore: " + showMore);

        // Read JSON body if needed
        if ((userMessage == null || userMessage.trim().isEmpty()) &&
            request.getContentType() != null && request.getContentType().contains("application/json")) {
            StringBuilder buffer = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    buffer.append(line);
                }
            }

            String jsonBody = buffer.toString();
            System.out.println("JSON Body: " + jsonBody);

            if (!jsonBody.trim().isEmpty()) {
                try {
                    JsonObject jsonRequest = JsonParser.parseString(jsonBody).getAsJsonObject();
                    if (jsonRequest.has("message")) {
                        userMessage = jsonRequest.get("message").getAsString();
                    }
                    if (jsonRequest.has("showMore")) {
                        showMore = jsonRequest.get("showMore").getAsString();
                    }
                } catch (Exception ex) {
                    System.err.println("❌ JSON parsing error: " + ex.getMessage());
                }
            }
        }

        System.out.println("Final - User message: " + userMessage);
        System.out.println("Final - Show more: " + showMore);

        if (userMessage == null || userMessage.trim().isEmpty()) {
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "⚠️ Vui lòng nhập tin nhắn.");
            response.getWriter().write(errorResponse.toString());
            return;
        }

        try {
            JsonObject jsonResponse = chatBotService.processChatRequest(
                userMessage, "true".equalsIgnoreCase(showMore)
            );
            response.getWriter().write(jsonResponse.toString());
            System.out.println("✅ ChatBot response sent successfully.");

        } catch (Exception e) {
            // In lỗi ra console
            System.err.println("❌ ERROR in ChatBotServlet:");
            e.printStackTrace();

            // Tạo phản hồi lỗi gửi về chat UI
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);

            StringBuilder errorMsg = new StringBuilder("❌ Xin lỗi, hệ thống gặp lỗi.\n");

            errorMsg.append("📛 Loại lỗi: ").append(e.getClass().getSimpleName()).append("\n");
            if (e.getMessage() != null) {
                errorMsg.append("📋 Chi tiết: ").append(e.getMessage());
            } else {
                errorMsg.append("Không có mô tả lỗi cụ thể.");
            }

            errorResponse.addProperty("message", errorMsg.toString());
            response.getWriter().write(errorResponse.toString());
        }
    }
}
