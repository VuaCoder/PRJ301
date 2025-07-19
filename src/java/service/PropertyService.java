package service;

import dao.PropertyDAO;
import model.Property;
import java.util.List;

public class PropertyService {
    private PropertyDAO propertyDAO = new PropertyDAO();

    public List<Property> getPropertiesByHostId(int hostId) {
        return propertyDAO.getPropertiesByHostId(hostId);
    }

    public Property getPropertyById(int propertyId) {
        return propertyDAO.findById(propertyId);
    }
} 