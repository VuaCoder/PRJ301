package controller;

import dao.UserDAO;
import model.UserAccount;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;

@WebServlet("/login")
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("email")) {
                    request.setAttribute("email", URLDecoder.decode(c.getValue(), "UTF-8"));
                }
                if (c.getName().equals("password")) {
                    request.setAttribute("password", URLDecoder.decode(c.getValue(), "UTF-8"));
                }
            }
        }

        request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email"); // tên input trong form login (forms.js)
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        UserAccount user = dao.checkLogin(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user); // lưu session
            String remember = request.getParameter("remember");
            if ("on".equals(remember)) {
                Cookie cUser = new Cookie("email", URLEncoder.encode(email, "UTF-8"));
                Cookie cPass = new Cookie("password", URLEncoder.encode(password, "UTF-8"));
                cUser.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
                cPass.setMaxAge(7 * 24 * 60 * 60);
                response.addCookie(cUser);
                response.addCookie(cPass);
            } else {
                Cookie cUser = new Cookie("email", null);
                Cookie cPass = new Cookie("password", null);
                cUser.setMaxAge(7 * 24 * 60 * 60);
                cPass.setMaxAge(0);
                response.addCookie(cUser);
                response.addCookie(cPass);
            }

            String role = user.getRoleId().getRoleName();

            // Điều hướng theo role
            switch (role) {
                case "customer":
                    response.sendRedirect(request.getContextPath() + "/home");
                    break;
                case "host":
                    response.sendRedirect(request.getContextPath() + "/host/dashboard");
                    break;
                case "admin":
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
                    break;
            }

        } else {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
        }
    }
}
