package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.BookingService;
import service.RoomService;
import dao.CustomerDAO;
import dao.baseDAO;
import model.Room;
import model.UserAccount;
import model.Customer;
import javax.persistence.EntityManager;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "BookingServlet", urlPatterns = {"/booking"})
public class BookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final RoomService roomService = new RoomService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("check-availability".equals(action)) {
            checkAvailability(request, response);
        } else if ("get-room-details".equals(action)) {
            getRoomDetails(request, response);
        } else {
            // Hiển thị form booking
            showBookingForm(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create-booking".equals(action)) {
            createBooking(request, response);
        } else if ("cancel-booking".equals(action)) {
            cancelBooking(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    /**
     * Hiển thị form booking
     */
    private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập trước
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        
        if (user == null) {
            // Lưu thông tin booking vào session để sau khi đăng nhập có thể tiếp tục
            session.setAttribute("pendingBooking", request.getQueryString());
            response.sendRedirect("view/auth/login.jsp?redirect=booking");
            return;
        }
        
        String roomId = request.getParameter("roomId");
        String checkin = request.getParameter("checkin");
        String checkout = request.getParameter("checkout");
        String guests = request.getParameter("guests");

        if (roomId == null || checkin == null || checkout == null || guests == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            int roomIdInt = Integer.parseInt(roomId);
            Room room = roomService.getRoomById(roomIdInt);
            
            if (room == null) {
                response.sendRedirect("home");
                return;
            }

            // Parse dates theo dd/MM/yyyy
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            Date checkinDate = sdf.parse(checkin);
            Date checkoutDate = sdf.parse(checkout);
            int guestsInt = Integer.parseInt(guests);

            // Kiểm tra availability
            boolean isAvailable = bookingService.isRoomAvailable(roomIdInt, checkinDate, checkoutDate);
            
            if (!isAvailable) {
                request.setAttribute("error", "Phòng không có sẵn trong khoảng thời gian này");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
                return;
            }

            // Tính tổng tiền
            BigDecimal totalPrice = bookingService.calculateTotalPrice(roomIdInt, checkinDate, checkoutDate);

            request.setAttribute("room", room);
            request.setAttribute("checkin", checkin);
            request.setAttribute("checkout", checkout);
            request.setAttribute("guests", guests);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("isAvailable", isAvailable);

            request.getRequestDispatcher("view/customer/booking-form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }

    /**
     * Kiểm tra availability
     */
    private void checkAvailability(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String roomId = request.getParameter("roomId");
        String checkin = request.getParameter("checkin");
        String checkout = request.getParameter("checkout");

        try {
            int roomIdInt = Integer.parseInt(roomId);
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            Date checkinDate = sdf.parse(checkin);
            Date checkoutDate = sdf.parse(checkout);

            boolean isAvailable = bookingService.isRoomAvailable(roomIdInt, checkinDate, checkoutDate);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"available\": " + isAvailable + "}");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid parameters\"}");
        }
    }

    /**
     * Lấy thông tin phòng
     */
    private void getRoomDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String roomId = request.getParameter("roomId");

        try {
            int roomIdInt = Integer.parseInt(roomId);
            Room room = roomService.getRoomById(roomIdInt);
            
            if (room == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"roomId\": " + room.getRoomId() + 
                                    ", \"title\": \"" + room.getTitle() + "\"" +
                                    ", \"price\": " + room.getPrice() + "}");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    /**
     * Tạo booking mới
     */
    private void createBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("view/auth/login.jsp");
            return;
        }

        String roomId = request.getParameter("roomId");
        String checkin = request.getParameter("checkin");
        String checkout = request.getParameter("checkout");
        String guests = request.getParameter("guests");

        try {
            int roomIdInt = Integer.parseInt(roomId);
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            Date checkinDate = sdf.parse(checkin);
            Date checkoutDate = sdf.parse(checkout);
            int guestsInt = Integer.parseInt(guests);

            // Kiểm tra availability
            if (!bookingService.isRoomAvailable(roomIdInt, checkinDate, checkoutDate)) {
                request.setAttribute("error", "Phòng không có sẵn trong khoảng thời gian này");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
                return;
            }

            // Tính tổng tiền
            BigDecimal totalPrice = bookingService.calculateTotalPrice(roomIdInt, checkinDate, checkoutDate);

            // Lấy customer từ user
            Customer customer = user.getCustomer();
            
            if (customer == null) {
                // Tạo customer mới cho user
                customer = new Customer();
                customer.setUserId(user);
                customer.setAddress("");
                customer.setGender(null);
                customer.setDob(null);
                customer.setIdentityNo("");
                
                // Lưu customer vào database
                CustomerDAO customerDAO = new CustomerDAO();
                boolean customerCreated = customerDAO.createCustomer(customer);
                
                if (!customerCreated) {
                    request.setAttribute("error", "Không thể tạo thông tin khách hàng.");
                    request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
                    return;
                }
            }

            // Tạo booking
            boolean success = bookingService.createBooking(roomIdInt, customer.getCustomerId(), checkinDate, checkoutDate, guestsInt, totalPrice);

            if (success) {
                // Redirect đến trang thành công
                response.sendRedirect("thankyou?bookingId=" + roomIdInt);
            } else {
                request.setAttribute("error", "Không thể tạo booking. Vui lòng thử lại.");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
        }
    }

    /**
     * Hủy booking
     */
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookingId = request.getParameter("bookingId");
        
        try {
            int bookingIdInt = Integer.parseInt(bookingId);
            boolean success = bookingService.cancelBooking(bookingIdInt);
            
            if (success) {
                response.sendRedirect("my-bookings?message=booking-cancelled");
            } else {
                request.setAttribute("error", "Không thể hủy booking. Vui lòng thử lại.");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
        }
    }
} 