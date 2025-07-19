///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package model;
//
//import java.io.Serializable;
//import java.math.BigDecimal;
//import java.util.Date;
//import java.util.List;
//import javax.persistence.Basic;
//import javax.persistence.Column;
//import javax.persistence.Entity;
//import javax.persistence.GeneratedValue;
//import javax.persistence.GenerationType;
//import javax.persistence.Id;
//import javax.persistence.JoinColumn;
//import javax.persistence.ManyToOne;
//import javax.persistence.NamedQueries;
//import javax.persistence.NamedQuery;
//import javax.persistence.OneToMany;
//import javax.persistence.Table;
//import javax.persistence.Temporal;
//import javax.persistence.TemporalType;
//
///**
// *
// * @author HOANG PHUC
// */
//@Entity
//@Table(name = "Booking")
//@NamedQueries({
//    @NamedQuery(name = "Booking.findAll", query = "SELECT b FROM Booking b"),
//    @NamedQuery(name = "Booking.findByBookingId", query = "SELECT b FROM Booking b WHERE b.bookingId = :bookingId"),
//    @NamedQuery(name = "Booking.findByCheckinDate", query = "SELECT b FROM Booking b WHERE b.checkinDate = :checkinDate"),
//    @NamedQuery(name = "Booking.findByCheckoutDate", query = "SELECT b FROM Booking b WHERE b.checkoutDate = :checkoutDate"),
//    @NamedQuery(name = "Booking.findByGuests", query = "SELECT b FROM Booking b WHERE b.guests = :guests"),
//    @NamedQuery(name = "Booking.findByStatus", query = "SELECT b FROM Booking b WHERE b.status = :status"),
//    @NamedQuery(name = "Booking.findByCreatedAt", query = "SELECT b FROM Booking b WHERE b.createdAt = :createdAt"),
//    @NamedQuery(name = "Booking.findByTotalPrice", query = "SELECT b FROM Booking b WHERE b.totalPrice = :totalPrice")})
//public class Booking implements Serializable {
//
//    private static final long serialVersionUID = 1L;
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    @Basic(optional = false)
//    @Column(name = "booking_id")
//    private Integer bookingId;
//    @Column(name = "checkin_date")
//    @Temporal(TemporalType.DATE)
//    private Date checkinDate;
//    @Column(name = "checkout_date")
//    @Temporal(TemporalType.DATE)
//    private Date checkoutDate;
//    @Column(name = "guests")
//    private Integer guests;
//    @Column(name = "status")
//    private String status;
//    @Column(name = "created_at")
//    @Temporal(TemporalType.TIMESTAMP)
//    private Date createdAt;
//    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
//    @Column(name = "total_price")
//    private BigDecimal totalPrice;
//    @OneToMany(mappedBy = "bookingId")
//    private List<Payment> paymentList;
//    @JoinColumn(name = "customer_id", referencedColumnName = "customer_id")
//    @ManyToOne
//    private Customer customerId;
//    @JoinColumn(name = "room_id", referencedColumnName = "room_id")
//    @ManyToOne
//    private Room roomId;
//    @OneToMany(mappedBy = "bookingId")
//    private List<Review> reviewList;
//
//    public Booking() {
//    }
//
//    public Booking(Integer bookingId) {
//        this.bookingId = bookingId;
//    }
//
//    public Integer getBookingId() {
//        return bookingId;
//    }
//
//    public void setBookingId(Integer bookingId) {
//        this.bookingId = bookingId;
//    }
//
//    public Date getCheckinDate() {
//        return checkinDate;
//    }
//
//    public void setCheckinDate(Date checkinDate) {
//        this.checkinDate = checkinDate;
//    }
//
//    public Date getCheckoutDate() {
//        return checkoutDate;
//    }
//
//    public void setCheckoutDate(Date checkoutDate) {
//        this.checkoutDate = checkoutDate;
//    }
//
//    public Integer getGuests() {
//        return guests;
//    }
//
//    public void setGuests(Integer guests) {
//        this.guests = guests;
//    }
//
//    public String getStatus() {
//        return status;
//    }
//
//    public void setStatus(String status) {
//        this.status = status;
//    }
//
//    public Date getCreatedAt() {
//        return createdAt;
//    }
//
//    public void setCreatedAt(Date createdAt) {
//        this.createdAt = createdAt;
//    }
//
//    public BigDecimal getTotalPrice() {
//        return totalPrice;
//    }
//
//    public void setTotalPrice(BigDecimal totalPrice) {
//        this.totalPrice = totalPrice;
//    }
//
//    public List<Payment> getPaymentList() {
//        return paymentList;
//    }
//
//    public void setPaymentList(List<Payment> paymentList) {
//        this.paymentList = paymentList;
//    }
//
//    public Customer getCustomerId() {
//        return customerId;
//    }
//
//    public void setCustomerId(Customer customerId) {
//        this.customerId = customerId;
//    }
//
//    public Room getRoomId() {
//        return roomId;
//    }
//
//    public void setRoomId(Room roomId) {
//        this.roomId = roomId;
//    }
//
//    public List<Review> getReviewList() {
//        return reviewList;
//    }
//
//    public void setReviewList(List<Review> reviewList) {
//        this.reviewList = reviewList;
//    }
//
//    @Override
//    public int hashCode() {
//        int hash = 0;
//        hash += (bookingId != null ? bookingId.hashCode() : 0);
//        return hash;
//    }
//
//    @Override
//    public boolean equals(Object object) {
//        // TODO: Warning - this method won't work in the case the id fields are not set
//        if (!(object instanceof Booking)) {
//            return false;
//        }
//        Booking other = (Booking) object;
//        if ((this.bookingId == null && other.bookingId != null) || (this.bookingId != null && !this.bookingId.equals(other.bookingId))) {
//            return false;
//        }
//        return true;
//    }
//
//    @Override
//    public String toString() {
//        return "model.Booking[ bookingId=" + bookingId + " ]";
//    }
//    
//}
package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import javax.persistence.CascadeType;
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

