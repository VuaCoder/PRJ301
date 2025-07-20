
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="model.UserAccount"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    boolean isHost = user != null && user.getRoleId() != null && "host".equalsIgnoreCase(user.getRoleId().getRoleName());
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Staytion</title>
        <link rel="stylesheet" href="css/style_home.css" />
        <link rel="icon" type="image/x-icon" href="img/favicon.ico">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:ital,wght@0,100..900;1,100..900&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <script src="js/forms.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css"/>
        <script src="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.js"></script>
    </head>
    <body>
        <jsp:include page="view/common/header.jsp"/>
        <div class="header">
            <div class="main-header">
                <div class="main-image">
                    <img src="img/forest.jpg" alt="forest">
                </div>
            </div>
            <div class="header-bottom">
                <div class="search-header">
                    <h1>FIND</h1>
                    <div class="search-header-option">
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/results?type=Room">Rooms</a></li>
                            <li><a href="${pageContext.request.contextPath}/results?type=Flat">Flats</a></li>
                            <li><a href="${pageContext.request.contextPath}/results?type=Hotel">Hotels</a></li>
                            <li><a href="${pageContext.request.contextPath}/results?type=Villa">Villas</a></li>
                        </ul>
                    </div>             
                </div>
                <form method="GET" action="results">
                    <div class="input-header-option">
                        <!-- Địa điểm custom dropdown -->
                        <div class="option-field">
                            <label for="location">Địa Điểm / Location</label>
                            <div class="custom-dropdown" id="location-dropdown">
                                <div class="custom-dropdown-selected" id="location-selected">Nhập địa điểm du lịch</div>
                                <div class="custom-dropdown-list" id="location-list">
                                    <div class="custom-dropdown-option" data-value="Ho Chi Minh">Hồ Chí Minh</div>
                                    <div class="custom-dropdown-option" data-value="Da Nang">Đà Nẵng</div>
                                    <div class="custom-dropdown-option" data-value="Ha Noi">Hà Nội</div>
                                    <div class="custom-dropdown-option" data-value="Hue">Huế</div>
                                    <div class="custom-dropdown-option" data-value="Nha Trang">Nha Trang</div>
                                    <div class="custom-dropdown-option" data-value="Vung Tau">Vũng Tàu</div>
                                    <div class="custom-dropdown-option" data-value="Da Lat">Đà Lạt</div>
                                </div>
                            </div>
                            <select id="location" name="location" style="display:none">
                                <option value="">Nhập địa điểm du lịch</option>
                                <option value="Ho Chi Minh">Hồ Chí Minh</option>
                                <option value="Da Nang">Đà Nẵng</option>
                                <option value="Ha Noi">Hà Nội</option>
                                <option value="Hue">Huế</option>
                                <option value="Nha Trang">Nha Trang</option>
                                <option value="Vung Tau">Vũng Tàu</option>
                                <option value="Da Lat">Đà Lạt</option>
                            </select>
                        </div>
                        <!-- Giá tiền custom dropdown -->
                        <div class="option-field">
                            <label for="money">Giá Tiền / Money</label>
                            <div class="custom-dropdown" id="money-dropdown">
                                <div class="custom-dropdown-selected" id="money-selected">Xin vui lòng chọn mức giá</div>
                                <div class="custom-dropdown-list" id="money-list">
                                    <div class="custom-dropdown-option" data-value="gia re">Dưới 500.000 đồng</div>
                                    <div class="custom-dropdown-option" data-value="trung binh thap">500.000 - 1.000.000 đồng</div>
                                    <div class="custom-dropdown-option" data-value="trung binh cao">1.000.000 - 2.000.000 đồng</div>
                                    <div class="custom-dropdown-option" data-value="mr beast">Trên 2.000.000 đồng</div>
                                </div>
                            </div>
                            <select id="money" name="money" style="display:none">
                                <option value="">Xin vui lòng chọn mức giá</option>
                                <option value="gia re">Dưới 500.000 đồng</option>
                                <option value="trung binh thap">500.000 - 1.000.000 đồng</option>
                                <option value="trung binh cao">1.000.000 - 2.000.000 đồng</option>
                                <option value="mr beast">Trên 2.000.000 đồng</option>
                            </select>
                        </div>
                        <!-- Thay input ngày vào/ngày ra sang type="text" để flatpickr hoạt động -->
                        <div class="option-field">
                            <label for="check-in">Ngày Vào / Check In</label>
                            <input type="text" id="check-in" name="check_in" placeholder="Chọn ngày">
                        </div>
                        <div class="option-field">
                            <label for="check-out">Ngày Ra / Check Out</label>
                            <input type="text" id="check-out" name="check_out" placeholder="Chọn ngày">
                        </div>
                        <div class="option-field">
                            <label for="guests">Số lượng khách / Guest</label>
                            <input type="number" id="guests" name="guests" min="1" max="50" placeholder="Add Guests">
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="second">
            <div class="lastest-selection">
                <div class="lastest-selection-header">
                    <h1>Danh sách tìm kiếm</h1>
                    <div class="show-on-map"><img src="img/location.png" alt="location">
                        <a href="#">
                            <p>Show on map</p>
                        </a>
                    </div>
                </div>
                <div class="property-listing" id="nearby-properties">
                    <c:forEach var="room" items="${nearbyRooms}">
                        <div class="home-room-card" onclick="window.location.href = 'detail?id=${room.roomId}'">
                            <c:set var="imgArr" value="${fn:split(room.images, ',')}" />
                            <c:set var="imgRaw" value="${imgArr[0]}" />
                            <img src="${imgRaw}" style="width:100%;height:180px;object-fit:cover;display:block;border-top-left-radius:16px;border-top-right-radius:16px;margin:0;padding:0;" alt="Room Image">
                            <div class="home-room-info p-4">
                                <h4>${room.title}</h4>
                                <p>${room.city}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>

        <div class="third">
            <div class="lastest-selection">
                <div class="lastest-selection-header">
                    <h1>Các tài sản hiện có</h1>
                </div>
                <div class="property-listing swiper property-swiper" style="position:relative;">
                    <div class="swiper-nav-blur left"></div>
                    <div class="swiper-nav-blur right"></div>
                    <div class="swiper-wrapper">
                        <c:forEach var="room" items="${latestRooms}">
                            <div class="home-room-card swiper-slide" onclick="window.location.href = 'detail?id=${room.roomId}'">
                                <c:set var="imgArr" value="${fn:split(room.images, ',')}" />
                                <c:set var="imgRaw" value="${imgArr[0]}" />
                                <img src="${imgRaw}" style="width:100%;height:180px;object-fit:cover;display:block;border-top-left-radius:16px;border-top-right-radius:16px;margin:0;padding:0;" alt="Room Image">
                                <div class="home-room-info p-4">
                                    <h4>${room.title}</h4>
                                    <p>${room.city}</p>
                                </div>
                            </div>
                        </c:forEach>
                        <div class="swiper-slide show-all-slide home-room-card" style="cursor:pointer;display:flex;flex-direction:column;align-items:center;justify-content:center;min-height:260px;background:#f7fafc;border:2px dashed #2d7dd2;" onclick="window.location.href='${pageContext.request.contextPath}/results'">
                            <div style="flex:1;display:flex;align-items:center;justify-content:center;width:100%;">
                                <i class="fas fa-arrow-right" style="font-size:2.8rem;color:#2d7dd2;"></i>
                            </div>
                            <div class="home-room-info p-4" style="text-align:center;background:none;box-shadow:none;">
                                <h4 style="font-size:1.1rem;font-weight:700;">Xem thêm</h4>
                            </div>
                        </div>
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                    <div class="swiper-pagination"></div>
                </div>
            </div>


        </div>
        <div class="fifth">
            <div class="lastest-selection">
                <div class="lastest-selection-header">
                    <h1>Feature Properties on our Listing</h1>
                </div>
                <div class="property-listing">
                    <div class="card-below">

                        <img src="https://img4.thuthuatphanmem.vn/uploads/2020/05/12/anh-nen-xam-dep_103622944.jpg"
                             alt="Well Furnished Apartment">
                        <h3>Well Furnished Apartment</h3>
                        <p>Ngu Hanh Son, Da Nang</p>
                        <div class="property-details">
                            <span><i class="fa-solid fa-bed"></i> 3</span>
                            <span><i class="fa-solid fa-bath"></i> 1</span>
                            <span><i class="fa-solid fa-car"></i> 2</span>
                            <span><i class="fa-solid fa-paw"></i> 0</span>
                        </div>
                        <p class="price">$1000 - $5000 USD</p>
                    </div>
                    <div class="card-below">
                        <img src="https://img4.thuthuatphanmem.vn/uploads/2020/05/12/anh-nen-xam-dep_103622944.jpg"
                             alt="Well Furnished Apartment">
                        <h3>Blue Door Villa Modern</h3>
                        <p>Ngu Hanh Son, Da Nang</p>
                        <div class="property-details">
                            <span><i class="fa-solid fa-bed"></i> 3</span>
                            <span><i class="fa-solid fa-bath"></i> 1</span>
                            <span><i class="fa-solid fa-car"></i> 2</span>
                            <span><i class="fa-solid fa-paw"></i> 0</span>
                        </div>
                        <p class="price">$1000 - $5000 USD</p>
                    </div>
                    <div class="card-below">
                        <img src="https://img4.thuthuatphanmem.vn/uploads/2020/05/12/anh-nen-xam-dep_103622944.jpg"
                             alt="Well Furnished Apartment">
                        <h3>Beach House Apartment</h3>
                        <p>Ngu Hanh Son, Da Nang</p>
                        <div class="property-details">
                            <span><i class="fa-solid fa-bed"></i> 3</span>
                            <span><i class="fa-solid fa-bath"></i> 1</span>
                            <span><i class="fa-solid fa-car"></i> 2</span>
                            <span><i class="fa-solid fa-paw"></i> 0</span>
                        </div>
                        <p class="price">$1000 - $5000 USD</p>
                    </div>
                    <div class="card-below">
                        <img src="https://img4.thuthuatphanmem.vn/uploads/2020/05/12/anh-nen-xam-dep_103622944.jpg"
                             alt="Well Furnished Apartment">
                        <h3>Country Boys Hostel</h3>
                        <p>Ngu Hanh Son, Da Nang</p>
                        <div class="property-details">
                            <span><i class="fa-solid fa-bed"></i> 3</span>
                            <span><i class="fa-solid fa-bath"></i> 1</span>
                            <span><i class="fa-solid fa-car"></i> 2</span>
                            <span><i class="fa-solid fa-paw"></i> 0</span>
                        </div>
                        <p class="price">$1000 - $5000 USD</p>
                    </div>
                    <div class="card-below">
                        <img src="https://img4.thuthuatphanmem.vn/uploads/2020/05/12/anh-nen-xam-dep_103622944.jpg"
                             alt="Well Furnished Apartment">
                        <h3>Well Furnished Apartment</h3>
                        <p>Ngu Hanh Son, Da Nang</p>
                        <div class="property-details">
                            <span><i class="fa-solid fa-bed"></i> 3</span>
                            <span><i class="fa-solid fa-bath"></i> 1</span>
                            <span><i class="fa-solid fa-car"></i> 2</span>
                            <span><i class="fa-solid fa-paw"></i> 0</span>
                        </div>
                        <p class="price">$1000 - $5000 USD</p>
                    </div>

                </div>
            </div>
        </div>

        <div class="sixth">
            <section class="browser-section">
                <div class="image-box"></div>
                <div class="content">
                    <h1>Browse For More Properties</h1>
                    <p>Explore properties by their categories/types...</p>
                    <button>Find A Property</button>
                </div>
            </section>

            <div class="blog-section">
                <h1>Property Rental <br>Guides & Tips</h1>

                <div class="blog-list">
                    <div class="blog-card">
                        <img src="https://img4.thuthuatphanmem.vn/uploads/2020/05/12/anh-nen-xam-dep_103622944.jpg" alt="">
                        <h3>Choose the right property!</h3>
                        <p class="category">Economy</p>
                    </div>

                    <div class="blog-card">
                        <img src="https://img4.thuthuatphanmem.vn/uploads/2020/05/12/anh-nen-xam-dep_103622944.jpg" alt="">
                        <h3>Best environment for rental</h3>
                        <p class="category">Lifestyle</p>
                    </div>

                    <div class="blog-card">
                        <img src="https://img4.thuthuatphanmem.vn/uploads/2020/05/12/anh-nen-xam-dep_103622944.jpg" alt="">
                        <h3>Boys Hostel Apartment</h3>
                        <p class="category">Property</p>
                    </div>
                </div>

                <div class="view-all-btn">
                    <button>View All Blogs</button>
                </div>
            </div>
        </div>

        <section class="download-mobile_app-section">
            <div class="image-box"></div>
            <div class="content">
                <h1>Download Our Mobile App</h1>
                <p>Available for free on these platforms</p>
                <div class="property-details">
                    <a href="https://play.google.com" target="_blank" class="store-btn">
                        <i class="fa-brands fa-google-play"></i> PlayStore
                    </a>
                    <a href="https://www.apple.com/app-store/" target="_blank" class="store-btn">
                        <i class="fab fa-app-store"></i> AppleStore
                    </a>
                </div>
            </div>
        </section>

        <footer class="footer">
            <div class="news-letter">
                <div class="news-letter-content">
                    <h2>NEWSLETTER</h2>
                    <p>Stay Upto Date</p>
                </div>
                <form>
                    <input type="email" name="email" placeholder="Your Email..." required>
                    <button type="submit">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                        <path d="M2,21L23,12L2,3V10L17,12L2,14V21Z" />
                        </svg>
                    </button>
                </form>
            </div>

            <!-- Inner -->
            <div class="footer-inner">
                <div class="footer-content">
                    <div class="footer-logo">
                        <img src="images/logo.png" alt="Logo" />
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
                            labore et
                            dolore magna aliqua.</p>
                        <div class="property-details">
                            <a href="https://play.google.com" target="_blank" class="store-btn">
                                <i class="fa-brands fa-google-play"></i> PlayStore
                            </a>
                            <a href="https://www.apple.com/app-store/" target="_blank" class="store-btn">
                                <i class="fab fa-app-store"></i> AppleStore
                            </a>
                        </div>
                    </div>

                    <div class="footer-links">
                        <div>
                            <h4>COMPANY</h4>
                            <div class="link-column">
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">About Us</a>
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">Legal Information</a>
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">Contact Us</a>
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">Blogs</a>
                            </div>

                        </div>
                        <div>
                            <h4>HELP CENTER</h4>
                            <div class="link-column">
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">Find a Property</a>
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">How To Host?</a>
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">Why Us?</a>
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">FAQs</a>
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">Rental Guides</a>
                            </div>
                        </div>
                        <div>
                            <h4>CONTACT INFO</h4>
                            <div class="contact-info">
                                <p>Phone: 1234567890</p>
                                <p>Email: company@email.com</p>
                                <p>Ngu Hanh Son, Da Nang</p>
                            </div>
                            <div class="social-icons">
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ" target="_blank">
                                    <i class="fa-brands fa-square-facebook"></i>
                                </a>
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ" target="_blank">
                                    <i class="fa-brands fa-twitter"></i>
                                </a>
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ" target="_blank">
                                    <i class="fa-brands fa-instagram"></i>
                                </a>
                                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ" target="_blank">
                                    <i class="fa-brands fa-linkedin"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="footer-bottom">
                    <p>&copy; 2025 PRJCHIMUNG.design | All rights reserved</p>
                    <p>Created with love by <strong>PRJ CHIM UNG</strong></p>
                </div>
            </div>
        </footer>
        <jsp:include page="/chatBotElement.jsp"></jsp:include>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Custom dropdown cho location
                function setupCustomDropdown(dropdownId, selectId, selectedId, listId) {
                    var dropdown = document.getElementById(dropdownId);
                    var select = document.getElementById(selectId);
                    var selected = document.getElementById(selectedId);
                    var list = document.getElementById(listId);
                    var options = list.querySelectorAll('.custom-dropdown-option');
                    dropdown.addEventListener('click', function(e) {
                        list.classList.toggle('show');
                    });
                    options.forEach(function(opt) {
                        opt.addEventListener('click', function(e) {
                            var value = opt.getAttribute('data-value');
                            var text = opt.textContent;
                            selected.textContent = text;
                            select.value = value;
                            list.classList.remove('show');
                            select.dispatchEvent(new Event('change', {bubbles:true}));
                        });
                    });
                    // Đóng dropdown khi click ngoài
                    document.addEventListener('click', function(e) {
                        if (!dropdown.contains(e.target)) {
                            list.classList.remove('show');
                        }
                    });
                }
                setupCustomDropdown('location-dropdown', 'location', 'location-selected', 'location-list');
                setupCustomDropdown('money-dropdown', 'money', 'money-selected', 'money-list');

                var locationSelect = document.getElementById('location');
                var moneySelect = document.getElementById('money');
                var checkInInput = document.getElementById('check-in');
                var checkOutInput = document.getElementById('check-out');
                var guestsInput = document.getElementById('guests');
                var nearbyProperties = document.getElementById('nearby-properties');

                function fetchRoomsRealtime() {
                    var city = locationSelect.value;
                    var money = moneySelect.value;
                    var checkIn = checkInInput.value;
                    var checkOut = checkOutInput.value;
                    var guests = guestsInput.value;

                    // Chỉ gửi khi có city hoặc guests hoặc money
                    if(city || guests || money) {
                        var params = [];
                        if(city) params.push('location=' + encodeURIComponent(city));
                        if(money) params.push('money=' + encodeURIComponent(money));
                        if(checkIn) params.push('check_in=' + encodeURIComponent(checkIn));
                        if(checkOut) params.push('check_out=' + encodeURIComponent(checkOut));
                        if(guests) params.push('guests=' + encodeURIComponent(guests));
                        var url = 'home?' + params.join('&');
                        fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                            .then(res => res.text())
                            .then(html => {
                                nearbyProperties.innerHTML = html;
                            })
                            .catch(err => {
                                nearbyProperties.innerHTML = '<div>Không thể tải danh sách phòng.</div>';
                            });
                    }
                }

                if(locationSelect) locationSelect.addEventListener('change', fetchRoomsRealtime);
                if(moneySelect) moneySelect.addEventListener('change', fetchRoomsRealtime);
                if(checkInInput) checkInInput.addEventListener('change', fetchRoomsRealtime);
                if(checkOutInput) checkOutInput.addEventListener('change', fetchRoomsRealtime);
                if(guestsInput) guestsInput.addEventListener('input', fetchRoomsRealtime);
            });
        </script>
        <script>
