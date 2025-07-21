package DTO;

import java.math.BigDecimal;
import java.util.Date;

public class RoomStat {

    private Integer roomId;
    private String title;
    private BigDecimal totalPrice;
    private Long bookingCount;
    private Date lastBookingDate;
    private Double averageRating;

    public RoomStat(Integer roomId, String title, BigDecimal totalPrice,
            Long bookingCount, Date lastBookingDate, Double averageRating) {
        this.roomId = roomId;
        this.title = title;
        this.totalPrice = totalPrice;
        this.bookingCount = bookingCount;
        this.lastBookingDate = lastBookingDate;
        this.averageRating = averageRating;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public String getTitle() {
        return title;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public Long getBookingCount() {
        return bookingCount;
    }

    public Date getLastBookingDate() {
        return lastBookingDate;
    }

    public Double getAverageRating() {
        return averageRating;
    }
}
