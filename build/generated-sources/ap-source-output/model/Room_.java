package model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Amenity;
import model.Booking;
import model.Property;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-07-19T09:35:06", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Room.class)
public class Room_ { 

    public static volatile SingularAttribute<Room, String> approvalStatus;
    public static volatile SingularAttribute<Room, String> images;
    public static volatile SingularAttribute<Room, String> description;
    public static volatile SingularAttribute<Room, String> type;
    public static volatile ListAttribute<Room, Amenity> amenityList;
    public static volatile SingularAttribute<Room, String> title;
    public static volatile SingularAttribute<Room, Integer> roomId;
    public static volatile SingularAttribute<Room, Integer> capacity;
    public static volatile SingularAttribute<Room, Date> createdAt;
    public static volatile ListAttribute<Room, Booking> bookingList;
    public static volatile SingularAttribute<Room, BigDecimal> price;
    public static volatile SingularAttribute<Room, Property> propertyId;
    public static volatile SingularAttribute<Room, String> status;

}