package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.UserAccount;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-07-21T02:14:09", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(AIChatLog.class)
public class AIChatLog_ { 

    public static volatile SingularAttribute<AIChatLog, Integer> chatId;
    public static volatile SingularAttribute<AIChatLog, String> question;
    public static volatile SingularAttribute<AIChatLog, String> answer;
    public static volatile SingularAttribute<AIChatLog, UserAccount> userId;
    public static volatile SingularAttribute<AIChatLog, Date> timestamp;

}