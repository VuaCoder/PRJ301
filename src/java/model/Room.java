/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
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
@Table(name = "Room")
@NamedQueries({
    @NamedQuery(name = "Room.findAll", query = "SELECT r FROM Room r"),
    @NamedQuery(name = "Room.findByRoomId", query = "SELECT r FROM Room r WHERE r.roomId = :roomId"),
    @NamedQuery(name = "Room.findByTitle", query = "SELECT r FROM Room r WHERE r.title = :title"),
    @NamedQuery(name = "Room.findByDescription", query = "SELECT r FROM Room r WHERE r.description = :description"),
    @NamedQuery(name = "Room.findByCapacity", query = "SELECT r FROM Room r WHERE r.capacity = :capacity"),
    @NamedQuery(name = "Room.findByPrice", query = "SELECT r FROM Room r WHERE r.price = :price"),
    @NamedQuery(name = "Room.findByImages", query = "SELECT r FROM Room r WHERE r.images = :images"),
    @NamedQuery(name = "Room.findByStatus", query = "SELECT r FROM Room r WHERE r.status = :status"),
    @NamedQuery(name = "Room.findByApprovalStatus", query = "SELECT r FROM Room r WHERE r.approvalStatus = :approvalStatus")})
public class Room implements Serializable {

    @Column(name = "type")
    private String type;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @ManyToMany(mappedBy = "roomList")
    private List<Amenity> amenityList;

    @OneToMany(mappedBy = "roomId")
    private List<Booking> bookingList;

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "room_id")
    private Integer roomId;
    @Column(name = "title")
    private String title;
    @Column(name = "description")
    private String description;
    @Column(name = "capacity")
    private Integer capacity;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "price")
    private BigDecimal price;
    @Column(name = "images")
    private String images;
    @Column(name = "status")
    private String status;
    @Column(name = "approval_status")
    private String approvalStatus;
    @JoinColumn(name = "property_id", referencedColumnName = "property_id")
    @ManyToOne
    private Property propertyId;

    public Room() {
    }

    
    public Room(Integer roomId) {
        this.roomId = roomId;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    public Property getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(Property propertyId) {
        this.propertyId = propertyId;
    }
    //getter trung gian
    public String getPropertyName() {
        return propertyId != null ? propertyId.getName() : "";
    }

    public String getCity() {
        return propertyId != null ? propertyId.getCity() : "";
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (roomId != null ? roomId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof Room)) {
            return false;
        }
        Room other = (Room) object;
        if ((this.roomId == null && other.roomId != null) || (this.roomId != null && !this.roomId.equals(other.roomId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Room[ roomId=" + roomId + " ]";
    }

    public List<Booking> getBookingList() {
        return bookingList;
    }

    public void setBookingList(List<Booking> bookingList) {
        this.bookingList = bookingList;
    }

    public List<Amenity> getAmenityList() {
        return amenityList;
    }

    public void setAmenityList(List<Amenity> amenityList) {
        this.amenityList = amenityList;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

}
