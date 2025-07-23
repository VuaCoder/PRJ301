Create database staytion_booking_platform;
USE staytion_booking_platform;
-- ==============================
-- BẢNG 1: QUYỀN HẠN & NGƯỜI DÙNG
-- ==============================

CREATE TABLE Role (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_name NVARCHAR(50) UNIQUE -- 'Customer', 'Host', 'Admin'
);

CREATE TABLE UserAccount  -- thông tin người dùng
(
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(50) UNIQUE NOT NULL,
    password NVARCHAR(100) NOT NULL,
    email NVARCHAR(100),
    phone NVARCHAR(20),
    full_name NVARCHAR(100),
    avatar_url NVARCHAR(255),
    status NVARCHAR(20) DEFAULT 'Active', -- Active, Suspended
    created_at DATETIME DEFAULT GETDATE(),
    role_id INT FOREIGN KEY REFERENCES Role(role_id)
);
select * from Room
-- ==============================
-- BẢNG 2: KHÁCH HÀNG (ĐẶT PHÒNG)
-- ==============================

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT UNIQUE FOREIGN KEY REFERENCES UserAccount(user_id),
    dob DATE,
    gender BIT, -- 1=Male, 0=Female
    identity_no NVARCHAR(20),
    address NVARCHAR(255)
);

-- ==============================
-- BẢNG 3: CHỦ CƠ SỞ LƯU TRÚ (HOST)
-- ==============================

CREATE TABLE Host (
    host_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT UNIQUE FOREIGN KEY REFERENCES UserAccount(user_id),
    verified BIT DEFAULT 0,
    description NVARCHAR(500)
);

-- ==============================
-- BẢNG 4: CƠ SỞ LƯU TRÚ / KHÁCH SẠN
-- ==============================

CREATE TABLE Property 
(
    property_id INT PRIMARY KEY IDENTITY(1,1),
    host_id INT FOREIGN KEY REFERENCES Host(host_id),
    name NVARCHAR(100),
    description NVARCHAR(1000),
    address NVARCHAR(255),
    city NVARCHAR(50),
    latitude FLOAT,
    longitude FLOAT,
    verified BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);

-- ==============================
-- BẢNG 5: PHÒNG
-- ==============================
select * from Room
CREATE TABLE Room (
    room_id INT PRIMARY KEY IDENTITY(1,1),
    property_id INT FOREIGN KEY REFERENCES Property(property_id),
    title NVARCHAR(100),
    description NVARCHAR(1000),
    capacity INT CHECK (capacity > 0),
    price DECIMAL(18,2) CHECK (price >= 0),
    images NVARCHAR(MAX),
    status NVARCHAR(50) DEFAULT 'Available'
);

-- ==============================
-- BẢNG 6: ĐẶT PHÒNG / HỢP ĐỒNG
-- ==============================

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id),
    room_id INT FOREIGN KEY REFERENCES Room(room_id),
    checkin_date DATE,
    checkout_date DATE,
    guests INT,
    status NVARCHAR(50), -- Pending, Confirmed, Cancelled, Completed
    created_at DATETIME DEFAULT GETDATE(),
    total_price DECIMAL(18,2)
);
select * from Booking
-- ==============================
-- BẢNG 7: THANH TOÁN
-- ==============================

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT FOREIGN KEY REFERENCES Booking(booking_id),
    method NVARCHAR(50), -- MoMo, CreditCard, ZaloPay...
    transaction_id NVARCHAR(100),
    paid_amount DECIMAL(18,2),
    status NVARCHAR(50),
    paid_at DATETIME DEFAULT GETDATE()
);

-- ==============================
-- BẢNG 8: ĐÁNH GIÁ VÀ PHẢN HỒI
-- ==============================

