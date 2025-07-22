package dao;

import model.Role;
import model.UserAccount;
import model.Host;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;
import java.util.List;
import javax.persistence.EntityTransaction;

public class UserDAO extends genericDAO<UserAccount> {

    public UserDAO() {
        super(UserAccount.class);
    }

    // Đăng nhập: check email hoặc tên + password
    public UserAccount checkLogin(String emailOrName, String password) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<UserAccount> query = em.createQuery(
                "SELECT u FROM UserAccount u WHERE (u.email = :input OR u.fullName = :input) AND u.password = :password", UserAccount.class);
            query.setParameter("input", emailOrName);
            query.setParameter("password", password);
            List<UserAccount> users = query.getResultList();
            if (users.isEmpty()) {
                return null;
            }
            return users.get(0);
        } finally {
            em.close();
        }
    }

    // Đăng ký tài khoản mới
    public boolean registerUser(UserAccount user) {
        EntityManager em = getEntityManager();
        try {
            Role role = em.find(Role.class, 1); // hoặc new Role(1)
            user.setRoleId(role);
            em.getTransaction().begin();
            em.persist(user);
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

    public UserAccount findByEmail(String email) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<UserAccount> query = em.createQuery(
                    "SELECT u FROM UserAccount u WHERE u.email = :email", UserAccount.class);
            query.setParameter("email", email);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public void createGoogleUser(String email, String fullName) {
        EntityManager em = getEntityManager();
        try {
            Role role = em.find(Role.class, 1); // 1 = customer
            UserAccount user = new UserAccount();
            user.setEmail(email);
            user.setFullName(fullName);
            user.setPassword(""); // Không có password
            user.setRoleId(role);

            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
        } finally {
            em.close();
        }
    }

    // Lấy host_id từ user_id (nếu có)
    public int getHostIdByUserId(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Host> query = em.createQuery(
                    "SELECT h FROM Host h WHERE h.userId.userId = :userId", Host.class);
            query.setParameter("userId", userId);
            Host host = query.getSingleResult();
            return host.getHostId();
        } catch (NoResultException e) {
            return -1;
        } finally {
            em.close();
        }
    }

    // Lấy toàn bộ người dùng (User + Role)
    public List<UserAccount> getAllUsers() {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<UserAccount> query = em.createQuery(
                    "SELECT u FROM UserAccount u", UserAccount.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public long countAllUsers() {
        EntityManager em = getEntityManager();
        return em.createQuery("SELECT COUNT(u) FROM UserAccount u", Long.class)
                .getSingleResult();
    }

    public long countActiveUsers() {
        EntityManager em = getEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(u) FROM UserAccount u "
                    + "WHERE UPPER(TRIM(u.status)) = 'ACTIVE'", Long.class)
                    .getSingleResult();

            System.out.println("[DEBUG] countActiveUsers() -> " + count);
            return count != null ? count : 0L;
        } catch (Exception e) {
            System.err.println("[ERROR] countActiveUsers(): " + e.getMessage());
            e.printStackTrace();
            return 0L;
        } finally {
            em.close();
        }
    }

    public boolean updateRole(int userId, int roleId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            UserAccount user = em.find(UserAccount.class, userId);
            if (user == null) {
                tx.rollback();
                return false;
            }

            // lấy entity Role đã tồn tại, tránh tạo Role mới trống
            Role roleRef = em.getReference(Role.class, roleId); // hoặc em.find(Role.class, roleId)
            user.setRoleId(roleRef);  // user đang managed -> tự flush khi commit

            tx.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (tx.isActive()) {
                tx.rollback();
            }
            return false;
        } finally {
            em.close();
        }
    }

    // Gán roleId = 1 (customer) cho user khi roleId bị null hoặc khi tạo user Google
    public void assignDefaultRole(int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            UserAccount user = em.find(UserAccount.class, userId);
            if (user == null) {
                tx.rollback();
                return;
            }
            Role role = em.find(Role.class, 1); // 1 = customer
            user.setRoleId(role);
            tx.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (tx.isActive()) {
                tx.rollback();
            }
        } finally {
            em.close();
        }
    }
}
