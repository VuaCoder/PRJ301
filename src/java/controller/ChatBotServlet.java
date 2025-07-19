//package controller;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.*;
//import com.google.gson.JsonObject;
//import com.google.gson.JsonParser;
//import service.ChatBotService;
//
//@WebServlet("/chat")
//public class ChatBotServlet extends HttpServlet {
//    
//    private ChatBotService chatBotService;
//
//    @Override
//    public void init() throws ServletException {
//        super.init();
//        chatBotService = new ChatBotService();
//    }
//    
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        
//        request.setCharacterEncoding("UTF-8");
//        response.setContentType("application/json;charset=UTF-8");
//        response.setCharacterEncoding("UTF-8");
//        
//        String userMessage = null;
//        String showMore = null;
//        
//        // Add detailed logging
//        System.out.println("=== ChatBot Debug ===");
//        System.out.println("Content-Type: " + request.getContentType());
//        System.out.println("Method: " + request.getMethod());
//        
//        // Get parameters first (form data from JSP)
//        userMessage = request.getParameter("message");
//        showMore = request.getParameter("showMore");
//        
//        System.out.println("Form parameters - message: " + userMessage + ", showMore: " + showMore);
//        
//        // If form parameters are null, try JSON
//        if (userMessage == null || userMessage.trim().isEmpty()) {
//            String contentType = request.getContentType();
//            if (contentType != null && contentType.contains("application/json")) {
//                StringBuilder buffer = new StringBuilder();
//                String line;
//                try (BufferedReader reader = request.getReader()) {
//                    while ((line = reader.readLine()) != null) {
//                        buffer.append(line);
//                    }
//                }
//                String jsonBody = buffer.toString();
//                System.out.println("JSON Body: " + jsonBody);
//                
//                if (!jsonBody.trim().isEmpty()) {
//                    try {
//                        JsonObject jsonRequest = JsonParser.parseString(jsonBody).getAsJsonObject();
//                        userMessage = jsonRequest.has("message") ? jsonRequest.get("message").getAsString() : null;
//                        showMore = jsonRequest.has("showMore") ? jsonRequest.get("showMore").getAsString() : null;
//                    } catch (Exception e) {
//                        System.err.println("Error parsing JSON: " + e.getMessage());
//                    }
//                }
//            }
//        }
//        
//        System.out.println("Final - User message: " + userMessage);
//        System.out.println("Final - Show more: " + showMore);
//        
//        // Validate input
//        if (userMessage == null || userMessage.trim().isEmpty()) {
//            JsonObject errorResponse = new JsonObject();
//            errorResponse.addProperty("success", false);
//            errorResponse.addProperty("message", "Vui lòng nhập tin nhắn.");
//            response.getWriter().write(errorResponse.toString());
//            return;
//        }
//        
//        try {
//            // Process request using service
//            JsonObject jsonResponse = chatBotService.processChatRequest(userMessage, "true".equals(showMore));
//            response.getWriter().write(jsonResponse.toString());
//            System.out.println("=== Request completed successfully ===");
//            
//        } catch (Exception e) {
//            System.err.println("=== ERROR in ChatBotServlet ===");
//            e.printStackTrace();
//            
//            String errorMessage = "Xin lỗi, tôi đang gặp sự cố. Vui lòng thử lại sau.";
//            if (e.getMessage() != null) {
//                if (e.getMessage().contains("Connection")) {
//                    errorMessage = "Lỗi kết nối database. Vui lòng thử lại.";
//                } else if (e.getMessage().contains("API")) {
//                    errorMessage = "Lỗi kết nối AI service. Vui lòng thử lại.";
//                }
//            }
//            
//            JsonObject errorResponse = new JsonObject();
//            errorResponse.addProperty("success", false);
//            errorResponse.addProperty("message", errorMessage);
//            response.getWriter().write(errorResponse.toString());
//        }
//    }
//}