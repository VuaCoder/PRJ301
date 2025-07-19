package dao;

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

    // Lấy danh sách booking theo roomId
    public List<Booking> getBookingsByRoomId(int roomId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT b FROM Booking b WHERE b.roomId.roomId = :roomId";
            TypedQuery<Booking> query = em.createQuery(jpql, Booking.class);
            query.setParameter("roomId", roomId);
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
}
