package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
import service.*;
import util.saveImageUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet("/host/room")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class RoomServlet extends HttpServlet {

    private RoomService roomService = new RoomService();
    private PropertyService propertyService = new PropertyService();
    private AmenityService amenityService = new AmenityService();
    private HostService hostService = new HostService();
    private saveImageUtil imageUtil = new saveImageUtil(); // 👈 Cloudinary uploader

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
            Host host = hostService.getHostByUserId(user.getUserId());
            List<Property> properties = host != null
                    ? propertyService.getPropertiesByHostId(host.getHostId())
                    : new ArrayList<>();
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
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int propertyId = Integer.parseInt(request.getParameter("propertyId"));
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            java.math.BigDecimal price = new java.math.BigDecimal(request.getParameter("price"));

            Room room = new Room();
            room.setTitle(title);
            room.setDescription(description);
            room.setCapacity(capacity);
            room.setPrice(price);
            room.setStatus("Available");
            room.setCreatedAt(new Date());

            Property property = propertyService.getPropertyById(propertyId);
            room.setPropertyId(property);

            List<String> imageUrls = new ArrayList<>();
            for (Part part : request.getParts()) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    try {
                        String url = imageUtil.upload(part);
                        if (url != null) {
                            imageUrls.add(url);
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
            room.setImages(String.join(",", imageUrls));

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

                if (status != null && !status.trim().isEmpty()) {
                    room.setStatus(status);
                }

                List<String> imageUrls = new ArrayList<>();
                for (Part part : request.getParts()) {
                    if (part.getName().equals("images") && part.getSize() > 0) {
                        try {
                            String url = imageUtil.upload(part);
                            if (url != null) {
                                imageUrls.add(url);
                            }
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }

                if (!imageUrls.isEmpty()) {
                    room.setImages(String.join(",", imageUrls));
                }

                roomService.updateRoom(room);
            }
            response.sendRedirect(request.getContextPath() + "/host/dashboard");

        }
    }
}
