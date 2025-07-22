package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Booking;
import model.UserAccount;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-07-22T23:50:24", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Customer.class)
public class Customer_ { 

    public static volatile SingularAttribute<Customer, String> identityNo;
    public static volatile SingularAttribute<Customer, String> address;
    public static volatile SingularAttribute<Customer, Boolean> gender;
    public static volatile SingularAttribute<Customer, Date> dob;
    public static volatile ListAttribute<Customer, Booking> bookingList;
    public static volatile SingularAttribute<Customer, Integer> customerId;
    public static volatile SingularAttribute<Customer, UserAccount> userId;

}