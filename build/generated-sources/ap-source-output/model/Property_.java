package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Host;
import model.Room;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-07-21T02:14:09", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Property.class)
public class Property_ { 

    public static volatile SingularAttribute<Property, Date> createdAt;
    public static volatile SingularAttribute<Property, String> address;
    public static volatile SingularAttribute<Property, String> city;
    public static volatile SingularAttribute<Property, Double> latitude;
    public static volatile SingularAttribute<Property, String> name;
    public static volatile SingularAttribute<Property, Boolean> verified;
    public static volatile SingularAttribute<Property, String> description;
    public static volatile SingularAttribute<Property, Host> hostId;
    public static volatile SingularAttribute<Property, Integer> propertyId;
    public static volatile ListAttribute<Property, Room> roomList;
    public static volatile SingularAttribute<Property, Double> longitude;

}