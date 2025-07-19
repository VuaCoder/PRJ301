package controller;

import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Room;

import java.io.IOException;

@WebServlet(name = "RoomDetailServlet", urlPatterns = {"/detail"})
public class RoomDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy ID từ tham số truy vấn
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu room ID");
                return;
            }

            int roomId = Integer.parseInt(idParam);

            // Dùng JPA DAO
            RoomDAO dao = new RoomDAO();
            Room room = dao.findById(roomId);

            // Kiểm tra null
            if (room == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Phòng không tồn tại");
                return;
            }

            // Debug (tùy chọn)
            System.out.println("➡️ Room Title: " + room.getTitle());
            System.out.println("➡️ Room City: " + room.getCity());

            // Truyền dữ liệu sang JSP
            request.setAttribute("room", room);
            // Tách imageList giống home.jsp
            java.util.List<String> imageList = new java.util.ArrayList<>();
            if (room.getImages() != null && !room.getImages().isEmpty()) {
                String[] imgArr = room.getImages().replace("[", "").replace("]", "").replace("\"", "").split(",");
                for (String img : imgArr) {
                    String trimmed = img.trim();
                    if (!trimmed.isEmpty()) imageList.add(trimmed);
                }
            }
            request.setAttribute("imageList", imageList);
            request.getRequestDispatcher("view/common/room-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi máy chủ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Có thể dùng lại GET nếu cần
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị chi tiết phòng theo ID";
    }
}
