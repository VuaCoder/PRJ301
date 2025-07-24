/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.HostDAO;
import dao.RoomDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Map;
import model.Host;
import model.UserAccount;

/**
 *
 * @author HOANG PHUC
 */
@WebServlet("/host/statistics")
public class HostStatisticServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final HostDAO hostDAO = new HostDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserAccount user = (UserAccount) request.getSession().getAttribute("user");
        if (user == null || !"host".equalsIgnoreCase(user.getRoleId().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Host host = hostDAO.getHostByUserId(user.getUserId());
        if (host == null) {
            response.sendRedirect(request.getContextPath() + "/view/host/become_host.jsp");
            return;
        }

        int hostId = host.getHostId();
        long activeRooms = roomDAO.countActiveRoomsByHost(hostId);
        long emptyRooms = roomDAO.countEmptyRoomsByHost(hostId);
        Map<String, Double> revenueMap = roomDAO.getMonthlyRevenueByHost(hostId);
        request.setAttribute("monthlyRevenue", revenueMap);

        request.setAttribute("activeRoomCount", activeRooms);
        request.setAttribute("emptyRoomCount", emptyRooms);


// Thêm dòng này để truyền tổng doanh thu
        double totalRevenue = revenueMap.values().stream()
                .mapToDouble(Double::doubleValue)
                .sum();
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("/view/host/statistic.jsp").forward(request, response);
    }
}