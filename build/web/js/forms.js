window.addEventListener("DOMContentLoaded", function () {
    // FLATPICKR cho định dạng dd/mm/yyyy
    flatpickr("#check-in", {
        dateFormat: "d/m/Y"
    });
    flatpickr("#check-out", {
        dateFormat: "d/m/Y"
    });

    // VALIDATION FORM SEARCH
    const form = document.querySelector('form[action="results"]');
    const locationInput = document.getElementById("location");
    const checkInInput = document.getElementById("check-in");
    const checkOutInput = document.getElementById("check-out");
    const guestsInput = document.getElementById("guests");

    if (form) {
        form.addEventListener("submit", function (e) {
            const location = locationInput.value.trim();
            const checkInValue = checkInInput.value;
            const checkOutValue = checkOutInput.value;
            const guests = guestsInput.value;

            if (!location || !checkInValue || !checkOutValue || !guests) {
                e.preventDefault();
                alert("Vui lòng điền đầy đủ thông tin trước khi tìm kiếm.");
                return;
            }
            
            const checkInDate = parseDate(checkInValue);
            const checkOutDate = parseDate(checkOutValue);

            if (checkOutDate < checkInDate) {
                e.preventDefault();
                alert("Ngày trả phòng không được trước ngày nhận phòng.");
            }
        });
    }

    // Parse chuỗi dd/mm/yyyy thành Date object
    function parseDate(str) {
        const [d, m, y] = str.split("/").map(Number);
        return new Date(y, m - 1, d);
    }

    // TOGGLE FORM LOGIN / SIGNUP
    const menuButton = document.getElementById("menuButton");
    const menuDropdown = document.getElementById("menuDropdown");
    const signupBtn = document.getElementById("signupBtn");
    const loginBtn = document.getElementById("loginBtn");
    const helpCenterBtn = document.getElementById("helpCenterBtn");
    const signupForm = document.getElementById("signupForm");
    const loginForm = document.getElementById("loginForm");

    menuButton?.addEventListener("click", (e) => {
        e.stopPropagation();
        menuDropdown?.classList.toggle("active");
    });

    document.addEventListener("click", (e) => {
        if (!menuButton?.contains(e.target) && !menuDropdown?.contains(e.target)) {
            menuDropdown?.classList.remove("active");
        }
    });

    signupBtn?.addEventListener("click", () => {
        signupForm?.classList.remove("hidden");
        loginForm?.classList.add("hidden");
        menuDropdown?.classList.remove("active");
    });

    loginBtn?.addEventListener("click", () => {
        loginForm?.classList.remove("hidden");
        signupForm?.classList.add("hidden");
        menuDropdown?.classList.remove("active");
    });

    helpCenterBtn?.addEventListener("click", () => {
        alert("Help Center clicked");
    });

    window.closeForms = function () {
        signupForm?.classList.add("hidden");
        loginForm?.classList.add("hidden");
    };

    //becomHost 
    function becomeHost() {
        // Gửi yêu cầu tới backend để cập nhật người dùng thành host
        fetch('/becomeHost', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                userId: getUserId()  // Lấy userId của người dùng đã đăng nhập
            })
        })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert("You are now a Host! Please add your property.");
                        // Chuyển hướng đến trang để thêm property
                        window.location.href = '/addProperty';
                    } else {
                        alert("There was an error while becoming a host.");
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                });
    }
// TỰ ĐỘNG LẤY VỊ TRÍ TỪ IP VÀ HIỂN THỊ PHÒNG GẦN ĐÂY
    fetch("http://ip-api.com/json")
            .then(res => res.json())
            .then(data => {
                const city = data.city;
                console.log("User city from IP:", city);

                // Gửi city đến servlet để lấy danh sách phòng gần đó
                fetch("/home?city=" + encodeURIComponent(city))
                        .then(res => res.text()) // hoặc .json nếu bạn xử lý dạng JSON
                        .then(html => {
                            const target = document.getElementById("nearby-properties");
                            if (target) {
                                target.innerHTML = html;
                            }
                        })
                        .catch(err => console.error("Không thể hiển thị phòng gần đây:", err));
            })
            .catch(err => {
                console.error("Không thể lấy vị trí từ IP:", err);
            });

});
