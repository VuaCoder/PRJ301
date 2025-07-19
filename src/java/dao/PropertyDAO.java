package dao;

import model.Property;
import model.Host;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.List;

public class PropertyDAO extends genericDAO<Property> {

    public PropertyDAO() {
        super(Property.class);
    }

    // Lấy tất cả property theo hostId
    public List<Property> getPropertiesByHostId(int hostId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Property> query = em.createQuery(
                "SELECT p FROM Property p WHERE p.hostId.hostId = :hostId", Property.class);
            query.setParameter("hostId", hostId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // Lấy 1 property theo ID
    public Property getPropertyById(int propertyId) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Property.class, propertyId);
        } finally {
            em.close();
        }
    }

    // Tạo mới property
    public boolean createProperty(Property property) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(property);
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

    // Cập nhật thông tin property
    public boolean updateProperty(Property property) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(property);
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

    // Xoá property theo ID
    public boolean deleteProperty(int propertyId) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Property property = em.find(Property.class, propertyId);
            if (property != null) {
                em.remove(property);
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

    // Lấy tất cả properties
    public List<Property> getAllProperties() {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Property> query = em.createQuery(
                "SELECT p FROM Property p", Property.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
