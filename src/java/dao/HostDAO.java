package dao;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import model.Host;

public class HostDAO extends genericDAO<Host> {

    public HostDAO() {
        super(Host.class);
    }

    // Tìm Host theo userId
    public Host getHostByUserId(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Host> query = em.createQuery(
                    "SELECT h FROM Host h WHERE h.userId.userId = :userId", Host.class
            );
            query.setParameter("userId", userId);
            List<Host> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    // Tạo mới host
    public int createHost(Host host) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(host);
            em.flush(); // Đảm bảo lấy được ID
            em.getTransaction().commit();
            return host.getHostId();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
            return -1;
        } finally {
            em.close();
        }
    }

    public boolean createHost(int userId, String description) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            model.Host host = new model.Host();
            host.setUserId(new model.UserAccount(userId));
            host.setDescription(description);
            host.setVerified(false);
            em.persist(host);
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

    // Cập nhật host
    public boolean updateHost(Host host) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(host);
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

    // Xoá host theo ID
    public boolean deleteHost(int hostId) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Host host = em.find(Host.class, hostId);
            if (host != null) {
                em.remove(host);
                em.getTransaction().commit();
                return true;
            } else {
                em.getTransaction().rollback();
                return false;
            }
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    // Lấy tất cả host (nếu muốn override)
    public List<Host> getAllHosts() {
        return super.findAll(); // hoặc override nếu cần sắp xếp
    }

    public List<Host> getPendingHosts() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT h FROM Host h WHERE h.verified = false", Host.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public long countPendingHosts() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(h) FROM Host h WHERE h.verified = false", Long.class
            ).getSingleResult();
        } finally {
            em.close();
        }
    }

    /**
     * Approve host: verified = true.
     */
    public boolean approveHost(int hostId) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Host h = em.find(Host.class, hostId);
            if (h == null) {
                em.getTransaction().rollback();
                return false;
            }
            h.setVerified(true);
            em.merge(h);
            em.getTransaction().commit();
            return true;
        } catch (Exception ex) {
            ex.printStackTrace();
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return false;
        } finally {
            em.close();
        }
    }

    //Phân trang
    public List<Host> getPendingHostsPaginated(int page, int pageSize) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT h FROM Host h WHERE h.verified = false ORDER BY h.hostId DESC", Host.class)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Reject host: xoá record. Có thể đổi thành soft-reject nếu bạn thêm cột.
     */
    public boolean rejectHost(int hostId) {
        return deleteHost(hostId); // tái sử dụng hàm đã có
    }
}
