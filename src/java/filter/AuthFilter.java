package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.UserAccount; // Cần import UserAccount model của bạn

@WebFilter(urlPatterns = {"/host/*", "/customer/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false); // Dòng 27

        boolean isLoggedIn = session != null && session.getAttribute("user") != null;
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (isLoggedIn) {
            UserAccount user = (UserAccount) session.getAttribute("user");
            if (user == null || user.getRoleId() == null) {
                res.sendRedirect(req.getContextPath() + "/view/auth/login.jsp");
                return;
            }
            String role = user.getRoleId().getRoleName().toLowerCase();
            // Kiểm tra vai trò dựa trên đường dẫn
            if (path.startsWith("/host/")) {
                if (!"host".equals(role)) {
                    res.sendRedirect(req.getContextPath() + "/view/common/error403.jsp");
                    return;
                }
            } else if (path.startsWith("/customer/")) {
                if (!"customer".equals(role) && !"guest".equals(role)) {
                    res.sendRedirect(req.getContextPath() + "/view/common/error403.jsp");
                    return;
                }
            } else if (path.startsWith("/admin/")) {
                if (!"admin".equals(role)) {
                    res.sendRedirect(req.getContextPath() + "/view/common/error403.jsp");
                    return;
                }
            }
            chain.doFilter(request, response); // Cho phép request đi tiếp nếu pass tất cả kiểm tra
        } else {
            // Chưa đăng nhập, chuyển hướng đến trang đăng nhập
            res.sendRedirect(req.getContextPath() + "/view/auth/login.jsp");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}