<%-- 
    Document   : home
    Created on : Jun 15, 2025, 1:31:54 PM
    Author     : quangminhnguyen
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="model.UserAccount"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
        <!-- FontAwesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    </head>
    <body>
        <div class="header">
            <div class="main-header">
                <div class="main-image">
                    <img src="img/forest.jpg" alt="forest">
                </div>
                <div class="main-header-logo">
                    <a href="#"><img src="img/logo.png"></a>
                </div>
                <div class="main-header-option">
                    <ul>
                        <li><a href="#">Find a Property</a></li>
                        <li><a href="#">Rental Guides</a></li>
                        <li><a href="#">Download Mobile App</a></li>
                            <% if (user != null && isHost) {%>
                        <li style="background-color: #484848; color: white; padding: 13px 40px; border-radius: 20px; display: inline-block;">Hello, Host <%= user.getFullName()%></li>
                            <% } else { %>
                        <li><a href="${pageContext.request.contextPath}/view/host/becomeHost.jsp" id="become-a-host">Become a host</a></li>
                            <% } %>
                    </ul>
                </div>
                <div id="account" class="account-container">
                    <label for="toggle-account-menu" class="hamburger-label">
                        <img src="img/hamburger-lines.png" alt="hamburger" class="hamburger" id="menuButton">
                    </label>
                    <a href="#"><img src="img/user.png" alt="avatar" class="avatar"></a>
                    <div id="menuDropdown" class="account-interface">
                        <ul class="account-menu">
                            <% if (user != null) {%>
                            <li class="font-semibold text-gray-800"> Hello, <%= user.getFullName()%></li>
                            <li><a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 hover:bg-gray-100">Logout</a></li>
                                <% } else { %>
                            <li><a href="${pageContext.request.contextPath}/view/auth/register.jsp" class="w-full block text-left">Sign Up</a></li>
                            <li><a href="${pageContext.request.contextPath}/view/auth/login.jsp" class="w-full block text-left">Login</a></li>
                                <% }%>
                        </ul>
                    </div>
                </div>


                <!-- Form containers -->
                <div class="absolute top-20 left-1/2 -translate-x-1/2 z-50 w-[360px]" id="formsContainer">
                    <div id="signupFormContainer"></div>
                    <div id="loginFormContainer"></div>
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
                        <div class="option-field">
                            <label for="location">Location</label>
                            <select id="location" name="location" required>
                                <option value="" disabled hidden>Which city do you prefer?</option>
                                <option value="Ho Chi Minh">Ho Chi Minh</option>
                                <option value="Da Nang">Da Nang</option>
                                <option value="Ha Noi">Ha Noi</option>
                            </select>
                        </div>
                        <div class="option-field">
                            <label for="check-in">Check In</label>
                            <input type="date" id="check-in" name="check_in" placeholder="Add Dates">
                        </div>
                        <div class="option-field">
                            <label for="check-out">Check Out</label>
                            <input type="date" id="check-out" name="check_out" placeholder="Add Dates">
                        </div>
                        <div class="option-field">
                            <label for="guests">Guest</label>
                            <input type="number" id="guests" name="guests" min="1" max="50" placeholder="Add Guests">
                        </div>
                        <button type="submit" class="search-button">
                            <img src="img/search-icon.png" alt="search-icon">
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <div class="second">
            <div class="lastest-selection">
                <div class="lastest-selection-header">
                    <h1>Lastest on the Property Listing</h1>
                </div>
                <div class="property-listing">
                    <c:forEach var="room" items="${latestRooms}">
                        <div class="card" onclick="window.location.href = 'detail?id=${room.roomId}'">                       
                            <div class="card-footer">
                                <c:choose>
                                    <c:when test="${not empty room.images}">
                                        <c:set var="imgArr" value="${fn:split(room.images, ',')}" />
                                        <c:set var="imgRaw" value="${imgArr[0]}" />
                                        <c:set var="imgUrl" value="${fn:replace(fn:replace(fn:replace(imgRaw, '[', ''), ']', ''), '&quot;', '')}" />
                                        <c:choose>
                                            <c:when test="${fn:startsWith(imgUrl, 'http')}">
                                                <img class="image-placeholder" src="${imgUrl}" alt="Room Image"/>
                                            </c:when>
                                            <c:otherwise>
                                                <img class="image-placeholder" src="img/${imgUrl}" alt="Room Image"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="image-placeholder" style="background:#eee;height:120px;"></div>
                                    </c:otherwise>
                                </c:choose>
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
                    <h1>Nearby Listed Properties</h1>
                    <div class="show-on-map"><img src="img/location.png" alt="location"></i>
                        <a href="#">
                            <p>Show on map</p>
                        </a>
                    </div>
                </div>
                <div class="property-listing" id="nearby-properties">
                    <p>Đang tìm phòng gần bạn...</p>
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
    </body>

</html>


