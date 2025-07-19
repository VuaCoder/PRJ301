package model;

import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Room;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-07-19T09:35:06", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Amenity.class)
public class Amenity_ { 

    public static volatile SingularAttribute<Amenity, Integer> amenityId;
    public static volatile SingularAttribute<Amenity, String> name;
    public static volatile SingularAttribute<Amenity, String> icon;
    public static volatile SingularAttribute<Amenity, String> description;
    public static volatile ListAttribute<Amenity, Room> roomList;

}