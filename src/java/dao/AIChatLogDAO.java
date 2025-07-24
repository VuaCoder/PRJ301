package dao;

import model.AIChatLog;
import model.UserAccount;

import javax.persistence.EntityManager;

public class AIChatLogDAO extends genericDAO<AIChatLog> {
    public AIChatLogDAO() {
        super(AIChatLog.class);
    }

    public void saveChatLog(int userId, String question, String answer) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();

            UserAccount user = em.getReference(UserAccount.class, userId);

            AIChatLog log = new AIChatLog();
            log.setUserId(user); // ✅ Đúng kiểu
            log.setQuestion(question);
            log.setAnswer(answer);
            log.setTimestamp(new java.util.Date());

            em.persist(log);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    // Lấy N bản ghi chat gần nhất của user, sắp xếp theo timestamp giảm dần
    public java.util.List<model.AIChatLog> findLastNByUser(int userId, int n) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                "SELECT a FROM AIChatLog a WHERE a.userId.userId = :userId ORDER BY a.timestamp DESC",
                model.AIChatLog.class
            )
            .setParameter("userId", userId)
            .setMaxResults(n)
            .getResultList();
        } finally {
            em.close();
        }
    }
}