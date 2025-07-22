package dao;

import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import model.Review;

public class ReviewDAO extends genericDAO<Review> {

    public ReviewDAO() {
        super(Review.class);
    }

    // Tạo review mới
    public boolean createReview(Review review) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            review.setCreatedAt(new Date());
            review.setStatus("Active");
            em.persist(review);
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

    // Lấy review theo bookingId
    public Review getReviewByBookingId(int bookingId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT r FROM Review r WHERE r.bookingId.bookingId = :bookingId";
            TypedQuery<Review> query = em.createQuery(jpql, Review.class);
            query.setParameter("bookingId", bookingId);
            List<Review> results = query.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            // Nếu bảng Review chưa tồn tại, trả về null
            return null;
        } finally {
            em.close();
        }
    }

    // Lấy tất cả review theo roomId
    public List<Review> getReviewsByRoomId(int roomId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT r FROM Review r WHERE r.bookingId.roomId.roomId = :roomId AND r.status = 'Active' ORDER BY r.createdAt DESC";
            TypedQuery<Review> query = em.createQuery(jpql, Review.class);
            query.setParameter("roomId", roomId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // Lấy tất cả review theo customerId
    public List<Review> getReviewsByCustomerId(int customerId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT r FROM Review r WHERE r.bookingId.customerId.customerId = :customerId ORDER BY r.createdAt DESC";
            TypedQuery<Review> query = em.createQuery(jpql, Review.class);
            query.setParameter("customerId", customerId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Review> getReviewsByHostId(int hostId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT r FROM Review r "
                    + "WHERE r.bookingId.roomId.propertyId.hostId.hostId = :hostId "
                    + "AND r.status = 'Active' "
                    + "ORDER BY r.createdAt DESC";
            TypedQuery<Review> query = em.createQuery(jpql, Review.class);
            query.setParameter("hostId", hostId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        } finally {
            em.close();
        }
    }

    // Kiểm tra xem booking đã có review chưa
    public boolean hasReviewForBooking(int bookingId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT COUNT(r) FROM Review r WHERE r.bookingId.bookingId = :bookingId";
            TypedQuery<Long> query = em.createQuery(jpql, Long.class);
            query.setParameter("bookingId", bookingId);
            Long count = query.getSingleResult();
            return count > 0;
        } catch (Exception e) {
            // Nếu bảng Review chưa tồn tại, trả về false
            return false;
        } finally {
            em.close();
        }
    }

    // Tính điểm trung bình của room
    public double getAverageRatingByRoomId(int roomId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT AVG(r.rating) FROM Review r WHERE r.bookingId.roomId.roomId = :roomId AND r.status = 'Active'";
            TypedQuery<Double> query = em.createQuery(jpql, Double.class);
            query.setParameter("roomId", roomId);
            Double result = query.getSingleResult();
            return result != null ? result : 0.0;
        } finally {
            em.close();
        }
    }

    // Đếm số review của room
    public int getReviewCountByRoomId(int roomId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT COUNT(r) FROM Review r WHERE r.bookingId.roomId.roomId = :roomId AND r.status = 'Active'";
            TypedQuery<Long> query = em.createQuery(jpql, Long.class);
            query.setParameter("roomId", roomId);
            Long count = query.getSingleResult();
            return count.intValue();
        } finally {
            em.close();
        }
    }

    // Lấy tất cả reviews
    public List<Review> getAllReviews() {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT r FROM Review r ORDER BY r.createdAt DESC";
            TypedQuery<Review> query = em.createQuery(jpql, Review.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        } finally {
            em.close();
        }
    }
}
