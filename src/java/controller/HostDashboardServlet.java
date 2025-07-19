/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.HostDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Host;
import model.Room;
import model.UserAccount;
import service.RoomService;

/**
 *
 * @author quangminhnguyen
 */
@WebServlet("/host/dashboard")
public class HostDashboardServlet extends HttpServlet {
    private final RoomService roomService = new RoomService();
    private final HostDAO hostDAO = new HostDAO();

    //chưa chặn được nếu là người dùng thì vẫn có thể vào dashboard
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserAccount user = (UserAccount) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Host host = hostDAO.getHostByUserId(user.getUserId());
        if (host == null) {
            response.sendRedirect(request.getContextPath() + "/view/host/become_host.jsp");
            return;
        }

        List<Room> rooms = roomService.getRoomsByHostId(host.getHostId());
        request.setAttribute("rooms", rooms);
        request.setAttribute("host", host); // Add host information
        request.getRequestDispatcher("/view/host/dashboard.jsp").forward(request, response);
    }
}

