package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.ReviewService;
import service.HostService;
import model.UserAccount;
import model.Host;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HostReviewServlet", urlPatterns = {"/host/reviews"})
public class HostReviewServlet extends HttpServlet {

    private final ReviewService reviewService = new ReviewService();
    private final HostService hostService = new HostService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
            return;
        }

        // Kiểm tra xem user có phải là host không
        Host host = hostService.getHostByUserId(user.getUserId());
        if (host == null) {
            response.sendRedirect(request.getContextPath() + "/view/host/become_host.jsp");
            return;
        }

        try {
            // Lấy tất cả đánh giá của host hiện tại
            List<model.Review> hostReviews = reviewService.getReviewsByHostId(host.getHostId());

            request.setAttribute("reviews", hostReviews);
            request.getRequestDispatcher("/view/host/review-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang đánh giá.");
            request.getRequestDispatcher("/view/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 