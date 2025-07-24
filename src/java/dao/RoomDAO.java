package dao;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;
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
                    + "WHERE LOWER(TRIM(p.city)) LIKE :city AND r.status = 'Available'", Room.class)
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
                    "SELECT r FROM Room r WHERE r.status = 'Available' AND r.approvalStatus = 'Approved' ORDER BY r.createdAt DESC",
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
                    "SELECT r FROM Room r WHERE r.propertyId.city LIKE :location AND r.capacity >= :guests AND r.status = 'Available'",
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
                WHERE r.status = 'Available' 
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

    // Lấy tất cả phòng active để lọc realtime
    public List<Room> getAllActiveRooms() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT r FROM Room r WHERE r.status = 'Available'", Room.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // Lấy danh sách phòng còn trống theo thành phố, số khách, ngày checkin/checkout
    public List<Room> getAvailableRooms(String city, int guests, java.util.Date checkin, java.util.Date checkout) {
        EntityManager em = getEntityManager();
        try {
            String jpql = """
                SELECT r FROM Room r
                WHERE r.status = 'Available'
                AND r.approvalStatus = 'Approved'
                AND r.capacity >= :guests
                AND r.propertyId.city LIKE :city
                AND NOT EXISTS (
                    SELECT b FROM Booking b
                    WHERE b.roomId = r
                    AND b.status IN ('Pending', 'Confirmed')
                    AND NOT (
                        b.checkoutDate <= :checkin OR b.checkinDate >= :checkout
                    )
                )
            """;

            return em.createQuery(jpql, Room.class)
                    .setParameter("guests", guests)
                    .setParameter("city", "%" + city + "%")
                    .setParameter("checkin", checkin)
                    .setParameter("checkout", checkout)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Lấy danh sách phòng có sẵn theo thời gian (không trùng với booking)
     */
    public List<Room> getAvailableRooms(java.util.Date checkin, java.util.Date checkout) {
        EntityManager em = getEntityManager();
        try {
            List<Room> allRooms = em.createQuery(
                    "SELECT r FROM Room r WHERE r.status = 'Available' AND r.approvalStatus = 'Approved'",
                    Room.class
            ).getResultList();

            dao.BookingDAO bookingDAO = new dao.BookingDAO();
            List<Room> result = new ArrayList<>();
            java.util.Date today = new java.util.Date();
            for (Room room : allRooms) {
                List<model.Booking> bookings = bookingDAO.getBookingsByRoomId(room.getRoomId());
                if (bookings.isEmpty()) {
                    result.add(room);
                    continue;
                }
                java.util.Date lastCheckout = null;
                for (model.Booking b : bookings) {
                    if (b.getCheckoutDate() != null) {
                        if (lastCheckout == null || b.getCheckoutDate().after(lastCheckout)) {
                            lastCheckout = b.getCheckoutDate();
                        }
                    }
                }
                // Nếu ngày hiện tại đã qua ngày check-out cuối cùng, cập nhật trạng thái phòng thành 'Available'
                if (lastCheckout != null && today.after(lastCheckout) && !"Available".equals(room.getStatus())) {
                    updateRoomStatus(room.getRoomId(), "Available");
                    room.setStatus("Available");
                }
                // Nếu ngày check-in của user lớn hơn ngày check-out cuối cùng => phòng rảnh
                if (lastCheckout == null || checkin.after(lastCheckout)) {
                    result.add(room);
                }
            }
            return result;
        } finally {
            em.close();
        }
    }

    /**
     * Cập nhật status phòng thành Unavailable khi được đặt
     */
    public boolean updateRoomStatus(int roomId, String status) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Room room = em.find(Room.class, roomId);
            if (room != null) {
                room.setStatus(status);
                em.merge(room);
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().rollback();
            return false;
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

    /**
     * Kiểm tra xem phòng có available trong khoảng thời gian không
     */
    public boolean isRoomAvailable(int roomId, java.util.Date checkin, java.util.Date checkout) {
        EntityManager em = getEntityManager();
        try {
            Long count = em.createQuery("""
                SELECT COUNT(b) FROM Booking b 
                WHERE b.roomId.roomId = :roomId
                AND b.status IN ('Pending', 'Confirmed')
                AND (b.checkinDate < :checkout AND b.checkoutDate > :checkin)
                """, Long.class)
                    .setParameter("roomId", roomId)
                    .setParameter("checkin", checkin)
                    .setParameter("checkout", checkout)
                    .getSingleResult();

            return count == 0;
        } finally {
            em.close();
        }
    }

    public List<Room> getAvailableRoomss(String city, int guests, Date checkin, Date checkout, String priceCategory) {
        EntityManager em = getEntityManager();
        try {
            // Khởi tạo JPQL cơ bản
            StringBuilder jpql = new StringBuilder("SELECT r FROM Room r WHERE r.status = 'Available' ");

            // City (nếu có)
            if (city != null && !city.trim().isEmpty()) {
                jpql.append("AND LOWER(r.city) LIKE :city ");
            }

            // Capacity
            jpql.append("AND r.capacity >= :guests ");

            // Check phòng không bị đặt trùng
            jpql.append("AND r.roomId NOT IN (")
                    .append("SELECT b.room.roomId FROM Booking b ")
                    .append("WHERE b.checkinDate < :checkout AND b.checkoutDate > :checkin")
                    .append(") ");

            // Price category (tuỳ chọn)
            if (priceCategory != null && !priceCategory.trim().isEmpty()) {
                switch (priceCategory.toLowerCase()) {
                    case "gia re":
                        jpql.append("AND r.price < 500000 ");
                        break;
                    case "trung binh thap":
                        jpql.append("AND r.price >= 500000 AND r.price <= 1000000 ");
                        break;
                    case "trung binh cao":
                        jpql.append("AND r.price > 1000000 AND r.price <= 2000000 ");
                        break;
                    case "mr beast":
                        jpql.append("AND r.price > 2000000 ");
                        break;
                }
            }

            TypedQuery<Room> query = em.createQuery(jpql.toString(), Room.class);
            query.setParameter("guests", guests);
            query.setParameter("checkin", checkin);
            query.setParameter("checkout", checkout);

            if (city != null && !city.trim().isEmpty()) {
                query.setParameter("city", "%" + city.toLowerCase() + "%");
            }

            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Room> getAvailableRoomsSimple(String city, int guests, Date checkin, Date checkout) {

        EntityManager em = getEntityManager();

        try {
            String jpql = """
            SELECT DISTINCT r FROM Room r 
            JOIN FETCH r.propertyId p
            WHERE r.status = 'Available' 
            AND r.approvalStatus = 'Approved'
            AND r.capacity >= :guests
        """;

            // Add city filter if provided
            if (city != null && !city.trim().isEmpty()) {

                jpql += " AND LOWER(p.city) LIKE :city";

            }

            // Add availability check
            jpql += """

             AND NOT EXISTS (
                SELECT b FROM Booking b 
                WHERE b.roomId = r
                AND b.status IN ('Pending', 'Confirmed')
                AND (b.checkinDate < :checkout AND b.checkoutDate > :checkin)
            )

        """;

            TypedQuery<Room> query = em.createQuery(jpql, Room.class);
            query.setParameter("guests", guests);
            query.setParameter("checkin", checkin);
            query.setParameter("checkout", checkout);
            if (city != null && !city.trim().isEmpty()) {

                query.setParameter("city", "%" + city.toLowerCase() + "%");

            }

            return query.getResultList();

        } finally {

            em.close();

        }

    }
    // đếm phòng đang được cho thuê và có status = "available và được approved"

    public long countActiveRoomsByHost(int hostId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("""
            SELECT COUNT(r) FROM Room r
            WHERE r.propertyId.hostId.hostId = :hostId
            AND r.status = 'Available'
            AND r.approvalStatus = 'Approved'
        """, Long.class)
                    .setParameter("hostId", hostId)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    //thống kê số phòng hiện tại
    public long countEmptyRoomsByHost(int hostId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("""
            SELECT COUNT(r) FROM Room r
            WHERE r.propertyId.hostId.hostId = :hostId
            AND r.status = 'Available'
            AND r.approvalStatus = 'Approved'
            AND NOT EXISTS (
                SELECT b FROM Booking b
                WHERE b.roomId = r
                AND b.status IN ('Confirmed', 'Pending')
                AND CURRENT_DATE BETWEEN b.checkinDate AND b.checkoutDate
            )
        """, Long.class)
                    .setParameter("hostId", hostId)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    //biểu đồ doanh thu theo từng tháng
    public Map<String, Double> getMonthlyRevenueByHost(int hostId) {
        EntityManager em = getEntityManager();
        try {
            List<Object[]> results = em.createNativeQuery("""
            SELECT FORMAT(b.checkin_date, 'yyyy-MM') AS Month,
                   SUM(b.total_price) AS TotalRevenue
            FROM Booking b
            JOIN Room r ON b.room_id = r.room_id
            JOIN Property p ON r.property_id = p.property_id
            WHERE p.host_id = ?
              AND b.status = 'Confirmed'
            GROUP BY FORMAT(b.checkin_date, 'yyyy-MM')
            ORDER BY Month
        """)
                    .setParameter(1, hostId)
                    .getResultList();

            Map<String, Double> revenueMap = new LinkedHashMap<>();
            for (Object[] row : results) {
                String month = (String) row[0];
                Double revenue = ((BigDecimal) row[1]).doubleValue();
                revenueMap.put(month, revenue);
            }
            return revenueMap;
        } finally {
            em.close();
        }
    }
}
