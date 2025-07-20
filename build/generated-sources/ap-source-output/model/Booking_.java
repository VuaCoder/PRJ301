package model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Customer;
import model.Payment;
import model.Review;
import model.Room;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-07-21T02:14:09", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Booking.class)
public class Booking_ { 

    public static volatile SingularAttribute<Booking, Date> createdAt;
    public static volatile ListAttribute<Booking, Review> reviewList;
    public static volatile SingularAttribute<Booking, Date> checkoutDate;
    public static volatile SingularAttribute<Booking, BigDecimal> totalPrice;
    public static volatile SingularAttribute<Booking, Integer> guests;
    public static volatile SingularAttribute<Booking, Customer> customerId;
    public static volatile SingularAttribute<Booking, Date> checkinDate;
    public static volatile SingularAttribute<Booking, Integer> bookingId;
    public static volatile SingularAttribute<Booking, Room> roomId;
    public static volatile SingularAttribute<Booking, String> status;
    public static volatile ListAttribute<Booking, Payment> paymentList;

}