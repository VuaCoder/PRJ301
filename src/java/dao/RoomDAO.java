package dao;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import model.Room;

public class RoomDAO extends genericDAO<Room> {

    public RoomDAO() {
        super(Room.class);
    }

    // 1. Tìm theo ID
    @Override
    public Room findById(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT r FROM Room r JOIN FETCH r.propertyId WHERE r.roomId = :id", Room.class)
                    .setParameter("id", id)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Lấy danh sách phòng thuộc tất cả property của host này
     *
     * @param hostId id của host
     * @return danh sách phòng
     */
    public List<Room> getRoomsByHostId(int hostId) {
        EntityManager em = getEntityManager();
        try {
            // Lấy tất cả phòng mà property của nó thuộc về host này
            return em.createQuery("""
                    SELECT r FROM Room r
                    WHERE r.propertyId.hostId.hostId = :hostId
                    """, Room.class)
                    .setParameter("hostId", hostId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    // 3. Tìm phòng theo thành phố
    public List<Room> getRoomsByCity(String city) {
        EntityManager em = getEntityManager();
        try {
            // Rút gọn "City" nếu có
            city = city.toLowerCase().replace("city", "").trim();

            return em.createQuery(
                    "SELECT r FROM Room r JOIN FETCH r.propertyId p "
                    + "WHERE LOWER(TRIM(p.city)) LIKE :city AND r.status = 'active'", Room.class)
                    .setParameter("city", "%" + city + "%")
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // 4. Lấy danh sách phòng mới nhất
    public List<Room> getLatestRooms(int limit) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT r FROM Room r WHERE r.status = 'active' AND r.approvalStatus = 'Approved' ORDER BY r.createdAt DESC",
                    Room.class)
                    .setMaxResults(limit)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // 5. Tìm kiếm phòng theo location + số khách
    public List<Room> searchRooms(String location, int guests) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT r FROM Room r WHERE r.propertyId.city LIKE :location AND r.capacity >= :guests AND r.status = 'active'",
                    Room.class)
                    .setParameter("location", "%" + location + "%")
                    .setParameter("guests", guests)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Room> searchRoomsByType(String type) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("""
                SELECT r FROM Room r 
                WHERE r.status = 'active' 
                AND r.approvalStatus = 'Approved'
                AND r.type = :type
                """, Room.class)
                    .setParameter("type", type)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // 6. Thêm phòng
    public void insertRoom(Room room) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(room);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    // 7. Cập nhật phòng
    public void updateRoom(Room room) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(room);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    // 8. Xoá phòng
    public void deleteRoom(int roomId) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Room room = em.find(Room.class, roomId);
            if (room != null) {
                em.remove(room);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public List<Room> getPendingRooms() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT r FROM Room r WHERE r.approvalStatus = :st", Room.class
            ).setParameter("st", "Pending")
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Đếm phòng chờ duyệt.
     */
    public long countPendingRooms() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(r) FROM Room r WHERE r.approvalStatus = :st", Long.class
            ).setParameter("st", "Pending")
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    /**
     * Cập nhật trạng thái duyệt phòng.
     */
    public boolean updateApprovalStatus(int roomId, String newStatus) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Room r = em.find(Room.class, roomId);
            if (r == null) {
                em.getTransaction().rollback();
                return false;
            }
            r.setApprovalStatus(newStatus); // Field phải có trong entity
            em.merge(r);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return false;
        } finally {
            em.close();
        }
    }

    //Lấy theo trạng thái 
    public List<Room> getRoomsByApprovalStatus(String status, int page, int pageSize) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT r FROM Room r WHERE r.approvalStatus = :st ORDER BY r.roomId DESC", Room.class)
                    .setParameter("st", status)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    //phân trang
    public List<Room> getAllRoomsPaginated(int page, int pageSize) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT r FROM Room r ORDER BY r.roomId DESC", Room.class)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    //Đếm phòng
    public long countRoomsByApprovalStatus(String status) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(r) FROM Room r WHERE r.approvalStatus = :st", Long.class)
                    .setParameter("st", status)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    public long countAllRooms() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(r) FROM Room r", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    public boolean approveRoom(int roomId) {
        return updateApprovalStatus(roomId, "Approved");
    }

    public boolean rejectRoom(int roomId) {
        return updateApprovalStatus(roomId, "Rejected");
    }
}
