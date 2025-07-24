package dao;

import DTO.RoomStat;
import dto.BookingHistory;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import model.Booking;

public class BookingDAO extends genericDAO<Booking> {

    public BookingDAO() {
        super(Booking.class);
    }

    // Kiểm tra phòng có sẵn trong khoảng ngày
    public boolean isRoomAvailable(int roomId, Date checkin, Date checkout) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT COUNT(b) FROM Booking b "
                    + "WHERE b.roomId.roomId = :roomId "
                    + "AND b.status IN ('Pending', 'Confirmed') "
                    + "AND (b.checkinDate < :checkout AND b.checkoutDate > :checkin)";
            TypedQuery<Long> query = em.createQuery(jpql, Long.class);
            query.setParameter("roomId", roomId);
            query.setParameter("checkin", checkin);
            query.setParameter("checkout", checkout);
            Long count = query.getSingleResult();
            return count == 0;
        } finally {
            em.close();
        }
    }

    // Tạo booking mới
    public boolean createBooking(Booking booking) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(booking);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    // Lấy danh sách booking theo customerId
    public List<Booking> getBookingsByCustomerId(int customerId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT b FROM Booking b WHERE b.customerId.customerId = :customerId";
            TypedQuery<Booking> query = em.createQuery(jpql, Booking.class);
            query.setParameter("customerId", customerId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Booking> getBookingsByCustomerIdWithReviews(int customerId, int page, int pageSize) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("""
                SELECT DISTINCT b FROM Booking b
                LEFT JOIN FETCH b.reviewList rv
                JOIN FETCH b.roomId r
                WHERE b.customerId.customerId = :cid
                ORDER BY b.createdAt DESC
            """, Booking.class)
                    .setParameter("cid", customerId)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // Lấy danh sách booking theo roomId
    public List<Booking> getBookingsByRoomId(int roomId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT b FROM Booking b WHERE b.roomId.roomId = :roomId ORDER BY b.checkinDate ASC",
                    Booking.class)
                    .setParameter("roomId", roomId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    // Lấy danh sách booking theo hostId
    public List<Booking> getBookingsByHostId(int hostId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT b FROM Booking b WHERE b.roomId.propertyId.hostId.hostId = :hostId";
            TypedQuery<Booking> query = em.createQuery(jpql, Booking.class);
            query.setParameter("hostId", hostId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // Cập nhật trạng thái booking
    public boolean updateBookingStatus(int bookingId, String newStatus) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Booking booking = em.find(Booking.class, bookingId);
            if (booking != null) {
                booking.setStatus(newStatus);
                em.merge(booking);
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().rollback();
            return false;
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
    //Get Room Stat By Status

    public List<RoomStat> getRoomStatsByHost(int hostId) {
        EntityManager em = getEntityManager();

        String jpql = "SELECT new dto.RoomStat(r.roomId, r.title, SUM(b.totalPrice), COUNT(b), MAX(b.createdAt), AVG(rv.rating)) "
                + "FROM Booking b JOIN b.roomId r LEFT JOIN b.reviewList rv "
                + "WHERE r.propertyId.hostId.hostId = :hostId "
                + "GROUP BY r.roomId, r.title";
        return em.createQuery(jpql, RoomStat.class)
                .setParameter("hostId", hostId)
                .getResultList();
    }

    public List<BookingHistory> getBookingHistoryByCustomer(int customerId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT new dto.BookingHistory("
                    + "r.title, b.checkinDate, b.checkoutDate, b.totalPrice, rv.comment, rv.rating) "
                    + "FROM Booking b "
                    + "JOIN b.roomId r "
                    + "LEFT JOIN b.reviewList rv "
                    + // LEFT JOIN để booking không có review vẫn hiển thị
                    "WHERE b.customerId.customerId = :customerId "
                    + "ORDER BY b.checkinDate DESC";

            return em.createQuery(jpql, BookingHistory.class)
                    .setParameter("customerId", customerId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // Đếm tổng số booking toàn hệ thống
    public long countAllBookings() {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT COUNT(b) FROM Booking b";
            TypedQuery<Long> query = em.createQuery(jpql, Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    // Tính tổng doanh thu toàn hệ thống (chỉ booking đã hoàn tất)
    public java.math.BigDecimal getTotalRevenue() {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT COALESCE(SUM(b.totalPrice), 0) FROM Booking b WHERE b.status = 'Confirmed'";
            TypedQuery<java.math.BigDecimal> query = em.createQuery(jpql, java.math.BigDecimal.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public long countBookingsByCustomerId(int customerId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(b) FROM Booking b WHERE b.customerId.customerId = :cid", Long.class)
                    .setParameter("cid", customerId)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

}
