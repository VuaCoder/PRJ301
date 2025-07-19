package service;

import dao.HostDAO;
import model.Host;

public class HostService {
    private HostDAO hostDAO;

    public HostService() {
        this.hostDAO = new HostDAO();
    }

    public HostService(HostDAO hostDAO) {
        this.hostDAO = hostDAO;
    }

    /**
     * Lấy Host theo userId
     * @param userId id của user
     * @return Host hoặc null nếu không tồn tại
     */
    public Host getHostByUserId(int userId) {
        return hostDAO.getHostByUserId(userId);
    }

    // Có thể mở rộng thêm các hàm quản lý host ở đây
} 