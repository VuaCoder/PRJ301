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
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 *
 * @author HOANG PHUC
 */
@Entity
@Table(name = "Amenity")
@NamedQueries({
    @NamedQuery(name = "Amenity.findAll", query = "SELECT a FROM Amenity a"),
    @NamedQuery(name = "Amenity.findByAmenityId", query = "SELECT a FROM Amenity a WHERE a.amenityId = :amenityId"),
    @NamedQuery(name = "Amenity.findByName", query = "SELECT a FROM Amenity a WHERE a.name = :name"),
    @NamedQuery(name = "Amenity.findByIcon", query = "SELECT a FROM Amenity a WHERE a.icon = :icon"),
    @NamedQuery(name = "Amenity.findByDescription", query = "SELECT a FROM Amenity a WHERE a.description = :description")})
public class Amenity implements Serializable {

    @JoinTable(name = "RoomAmenity", joinColumns = {
        @JoinColumn(name = "amenity_id", referencedColumnName = "amenity_id")}, inverseJoinColumns = {
        @JoinColumn(name = "room_id", referencedColumnName = "room_id")})
    @ManyToMany
    private List<Room> roomList;

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "amenity_id")
    private Integer amenityId;
    @Column(name = "name")
    private String name;
    @Column(name = "icon")
    private String icon;
    @Column(name = "description")
    private String description;

    public Amenity() {
    }

    public Amenity(Integer amenityId) {
        this.amenityId = amenityId;
    }

    public Integer getAmenityId() {
        return amenityId;
    }

    public void setAmenityId(Integer amenityId) {
        this.amenityId = amenityId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (amenityId != null ? amenityId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Amenity)) {
            return false;
        }
        Amenity other = (Amenity) object;
        if ((this.amenityId == null && other.amenityId != null) || (this.amenityId != null && !this.amenityId.equals(other.amenityId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Amenity[ amenityId=" + amenityId + " ]";
    }

    public List<Room> getRoomList() {
        return roomList;
    }

    public void setRoomList(List<Room> roomList) {
        this.roomList = roomList;
    }
    
}
