/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import static dao.baseDAO.emf;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

/**
 *
 * @author Kassaa
 */
public class genericDAO<T> extends baseDAO {

    private final Class<T> entityClass;

    public genericDAO(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    @Override
    protected EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public List<T> findAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT e FROM " + entityClass.getSimpleName() + " e", entityClass).getResultList();
        } finally {
            em.close();
        }
    }

    public T findById(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(entityClass, id);
        } finally {
            em.close();
        }
    }

    public void save(T entity) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(entity);
            em.flush();
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void update(T entity) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(entity);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void delete(Object id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            T entity = em.find(entityClass, id);
            if (entity != null) {
                em.remove(entity);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public List<T> findByStatus(String status) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<T> query = em.createQuery(
                    "SELECT e FROM " + entityClass.getSimpleName() + " e WHERE e.status = :status", entityClass);
            query.setParameter("status", status);
            return query.getResultList();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi lấy danh sách entity với status: " + status, e);
        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }
}