document.querySelectorAll('.custom-dropdown').forEach(dropdown => {
    const selected = dropdown.querySelector('.custom-dropdown-selected');
    const list = dropdown.querySelector('.custom-dropdown-list');
    const options = dropdown.querySelectorAll('.custom-dropdown-option');

    selected.addEventListener('click', (e) => {
        e.stopPropagation();
        list.classList.toggle('show');
    });

    options.forEach(option => {
        option.addEventListener('click', (e) => {
            e.stopPropagation();
            selected.textContent = option.textContent;
            list.classList.remove('show');
            const hiddenSelect = dropdown.nextElementSibling;
            if (hiddenSelect && hiddenSelect.tagName === 'SELECT') {
                hiddenSelect.value = option.dataset.value;
                hiddenSelect.dispatchEvent(new Event('change', {bubbles:true}));
            }
        });
    });

    // Click outside to close ngay lập tức
    document.addEventListener('click', (e) => {
        if (!dropdown.contains(e.target)) {
            list.classList.remove('show');
        }
    });
});
</script>
<style>
.home-room-card {
    background: #f5f6f8;
    border-radius: 16px;
    box-shadow: 0 2px 12px #0001;
    overflow: hidden;
    transition: box-shadow 0.2s, transform 0.2s;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    min-width: 260px;
    max-width: 320px;
    margin: 0 auto;
}
.home-room-card:hover {
    box-shadow: 0 6px 24px #0002;
    transform: translateY(-6px) scale(1.03);
}
.home-room-img-carousel {
    width: 100%;
    height: 180px;
    position: relative;
    background: #e6e6e6;
    border-top-left-radius: 16px;
    border-top-right-radius: 16px;
    overflow: hidden;
}
.swiper-slide img {
    width: 100%;
    height: 180px;
    object-fit: cover;
    display: block;
}
.home-room-info {
    background: #fff;
    border-bottom-left-radius: 16px;
    border-bottom-right-radius: 16px;
    min-height: 90px;
    padding: 18px 18px 14px 18px;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    gap: 4px;
}
.home-room-info h4 {
    font-size: 1.1rem;
    font-weight: 700;
    color: #222;
    margin: 0 0 2px 0;
    line-height: 1.3;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    text-overflow: ellipsis;
    min-height: 2.6em;
    max-height: 2.6em;
    word-break: break-word;
}
.home-room-info p {
    color: #888;
    font-size: 0.97rem;
    margin: 0 0 2px 0;
    font-weight: 400;
    line-height: 1.2;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.home-room-info .room-price {
    font-size: 1.08rem;
    font-weight: 600;
    color: #2563eb;
    margin-top: 4px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.swiper-pagination {
    position: absolute;
    bottom: 8px;
    left: 0;
    width: 100%;
    text-align: center;
    z-index: 10;
    display: block !important;
}
.swiper-pagination-bullet {
    background: #222 !important;
    opacity: 0.5;
    width: 10px;
    height: 10px;
    margin: 0 3px !important;
    border-radius: 50%;
    display: inline-block;
    transition: opacity 0.2s;
}
.swiper-pagination-bullet-active {
    opacity: 1;
    background: #2563eb !important;
}
</style>
<script>
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('[class^="swiper swiper-room-"]').forEach((swiperEl) => {
        const roomId = swiperEl.className.match(/swiper-room-(\d+)/);
        const pag = roomId ? `.swiper-pagination-${roomId[1]}` : '.swiper-pagination';
        new Swiper(swiperEl, {
            loop: true,
            pagination: {
                el: pag,
                clickable: true,
                renderBullet: function (index, className) {
                    return `<span class="${className}"></span>`;
                }
            },
            slidesPerView: 1,
            spaceBetween: 0,
        });
    });
});
</script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const swiper = new Swiper('.property-swiper', {
        slidesPerView: 3,
        spaceBetween: 24,
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        loop: false,
        centeredSlides: false,
        watchOverflow: true,
        breakpoints: {
            900: { slidesPerView: 3 },
            600: { slidesPerView: 2 },
            0:   { slidesPerView: 1 }
        },
        on: {
            slideChange: function() {
                const prevBtn = document.querySelector('.property-swiper .swiper-button-prev');
                const nextBtn = document.querySelector('.property-swiper .swiper-button-next');
                const slides = document.querySelectorAll('.property-swiper .swiper-slide');
                const showAllIndex = Array.from(slides).findIndex(slide => slide.classList.contains('show-all-slide'));
                // Lấy số slide đang hiển thị (responsive)
                let slidesPerView = this.params.slidesPerView;
                if (typeof slidesPerView === 'object') {
                    // Responsive: lấy đúng số lượng theo màn hình
                    const width = window.innerWidth;
                    if (width >= 900) slidesPerView = 3;
                    else if (width >= 600) slidesPerView = 2;
                    else slidesPerView = 1;
                }
                const lastVisibleIndex = this.activeIndex + slidesPerView - 1;
                // Ẩn mũi tên trái nếu ở đầu
                if (prevBtn && prevBtn.classList.contains('swiper-button-disabled')) {
                    prevBtn.style.display = 'none';
                } else if (prevBtn) {
                    prevBtn.style.display = '';
                }
                // Ẩn mũi tên phải nếu 'Xem thêm' là slide cuối cùng bên phải
                if (nextBtn) {
                    if (lastVisibleIndex >= showAllIndex) {
                        nextBtn.style.display = 'none';
                    } else {
                        nextBtn.style.display = '';
                    }
                }
            },
            afterInit: function() {
                this.emit('slideChange');
            }
        }
    });
});
</script>

