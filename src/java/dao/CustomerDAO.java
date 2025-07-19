package dao;

import javax.persistence.EntityManager;
import model.Customer;

public class CustomerDAO extends genericDAO<Customer> {
    public CustomerDAO() {
        super(Customer.class);
    }

    public void createCustomer(Customer customer) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(customer);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
