package controller;

import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Room;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SearchServlet", urlPatterns = {"/results"})
public class SearchServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Room> searchResults = null;
        String searchType = ""; // To store the type of search performed for JSP

        // Part 2 search (from the main form: location, check-in, check-out, guests)
        String location = request.getParameter("location");
        String checkIn = request.getParameter("check_in"); // Not used in current searchRooms method, but good to have
        String checkOut = request.getParameter("check_out"); // Not used in current searchRooms method, but good to have
        String guestsParam = request.getParameter("guests");

        // Prioritize the main search form if location and guests are provided
        if (location != null && !location.trim().isEmpty() && guestsParam != null && !guestsParam.trim().isEmpty()) {
            try {
                int guests = Integer.parseInt(guestsParam);
                searchResults = roomDAO.searchRooms(location.trim(), guests);
                request.setAttribute("location", location.trim());
                request.setAttribute("guests", guests);
                searchType = "fullSearch";
            } catch (NumberFormatException e) {
                // Handle invalid guests input
                searchResults = List.of(); // Return empty list or handle error appropriately
                System.err.println("Invalid guests parameter: " + guestsParam);
                searchType = "invalidInput";
            }
        } else {
            // Part 1 search (from type or city links)
            String type = request.getParameter("type");
            String city = request.getParameter("city");

            if (type != null && !type.trim().isEmpty()) {
                // Search rooms by type
                searchResults = roomDAO.searchRoomsByType(type.trim());
                request.setAttribute("type", type.trim());
                searchType = "typeSearch";
            } else if (city != null && !city.trim().isEmpty()) {
                // Search rooms by city
                searchResults = roomDAO.getRoomsByCity(city.trim());
                request.setAttribute("city", city.trim());
                searchType = "citySearch";
            } else {
                // If no search parameters, return an empty list or all rooms
                searchResults = List.of();
                searchType = "noParams";
            }
        }

        // Set the results and search type attribute to be used in JSP
        request.setAttribute("searchResults", searchResults);
        request.setAttribute("searchType", searchType);

        // Forward to the result JSP
        request.getRequestDispatcher("result.jsp").forward(request, response);
    }
}