package dto;

import java.util.Date;

public class BookingHistory {
    private String roomName;
    private String hotelName;
    private Date checkInDate;
    private Date checkOutDate;
    private int rating;

    public BookingHistory(String roomName, String hotelName, Date checkInDate, Date checkOutDate, int rating) {
        this.roomName = roomName;
        this.hotelName = hotelName;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.rating = rating;
    }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public String getHotelName() { return hotelName; }
    public void setHotelName(String hotelName) { this.hotelName = hotelName; }

    public Date getCheckInDate() { return checkInDate; }
    public void setCheckInDate(Date checkInDate) { this.checkInDate = checkInDate; }

    public Date getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(Date checkOutDate) { this.checkOutDate = checkOutDate; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
}
