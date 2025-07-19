package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.AIChatLog;
import model.Customer;
import model.Host;
import model.Role;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-07-19T18:33:12", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(UserAccount.class)
public class UserAccount_ { 

    public static volatile SingularAttribute<UserAccount, String> avatarUrl;
    public static volatile ListAttribute<UserAccount, AIChatLog> aIChatLogList;
    public static volatile SingularAttribute<UserAccount, Role> roleId;
    public static volatile SingularAttribute<UserAccount, String> fullName;
    public static volatile SingularAttribute<UserAccount, Integer> userId;
    public static volatile SingularAttribute<UserAccount, Date> createdAt;
    public static volatile SingularAttribute<UserAccount, String> password;
    public static volatile SingularAttribute<UserAccount, String> phone;
    public static volatile SingularAttribute<UserAccount, Host> host;
    public static volatile SingularAttribute<UserAccount, String> email;
    public static volatile SingularAttribute<UserAccount, String> username;
    public static volatile SingularAttribute<UserAccount, String> status;
    public static volatile SingularAttribute<UserAccount, Customer> customer;

}