package controller;

import dao.HostDAO;
import dao.UserDAO;
import dao.PropertyDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserAccount;
import model.Host;
import model.Property;
import java.io.IOException;

@WebServlet("/becomeHost")
public class BecomeHostServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("view/auth/login.jsp");
            return;
        }
        int userId = user.getUserId();
        String description = request.getParameter("description");
        String propertyName = request.getParameter("propertyName");
        String propertyDescription = request.getParameter("propertyDescription");
        String propertyAddress = request.getParameter("propertyAddress");
        String propertyCity = request.getParameter("propertyCity");
        String latStr = request.getParameter("propertyLatitude");
        String lngStr = request.getParameter("propertyLongitude");
        Double latitude = null, longitude = null;
        try {
            latitude = (latStr != null && !latStr.isEmpty()) ? Double.parseDouble(latStr) : null;
            longitude = (lngStr != null && !lngStr.isEmpty()) ? Double.parseDouble(lngStr) : null;
        } catch (Exception e) {
            // ignore parse error, keep null
        }
        HostDAO hostDAO = new HostDAO();
        UserDAO userDAO = new UserDAO();
        PropertyDAO propertyDAO = new PropertyDAO();
        // Kiểm tra đã là host chưa
        Host host = hostDAO.getHostByUserId(userId);
        int hostId;
        if (host == null) {
            Host newHost = new Host();
            newHost.setUserId(user);
            newHost.setDescription(description);
            newHost.setVerified(false);
            hostId = hostDAO.createHost(newHost);
        } else {
            hostId = host.getHostId();
        }
        boolean updated = userDAO.updateRole(userId, 2); // 2 = host
        // Tạo property mới
        if (hostId > 0 && updated) {
            Property property = new Property();
            property.setHostId(new Host(hostId));
            property.setName(propertyName);
            property.setDescription(propertyDescription);
            property.setAddress(propertyAddress);
            property.setCity(propertyCity);
            property.setLatitude(latitude);
            property.setLongitude(longitude);
            property.setVerified(false);
            propertyDAO.createProperty(property);
            // Cập nhật lại user trong session
            user.setRoleId(new model.Role(2));
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/host/dashboard");
        } else {
            response.getWriter().write("<script>alert('Error: Could not become host!');window.location='home.jsp';</script>");
        }
    }
} 