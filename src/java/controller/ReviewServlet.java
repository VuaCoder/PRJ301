package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.ReviewService;
import service.BookingService;
import model.UserAccount;
import model.Customer;
import model.Booking;

import java.io.IOException;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    private final ReviewService reviewService = new ReviewService();
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("view/auth/login.jsp");
            return;
        }

        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Thiếu thông tin đặt phòng.");
            request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            
            // Lấy booking
            Booking booking = reviewService.getBookingById(bookingId);
            if (booking == null) {
                request.setAttribute("error", "Không tìm thấy thông tin đặt phòng.");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra xem booking có thuộc về user hiện tại không
            Customer customer = user.getCustomer();
            if (customer == null || !customer.getCustomerId().equals(booking.getCustomerId().getCustomerId())) {
                request.setAttribute("error", "Bạn không có quyền đánh giá đặt phòng này.");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra trạng thái booking
            if (!"Confirmed".equals(booking.getStatus())) {
                request.setAttribute("error", "Chỉ có thể đánh giá đặt phòng đã được xác nhận.");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
                return;
            }
            //kiểm tra đã đánh giá chưa
            boolean hasReviewed = reviewService.hasReviewForBooking(bookingId);
            request.setAttribute("hasReviewed", hasReviewed);
            if (hasReviewed) {
                model.Review review = reviewService.getReviewByBookingId(bookingId);
                request.setAttribute("review", review);
            }
            
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("view/customer/review-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Thông tin đặt phòng không hợp lệ.");
            request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang đánh giá: " + e.getMessage());
            request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("view/auth/login.jsp");
            return;
        }

        String bookingIdStr = request.getParameter("bookingId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (bookingIdStr == null || ratingStr == null || 
            bookingIdStr.trim().isEmpty() || ratingStr.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            // Validate rating
            if (rating < 1 || rating > 5) {
                request.setAttribute("error", "Điểm đánh giá phải từ 1 đến 5.");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
                return;
            }
            
            // Validate comment
            if (comment == null || comment.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập nội dung đánh giá.");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
                return;
            }
            
            if (comment.trim().length() < 10) {
                request.setAttribute("error", "Nội dung đánh giá phải có ít nhất 10 ký tự.");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
                return;
            }
            
            // Tạo review
            boolean success = reviewService.createReview(bookingId, rating, comment);
            
            if (success) {
                response.sendRedirect("my-bookings?message=review-success");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo đánh giá. Có thể bạn đã đánh giá rồi hoặc bảng Review chưa được tạo.");
                request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Thông tin không hợp lệ.");
            request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tạo đánh giá: " + e.getMessage());
            request.getRequestDispatcher("view/common/error.jsp").forward(request, response);
        }
    }
} 