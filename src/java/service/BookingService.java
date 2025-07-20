package service;

import dao.BookingDAO;
import dao.RoomDAO;
import dao.CustomerDAO;
import model.Booking;
import model.Room;
import model.Customer;
import model.UserAccount;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class BookingService {

    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private CustomerDAO customerDAO;

    public BookingService() {
        this.bookingDAO = new BookingDAO();
        this.roomDAO = new RoomDAO();
        this.customerDAO = new CustomerDAO();
    }

    /**
     * Kiểm tra phòng có sẵn trong khoảng thời gian
     */
    public boolean isRoomAvailable(int roomId, Date checkin, Date checkout) {
        return bookingDAO.isRoomAvailable(roomId, checkin, checkout);
    }

    /**
     * Tạo booking mới
     */
    public boolean createBooking(int roomId, int customerId, Date checkin, Date checkout, 
                                int guests, BigDecimal totalPrice) {
        try {
            // Kiểm tra phòng có sẵn
            if (!isRoomAvailable(roomId, checkin, checkout)) {
                System.out.println("Room " + roomId + " is not available for the selected dates");
                return false;
            }

            // Lấy thông tin phòng và customer
            Room room = roomDAO.findById(roomId);
            Customer customer = customerDAO.findById(customerId);

            if (room == null || customer == null) {
                return false;
            }

            // Tạo booking mới
            Booking booking = new Booking();
            booking.setRoomId(room);
            booking.setCustomerId(customer);
            booking.setCheckinDate(checkin);
            booking.setCheckoutDate(checkout);
            booking.setGuests(guests);
            booking.setTotalPrice(totalPrice);
            booking.setStatus("Pending");
            booking.setCreatedAt(new Date());

            // Tạo booking
            boolean bookingCreated = bookingDAO.createBooking(booking);
            
            if (bookingCreated) {
                // Cập nhật status phòng thành Unavailable
                roomDAO.updateRoomStatus(roomId, "Unavailable");
                System.out.println("Room " + roomId + " status updated to Unavailable");
            }
            
            return bookingCreated;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Tính tổng tiền cho booking
     */
    public BigDecimal calculateTotalPrice(int roomId, Date checkin, Date checkout) {
        Room room = roomDAO.findById(roomId);
        if (room == null || room.getPrice() == null) {
            return BigDecimal.ZERO;
        }

        // Tính số ngày
        long diffInMillies = checkout.getTime() - checkin.getTime();
        long diffInDays = diffInMillies / (24 * 60 * 60 * 1000);

        return room.getPrice().multiply(new BigDecimal(diffInDays));
    }

    /**
     * Lấy danh sách booking theo customer
     */
    public List<Booking> getBookingsByCustomerId(int customerId) {
        return bookingDAO.getBookingsByCustomerId(customerId);
    }

    /**
     * Lấy danh sách booking theo phòng
     */
    public List<Booking> getBookingsByRoomId(int roomId) {
        return bookingDAO.getBookingsByRoomId(roomId);
    }

    /**
     * Lấy danh sách booking theo host
     */
    public List<Booking> getBookingsByHostId(int hostId) {
        return bookingDAO.getBookingsByHostId(hostId);
    }

    /**
     * Cập nhật trạng thái booking
     */
    public boolean updateBookingStatus(int bookingId, String newStatus) {
        return bookingDAO.updateBookingStatus(bookingId, newStatus);
    }

    /**
     * Hủy booking
     */
    public boolean cancelBooking(int bookingId) {
        Booking booking = getBookingById(bookingId);
        if (booking != null) {
            boolean updated = updateBookingStatus(bookingId, "Cancelled");
            if (updated) {
                // Kiểm tra xem phòng có còn booking nào khác không
                List<Booking> activeBookings = bookingDAO.getBookingsByRoomId(booking.getRoomId().getRoomId());
                boolean hasOtherActiveBookings = activeBookings.stream()
                    .anyMatch(b -> b.getBookingId() != bookingId && 
                                 (b.getStatus().equals("Pending") || b.getStatus().equals("Confirmed")));
                
                // Nếu không có booking nào khác, cập nhật status phòng thành Available
                if (!hasOtherActiveBookings) {
                    roomDAO.updateRoomStatus(booking.getRoomId().getRoomId(), "Available");
                    System.out.println("Room " + booking.getRoomId().getRoomId() + " status updated to Available after cancellation");
                }
            }
            return updated;
        }
        return false;
    }

    /**
     * Xác nhận booking
     */
    public boolean confirmBooking(int bookingId) {
        Booking booking = getBookingById(bookingId);
        if (booking != null) {
            boolean updated = updateBookingStatus(bookingId, "Confirmed");
            if (updated) {
                // Cập nhật status phòng thành Unavailable khi xác nhận
                roomDAO.updateRoomStatus(booking.getRoomId().getRoomId(), "Unavailable");
                System.out.println("Room " + booking.getRoomId().getRoomId() + " status updated to Unavailable after confirmation");
            }
            return updated;
        }
        return false;
    }

    /**
     * Lấy booking theo ID
     */
    public Booking getBookingById(int bookingId) {
        return bookingDAO.findById(bookingId);
    }
} 