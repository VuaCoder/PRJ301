package controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserAccount;
import model.Room;
import model.Property;
import model.Amenity;
import service.RoomService;
// Bạn cần tự tạo PropertyService, AmenityService nếu chưa có
import java.io.IOException;
import java.util.List;
import service.AmenityService;
import service.PropertyService;
import model.Host;
import service.HostService;
import java.nio.file.Paths;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

@WebServlet("/host/room")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class RoomServlet extends HttpServlet {
    private RoomService roomService = new RoomService();
    // Giả sử bạn đã có PropertyService và AmenityService
    private PropertyService propertyService = new PropertyService();
    private AmenityService amenityService = new AmenityService();
    private HostService hostService = new HostService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
            return;
        }
        if ("create".equals(action)) {
            // Lấy hostId từ userId
            Host host = hostService.getHostByUserId(user.getUserId());
            List<Property> properties = null;
            if (host != null) {
                properties = propertyService.getPropertiesByHostId(host.getHostId());
            }
            List<Amenity> amenities = amenityService.getAllAmenities();
            request.setAttribute("properties", properties);
            request.setAttribute("amenities", amenities);
            request.getRequestDispatcher("/view/host/add-room.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            int roomId = Integer.parseInt(request.getParameter("id"));
            Room room = roomService.getRoomById(roomId);
            request.setAttribute("room", room);
            request.getRequestDispatcher("/view/host/edit-room.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            int roomId = Integer.parseInt(request.getParameter("id"));
            roomService.deleteRoom(roomId);
            response.sendRedirect(request.getContextPath() + "/host/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
            return;
        }
        if ("create".equals(action)) {
            // Lấy dữ liệu từ form và tạo phòng mới
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int propertyId = Integer.parseInt(request.getParameter("propertyId"));
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            java.math.BigDecimal price = new java.math.BigDecimal(request.getParameter("price"));
            // String status = request.getParameter("status"); // Bỏ lấy status từ form
            // Xử lý images và amenities nếu cần
            Room room = new Room();
            room.setTitle(title);
            room.setDescription(description);
            room.setCapacity(capacity);
            room.setPrice(price);
            // room.setStatus(status); // Bỏ dòng này
            room.setStatus("Available"); // Luôn set là Available
            room.setCreatedAt(new java.util.Date()); // Set thời gian hiện tại
            // Set property cho room
            Property property = propertyService.getPropertyById(propertyId);
            room.setPropertyId(property);
            // Xử lý upload ảnh
            String uploadPath = getServletContext().getRealPath("") + File.separator + "img";
            System.out.println("[DEBUG] Upload path: " + uploadPath);
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            List<String> imageFileNames = new ArrayList<>();
            for (Part part : request.getParts()) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    part.write(uploadPath + File.separator + uniqueFileName);
                    imageFileNames.add(uniqueFileName);
                }
            }
            System.out.println("[DEBUG] Uploaded images: " + imageFileNames);
            room.setImages(String.join(",", imageFileNames));
            roomService.addRoom(room);
            response.sendRedirect(request.getContextPath() + "/host/dashboard");
        } else if ("edit".equals(action)) {
            int roomId = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            java.math.BigDecimal price = new java.math.BigDecimal(request.getParameter("price"));
            String status = request.getParameter("status");
            Room room = roomService.getRoomById(roomId);
            if (room != null) {
                room.setTitle(title);
                room.setDescription(description);
                room.setCapacity(capacity);
                room.setPrice(price);
                // Nếu status null hoặc rỗng thì giữ nguyên status cũ, không set lại
                if (status != null && !status.trim().isEmpty()) {
                    room.setStatus(status);
                }
                // KHÔNG cập nhật createdAt khi update
                // Xử lý upload ảnh khi edit
                String uploadPath = getServletContext().getRealPath("") + File.separator + "img";
                System.out.println("[DEBUG] (EDIT) Upload path: " + uploadPath);
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                List<String> imageFileNames = new ArrayList<>();
                for (Part part : request.getParts()) {
                    if (part.getName().equals("images") && part.getSize() > 0) {
                        String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                        part.write(uploadPath + File.separator + uniqueFileName);
                        imageFileNames.add(uniqueFileName);
                    }
                }
                if (!imageFileNames.isEmpty()) {
                    System.out.println("[DEBUG] (EDIT) Uploaded images: " + imageFileNames);
                    room.setImages(String.join(",", imageFileNames));
                }
                // Nếu không upload ảnh mới, giữ nguyên ảnh cũ
                roomService.updateRoom(room);
            }
            response.sendRedirect(request.getContextPath() + "/host/dashboard");
        }
    }
}