CREATE TABLE Review (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT FOREIGN KEY REFERENCES Booking(booking_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(1000),
    created_at DATETIME DEFAULT GETDATE(),
    status NVARCHAR(50) DEFAULT 'Published'
);

-- ==============================
-- BẢNG 9: KHUYẾN MÃI & MÃ GIẢM GIÁ
-- ==============================

CREATE TABLE Promotion (
    promo_id INT PRIMARY KEY IDENTITY(1,1),
    code NVARCHAR(20) UNIQUE,
    discount_percent INT,
    description NVARCHAR(255),
    start_date DATE,
    end_date DATE
);

-- ==============================
-- BẢNG 10: AI CHATBOT / TƯ VẤN
-- ==============================

CREATE TABLE AIChatLog (
    chat_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES UserAccount(user_id),
    question NVARCHAR(500),
    answer NVARCHAR(1000),
    timestamp DATETIME DEFAULT GETDATE()
);


INSERT INTO Role (role_name)
VALUES ('customer'), ('host'), ('admin');

INSERT INTO UserAccount (username, password, role_id)
VALUES ('minh', 'minhfptu', '1');
SELECT * FROM UserAccount;

-- Cập nhật tài khoản mẫu để có email
UPDATE UserAccount
SET email = 'minh@gmail.com'
WHERE username = 'minh';

-- Nếu bạn có admin và host, bạn cũng có thể thêm:
UPDATE UserAccount
SET email = 'admin01@gmail.com'
WHERE username = 'admin01';

UPDATE UserAccount
SET email = 'host01@gmail.com'
WHERE username = 'host01';

INSERT INTO UserAccount (username, password, full_name, email, role_id)
VALUES ('host01', 'hostpass', 'Host One', 'host01@gmail.com', 2);

INSERT INTO UserAccount (username, password, full_name, email, role_id)
VALUES ('thinh', '12345', 'Host One', 'thinhh@gmail.com', 3);
select * from UserAccount;
select * from Customer;
-- phần P add dữ liệu từ đây
-- Thêm thông tin của host vào trong bảng Host
INSERT INTO Host (user_id, verified, description)
    SELECT 
        user_id,
        1,
        'Experienced host providing comfortable stays.'
    FROM UserAccount 
    WHERE username = 'host01';
select * from UserAccount;
select * from Host;
-- Lệnh xoá, nếu lỗi thì xoá theo thứ tự từ trên xuống dưới
--DELETE FROM Room;
--DELETE FROM Property;
--DELETE FROM Host;
INSERT INTO Property (host_id, name, description, address, city, latitude, longitude, verified, created_at)
    SELECT 
        (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01')),
        'Dalat Cozy Homestay',
        'A charming homestay nestled in the pine hills of Da Lat, offering a cozy atmosphere with modern amenities and stunning views.',
        '12 Tran Hung Dao, Ward 3, Da Lat',
        'Da Lat',
        11.9411,
        108.4380,
        1,
        GETDATE()
    FROM Host
    WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01');

    -- Thêm phòng cho tài sản 1
    INSERT INTO Room (property_id, title, description, capacity, price, images, status)
    SELECT 
        (SELECT property_id FROM Property WHERE name = 'Dalat Cozy Homestay' AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'))),
        'Pine View Double Room',
        'A cozy double room with a view of the pine forest, equipped with a queen-size bed and private bathroom.',
        2,
        45.00,
        '["https://example.com/images/dalat_room1_photo1.jpg", "https://example.com/images/dalat_room1_photo2.jpg"]',
        'Available'
    FROM Property
    WHERE name = 'Dalat Cozy Homestay' 
    AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'));

    INSERT INTO Room (property_id, title, description, capacity, price, images, status)
    SELECT 
        (SELECT property_id FROM Property WHERE name = 'Dalat Cozy Homestay' AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'))),
        'Family Suite',
        'A spacious suite perfect for families, featuring two bedrooms, a living area, and a small kitchenette.',
        4,
        80.00,
        '["https://example.com/images/dalat_room2_photo1.jpg", "https://example.com/images/dalat_room2_photo2.jpg"]',
        'Available'
    FROM Property
    WHERE name = 'Dalat Cozy Homestay' 
    AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'));

    INSERT INTO Room (property_id, title, description, capacity, price, images, status)
    SELECT 
        (SELECT property_id FROM Property WHERE name = 'Dalat Cozy Homestay' AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'))),
        'Garden View Single Room',
        'A compact single room with a view of the garden, ideal for solo travelers.',
        1,
        30.00,
        '["https://example.com/images/dalat_room3_photo1.jpg"]',
        'Available'
    FROM Property
    WHERE name = 'Dalat Cozy Homestay' 
    AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'));

    -- Bước 6: Thêm tài sản 2: Nha Trang Sea View Hotel
    INSERT INTO Property (host_id, name, description, address, city, latitude, longitude, verified, created_at)
    SELECT 
        (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01')),
        'Nha Trang Sea View Hotel',
        'A luxurious hotel located by the beach in Nha Trang, featuring modern rooms, a rooftop pool, and breathtaking ocean views.',
        '78 Tran Phu, Loc Tho Ward, Nha Trang',
        'Nha Trang',
        12.2388,
        109.1969,
        1,
        GETDATE()
    FROM Host
    WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01');

    -- Thêm phòng cho tài sản 2
    INSERT INTO Room (property_id, title, description, capacity, price, images, status)
    SELECT 
        (SELECT property_id FROM Property WHERE name = 'Nha Trang Sea View Hotel' AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'))),
        'Ocean View Deluxe Room',
        'A luxurious room with a private balcony offering stunning views of Nha Trang Bay.',
        2,
        120000.00,
        '["https://example.com/images/nha_trang_room1_photo1.jpg", "https://example.com/images/nha_trang_room1_photo2.jpg"]',
        'Available'
    FROM Property
    WHERE name = 'Nha Trang Sea View Hotel' 
    AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'));

    INSERT INTO Room (property_id, title, description, capacity, price, images, status)
    SELECT 
        (SELECT property_id FROM Property WHERE name = 'Nha Trang Sea View Hotel' AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'))),
        'Executive Suite',
        'A premium suite with a spacious living area, king-size bed, and access to exclusive hotel amenities.',
        4,
        200000.00,
        '["https://example.com/images/nha_trang_room2_photo1.jpg", "https://example.com/images/nha_trang_room2_photo2.jpg"]',
        'Available'
    FROM Property
    WHERE name = 'Nha Trang Sea View Hotel' 
    AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'));

    INSERT INTO Room (property_id, title, description, capacity, price, images, status)
    SELECT 
        (SELECT property_id FROM Property WHERE name = 'Nha Trang Sea View Hotel' AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'))),
        'Standard Twin Room',
        'A comfortable room with two single beds, perfect for friends or colleagues.',
        2,
        900000.00,
        '["https://example.com/images/nha_trang_room3_photo1.jpg"]',
        'Available'
    FROM Property
    WHERE name = 'Nha Trang Sea View Hotel' 
    AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'));
	--Xoá tài sản - phòng của user_id = 1
	DELETE FROM Property
WHERE name = 'Nha Trang Sea View Hotel'
  AND host_id = (
      SELECT host_id
      FROM Host
      WHERE user_id = (
          SELECT user_id FROM UserAccount WHERE username = 'host01'
      )
  );
	
SELECT * FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01');
SELECT * FROM Property WHERE host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01'));
SELECT * FROM Room WHERE property_id IN (SELECT property_id FROM Property WHERE host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'host01')));
-- chỉnh thông số account
ALTER TABLE UserAccount
ADD CONSTRAINT chk_status 
CHECK (status IN ('Active', 'Inactive'));
-- chỉnh thông số room
ALTER TABLE Room
ADD approval_status NVARCHAR(20) DEFAULT 'Pending';
UPDATE Room
SET images = '["/image_rooms/DALAT/SUITE/1.jpg", "/image_rooms/DALAT/SUITE/2.jpg"]'
WHERE title = 'Family Suite';
ALTER TABLE Room
ADD CONSTRAINT chk_approval_status CHECK (approval_status IN ('Pending', 'Approved', 'Rejected'));
UPDATE Room
SET price = 800000.00
WHERE room_id = 8;  -- hoặc theo điều kiện khác
-- Phần Minh
--Thêm vào host tạm thời trước khi become host
INSERT INTO Host (user_id, verified, description)
VALUES (1, 1, 'Chủ nhà số 1');

INSERT INTO Host (user_id, verified, description)
VALUES (3, 1, 'Host for room testing');

--kiểm tra từng host có từng room nào.
SELECT r.*
FROM Room r

SELECT * FROM Host WHERE user_id = 1;
select * from Host
select * from Customer

SELECT * FROM Property WHERE host_id = 2
SELECT * FROM Host WHERE user_id = 2

Select * from host
Select * from useraccount
SELECT * FROM Role;

INSERT INTO UserAccount (username, password, full_name, email, role_id)
VALUES ('admin', '12345', 'Administrator', 'admin@gmail.com', 3);
--cú pháp để xoá bảng cần thiết, trong trường hợp muốn xoá bảng
--drop TABLE tên_bảng;
-- thêm các bảng cần thiết
CREATE TABLE Amenity (
    amenity_id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(100),
    icon VARCHAR(255),
    description NVARCHAR(1000)
);
CREATE TABLE RoomAmenity (
    room_id INT NOT NULL,
    amenity_id INT NOT NULL,
    PRIMARY KEY (room_id, amenity_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    FOREIGN KEY (amenity_id) REFERENCES Amenity(amenity_id)
);
ALTER TABLE Room
ADD created_at DATETIME DEFAULT GETDATE();
  UPDATE Room SET created_at = GETDATE() WHERE created_at IS NULL;

ALTER TABLE Room
ADD type NVARCHAR(50) DEFAULT 'Room';
ALTER TABLE Room
ADD CONSTRAINT chk_room_type 
CHECK (type IN ('Room', 'Flat', 'Hotel', 'Villa'));
UPDATE Room
SET type = 'Hotel'
WHERE property_id IN (
    SELECT property_id FROM Property WHERE name = 'Nha Trang Sea View Hotel'
);
select  * from Room
UPDATE Room
SET type = 'Villa'
WHERE property_id IN (
    SELECT property_id FROM Property WHERE name = 'Dalat Cozy Homestay'
);

-- Gán loại Flat cho Green Riverside Hotel & Apartment
UPDATE Room
SET type = 'Flat'
WHERE property_id IN (
    SELECT property_id FROM Property WHERE name = 'Green Riverside Hotel & Apartment'
);
UPDATE Room
SET approval_status = 'Approved';

-- thêm tài sản mới cho user_id=1
	INSERT INTO Property (host_id, name, description, address, city, latitude, longitude, verified, created_at)
    SELECT 
        (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'minh')),
        'Green Riverside Hotel & Apartment',
        'A stylish apartment-hotel by the riverside in Ho Chi Minh City, offering modern comfort and urban convenience.',
        '89/21A Phan Huy Ich, Tan Binh, Ho Chi Minh City',
        'Ho Chi Minh',
        10.8225,
        106.6872,
        1,
        GETDATE()
    FROM Host
    WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'minh');

    -- Thêm phòng cho tài sản 

    INSERT INTO Room (property_id, title, description, capacity, price, images, status)
    SELECT 
        (SELECT property_id FROM Property WHERE name = 'Green Riverside Hotel & Apartment' AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'minh'))),
        'Double Room',
        'Offering free toiletries, this double room includes a private bathroom with a shower, a bidet and a hairdryer. The air-conditioned double room offers a flat-screen TV, a mini-bar, a wardrobe, an electric kettle as well as city views. The unit offers 1 bed.',
        2,
        513010.00,
        '["https://example.com/images/dalat_room1_photo1.jpg", "https://example.com/images/dalat_room1_photo2.jpg"]',
        'Available'
    FROM Property
    WHERE name = 'Green Riverside Hotel & Apartment' 
    AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'minh'));

    INSERT INTO Room (property_id, title, description, capacity, price, images, status)
    SELECT 
        (SELECT property_id FROM Property WHERE name = 'Green Riverside Hotel & Apartment' AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'minh'))),
        'King Room with Garden View',
        'The spacious double room provides air conditioning, a mini-bar, a terrace with garden views as well as a private bathroom featuring a bath. The unit offers 1 bed.',
        2,
        766770.00,
        '["https://example.com/images/dalat_room2_photo1.jpg", "https://example.com/images/dalat_room2_photo2.jpg"]',
        'Available'
    FROM Property
    WHERE name = 'Green Riverside Hotel & Apartment' 
    AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'minh'));
	--thêm tài sản và room(tối ưu)
	INSERT INTO Property (host_id, name, description, address, city, latitude, longitude, verified, created_at)
