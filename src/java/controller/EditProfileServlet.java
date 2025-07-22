package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.UserAccount;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import util.saveImageUtil;

@WebServlet(name = "EditProfileServlet", urlPatterns = {"/edit-profile"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
public class EditProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        Part avatarPart = request.getPart("avatar");
        String deleteAvatar = request.getParameter("deleteAvatar");

        boolean avatarUpdated = false;
        boolean passwordUpdated = false;
        boolean avatarDeleted = false;

        // Handle avatar deletion
        if ("true".equals(deleteAvatar)) {
            user.setAvatarUrl(null);
            userDAO.update(user);
            session.setAttribute("user", user);
            avatarDeleted = true;
        } else if (avatarPart != null && avatarPart.getSize() > 0) {
            saveImageUtil uploader = new saveImageUtil();
            try {
                String avatarUrl = uploader.upload(avatarPart);
                user.setAvatarUrl(avatarUrl);
                userDAO.update(user);
                session.setAttribute("user", user);
                avatarUpdated = true;
            } catch (Exception e) {
                request.setAttribute("error", "Failed to upload avatar: " + e.getMessage());
                request.getRequestDispatcher("/view/auth/edit-profile.jsp").forward(request, response);
                return;
            }
        }

        // Handle password change only if password fields are filled
        if (currentPassword != null && !currentPassword.isEmpty() && newPassword != null && !newPassword.isEmpty()) {
            if (!user.getPassword().equals(currentPassword)) {
                request.setAttribute("error", "Current password is incorrect.");
                request.getRequestDispatcher("/view/auth/edit-profile.jsp").forward(request, response);
                return;
            }
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New passwords do not match.");
                request.getRequestDispatcher("/view/auth/edit-profile.jsp").forward(request, response);
                return;
            }
            user.setPassword(newPassword);
            userDAO.update(user);
            session.setAttribute("user", user);
            passwordUpdated = true;
        }

        if (avatarUpdated) {
            request.setAttribute("avatarSuccess", true);
        }
        if (passwordUpdated) {
            request.setAttribute("passwordSuccess", true);
        }
        if (avatarDeleted) {
            request.setAttribute("avatarDeleted", true);
        }
        request.getRequestDispatcher("/view/auth/edit-profile.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/view/auth/edit-profile.jsp");
    }
} 