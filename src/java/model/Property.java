/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
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
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author HOANG PHUC
 */
@Entity
@Table(name = "Property")
@NamedQueries({
    @NamedQuery(name = "Property.findAll", query = "SELECT p FROM Property p"),
    @NamedQuery(name = "Property.findByPropertyId", query = "SELECT p FROM Property p WHERE p.propertyId = :propertyId"),
    @NamedQuery(name = "Property.findByName", query = "SELECT p FROM Property p WHERE p.name = :name"),
    @NamedQuery(name = "Property.findByDescription", query = "SELECT p FROM Property p WHERE p.description = :description"),
    @NamedQuery(name = "Property.findByAddress", query = "SELECT p FROM Property p WHERE p.address = :address"),
    @NamedQuery(name = "Property.findByCity", query = "SELECT p FROM Property p WHERE p.city = :city"),
    @NamedQuery(name = "Property.findByLatitude", query = "SELECT p FROM Property p WHERE p.latitude = :latitude"),
    @NamedQuery(name = "Property.findByLongitude", query = "SELECT p FROM Property p WHERE p.longitude = :longitude"),
    @NamedQuery(name = "Property.findByVerified", query = "SELECT p FROM Property p WHERE p.verified = :verified"),
    @NamedQuery(name = "Property.findByCreatedAt", query = "SELECT p FROM Property p WHERE p.createdAt = :createdAt")})
public class Property implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "property_id")
    private Integer propertyId;
    @Column(name = "name")
    private String name;
    @Column(name = "description")
    private String description;
    @Column(name = "address")
    private String address;
    @Column(name = "city")
    private String city;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "latitude")
    private Double latitude;
    @Column(name = "longitude")
    private Double longitude;
    @Column(name = "verified")
    private Boolean verified;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @JoinColumn(name = "host_id", referencedColumnName = "host_id")
    @ManyToOne
    private Host hostId;
    @OneToMany(mappedBy = "propertyId")
    private List<Room> roomList;

    public Property() {
    }

    public Property(Integer propertyId) {
        this.propertyId = propertyId;
    }

    public Integer getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(Integer propertyId) {
        this.propertyId = propertyId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Boolean getVerified() {
        return verified;
    }

    public void setVerified(Boolean verified) {
        this.verified = verified;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Host getHostId() {
        return hostId;
    }

    public void setHostId(Host hostId) {
        this.hostId = hostId;
    }

    public List<Room> getRoomList() {
        return roomList;
    }

    public void setRoomList(List<Room> roomList) {
        this.roomList = roomList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (propertyId != null ? propertyId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Property)) {
            return false;
        }
        Property other = (Property) object;
        if ((this.propertyId == null && other.propertyId != null) || (this.propertyId != null && !this.propertyId.equals(other.propertyId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Property[ propertyId=" + propertyId + " ]";
    }
    
}
