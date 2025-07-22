package controller;

import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Room;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lọc theo type nếu có
        String type = request.getParameter("type");
        if (type != null && !type.trim().isEmpty()) {
            type = type.trim();

            List<Room> roomsByType = roomDAO.searchRoomsByType(type);
            if (roomsByType != null && !roomsByType.isEmpty()) {
                response.setContentType("text/html;charset=UTF-8");
                for (Room room : roomsByType) {
                    String cityName = (room.getPropertyId() != null && room.getPropertyId().getCity() != null)
                            ? room.getPropertyId().getCity()
                            : "Unknown";

                    response.getWriter().println(
                            "<div class=\"card\" onclick=\"window.location.href='detail?id=" + room.getRoomId() + "'\">"
                            + "<div class=\"card-footer\">"
                            + "<div class=\"image-placeholder\"></div>"
                            + "<h4>" + room.getTitle() + "</h4>"
                            + "<p>" + cityName + "</p>"
                            + "</div></div>"
                    );
                }
                return;
            }
        }

//        // 2. Nearby theo city nếu có
        String city = request.getParameter("city");
        // Chuẩn hóa city cho các trường hợp phổ biến
        if (city != null) {
            String cityLower = city.toLowerCase();
            if (cityLower.contains("hồ chí minh") || cityLower.contains("ho chi minh")) city = "Ho Chi Minh";
            
        }

        if (city != null && !city.trim().isEmpty()) {
            List<Room> nearbyRooms = new RoomDAO().getRoomsByCity(city);

            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();

            for (Room room : nearbyRooms) {
                String imageUrl = null;
                if (room.getImages() != null && !room.getImages().isEmpty()) {
                    String[] imgArr = room.getImages().replace("[", "").replace("]", "").replace("\"", "").split(",");
                    imageUrl = imgArr[0].trim();
                    if (!imageUrl.startsWith("http")) {
                        imageUrl = "img/" + imageUrl;
                    }
                }
                out.println("<div class='home-room-card' onclick=\"window.location.href='detail?id=" + room.getRoomId() + "'\">"
                        + (imageUrl != null && !imageUrl.isEmpty() && !imageUrl.equals("img/")
                            ? ("<img src='" + imageUrl + "' style='width:100%;height:180px;object-fit:cover;display:block;border-top-left-radius:16px;border-top-right-radius:16px;margin:0;padding:0;' alt='Room Image'>")
                            : ("<div class='home-room-img home-room-img-placeholder' style='width:100%;height:180px;display:flex;align-items:center;justify-content:center;background:#f3f3f3;color:#aaa;font-size:1.1rem;font-weight:600;letter-spacing:0.5px;border-top-left-radius:16px;border-top-right-radius:16px;'>Room Image</div>"))
                        + "<div class='home-room-info p-4'>"
                        + "<h4>" + room.getTitle() + "</h4>"
                        + "<p>" + room.getCity() + "</p>"
                        + "</div>"
                        + "</div>");
            }
            if (nearbyRooms.isEmpty()) {
                out.println("<div>Không có phòng nào ở thành phố này/Hiện tại các phòng đã được đặt hết...</div>");
            }
            return;
        }

        // Xử lý lọc realtime nếu là AJAX request (fetch)
        String requestedWith = request.getHeader("X-Requested-With");
        String location = request.getParameter("location");
        String money = request.getParameter("money");
        String checkIn = request.getParameter("check-in");
        String checkOut = request.getParameter("check-out");
        String guestsParam = request.getParameter("guests");
        
        if (requestedWith != null && requestedWith.equals("XMLHttpRequest")) {
            List<Room> allRooms = roomDAO.getAllActiveRooms();
            
            // Kiểm tra availability theo thời gian thực
            if (checkIn != null && !checkIn.isEmpty() && checkOut != null && !checkOut.isEmpty()) { 
                try {
                    // Parse ngày từ yyyy-MM-dd format (HTML date input)
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date checkInDate = sdf.parse(checkIn);
                    Date checkOutDate = sdf.parse(checkOut);

                    // Luôn gọi hàm lọc phòng, bất kể ngày vào lớn hơn hay nhỏ hơn ngày ra
                    allRooms = roomDAO.getAvailableRooms(checkInDate, checkOutDate);
                    System.out.println("=== Availability Check (Always) ===");
                    System.out.println("Check-in: " + checkInDate);
                    System.out.println("Check-out: " + checkOutDate);
                    System.out.println("Available rooms: " + allRooms.size());
                } catch (Exception e) {
                    System.out.println("Error parsing dates: " + e.getMessage());
                }
            }
            
            // Lọc theo location
            if (location != null && !location.isEmpty()) {
                allRooms.removeIf(r -> r.getCity() == null || 
                    !r.getCity().toLowerCase().contains(location.toLowerCase()));
            }
            
            // Lọc theo money (giá tiền)
            if (money != null && !money.isEmpty()) {
                allRooms.removeIf(r -> !matchMoneyFilter(r.getPrice(), money));
            }
            
            // Lọc theo số khách
            if (guestsParam != null && !guestsParam.isEmpty()) {
                try {
                    int guests = Integer.parseInt(guestsParam);
                    allRooms.removeIf(r -> r.getCapacity() < guests);
                } catch (NumberFormatException ignored) {}
            }
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            if (!allRooms.isEmpty()) {
                for (Room room : allRooms) {
                    String imageUrl = null;
                    if (room.getImages() != null && !room.getImages().isEmpty()) {
                        String[] imgArr = room.getImages().replace("[", "").replace("]", "").replace("\"", "").split(",");
                        imageUrl = imgArr[0].trim();
                        if (!imageUrl.startsWith("http")) {
                            imageUrl = "img/" + imageUrl;
                        }
                    }
                    out.println("<div class='home-room-card' onclick=\"window.location.href='detail?id=" + room.getRoomId() + "'\">"
                        + (imageUrl != null && !imageUrl.isEmpty() && !imageUrl.equals("img/")
                            ? ("<img src='" + imageUrl + "' style='width:100%;height:180px;object-fit:cover;display:block;border-top-left-radius:16px;border-top-right-radius:16px;margin:0;padding:0;' alt='Room Image'>")
                            : ("<div class='home-room-img home-room-img-placeholder' style='width:100%;height:180px;display:flex;align-items:center;justify-content:center;background:#f3f3f3;color:#aaa;font-size:1.1rem;font-weight:600;letter-spacing:0.5px;border-top-left-radius:16px;border-top-right-radius:16px;'>Room Image</div>"))
                        + "<div class='home-room-info p-4'>"
                        + "<h4>" + room.getTitle() + "</h4>"
                        + "<p>" + room.getCity() + "</p>"
                        + "</div>"
                        + "</div>");
                }
                out.println("</div>");
            } else {
                out.println("<div>Không có phòng nào phù hợp với yêu cầu của bạn.</div>");
            }
            return;
        }

        // 3. Nếu không có type hoặc city, thì load latestRooms và nearbyRooms mặc định
        List<Room> latestRooms = roomDAO.getLatestRooms(10);
        // Lấy nearbyRooms mặc định (ví dụ: lấy 5 phòng ở thành phố đầu tiên có trong DB, hoặc random)
        List<Room> nearbyRooms = roomDAO.getRoomsByCity(latestRooms.size() > 0 ? latestRooms.get(0).getCity() : "");
        if (nearbyRooms.size() > 5) nearbyRooms = nearbyRooms.subList(0, 5);

        request.setAttribute("latestRooms", latestRooms);
        request.setAttribute("nearbyRooms", nearbyRooms);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Xử lý POST như GET
    }

    @Override
    public String getServletInfo() {
        return "Trang chủ hiển thị danh sách phòng mới nhất, theo loại, hoặc theo thành phố (Nearby)";
    }

    // Hàm lọc giá tiền theo money option (BigDecimal)
    private boolean matchMoneyFilter(java.math.BigDecimal price, String money) {
        if (price == null) return false;
        java.math.BigDecimal fiveHundredK = new java.math.BigDecimal("500000");
        java.math.BigDecimal oneMillion = new java.math.BigDecimal("1000000");
        java.math.BigDecimal twoMillion = new java.math.BigDecimal("2000000");
        switch (money) {
            case "gia re": // Dưới 500.000
                return price.compareTo(fiveHundredK) < 0;
            case "trung binh thap": // 500.000 - 1.000.000
                return price.compareTo(fiveHundredK) >= 0 && price.compareTo(oneMillion) <= 0;
            case "trung binh cao": // 1.000.000 - 2.000.000
                return price.compareTo(oneMillion) > 0 && price.compareTo(twoMillion) <= 0;
            case "mr beast": // Trên 2.000.000
                return price.compareTo(twoMillion) > 0;
            default:
                return true;
        }
    }
}
