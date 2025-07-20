package dao;

import javax.persistence.EntityManager;
import model.Customer;

public class CustomerDAO extends genericDAO<Customer> {
    public CustomerDAO() {
        super(Customer.class);
    }

    public boolean createCustomer(Customer customer) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(customer);
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
}
