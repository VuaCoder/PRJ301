package controller;

import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Room;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SearchServlet", urlPatterns = {"/results"})
public class SearchServlet extends HttpServlet {
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Room> searchResults = null;
        String searchType = ""; // To store the type of search performed for JSP

        // Lấy các tham số tìm kiếm
        String location = request.getParameter("location");
        String checkIn = request.getParameter("check_in");
        String checkOut = request.getParameter("check_out");
        String guestsParam = request.getParameter("guests");
        String showAll = request.getParameter("showAll");
        String type = request.getParameter("type");
        String city = request.getParameter("city");

        // 1. Tìm kiếm theo ngày (check-in/check-out)
        if (checkIn != null && !checkIn.trim().isEmpty() && checkOut != null && !checkOut.trim().isEmpty()) {
            try {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.util.Date checkInDate = sdf.parse(checkIn);
                java.util.Date checkOutDate = sdf.parse(checkOut);
                searchResults = roomDAO.getAvailableRooms(checkInDate, checkOutDate);
                // Có thể lọc thêm theo location, guests nếu muốn
                if (location != null && !location.isEmpty()) {
                    searchResults.removeIf(r -> r.getCity() == null || !r.getCity().toLowerCase().contains(location.toLowerCase()));
                }
                if (guestsParam != null && !guestsParam.isEmpty()) {
                    try {
                        int guests = Integer.parseInt(guestsParam);
                        searchResults.removeIf(r -> r.getCapacity() < guests);
                    } catch (NumberFormatException ignored) {}
                }
                searchType = "dateSearch";
            } catch (Exception e) {
                searchResults = List.of();
                searchType = "invalidDate";
            }
        }
        // 2. Nếu có showAll=true, trả về toàn bộ phòng và forward sang all-properties.jsp
        else if (showAll != null && "true".equalsIgnoreCase(showAll)) {
            searchResults = roomDAO.getAllActiveRooms();
            searchType = "showAll";
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("searchType", searchType);
            request.getRequestDispatcher("/view/common/all-properties.jsp").forward(request, response);
            return;
        }
        // 3. Tìm kiếm theo location + guests
        else if (location != null && !location.trim().isEmpty() && guestsParam != null && !guestsParam.trim().isEmpty()) {
            try {
                int guests = Integer.parseInt(guestsParam);
                searchResults = roomDAO.searchRooms(location.trim(), guests);
                request.setAttribute("location", location.trim());
                request.setAttribute("guests", guests);
                searchType = "fullSearch";
            } catch (NumberFormatException e) {
                searchResults = List.of();
                System.err.println("Invalid guests parameter: " + guestsParam);
                searchType = "invalidInput";
            }
        }
        // 4. Tìm kiếm theo type/city
        else if (type != null && !type.trim().isEmpty()) {
            searchResults = roomDAO.searchRoomsByType(type.trim());
            request.setAttribute("type", type.trim());
            searchType = "typeSearch";
        } else if (city != null && !city.trim().isEmpty()) {
            searchResults = roomDAO.getRoomsByCity(city.trim());
            request.setAttribute("city", city.trim());
            searchType = "citySearch";
        }
        // 5. Không có tham số nào, trả về rỗng
        else {
            searchResults = List.of();
            searchType = "noParams";
        }

        // Set the results and search type attribute to be used in JSP
        request.setAttribute("searchResults", searchResults);
        request.setAttribute("searchType", searchType);

        // Nếu là AJAX request thì trả về HTML giống HomeServlet
        String requestedWith = request.getHeader("X-Requested-With");
        if (requestedWith != null && requestedWith.equals("XMLHttpRequest")) {
            response.setContentType("text/html;charset=UTF-8");
            java.io.PrintWriter out = response.getWriter();
            out.println("<div class='property-listing'>");
            if (searchResults != null && !searchResults.isEmpty()) {
                for (Room room : searchResults) {
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
            } else {
                out.println("<div>Không có phòng nào phù hợp với yêu cầu của bạn.</div>");
            }
            out.println("</div>");
            return;
        }

        // Forward to the result JSP
        request.getRequestDispatcher("result.jsp").forward(request, response);
    }
}