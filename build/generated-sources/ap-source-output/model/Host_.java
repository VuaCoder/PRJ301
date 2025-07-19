package model;

import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Property;
import model.UserAccount;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-07-20T02:35:51", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Host.class)
public class Host_ { 

    public static volatile ListAttribute<Host, Property> propertyList;
    public static volatile SingularAttribute<Host, Boolean> verified;
    public static volatile SingularAttribute<Host, Integer> hostId;
    public static volatile SingularAttribute<Host, String> description;
    public static volatile SingularAttribute<Host, UserAccount> userId;

}