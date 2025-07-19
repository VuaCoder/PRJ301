package service;

import dao.HostDAO;
import dao.RoomDAO;
import dao.UserDAO;
import dao.genericDAO;
import java.util.List;
import model.Host;
import model.Room;
import model.UserAccount;

public class AdminService {

    private final genericDAO<UserAccount> userDAO = new genericDAO<>(UserAccount.class);
    private final HostDAO hostDAO = new HostDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final UserDAO userCustomDAO = new UserDAO();

    /* ---------------- USER CRUD ---------------- */
    public List<UserAccount> getAllUsers() { return userDAO.findAll(); }
    public void deleteUser(int userId) { userDAO.delete(userId); }
    public UserAccount getUserById(int id) { return userDAO.findById(id); }
    public void updateUser(UserAccount user) { userDAO.update(user); }
    public void saveUser(UserAccount user) { userDAO.save(user); }

    /* ---------------- HOST PENDING ---------------- */
    public List<Host> getPendingHosts() { return hostDAO.getPendingHosts(); }
    public long countPendingHosts() { return hostDAO.countPendingHosts(); }

    // phân trang
    public List<Host> getPendingHostsPaginated(int page, int pageSize) {
        return hostDAO.getPendingHostsPaginated(page, pageSize);
    }

    public boolean approveHost(int hostId) {
        Host host = hostDAO.findById(hostId);
        if (host == null) return false;
        boolean ok = hostDAO.approveHost(hostId);
        if (ok) {
            // Đổi role user -> host (role_id = 2)
            userCustomDAO.updateRole(host.getUserId().getUserId(), 2);
        }
        return ok;
    }

    public boolean rejectHost(int hostId) {
        // hiện đang remove; nếu muốn soft reject cần custom
        return hostDAO.rejectHost(hostId);
    }

    /* ---------------- ROOM PENDING ---------------- */
    public List<Room> getPendingRooms() { return roomDAO.getPendingRooms(); }
    public long countPendingRooms() { return roomDAO.countPendingRooms(); }

    // phân trang
    public List<Room> getPendingRoomsPaginated(int page, int pageSize) {
        return roomDAO.getRoomsByApprovalStatus("Pending", page, pageSize);
    }

    public boolean approveRoom(int roomId) { return roomDAO.approveRoom(roomId); }
    public boolean rejectRoom(int roomId) { return roomDAO.rejectRoom(roomId); }

    /* ---------------- ROOMS BY STATUS ---------------- */
    public List<Room> getRoomsByStatus(String approvalStatus, int page, int pageSize) {
        return roomDAO.getRoomsByApprovalStatus(approvalStatus, page, pageSize);
    }

    public long countRoomsByStatus(String approvalStatus) {
        return roomDAO.countRoomsByApprovalStatus(approvalStatus);
    }

    /* ---------------- ALL ROOMS (paging) ---------------- */
    public long countAllRooms() { return roomDAO.countAllRooms(); }

    public List<Room> getAllRoomsPaginated(int page, int pageSize) {
        return roomDAO.getAllRoomsPaginated(page, pageSize);
    }

    /* ---------------- ROLE UPDATE (manual) ---------------- */
    // dùng khi đổi role trong dashboard
    public void updateNewRole(int userId, int roleId) {
        userCustomDAO.updateRole(userId, roleId);
    }
}
