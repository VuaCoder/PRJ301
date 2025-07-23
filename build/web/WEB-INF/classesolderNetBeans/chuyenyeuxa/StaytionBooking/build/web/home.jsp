
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
    <body class="is-home">
        <jsp:include page="view/common/header.jsp"/>
        <div class="header">
            <div class="main-header">
                <div class="main-image">
                    <img src="https://images.pexels.com/photos/260922/pexels-photo-260922.jpeg" alt="bar">
                </div>
            </div>
            <div class="header-bottom">
                <div class="search-header">
                    <h1 style="color: white">FIND</h1>
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
        <div class="second" id="find-property-section">
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
                <div class="property-listing swiper property-swiper" style="position:relative; margin-left: 4%">
                    <div class="swiper-nav-blur left"></div>
                    <div class="swiper-nav-blur right"></div>
                    <div class="swiper-wrapper" >
                        <c:forEach var="room" items="${latestRooms}">
                            <div class="home-room-card swiper-slide" onclick="window.location.href = 'detail?id=${room.roomId}'" >
                                <c:set var="imgArr" value="${fn:split(room.images, ',')}" />
                                <c:set var="imgRaw" value="${imgArr[0]}" />
                                <img src="${imgRaw}" style="width:100%;height:180px;object-fit:cover;display:block;border-top-left-radius:16px;border-top-right-radius:16px;margin:0;padding:0;" alt="Room Image">
                                <div class="home-room-info p-4">
                                    <h4>${room.title}</h4>
                                    <p>${room.city}</p>
                                </div>
                            </div>
                        </c:forEach>
                        <div class="swiper-slide show-all-slide home-room-card" style="cursor:pointer;display:flex;flex-direction:column;align-items:center;justify-content:center;min-height:260px;background:#f7fafc;border:2px dashed #fff;" onclick="window.location.href = '${pageContext.request.contextPath}/results?showAll=true'">
                            <div style="flex:1;display:flex;align-items:center;justify-content:center;width:100%;">
                                <i class="fas fa-arrow-right" style="font-size:2.8rem;color: #fff;;"></i>
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

        <div class="sixth">
            <section class="browser-section">
                <div class="image-box"></div>
                <div class="content">
                    <h1>Browse For More Properties</h1>
                    <p>Explore properties by their categories/types...</p>
                    <button>Find A Property</button>
                </div>
            </section>

            <div class="blog-section" id="rental-guides-section">
                <h1>Mẹo Thuê Bất Động Sản &<br>Hướng Dẫn</h1>

                <div class="blog-list">
                    <div class="blog-card">
                        <img src="https://www.ca.kayak.com/rimg/dimg/dynamic/186/2023/08/295ffd3a54bd51fc33810ce59382d1da.webp" alt="">
                        <h3>HÃY CHỌN GIÁ ĐÚNG!</h3>
                        <p class="category">Khách sạn</p>
                    </div>

                    <div class="blog-card">
                        <img src="https://www.annovahotel.com/storage/event/r5-7106-copy.jpg" alt="">
                        <h3>KHÔNG NƠI NÀO TUYỆT HƠN</h3>
                        <p class="category">Lối sống</p>
                    </div>

                    <div class="blog-card">
                        <img src="https://images.adsttc.com/media/images/677d/c6c2/1e23/3d01/7d2a/f44d/newsletter/m-hotel-ho-khue-architects_26.jpg?1736296233" alt="">
                        <h3>ƯU ĐÃI CHO NGƯỜI MỚI</h3>
                        <p class="category">Tài sản</p>
                    </div>
                </div>

                <div class="view-all-btn">
                    <a href="https://blog.booking.com/"><button>Tìm hiểu thêm</button></a>
                </div>
            </div>
        </div>

        <section class="download-mobile_app-section" id="download-mobile-app-section">
            <div class="image-box"></div>
            <div class="content">
                <h1>Tải App Chúng Tôi Tại</h1>
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

        
        <jsp:include page="/chatBotElement.jsp"></jsp:include>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // Custom dropdown cho location
                    function setupCustomDropdown(dropdownId, selectId, selectedId, listId) {
                        var dropdown = document.getElementById(dropdownId);
                        var select = document.getElementById(selectId);
                        var selected = document.getElementById(selectedId);
                        var list = document.getElementById(listId);
                        var options = list.querySelectorAll('.custom-dropdown-option');
                        dropdown.addEventListener('click', function (e) {
                            list.classList.toggle('show');
                        });
                        options.forEach(function (opt) {
                            opt.addEventListener('click', function (e) {
                                var value = opt.getAttribute('data-value');
                                var text = opt.textContent;
                                selected.textContent = text;
                                select.value = value;
                                list.classList.remove('show');
                                select.dispatchEvent(new Event('change', {bubbles: true}));
                            });
                        });
                        // Đóng dropdown khi click ngoài
                        document.addEventListener('click', function (e) {
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
                        if (city || guests || money) {
                            var params = [];
                            if (city)
                                params.push('location=' + encodeURIComponent(city));
                            if (money)
                                params.push('money=' + encodeURIComponent(money));
                            if (checkIn)
                                params.push('check_in=' + encodeURIComponent(checkIn));
                            if (checkOut)
                                params.push('check_out=' + encodeURIComponent(checkOut));
                            if (guests)
                                params.push('guests=' + encodeURIComponent(guests));
                            var url = 'home?' + params.join('&');
                            fetch(url, {headers: {'X-Requested-With': 'XMLHttpRequest'}})
                                    .then(res => res.text())
                                    .then(html => {
                                        nearbyProperties.innerHTML = html;
                                    })
                                    .catch(err => {
                                        nearbyProperties.innerHTML = '<div>Không thể tải danh sách phòng.</div>';
                                    });
                        }
                    }

                    if (locationSelect)
                        locationSelect.addEventListener('change', fetchRoomsRealtime);
                    if (moneySelect)
                        moneySelect.addEventListener('change', fetchRoomsRealtime);
                    if (checkInInput)
                        checkInInput.addEventListener('change', fetchRoomsRealtime);
                    if (checkOutInput)
                        checkOutInput.addEventListener('change', fetchRoomsRealtime);
                    if (guestsInput)
                        guestsInput.addEventListener('input', fetchRoomsRealtime);
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
                                hiddenSelect.dispatchEvent(new Event('change', {bubbles: true}));
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
            document.addEventListener('DOMContentLoaded', function () {
                const swiper = new Swiper('.property-swiper', {
                    slidesPerView: 5,
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
                        1200: {slidesPerView: 5},
                        900: {slidesPerView: 4},
                        600: {slidesPerView: 2},
                        0: {slidesPerView: 1}
                    },
                    on: {
                        slideChange: function () {
                            const prevBtn = document.querySelector('.property-swiper .swiper-button-prev');
                            const nextBtn = document.querySelector('.property-swiper .swiper-button-next');
                            const slides = document.querySelectorAll('.property-swiper .swiper-slide');
                            const showAllIndex = Array.from(slides).findIndex(slide => slide.classList.contains('show-all-slide'));
                            // Lấy số slide đang hiển thị (responsive)
                            let slidesPerView = this.params.slidesPerView;
                            if (typeof slidesPerView === 'object') {
                                // Responsive: lấy đúng số lượng theo màn hình
                                const width = window.innerWidth;
                                if (width >= 1200)
                                    slidesPerView = 5;
                                else if (width >= 900)
                                    slidesPerView = 4;
                                else if (width >= 600)
                                    slidesPerView = 2;
                                else
                                    slidesPerView = 1;
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
                        afterInit: function () {
                            this.emit('slideChange');
                        }
                    }
                });
            });
        </script>

        <script>
        // Xử lý hamburger menu cho trang home
            document.addEventListener('DOMContentLoaded', function () {
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
                onChange: function (selectedDates, dateStr, instance) {
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
            document.addEventListener('DOMContentLoaded', function () {
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
                        if (checkIn)
                            params.append('check_in', checkIn);
                        if (checkOut)
                            params.append('check_out', checkOut);
                        if (location)
                            params.append('location', location);
                        if (money)
                            params.append('money', money);
                        if (guests)
                            params.append('guests', guests);

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
                        input.addEventListener('change', function () {
                            clearTimeout(searchTimeout);
                            searchTimeout = setTimeout(performSearch, 500); // Delay 500ms
                        });
                    }
                });

                // Cập nhật min date cho check-out khi check-in thay đổi
                if (checkInInput && checkOutInput) {
                    checkInInput.addEventListener('change', function () {
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


