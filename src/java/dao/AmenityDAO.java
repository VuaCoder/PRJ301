package dao;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import model.Amenity;

public class AmenityDAO extends genericDAO<Amenity> {

    public AmenityDAO() {
        super(Amenity.class);
    }

    // Lấy tất cả amenities (có sẵn trong genericDAO nhưng ghi đè nếu cần sắp xếp)
    public List<Amenity> getAllAmenities() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT a FROM Amenity a ORDER BY a.name", Amenity.class).getResultList();
        } finally {
            em.close();
        }
    }

    // Lấy danh sách tiện ích theo roomId
    public List<Amenity> getAmenitiesByRoomId(int roomId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT a FROM Amenity a JOIN a.roomList r WHERE r.roomId = :roomId ORDER BY a.name";
            TypedQuery<Amenity> query = em.createQuery(jpql, Amenity.class);
            query.setParameter("roomId", roomId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // Gán list amenity cho room (bạn cần xử lý ở phía Room entity)
    public void setAmenitiesForRoom(model.Room room, List<Amenity> newAmenities) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            room.setAmenityList(newAmenities);  // giả sử bạn có get/set list bên Room
            em.merge(room); // cập nhật Room
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

}
