package service;

import dao.AmenityDAO;
import model.Amenity;
import java.util.List;

public class AmenityService {
    private AmenityDAO amenityDAO = new AmenityDAO();

    public List<Amenity> getAllAmenities() {
        return amenityDAO.findAll();
    }
} 