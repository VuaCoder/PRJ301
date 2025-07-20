package model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Booking;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-07-20T08:43:05", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Payment.class)
public class Payment_ { 

    public static volatile SingularAttribute<Payment, String> method;
    public static volatile SingularAttribute<Payment, Integer> paymentId;
    public static volatile SingularAttribute<Payment, Date> paidAt;
    public static volatile SingularAttribute<Payment, BigDecimal> paidAmount;
    public static volatile SingularAttribute<Payment, String> transactionId;
    public static volatile SingularAttribute<Payment, Booking> bookingId;
    public static volatile SingularAttribute<Payment, String> status;

}