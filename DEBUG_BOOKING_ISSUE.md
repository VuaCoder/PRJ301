# Debug Booking Issue - Staytion

## 🐛 Vấn đề đã được sửa

### **Vấn đề:**
Khi đã đăng nhập mà bấm đặt phòng vẫn bị redirect về trang chính.

### **Nguyên nhân:**
Form trong `room-detail.jsp` thiếu hidden field cho `roomId`, khiến BookingServlet không nhận được tham số này và redirect về trang chủ.

### **Giải pháp đã áp dụng:**

#### **1. Thêm hidden field roomId vào form:**
```jsp
<form method="GET" action="${pageContext.request.contextPath}/booking" class="booking-form">
    <input type="hidden" name="roomId" value="${room.roomId}">
    <!-- Các field khác -->
</form>
```

#### **2. Kiểm tra tham số trong BookingServlet:**
```java
String roomId = request.getParameter("roomId");
String checkin = request.getParameter("checkin");
String checkout = request.getParameter("checkout");
String guests = request.getParameter("guests");

if (roomId == null || checkin == null || checkout == null || guests == null) {
    response.sendRedirect("home");
    return;
}
```

## 🔍 Test Cases

### **Test Case 1: Đã đăng nhập - Đặt phòng thành công**

#### **Bước thực hiện:**
1. Đăng nhập với tài khoản customer
2. Vào trang chi tiết phòng
3. Chọn ngày check-in
4. Chọn ngày check-out
5. Chọn số khách
6. Bấm "Kiểm tra & Đặt phòng"

#### **Kết quả mong đợi:**
- ✅ Form submit với đầy đủ tham số
- ✅ BookingServlet nhận được roomId, checkin, checkout, guests
- ✅ Chuyển đến trang booking-form.jsp
- ✅ Hiển thị thông tin phòng và giá tiền

### **Test Case 2: Chưa đăng nhập - Redirect login**

#### **Bước thực hiện:**
1. Chưa đăng nhập
2. Vào trang chi tiết phòng
3. Điền thông tin đặt phòng
4. Bấm "Kiểm tra & Đặt phòng"

#### **Kết quả mong đợi:**
- ✅ Hiển thị thông báo "Vui lòng đăng nhập để đặt phòng"
- ✅ Redirect đến trang login
- ✅ Sau khi đăng nhập, tiếp tục booking

## 📋 Checklist kiểm tra

### **Form Parameters:**
- [ ] roomId được gửi đúng
- [ ] checkin được gửi đúng
- [ ] checkout được gửi đúng
- [ ] guests được gửi đúng

### **Server-side Validation:**
- [ ] Kiểm tra đăng nhập
- [ ] Kiểm tra tham số đầy đủ
- [ ] Kiểm tra availability
- [ ] Tính toán giá tiền

### **Redirect Flow:**
- [ ] Chưa đăng nhập -> login
- [ ] Đã đăng nhập -> booking-form
- [ ] Lỗi -> error page

## 🛠️ Debug Commands

### **Kiểm tra URL parameters:**
```
GET /booking?roomId=1&checkin=2024-01-15&checkout=2024-01-17&guests=2
```

### **Kiểm tra session:**
```java
UserAccount user = (UserAccount) session.getAttribute("user");
System.out.println("User: " + (user != null ? user.getFullName() : "null"));
```

### **Kiểm tra form submission:**
```javascript
console.log("Form submitted with:", {
    roomId: document.querySelector('input[name="roomId"]').value,
    checkin: document.getElementById('checkin').value,
    checkout: document.getElementById('checkout').value,
    guests: document.getElementById('guests').value
});
```

## ✅ Kết quả sau khi sửa

### **Đã sửa:**
- ✅ Thêm hidden field roomId vào form
- ✅ Kiểm tra đầy đủ tham số trong BookingServlet
- ✅ Xử lý redirect đúng cách
- ✅ Thông báo lỗi rõ ràng

### **Flow hoạt động:**
1. **Đã đăng nhập:** Form submit -> BookingServlet -> booking-form.jsp
2. **Chưa đăng nhập:** Form submit -> BookingServlet -> redirect login -> đăng nhập -> tiếp tục booking

---

**Vấn đề đã được giải quyết! 🎉** 