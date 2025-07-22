<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_footer.css">
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <footer class="footer">
        <div class="news-letter">
            <div class="news-letter-content">
                <h2>NEWSLETTER</h2>
                <p>Stay Up to Date</p>
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
        <div class="footer-inner">
            <div class="footer-content">
                <div class="footer-logo">
                    <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" />
                    <p>Chỗ nghỉ như ở nhà cho chuyến đi tiếp theo.</p>
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
                            <a href="#">About Us</a>
                            <a href="#">Legal Information</a>
                            <a href="#">Contact Us</a>
                            <a href="#">Blogs</a>
                        </div>
                    </div>
                    <div>
                        <h4>HELP CENTER</h4>
                        <div class="link-column">
                            <a href="#">Find a Property</a>
                            <a href="#">How To Host?</a>
                            <a href="#">Why Us?</a>
                            <a href="#">FAQs</a>
                            <a href="#">Rental Guides</a>
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
                            <a href="#" target="_blank">
                                <i class="fa-brands fa-square-facebook"></i>
                            </a>
                            <a href="#" target="_blank">
                                <i class="fa-brands fa-twitter"></i>
                            </a>
                            <a href="#" target="_blank">
                                <i class="fa-brands fa-instagram"></i>
                            </a>
                            <a href="#" target="_blank">
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