VALUES (
    (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'tên_username')),
    'tên-tài-sản',
    'miêu tả của tài sản',
    'Địa chỉ',
    'Thành phố',
    10.8225,  -- Latitude TP của bạn (bạn nên cập nhật theo vị trí thật)
    106.6872, -- Longitude TP của bạn
    1,
    GETDATE()
);
    INSERT INTO Room (property_id, title, description, capacity, price, images, status)
VALUES (
    (SELECT property_id FROM Property 
     WHERE name = 'Green Riverside Hotel & Apartment' 
     AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'tên_username'))),
    'Deluxe Riverside Room',
    'Spacious room with a balcony overlooking the river, includes king-size bed, private bathroom, and smart TV.',
    2,
    450000.00, -- giá tiền
    '["https://example.com/images/hcm_room1.jpg", "https://example.com/images/hcm_room1_view.jpg"]',
    'Available'
);
INSERT INTO Property (host_id, name, description, address, city, latitude, longitude, verified, created_at)
VALUES (
    (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'minh')),
    'Cubicity Hidden House',
    'A distinguished place to live in Ho Chi Minh.',
    '62 Thach Thi Thanh, Tan Dinh, District 1 Cubicity Hidden House, District 1, Ho Chi Minh City',
    'Ho Chi Minh',
    10.8225,  -- Latitude TP.HCM (bạn nên cập nhật theo vị trí thật)
    106.6872, -- Longitude TP.HCM
    1,
    GETDATE()
);
INSERT INTO Room (property_id, title, description, capacity, price, images, status)
VALUES (
    (SELECT property_id FROM Property 
     WHERE name = 'Cubicity Hidden House' 
     AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'minh'))),
    'King Studio',
    'Featuring free toiletries, this studio includes a private bathroom with a walk-in shower, a bidet and a hairdryer. Meals can be prepared in the kitchen, which has a stovetop, a refrigerator, kitchenware and a microwave. The air-conditioned studio features a flat-screen TV, a private entrance, soundproof walls, a seating area as well as city views. The unit has 1 bed..',
    1,
    3000.00, -- giá tiền
    '["https://example.com/images/hcm_room1.jpg", "https://example.com/images/hcm_room1_view.jpg"]',
    'Available'
);
INSERT INTO Room (property_id, title, description, capacity, price, images, status)
VALUES (
    (SELECT property_id FROM Property 
     WHERE name = 'Cubicity Hidden House' 
     AND host_id = (SELECT host_id FROM Host WHERE user_id = (SELECT user_id FROM UserAccount WHERE username = 'minh'))),
    'Queen Room',
    'Comfy beds. The unit offers 1 bed.',
    1,
    4000.00, -- giá tiền
    '["https://example.com/images/hcm_room1.jpg", "https://example.com/images/hcm_room1_view.jpg"]',
    'Available'
);
select * from Host
select * from Property
Select * from Room
select * from Booking
select * from UserAccount
select * from Review
DROP TABLE Review
CREATE TABLE Review (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT NOT NULL FOREIGN KEY REFERENCES Booking(booking_id),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(1000),
    created_at DATETIME DEFAULT GETDATE(),
    status NVARCHAR(50) DEFAULT 'Active'
)