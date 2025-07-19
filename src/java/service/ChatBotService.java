//package service;
//
//    import com.google.gson.JsonArray;
//    import com.google.gson.JsonObject;
//    import com.google.gson.JsonParser;
//    import java.io.*;
//    import java.net.HttpURLConnection;
//    import java.net.URL;
//    import java.sql.Connection;
//    import java.sql.PreparedStatement;
//    import java.sql.ResultSet;
//    import java.util.regex.Matcher;
//    import java.util.regex.Pattern;
//    import util.DBConnection;
//
//    public class ChatBotService {
//
//        private static final String GROQ_API_URL = "https://api.groq.com/openai/v1/chat/completions";
//        private static final String GROQ_API_KEY = "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";
//
//        public JsonObject processChatRequest(String userMessage, boolean showMore) throws Exception {
//            if (userMessage.equalsIgnoreCase("Không, cảm ơn")) {
//        JsonObject response = new JsonObject();
//        response.addProperty("success", true);
//        response.addProperty("message", "Cảm ơn bạn đã sử dụng dịch vụ! Nếu cần hỗ trợ thêm, hãy nhắn cho tôi bất kỳ lúc nào.");
//        return response;
//    }
//
//            System.out.println("Step 1: Getting filtered rooms with AI SQL...");
//            String propertyContext = getFilteredRoomsWithAI(userMessage, showMore);
//            System.out.println("Property context: " + propertyContext);
//
//            System.out.println("Step 2: Creating system prompt...");
//            String systemPrompt = createSystemPrompt(propertyContext);
//
//            if ("KHÔNG_CÓ_PHÒNG".equals(systemPrompt)) {
//                JsonObject jsonResponse = new JsonObject();
//                jsonResponse.addProperty("success", true);
//                jsonResponse.addProperty("message", "Xin lỗi, hiện không có phòng phù hợp với yêu cầu của bạn.");
//                System.out.println("Không có phòng phù hợp - kết thúc sớm.");
//                return jsonResponse;
//            }
//
//            System.out.println("Step 3: Calling Groq API...");
//            String aiResponse = callGroqAPI(systemPrompt, userMessage);
//            System.out.println("AI Response: " + aiResponse);
//
//            try {
//                logChatHistory(userMessage, aiResponse);
//            } catch (Exception logError) {
//                System.err.println("Failed to log chat history (non-critical): " + logError.getMessage());
//            }
//
//            JsonObject jsonResponse = new JsonObject();
//            jsonResponse.addProperty("success", true);
//            jsonResponse.addProperty("message", aiResponse);
//            return jsonResponse;
//        }
//
//        private String getFilteredRoomsWithAI(String userMessage, boolean showMore) throws Exception {
//            System.out.println("=== getFilteredRoomsWithAI ===");
//            System.out.println("User message: " + userMessage);
//            System.out.println("Show more: " + showMore);
//System.out.println("Attempting database connection...");
//
//            StringBuilder context = new StringBuilder();
//
//            try (Connection conn = DBConnection.getConnection()) {
//                System.out.println("Database connected successfully");
//
//                String aiGeneratedSQL = generateSQLWithAI(userMessage, showMore);
//                System.out.println("AI Generated SQL: " + aiGeneratedSQL);
//
//                PreparedStatement stmt = conn.prepareStatement(aiGeneratedSQL);
//                ResultSet rs = stmt.executeQuery();
//
//                int count = 0;
//                while (rs.next()) {
//                    count++;
//                    String title = rs.getString("title");
//                    double price = rs.getDouble("price");
//                    int capacity = rs.getInt("capacity");
//                    String description = rs.getString("description");
//                    String imagesJson = rs.getString("images");
//
//                    String firstImage = extractFirstImage(imagesJson);
//
//                    context.append(String.format("""
//                        <div class='message bot-message' style='margin-bottom:20px;'>
//                            <strong>🏠 Phòng %s:</strong> ,.0f đ/đêm - %d người<br>
//                            📌 %s<br>
//                            <img src='%s' alt='Ảnh phòng' style='width:100%%; max-height:160px; object-fit:cover; border-radius:10px; margin-top:5px;'>
//                        </div>
//                        """, title, price, capacity, description, firstImage));
//                }
//
//                System.out.println("Found " + count + " rooms");
//
//                if (count == 0) {
//                    System.out.println("No rooms found, returning KHÔNG_CÓ_PHÒNG directly");
//                    return "KHÔNG_CÓ_PHÒNG";
//                }
//
//
//            } catch (Exception e) {
//                System.err.println("Database error: " + e.getMessage());
//                e.printStackTrace();
//                System.out.println("Falling back to original method...");
//                return getFilteredRoomsOriginal(userMessage, showMore);
//            }
//
//            System.out.println("Context: " + context.toString());
//            return context.toString();
//        }
//
//    private String extractFirstImage(String json) {
//        if (json == null || json.isBlank()) return "https://via.placeholder.com/300x180.png?text=No+Image";
//        try {
//            JsonArray arr = JsonParser.parseString(json).getAsJsonArray();
//            if (arr.size() > 0) return arr.get(0).getAsString();
//        } catch (Exception e) {
//            System.err.println("Error parsing image JSON: " + e.getMessage());
//        }
//        return "https://via.placeholder.com/300x180.png?text=No+Image";
//    }
//
//
//
//
//        private String generateSQLWithAI(String userMessage, boolean showMore) throws IOException {
//System.out.println("Generating SQL with AI...");
//
//            String sqlPrompt = createSQLGenerationPrompt(userMessage, showMore);
//            String aiResponse = callGroqAPIForSQL(sqlPrompt);
//
//            String sql = extractSQLFromResponse(aiResponse);
//            sql = validateAndSanitizeSQL(sql);
//
//            return sql;
//        }
//
//        private String createSQLGenerationPrompt(String userMessage, boolean showMore) {
//            int limit = showMore ? 8 : 3;
//
//
//            return String.format("""
//                 Bạn là chuyên gia SQL. Dựa vào yêu cầu của khách hàng, hãy tạo câu SQL để tìm phòng phù hợp.
//
//                    SCHEMA DATABASE:
//                    - Room(room_id, property_id, title, description, capacity, price, images, status)
//                    - Property(property_id, host_id, name, description, address, city, ...)
//
//                    YÊU CẦU KHÁCH HÀNG: "%s"
//
//                    QUY TẮC TẠO SQL:
//                    1. Chỉ lấy phòng có status = 'Available'
//                    2. JOIN Room r với Property p ON r.property_id = p.property_id
//                    3. Nếu người dùng yêu cầu thành phố (VD: 'Nha Trang'), lọc theo p.city LIKE '%%...%%'
//                    4. SELECT các cột: r.title, r.price, r.capacity, r.description, p.city
//                    5. Sắp xếp theo giá từ thấp đến cao
//                    6. Giới hạn %d kết quả (dùng TOP %d cho SQL Server)
//
//                    PHÂN TÍCH NGÔN NGỮ TỰ NHIÊN:
//                    - \"đơn/single\": description LIKE N'%%đơn%%'
//                    - \"đôi/double\": description LIKE N'%%đôi%%'
//                    - \"vip\": description LIKE N'%%VIP%%'
//                    - \"view\": description LIKE N'%%view%%'
//                    - \"dưới X triệu\": price <= X*1000000
//                    - \"dưới X nghìn/k\": price <= X*1000
//                    - \"từ X tới Y\": price BETWEEN X AND Y
//                    - \"X người\": capacity >= X
//                    - \"rẻ/giá rẻ\": ORDER BY price ASC
//                    - \"đắt/cao cấp\": ORDER BY price DESC
//
//                    CHỈ TRẢ VỀ CÂU SQL, KHÔNG GIẢI THÍCH.
//                """, userMessage, limit, limit);
//        }
//
//         private String getFilteredRoomsOriginal(String userMessage, boolean showMore) throws Exception {
//            StringBuilder context = new StringBuilder();
//            String fallbackCity = extractCityFromMessage(userMessage);
//
//            try (Connection conn = DBConnection.getConnection()) {
//                String sql = buildDynamicQuery(userMessage, showMore);
//                System.out.println("Fallback SQL: " + sql);
//
//                PreparedStatement stmt = conn.prepareStatement(sql);
//                ResultSet rs = stmt.executeQuery();
//
//                context.append("Danh sách phòng có sẵn:\n");
//                int count = 0;
//                while (rs.next()) {
//                    count++;
//String title = rs.getString("title");
//                    double price = rs.getDouble("price");
//                    int capacity = rs.getInt("capacity");
//                    String description = rs.getString("description");
//
//                    context.append(String.format(
//                            "- Phòng %s: %,.0f đ/đêm - %d người - %s\n",
//                            title, price, capacity, description
//                    ));
//                }
//
//                if (count == 0) {
//                    // Nếu không có phòng theo yêu cầu, thử lấy 3 phòng bất kỳ tại thành phố đó
//                    String top3sql = "SELECT TOP 3 r.title, r.price, r.capacity, r.description " +
//                                     "FROM Room r JOIN Property p ON r.property_id = p.property_id " +
//                                     "WHERE r.status = 'Available' AND p.city LIKE ? ORDER BY r.price ASC";
//
//                    PreparedStatement top3stmt = conn.prepareStatement(top3sql);
//                    top3stmt.setString(1, "%" + fallbackCity + "%");
//                    ResultSet top3rs = top3stmt.executeQuery();
//
//                    int fallbackCount = 0;
//                    while (top3rs.next()) {
//                        fallbackCount++;
//                        String title = top3rs.getString("title");
//                        double price = top3rs.getDouble("price");
//                        int capacity = top3rs.getInt("capacity");
//                        String description = top3rs.getString("description");
//
//                        context.append(String.format(
//                                "- Phòng %s: %,.0f đ/đêm - %d người - %s\n",
//                                title, price, capacity, description
//                        ));
//                    }
//
//                    if (fallbackCount == 0) {
//                        context.append(String.format("Hiện tại không còn phòng nào khả dụng ở %s.\n", fallbackCity));
//                    }
//                }
//
//            } catch (Exception e) {
//                System.err.println("Fallback error: " + e.getMessage());
//                context.append("Hiện tại chưa có phòng tại thành phố bạn mong muốn");
//
//            }
//
//            return context.toString();
//        }
//
//        private String extractCityFromMessage(String message) {
//            message = message.toLowerCase();
//            if (message.contains("nha trang")) return "Nha Trang";
//            if (message.contains("đà lạt") || message.contains("da lat")) return "Đà Lạt";
//            if (message.contains("hà nội")) return "Hà Nội";
//            if (message.contains("thanh hóa") || message.contains("thanh hoa")) return "Thanh Hóa";
//            return ""; // fallback nếu không phát hiện được thành phố
//        }
//        private String callGroqAPIForSQL(String prompt) throws IOException {
//            URL url = new URL(GROQ_API_URL);
//HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//
//            conn.setConnectTimeout(10000);
//            conn.setReadTimeout(30000);
//
//            conn.setRequestMethod("POST");
//            conn.setRequestProperty("Authorization", "Bearer " + GROQ_API_KEY);
//            conn.setRequestProperty("Content-Type", "application/json");
//            conn.setDoOutput(true);
//
//            JsonObject request = new JsonObject();
//            request.addProperty("model", "llama3-8b-8192");
//            request.addProperty("max_tokens", 300);
//            request.addProperty("temperature", 0.1);
//
//            JsonArray messages = new JsonArray();
//
//            JsonObject userMessage = new JsonObject();
//            userMessage.addProperty("role", "user");
//            userMessage.addProperty("content", prompt);
//            messages.add(userMessage);
//
//            request.add("messages", messages);
//
//            try (OutputStream os = conn.getOutputStream()) {
//                byte[] input = request.toString().getBytes("utf-8");
//                os.write(input, 0, input.length);
//            }
//
//            int responseCode = conn.getResponseCode();
//            if (responseCode != 200) {
//                throw new IOException("SQL AI API call failed with code " + responseCode);
//            }
//
//            StringBuilder response = new StringBuilder();
//            try (BufferedReader br = new BufferedReader(
//                    new InputStreamReader(conn.getInputStream(), "utf-8"))) {
//                String responseLine;
//                while ((responseLine = br.readLine()) != null) {
//                    response.append(responseLine.trim());
//                }
//            }
//
//            JsonObject jsonResponse = JsonParser.parseString(response.toString()).getAsJsonObject();
//            JsonArray choices = jsonResponse.getAsJsonArray("choices");
//            if (choices != null && choices.size() > 0) {
//                JsonObject firstChoice = choices.get(0).getAsJsonObject();
//                JsonObject message = firstChoice.getAsJsonObject("message");
//                return message.get("content").getAsString();
//            }
//
//            throw new IOException("Failed to get SQL from AI");
//        }
//
//        private String extractSQLFromResponse(String aiResponse) {
//            String sql = aiResponse.replaceAll("```sql", "").replaceAll("```", "").trim();
//
//            String[] lines = sql.split("\n");
//            StringBuilder cleanSQL = new StringBuilder();
//
//            for (String line : lines) {
//                line = line.trim();
//                if (line.toUpperCase().startsWith("SELECT") || 
//                    line.toUpperCase().startsWith("FROM") ||
//                    line.toUpperCase().startsWith("WHERE") ||
//                    line.toUpperCase().startsWith("AND") ||
//                    line.toUpperCase().startsWith("OR") ||
//line.toUpperCase().startsWith("ORDER") ||
//                    line.toUpperCase().startsWith("TOP") ||
//                    cleanSQL.length() > 0) {
//                    cleanSQL.append(line).append(" ");
//                }
//            }
//
//            return cleanSQL.toString().trim();
//        }
//
//           private String validateAndSanitizeSQL(String sql) {
//            String[] forbiddenKeywords = {"DROP", "DELETE", "UPDATE", "INSERT", "ALTER", "CREATE", "EXEC", "--", "/*", "*/"};
//
//            String upperSQL = sql.toUpperCase();
//            for (String keyword : forbiddenKeywords) {
//                if (upperSQL.contains(keyword)) {
//                    System.err.println("[SECURITY WARNING] Forbidden keyword detected in SQL: " + keyword);
//                    return "SELECT TOP 3 r.title, r.capacity, r.price, r.description, p.city " +
//                           "FROM Room r JOIN Property p ON r.property_id = p.property_id " +
//                           "WHERE r.status = 'Available' ORDER BY r.price ASC";
//                }
//            }
//
//            if (!upperSQL.trim().startsWith("SELECT")) {
//                throw new IllegalArgumentException("Invalid SQL query generated by AI (must start with SELECT)");
//            }
//
//            return sql;
//        }
//
//         private String buildDynamicQuery(String userMessage, boolean showMore) {
//            StringBuilder sql = new StringBuilder();
//
//            sql.append("SELECT ");
//            sql.append(showMore ? "TOP 8 " : "TOP 3 ");
//            sql.append("r.title, r.capacity, r.price, r.description, p.city ");
//            sql.append("FROM Room r JOIN Property p ON r.property_id = p.property_id ");
//            sql.append("WHERE r.status = 'Available' ");
//
//            String message = userMessage.toLowerCase();
//
//            // Nếu người dùng nói đến tên thành phố
//         if (message.contains("nha trang")) {
//        sql.append("AND LOWER(p.city) LIKE '%nha trang%' ");
//    } else if (message.contains("đà lạt") || message.contains("da lat")) {
//        sql.append("AND LOWER(p.city) LIKE '%da lat%' ");
//    } else if (message.contains("hà nội") || message.contains("ha noi")) {
//        sql.append("AND LOWER(p.city) LIKE '%ha noi%' ");
//    } else if (message.contains("thanh hóa") || message.contains("thanh hoa")) {
//        sql.append("AND LOWER(p.city) LIKE '%thanh hoa%' ");
//    } else if (message.contains("hồ chí minh") || message.contains("ho chi minh") || message.contains("sai gon") || message.contains("sài gòn")) {
//        sql.append("AND LOWER(p.city) LIKE '%ho chi minh%' ");
//    }else if (message.contains("đà nẵng") || message.contains("da nang")) {
//        sql.append("AND LOWER(p.city) LIKE '%da nang%' ");
//    }
//         
//         
//
//            // Loại phòng - dựa trên mô tả trong description
//            if (message.contains("suite")) {
//sql.append("AND r.description LIKE N'%suite%' ");
//            } else if (message.contains("đơn") || message.contains("don") || message.contains("single")) {
//                sql.append("AND r.description LIKE N'%single%' ");
//            } else if (message.contains("đôi") || message.contains("doi") || message.contains("double")) {
//                sql.append("AND r.description LIKE N'%double%' ");
//            }
//
//            String priceCondition = extractPriceRange(userMessage);
//            if (!priceCondition.isEmpty()) {
//                sql.append("AND " + priceCondition + " ");
//            }
//
//            int capacity = extractCapacity(userMessage);
//            if (capacity > 0) {
//                sql.append("AND r.capacity >= " + capacity + " ");
//            }
//
//            // Nếu người dùng hỏi phòng rẻ nhất hoặc có từ khóa liên quan
//            if (message.contains("rẻ nhất") || message.contains("thấp nhất") || message.contains("giá thấp")) {
//                sql.append("ORDER BY r.price ASC");
//            } else if (message.contains("đắt nhất") || message.contains("cao cấp nhất")) {
//                sql.append("ORDER BY r.price DESC");
//            } else {
//                sql.append("ORDER BY r.price ASC");
//            }
//
//            return sql.toString();
//        }
//
//
//        private String extractPriceRange(String message) {
//            message = message.toLowerCase();
//
//            try {
//                if (message.matches(".*dưới\\s*\\d+\\s*triệu.*")) {
//                    Pattern pattern = Pattern.compile("dưới\\s*(\\d+)\\s*triệu");
//                    Matcher matcher = pattern.matcher(message);
//                    if (matcher.find()) {
//                        long maxPrice = Long.parseLong(matcher.group(1)) * 1000000;
//                        return "price <= " + maxPrice;
//                    }
//                }
//
//                if (message.matches(".*dưới\\s*\\d+\\s*[k|nghìn].*")) {
//                    Pattern pattern = Pattern.compile("dưới\\s*(\\d+)\\s*(?:k|nghìn)");
//                    Matcher matcher = pattern.matcher(message);
//                    if (matcher.find()) {
//                        long maxPrice = Long.parseLong(matcher.group(1)) * 1000;
//                        return "price <= " + maxPrice;
//                    }
//                }
//
//                if (message.matches(".*từ\\s*\\d+.*tới\\s*\\d+.*")) {
//                    Pattern pattern = Pattern.compile("từ\\s*(\\d+).*?tới\\s*(\\d+)");
//                    Matcher matcher = pattern.matcher(message);
//                    if (matcher.find()) {
//                        long minPrice = Long.parseLong(matcher.group(1)) * 1000;
//                        long maxPrice = Long.parseLong(matcher.group(2)) * 1000;
//                        return "price BETWEEN " + minPrice + " AND " + maxPrice;
//                    }
//}
//            } catch (NumberFormatException e) {
//                System.err.println("Error parsing price: " + e.getMessage());
//            }
//
//            return "";
//        }
//
//        private int extractCapacity(String message) {
//            Pattern pattern = Pattern.compile("(\\d+)\\s*người");
//            Matcher matcher = pattern.matcher(message);
//            if (matcher.find()) {
//                try {
//                    return Integer.parseInt(matcher.group(1));
//                } catch (NumberFormatException e) {
//                    System.err.println("Error parsing capacity: " + e.getMessage());
//                }
//            }
//            return 0;
//        }
//
//        private void logChatHistory(String userInput, String botResponse) throws Exception {
//            try (Connection conn = DBConnection.getConnection()) {
//                String sql = "INSERT INTO AIChatLog (user_id, question, answer, timestamp) VALUES (?, ?, ?, GETDATE())";
//                PreparedStatement stmt = conn.prepareStatement(sql);
//                stmt.setInt(1, 1); // Replace with actual user_id
//                stmt.setString(2, userInput);
//                stmt.setString(3, botResponse);
//                stmt.executeUpdate();
//            } catch (Exception e) {
//                System.err.println("Error logging chat: " + e.getMessage());
//            }
//        }
//
//       private String createSystemPrompt(String propertyContext) {
//            if (propertyContext.contains("KHÔNG_CÓ_PHÒNG")) {
//                return "KHÔNG_CÓ_PHÒNG";
//            }
//
//            return String.format("""
//                Bạn là một trợ lý ảo chuyên hỗ trợ tra cứu khách sạn. Dưới đây là danh sách phòng khả dụng lấy trực tiếp từ cơ sở dữ liệu. TUYỆT ĐỐI KHÔNG bịa đặt hay tạo ra thông tin không có. Nếu không có phòng phù hợp, hãy trả lời rõ ràng là không có.
//
//                NHIỆM VỤ:
//                1. Phân tích yêu cầu khách hàng về loại phòng, số người, giá, địa điểm
//                2. Nếu chỉ có một tiêu chí như 'phòng rẻ nhất ở Nha Trang' thì chỉ cần gợi ý 1–2 phòng thỏa mãn đúng điều kiện đó
//                3. Ngược lại, đề xuất 3–5 phòng phù hợp nhất trong danh sách bên dưới
//                4. Mỗi phòng trình bày gồm: tên phòng, giá/đêm, mô tả ngắn gọn đặc điểm nổi bật
//                5. Nếu có nhiều phòng giống nhau, chọn phòng rẻ hơn trước
//                6. Kết thúc bằng: "Bạn có muốn xem thêm lựa chọn khác không?"
//
//                QUY TẮC TRẢ LỜI:
//                - Ngôn ngữ: tiếng Việt, lịch sự và thân thiện
//                - Thông tin ngắn gọn, chính xác, không thêm thắt
//                - Luôn hiển thị giá cụ thể theo định dạng ###,000 đ/đêm
//                - Dữ liệu đầu vào nằm trong danh sách bên dưới
//
//                %s
//
//                Ví dụ cách trình bày:
//"Dạ, có một số phòng phù hợp với yêu cầu của bạn:
//
//                🛏️ Pine View Double Room: 450,000 đ/đêm
//                - Phòng đôi nhìn ra rừng thông, có giường queen
//
//                🛏️ Garden View Single Room: 300,000 đ/đêm
//                - Phòng đơn nhìn ra vườn, yên tĩnh
//
//                🛏️ Family Suite: 800,000 đ/đêm
//                - Phù hợp cho gia đình, có bếp nhỏ
//
//                Bạn có muốn xem thêm lựa chọn khác không?"
//            """, propertyContext);
//        }
//
//
//       private String callGroqAPI(String systemPrompt, String userMessage) throws IOException {
//        System.out.println("➡️ Bắt đầu gọi Groq API...");
//
//        URL url = new URL(GROQ_API_URL);
//        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//
//        // Cài đặt timeout mạnh hơn
//        conn.setConnectTimeout(10000);  // 10 giây kết nối
//        conn.setReadTimeout(20000);     // 20 giây phản hồi
//
//        conn.setRequestMethod("POST");
//        conn.setRequestProperty("Authorization", "Bearer " + GROQ_API_KEY);
//        conn.setRequestProperty("Content-Type", "application/json");
//        conn.setDoOutput(true);
//
//        JsonObject request = new JsonObject();
//        request.addProperty("model", "llama3-8b-8192");
//        request.addProperty("max_tokens", 400);
//        request.addProperty("temperature", 0.7);
//
//        JsonArray messages = new JsonArray();
//
//        JsonObject systemMessage = new JsonObject();
//        systemMessage.addProperty("role", "system");
//        systemMessage.addProperty("content", systemPrompt);
//        messages.add(systemMessage);
//
//        JsonObject userMessageObj = new JsonObject();
//        userMessageObj.addProperty("role", "user");
//        userMessageObj.addProperty("content", userMessage);
//        messages.add(userMessageObj);
//
//        request.add("messages", messages);
//
//        System.out.println("➡️ Gửi request đến Groq...");
//        try (OutputStream os = conn.getOutputStream()) {
//            byte[] input = request.toString().getBytes("utf-8");
//            os.write(input, 0, input.length);
//        }
//
//        int responseCode = conn.getResponseCode();
//        System.out.println("✅ Response Code từ Groq: " + responseCode);
//
//        if (responseCode != 200) {
//            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"));
//            StringBuilder errorResponse = new StringBuilder();
//            String line;
//            while ((line = br.readLine()) != null) {
//                errorResponse.append(line.trim());
//            }
//            System.err.println("❌ API lỗi: " + errorResponse);
//            throw new IOException("Groq API trả về lỗi: " + responseCode);
//        }
//
//        StringBuilder response = new StringBuilder();
//try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
//            String line;
//            while ((line = br.readLine()) != null) {
//                response.append(line.trim());
//            }
//        }
//
//        System.out.println("✅ Nhận được phản hồi JSON từ Groq");
//
//        try {
//
//            JsonObject jsonResponse = JsonParser.parseString(response.toString()).getAsJsonObject();
//            JsonArray choices = jsonResponse.getAsJsonArray("choices");
//
//            if (choices == null || choices.size() == 0) {
//                System.err.println("❗ Groq trả về phản hồi rỗng.");
//                return "Xin lỗi, hiện tôi không thể đưa ra gợi ý phù hợp. Vui lòng thử lại sau.";
//            }
//
//            JsonObject firstChoice = choices.get(0).getAsJsonObject();
//            JsonObject message = firstChoice.getAsJsonObject("message");
//            return message.get("content").getAsString();
//
//        } catch (Exception e) {
//            System.err.println("❗ Lỗi khi phân tích phản hồi từ Groq: " + e.getMessage());
//            return "Xin lỗi, tôi đang gặp sự cố xử lý phản hồi. Vui lòng thử lại sau.";
//        }
//    }
//
//    }
