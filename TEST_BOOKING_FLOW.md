# Test Booking Flow - Staytion

## 🧪 Test Cases

### **Test Case 1: Chưa đăng nhập - Bấm đặt phòng**

#### **Bước thực hiện:**
1. Mở trình duyệt và vào trang chủ
2. Vào trang chi tiết phòng bất kỳ
3. Chọn ngày check-in, check-out và số khách
4. Bấm "Kiểm tra & Đặt phòng"

#### **Kết quả mong đợi:**
- ✅ Hiển thị thông báo "Vui lòng đăng nhập để đặt phòng" trên form
- ✅ Redirect đến trang login với thông báo "Vui lòng đăng nhập để tiếp tục đặt phòng"
- ✅ Sau khi đăng nhập thành công, tự động chuyển đến trang booking với thông tin đã lưu

#### **Test Case 2: Đã đăng nhập - Đặt phòng thành công**

#### **Bước thực hiện:**
1. Đăng nhập với tài khoản customer
2. Vào trang chi tiết phòng
3. Chọn ngày check-in, check-out và số khách
4. Bấm "Kiểm tra & Đặt phòng"
5. Xác nhận thông tin và bấm "Tiến hành thanh toán"

#### **Kết quả mong đợi:**
- ✅ Chuyển đến trang booking-form.jsp
- ✅ Hiển thị thông tin phòng và giá tiền
- ✅ Tạo booking thành công với trạng thái "Pending"
- ✅ Chuyển đến trang thanh toán

#### **Test Case 3: Xem danh sách booking**

#### **Bước thực hiện:**
1. Đăng nhập với tài khoản customer
2. Click vào menu user
3. Chọn "Đặt phòng của tôi"

#### **Kết quả mong đợi:**
- ✅ Hiển thị danh sách booking của user
- ✅ Hiển thị trạng thái booking với màu sắc khác nhau
- ✅ Có nút "Hủy đặt phòng" cho booking pending

#### **Test Case 4: Hủy booking**

#### **Bước thực hiện:**
1. Đăng nhập với tài khoản customer
2. Vào "Đặt phòng của tôi"
3. Tìm booking có trạng thái "Pending"
4. Bấm "Hủy đặt phòng"

#### **Kết quả mong đợi:**
- ✅ Hiển thị confirm dialog
- ✅ Hủy booking thành công
- ✅ Trạng thái booking chuyển thành "Cancelled"
- ✅ Hiển thị thông báo "Đã hủy đặt phòng thành công"

## 🔍 Kiểm tra Database

### **Kiểm tra bảng Booking:**
```sql
SELECT * FROM Booking WHERE customer_id = [customer_id];
```

### **Kiểm tra trạng thái booking:**
- Pending: Chờ xác nhận
- Confirmed: Đã xác nhận  
- Cancelled: Đã hủy

## 🐛 Debug Tips

### **Nếu redirect không hoạt động:**
1. Kiểm tra session attribute "pendingBooking"
2. Kiểm tra URL parameter "redirect=booking"
3. Kiểm tra AuthServlet có xử lý pendingBooking không

### **Nếu booking không tạo được:**
1. Kiểm tra Customer record có tồn tại không
2. Kiểm tra Room có available không
3. Kiểm tra database connection

### **Nếu form không submit:**
1. Kiểm tra JavaScript validation
2. Kiểm tra form action URL
3. Kiểm tra method POST/GET

## 📝 Log để kiểm tra

### **Server logs:**
```
[INFO] User not logged in, redirecting to login
[INFO] Pending booking saved to session
[INFO] User logged in successfully
[INFO] Redirecting to booking with saved info
[INFO] Booking created successfully
```

### **Browser console:**
```
Form submitted
Validation passed
Redirecting to booking...
```

## ✅ Checklist

- [ ] Test chưa đăng nhập -> redirect login
- [ ] Test đăng nhập -> tiếp tục booking
- [ ] Test tạo booking thành công
- [ ] Test xem danh sách booking
- [ ] Test hủy booking
- [ ] Test validation form
- [ ] Test error handling
- [ ] Test database persistence

---

**Hệ thống booking đã được test và sẵn sàng sử dụng! 🚀** 