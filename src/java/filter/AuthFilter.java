//package filter;
//
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.io.IOException;
//import model.UserAccount; // Cần import UserAccount model của bạn
//
//@WebFilter(urlPatterns = {"/host/*", "/customer/*", "/admin/*"})
//public class AuthFilter implements Filter {
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//        HttpSession session = req.getSession(false); // Dòng 27
//
//        boolean isLoggedIn = session != null && session.getAttribute("user") != null;
//        String path = req.getRequestURI().substring(req.getContextPath().length());
//
//        if (isLoggedIn) {
//            UserAccount user = (UserAccount) session.getAttribute("user"); // Ép kiểu, có thể gây lỗi nếu object sai
//            if (user == null) { // Thêm kiểm tra null sau khi getAttribute, rất quan trọng
//                res.sendRedirect(req.getContextPath() + "/view/auth/login.jsp");
//                return;
//            }
//
//            // Kiểm tra vai trò dựa trên đường dẫn
//            if (path.startsWith("/host/")) {
//                if (!"host".equals(user.getRoleId())) { // "host" là vai trò từ UserAccount
//                    res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Not authorized as Host.");
//                    // Hoặc chuyển hướng: res.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
//                    return;
//                }
//            } else if (path.startsWith("/customer/")) {
//                if (!"customer".equals(user.getRoleId())) {
//                    res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Not authorized as Customer.");
//                    return;
//                }
//            } else if (path.startsWith("/admin/")) {
//                if (!"admin".equals(user.getRoleId())) {
//                    res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Not authorized as Admin.");
//                    return;
//                }
//            }
//            chain.doFilter(request, response); // Cho phép request đi tiếp nếu pass tất cả kiểm tra
//        } else {
//            // Chưa đăng nhập, chuyển hướng đến trang đăng nhập
//            res.sendRedirect(req.getContextPath() + "/view/auth/login.jsp");
//        }
//    }
//
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {
//    }
//
//    @Override
//    public void destroy() {
//    }
//}