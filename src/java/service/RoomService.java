package service;

import dao.RoomDAO;
import dao.HostDAO;
import dao.PropertyDAO;
import model.Room;

import java.util.List;

public class RoomService {

    private RoomDAO roomDAO;
    private HostDAO hostDAO;
    private PropertyDAO propertyDAO;

    // Constructor mặc định nếu bạn không inject từ ngoài
    public RoomService() {
        this.roomDAO = new RoomDAO();
        this.hostDAO = new HostDAO();
        this.propertyDAO = new PropertyDAO();
    }

    // Constructor dùng để inject (nếu muốn)
    public RoomService(RoomDAO roomDAO, HostDAO hostDAO, PropertyDAO propertyDAO) {
        this.roomDAO = roomDAO;
        this.hostDAO = hostDAO;
        this.propertyDAO = propertyDAO;
    }

    /**
     * Lấy danh sách phòng theo hostId
     * @param hostId id của host
     * @return danh sách phòng thuộc các property của host này
     */
    public List<Room> getRoomsByHostId(int hostId) {
        return roomDAO.getRoomsByHostId(hostId);
    }

    // Lấy thông tin phòng theo roomId
    public Room getRoomById(int roomId) {
        return roomDAO.findById(roomId);
    }

    // Thêm phòng mới
    public void addRoom(Room room) {
        roomDAO.insertRoom(room);
    }

    // Cập nhật phòng
    public void updateRoom(Room room) {
        roomDAO.updateRoom(room);
    }

    // Xoá phòng
    public void deleteRoom(int roomId) {
        roomDAO.deleteRoom(roomId);
    }

    // (tuỳ chọn) Tìm phòng theo thành phố
    public List<Room> getRoomsByCity(String city) {
        return roomDAO.getRoomsByCity(city);
    }

    // (tuỳ chọn) Lấy phòng mới nhất
    public List<Room> getLatestRooms(int limit) {
        return roomDAO.getLatestRooms(limit);
    }

    // (tuỳ chọn) Tìm theo location và số khách
    public List<Room> searchRooms(String location, int guests) {
        return roomDAO.searchRooms(location, guests);
    }
}