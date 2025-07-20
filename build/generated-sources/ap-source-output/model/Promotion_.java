package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-07-20T19:08:29", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Promotion.class)
public class Promotion_ { 

    public static volatile SingularAttribute<Promotion, String> code;
    public static volatile SingularAttribute<Promotion, Integer> discountPercent;
    public static volatile SingularAttribute<Promotion, Date> endDate;
    public static volatile SingularAttribute<Promotion, String> description;
    public static volatile SingularAttribute<Promotion, Integer> promoId;
    public static volatile SingularAttribute<Promotion, Date> startDate;

}