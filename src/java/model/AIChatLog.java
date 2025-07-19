/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author HOANG PHUC
 */
@Entity
@Table(name = "AIChatLog")
@NamedQueries({
    @NamedQuery(name = "AIChatLog.findAll", query = "SELECT a FROM AIChatLog a"),
    @NamedQuery(name = "AIChatLog.findByChatId", query = "SELECT a FROM AIChatLog a WHERE a.chatId = :chatId"),
    @NamedQuery(name = "AIChatLog.findByQuestion", query = "SELECT a FROM AIChatLog a WHERE a.question = :question"),
    @NamedQuery(name = "AIChatLog.findByAnswer", query = "SELECT a FROM AIChatLog a WHERE a.answer = :answer"),
    @NamedQuery(name = "AIChatLog.findByTimestamp", query = "SELECT a FROM AIChatLog a WHERE a.timestamp = :timestamp")})
public class AIChatLog implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "chat_id")
    private Integer chatId;
    @Column(name = "question")
    private String question;
    @Column(name = "answer")
    private String answer;
    @Column(name = "timestamp")
    @Temporal(TemporalType.TIMESTAMP)
    private Date timestamp;
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    @ManyToOne
    private UserAccount userId;

    public AIChatLog() {
    }

    public AIChatLog(Integer chatId) {
        this.chatId = chatId;
    }

    public Integer getChatId() {
        return chatId;
    }

    public void setChatId(Integer chatId) {
        this.chatId = chatId;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public UserAccount getUserId() {
        return userId;
    }

    public void setUserId(UserAccount userId) {
        this.userId = userId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (chatId != null ? chatId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof AIChatLog)) {
            return false;
        }
        AIChatLog other = (AIChatLog) object;
        if ((this.chatId == null && other.chatId != null) || (this.chatId != null && !this.chatId.equals(other.chatId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.AIChatLog[ chatId=" + chatId + " ]";
    }
    
}
