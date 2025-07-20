package controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.oauth2.Oauth2;
import com.google.api.services.oauth2.model.Userinfo;
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

    private static final String CLIENT_ID = "701939732906-jtaqhn70lb55hsk4iod5q66635s22gql.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:9999/login";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code != null) {
            // Xử lý đăng nhập Google
            try {
                GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                        new NetHttpTransport(),
                        JacksonFactory.getDefaultInstance(),
                        "https://oauth2.googleapis.com/token",
                        CLIENT_ID,
                        CLIENT_SECRET,
                        code,
                        REDIRECT_URI
                ).execute();

                GoogleCredential credential = new GoogleCredential().setAccessToken(tokenResponse.getAccessToken());

                Oauth2 oauth2 = new Oauth2.Builder(
                        new NetHttpTransport(),
                        JacksonFactory.getDefaultInstance(),
                        credential
                ).setApplicationName("StaytionBooking").build();

                Userinfo userInfo = oauth2.userinfo().get().execute();

                String email = userInfo.getEmail();
                String name = userInfo.getName();

                UserDAO dao = new UserDAO();
                UserAccount user = dao.findByEmail(email);

                if (user == null) {
                    dao.createGoogleUser(email, name); // Tạo user mới với role customer
                    user = dao.findByEmail(email);
                }
                // Nếu user đã có nhưng chưa có role, gán role customer
                if (user.getRoleId() == null) {
                    dao.assignDefaultRole(user.getUserId());
                    user = dao.findByEmail(email);
                }

                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                String role = user.getRoleId().getRoleName();
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
                return;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Đăng nhập Google thất bại");
                request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
                return;
            }
        }
        // Nếu không có code, hiển thị form login (bình thường)
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

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        UserAccount user = dao.checkLogin(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            String remember = request.getParameter("remember");
            if ("on".equals(remember)) {
                Cookie cUser = new Cookie("email", URLEncoder.encode(email, "UTF-8"));
                Cookie cPass = new Cookie("password", URLEncoder.encode(password, "UTF-8"));
                cUser.setMaxAge(7 * 24 * 60 * 60);
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

            // Kiểm tra xem có pending booking không
            String pendingBooking = (String) session.getAttribute("pendingBooking");
            if (pendingBooking != null) {
                session.removeAttribute("pendingBooking");
                response.sendRedirect(request.getContextPath() + "/booking?" + pendingBooking);
                return;
            }

            String role = user.getRoleId().getRoleName();
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
