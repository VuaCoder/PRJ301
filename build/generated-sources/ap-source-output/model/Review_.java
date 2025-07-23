package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Booking;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-07-23T10:29:46", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Review.class)
public class Review_ { 

    public static volatile SingularAttribute<Review, Date> createdAt;
    public static volatile SingularAttribute<Review, Integer> rating;
    public static volatile SingularAttribute<Review, String> comment;
    public static volatile SingularAttribute<Review, Integer> reviewId;
    public static volatile SingularAttribute<Review, Booking> bookingId;
    public static volatile SingularAttribute<Review, String> status;

}