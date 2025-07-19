/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

/**
 *
 * @author HOANG PHUC
 */
@Entity
@Table(name = "Host")
@NamedQueries({
    @NamedQuery(name = "Host.findAll", query = "SELECT h FROM Host h"),
    @NamedQuery(name = "Host.findByHostId", query = "SELECT h FROM Host h WHERE h.hostId = :hostId"),
    @NamedQuery(name = "Host.findByVerified", query = "SELECT h FROM Host h WHERE h.verified = :verified"),
    @NamedQuery(name = "Host.findByDescription", query = "SELECT h FROM Host h WHERE h.description = :description")})
public class Host implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "host_id")
    private Integer hostId;
    @Column(name = "verified")
    private Boolean verified;
    @Column(name = "description")
    private String description;
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    @OneToOne
    private UserAccount userId;
    @OneToMany(mappedBy = "hostId")
    private List<Property> propertyList;

    public Host() {
    }

    public Host(Integer hostId) {
        this.hostId = hostId;
    }

    public Integer getHostId() {
        return hostId;
    }

    public void setHostId(Integer hostId) {
        this.hostId = hostId;
    }

    public Boolean getVerified() {
        return verified;
    }

    public void setVerified(Boolean verified) {
        this.verified = verified;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public UserAccount getUserId() {
        return userId;
    }

    public void setUserId(UserAccount userId) {
        this.userId = userId;
    }

    public List<Property> getPropertyList() {
        return propertyList;
    }

    public void setPropertyList(List<Property> propertyList) {
        this.propertyList = propertyList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (hostId != null ? hostId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Host)) {
            return false;
        }
        Host other = (Host) object;
        if ((this.hostId == null && other.hostId != null) || (this.hostId != null && !this.hostId.equals(other.hostId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Host[ hostId=" + hostId + " ]";
    }
    
}
