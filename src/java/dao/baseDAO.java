
package dao;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;


public abstract class baseDAO {
    protected static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("staytion_booking_platform");
    
    protected EntityManager getEntityManager(){
        return emf.createEntityManager();
    }
    
    public void close(){
        emf.close();
    }
    
}