@Entity
@Table(name = "Booking")
@NamedQueries({
    @NamedQuery(name = "Booking.findAll", query = "SELECT b FROM Booking b"),
    @NamedQuery(name = "Booking.findByBookingId", query = "SELECT b FROM Booking b WHERE b.bookingId = :bookingId"),
    @NamedQuery(name = "Booking.findByCheckinDate", query = "SELECT b FROM Booking b WHERE b.checkinDate = :checkinDate"),
    @NamedQuery(name = "Booking.findByCheckoutDate", query = "SELECT b FROM Booking b WHERE b.checkoutDate = :checkoutDate"),
    @NamedQuery(name = "Booking.findByGuests", query = "SELECT b FROM Booking b WHERE b.guests = :guests"),
    @NamedQuery(name = "Booking.findByStatus", query = "SELECT b FROM Booking b WHERE b.status = :status"),
    @NamedQuery(name = "Booking.findByCreatedAt", query = "SELECT b FROM Booking b WHERE b.createdAt = :createdAt"),
    @NamedQuery(name = "Booking.findByTotalPrice", query = "SELECT b FROM Booking b WHERE b.totalPrice = :totalPrice")
})
public class Booking implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "booking_id")
    private Integer bookingId;

    @Column(name = "checkin_date")
    @Temporal(TemporalType.DATE)
    private Date checkinDate;

    @Column(name = "checkout_date")
    @Temporal(TemporalType.DATE)
    private Date checkoutDate;

    @Column(name = "guests")
    private Integer guests;

    @Column(name = "status")
    private String status;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Column(name = "total_price")
    private BigDecimal totalPrice;

    // Quan hệ nhiều-1 với customer
    @ManyToOne(optional = false)
    @JoinColumn(name = "customer_id", referencedColumnName = "customer_id")
    private Customer customerId;

    // Quan hệ nhiều-1 với room
    @ManyToOne(optional = false)
    @JoinColumn(name = "room_id", referencedColumnName = "room_id")
    private Room roomId;

    // Một đơn có thể có nhiều payment
    @OneToMany(mappedBy = "bookingId", cascade = CascadeType.ALL)
    private List<Payment> paymentList;

    // Một đơn có thể có nhiều đánh giá
    @OneToMany(mappedBy = "bookingId", cascade = CascadeType.ALL)
    private List<Review> reviewList;

    // Constructors
    public Booking() {}

    public Booking(Integer bookingId) {
        this.bookingId = bookingId;
    }

    // Getters & Setters
    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }

    public Date getCheckinDate() {
        return checkinDate;
    }

    public void setCheckinDate(Date checkinDate) {
        this.checkinDate = checkinDate;
    }

    public Date getCheckoutDate() {
        return checkoutDate;
    }

    public void setCheckoutDate(Date checkoutDate) {
        this.checkoutDate = checkoutDate;
    }

    public Integer getGuests() {
        return guests;
    }

    public void setGuests(Integer guests) {
        this.guests = guests;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Customer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Customer customerId) {
        this.customerId = customerId;
    }

    public Room getRoomId() {
        return roomId;
    }

    public void setRoomId(Room roomId) {
        this.roomId = roomId;
    }

    public List<Payment> getPaymentList() {
        return paymentList;
    }

    public void setPaymentList(List<Payment> paymentList) {
        this.paymentList = paymentList;
    }

    public List<Review> getReviewList() {
        return reviewList;
    }

    public void setReviewList(List<Review> reviewList) {
        this.reviewList = reviewList;
    }

    @Override
    public int hashCode() {
        return (bookingId != null ? bookingId.hashCode() : 0);
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof Booking)) return false;
        Booking other = (Booking) obj;
        return this.bookingId != null && this.bookingId.equals(other.bookingId);
    }

    @Override
    public String toString() {
        return "Booking[ id=" + bookingId + " ]";
    }
}