<script>
// Xử lý hamburger menu cho trang home
document.addEventListener('DOMContentLoaded', function() {
    const menuButton = document.getElementById("menuButton");
    const menuDropdown = document.getElementById("menuDropdown");
    
    if (menuButton && menuDropdown) {
        menuButton.addEventListener("click", (e) => {
            e.stopPropagation();
            menuDropdown.classList.toggle("active");
        });
        
        document.addEventListener("click", (e) => {
            if (!menuButton.contains(e.target) && !menuDropdown.contains(e.target)) {
                menuDropdown.classList.remove("active");
            }
        });
    }
});
const checkinPicker = flatpickr("#check-in", {
    dateFormat: "d/m/Y",
    minDate: "today",
    onChange: function(selectedDates, dateStr, instance) {
        if (selectedDates.length) {
            checkoutPicker.set('minDate', selectedDates[0]);
        }
    }
});
const checkoutPicker = flatpickr("#check-out", {
    dateFormat: "d/m/Y",
    minDate: "today"
});
// Xử lý search theo thời gian thực
document.addEventListener('DOMContentLoaded', function() {
    const checkInInput = document.getElementById('check-in');
    const checkOutInput = document.getElementById('check-out');
    const locationSelect = document.getElementById('location');
    const moneySelect = document.getElementById('money');
    const guestsInput = document.getElementById('guests');
    const nearbyProperties = document.getElementById('nearby-properties');
    
    let searchTimeout;
    
    function performSearch() {
        const checkIn = checkInInput.value;
        const checkOut = checkOutInput.value;
        const location = locationSelect.value;
        const money = moneySelect.value;
        const guests = guestsInput.value;
        
        // Chỉ search nếu có ít nhất 2 thông tin
        const hasCheckIn = checkIn && checkIn.trim() !== '';
        const hasCheckOut = checkOut && checkOut.trim() !== '';
        const hasLocation = location && location.trim() !== '';
        const hasGuests = guests && guests.trim() !== '';
        
        if ((hasCheckIn && hasCheckOut) || hasLocation || hasGuests) {
            // Hiển thị loading
            nearbyProperties.innerHTML = '<div style="text-align: center; padding: 40px; color: #666;"><i class="fas fa-spinner fa-spin" style="font-size: 2rem; margin-bottom: 10px;"></i><br>Đang tìm kiếm phòng...</div>';
            
            // Tạo URL với parameters
            const params = new URLSearchParams();
            if (checkIn) params.append('check_in', checkIn);
            if (checkOut) params.append('check_out', checkOut);
            if (location) params.append('location', location);
            if (money) params.append('money', money);
            if (guests) params.append('guests', guests);
            
            // Gửi AJAX request
            fetch('${pageContext.request.contextPath}/home?' + params.toString(), {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.text())
            .then(html => {
                nearbyProperties.innerHTML = html;
            })
            .catch(error => {
                console.error('Search error:', error);
                nearbyProperties.innerHTML = '<div style="text-align: center; padding: 40px; color: #dc2626;"><i class="fas fa-exclamation-triangle" style="font-size: 2rem; margin-bottom: 10px;"></i><br>Có lỗi xảy ra khi tìm kiếm</div>';
            });
        }
    }
    
    // Thêm event listeners cho các input
    [checkInInput, checkOutInput, locationSelect, moneySelect, guestsInput].forEach(input => {
        if (input) {
            input.addEventListener('change', function() {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(performSearch, 500); // Delay 500ms
            });
        }
    });
    
    // Cập nhật min date cho check-out khi check-in thay đổi
    if (checkInInput && checkOutInput) {
        checkInInput.addEventListener('change', function() {
            if (this.value) {
                const nextDay = new Date(this.value);
                nextDay.setDate(nextDay.getDate() + 1);
                checkOutInput.min = nextDay.toISOString().split('T')[0];
            }
        });
    }
});
</script>

<jsp:include page="view/common/footer.jsp"/>
    </body>

</html>


