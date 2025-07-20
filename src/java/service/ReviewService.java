package service;

import dao.ReviewDAO;
import dao.BookingDAO;
import model.Review;
import model.Booking;
import java.util.List;

public class ReviewService {

    private final ReviewDAO reviewDAO;
    private final BookingDAO bookingDAO;

    public ReviewService() {
        this.reviewDAO = new ReviewDAO();
        this.bookingDAO = new BookingDAO();
    }

    // Tạo review mới
    public boolean createReview(int bookingId, int rating, String comment) {
        try {
            // Kiểm tra xem booking đã có review chưa
            if (reviewDAO.hasReviewForBooking(bookingId)) {
                return false; // Đã có review rồi
            }

            // Lấy booking
            Booking booking = bookingDAO.findById(bookingId);
            if (booking == null) {
                return false;
            }

            // Kiểm tra trạng thái booking phải là Confirmed
            if (!"Confirmed".equals(booking.getStatus())) {
                return false;
            }

            // Tạo review mới
            Review review = new Review();
            review.setBookingId(booking);
            review.setRating(rating);
            review.setComment(comment);

            return reviewDAO.createReview(review);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy review theo bookingId
    public Review getReviewByBookingId(int bookingId) {
        return reviewDAO.getReviewByBookingId(bookingId);
    }

    // Lấy tất cả review theo roomId
    public List<Review> getReviewsByRoomId(int roomId) {
        return reviewDAO.getReviewsByRoomId(roomId);
    }

    // Lấy tất cả review theo customerId
    public List<Review> getReviewsByCustomerId(int customerId) {
        return reviewDAO.getReviewsByCustomerId(customerId);
    }

    // Lấy tất cả review theo hostId
    public List<Review> getReviewsByHostId(int hostId) {
        return reviewDAO.getReviewsByHostId(hostId);
    }

    // Kiểm tra xem booking đã có review chưa
    public boolean hasReviewForBooking(int bookingId) {
        return reviewDAO.hasReviewForBooking(bookingId);
    }

    // Tính điểm trung bình của room
    public double getAverageRatingByRoomId(int roomId) {
        return reviewDAO.getAverageRatingByRoomId(roomId);
    }

    // Đếm số review của room
    public int getReviewCountByRoomId(int roomId) {
        return reviewDAO.getReviewCountByRoomId(roomId);
    }

    // Lấy booking theo ID
    public Booking getBookingById(int bookingId) {
        return bookingDAO.findById(bookingId);
    }

    // Lấy tất cả đánh giá
    public List<Review> getAllReviews() {
        return reviewDAO.getAllReviews();
    }
} 