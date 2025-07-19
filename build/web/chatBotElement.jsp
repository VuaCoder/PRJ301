<%-- 
    Document   : chatBoxElement
    Created on : Jun 23, 2025, 9:23:05 AM
    Author     : ccc12
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
        <head>

    <style>
         #chat-icon {
            position: fixed;
            bottom: 20px; right: 20px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-radius: 50%;
            width: 60px; height: 60px;
            text-align: center;
            line-height: 60px;
            font-size: 24px;
            cursor: pointer;
            z-index: 999;
            box-shadow: 0 4px 12px rgba(0,123,255,0.4);
            transition: all 0.3s ease;
        }

        #chat-icon:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 20px rgba(0,123,255,0.6);
        }

        #chatbox {
            display: none;
            position: fixed;
            bottom: 90px; right: 20px;
            width: 350px;
            height: 450px;
            background: white;
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            z-index: 1000;
            flex-direction: column;
            overflow: hidden;
        }

        #chat-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 15px 20px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        #chat-header .close-btn {
            cursor: pointer;
            font-size: 18px;
            opacity: 0.8;
            transition: opacity 0.3s;
        }

        #chat-header .close-btn:hover {
            opacity: 1;
            transform: scale(1.1);
        }

        #chat-body {
            flex: 1;
            padding: 15px;
            overflow-y: auto;
            background: #f8f9fa;
            display: flex;
            flex-direction: column;
        }

        #messages {
            display: flex;
            flex-direction: column;
            gap: 10px;
            flex: 1;
        }

        .message {
            max-width: 85%;
            padding: 10px 14px;
            border-radius: 15px;
            font-size: 14px;
            line-height: 1.5;
            word-wrap: break-word;
            animation: fadeInUp 0.3s ease;
        }

        .user-message {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            align-self: flex-end;
            border-bottom-right-radius: 4px;
        }

        .bot-message {
            background: white;
            color: #333;
            align-self: flex-start;
            border: 1px solid #e0e0e0;
            border-bottom-left-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .typing-indicator {
            display: none;
            padding: 10px 14px;
            font-style: italic;
            color: #666;
            font-size: 13px;
            background: white;
            border-radius: 15px;
            border-bottom-left-radius: 4px;
            align-self: flex-start;
            max-width: 85%;
        }

        .typing-dots {
            display: inline-block;
        }

        .typing-dots::after {
            content: '...';
            animation: dots 1.5s infinite;
        }

        @keyframes dots {
            0%, 20% { content: '.'; }
            40% { content: '..'; }
            60%; 100% { content: '...'; }
        }

        #chat-input {
            display: flex;
            border-top: 1px solid #e0e0e0;
            background: white;
        }

        #chat-input input {
            flex: 1;
            padding: 12px 15px;
            border: none;
            outline: none;
            font-size: 14px;
        }

        #chat-input button {
            padding: 12px 18px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
        }

        #chat-input button:hover {
            background: linear-gradient(135deg, #0056b3, #004085);
        }

        #chat-input button:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        /* Quick Reply Buttons */
        .quick-replies {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 10px;
            padding: 0 5px;
        }

        .quick-reply-btn {
            background: #f0f2f5;
            border: 1px solid #ddd;
            border-radius: 20px;
            padding: 6px 12px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s;
            color: #333;
        }

        .quick-reply-btn:hover {
            background: #e3f2fd;
            border-color: #007bff;
            color: #007bff;
        }

        .top-menu {
            margin-bottom: 30px;
        }
        .main-header {
    display: flex;
    justify-content: space-around;
    align-items: center;
    height: 70px;
}

.main-header-image {
    display: flex;
}

.account-container {
    display: flex;
    align-items: center;
    position: relative;
    background: #f5f6f8;
    border-radius: 20px;
    padding: 8px 16px;
    width: fit-content;
}

.menu-icon {
    display: flex;
    flex-direction: column;
    justify-content: center;
    margin-right: 10px;
    cursor: pointer;
}

.menu-icon span {
    width: 20px;
    height: 3px;
    background: #888;
    margin: 2px 0;
    border-radius: 2px;
    transition: background 0.2s;
}

.hamburger {
    width: 40px;
    margin-right: 40%;
    height: 40px;
    object-fit: contain;
    cursor: pointer;
}

.avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
}

.account-interface {
    opacity: 0;
    transform: translateY(-10px);
    pointer-events: none;
    transition: opacity 0.3s, transform 0.3s;
    position: absolute;
    top: 60px;
    right: 0;
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    padding: 16px;
    z-index: 10;
}

.account-interface.active {
    opacity: 1;
    transform: translateY(0);
    pointer-events: auto;
}

.account-menu {
    list-style: none;
    margin: 0;
    padding: 0;
    min-width: 120px;
}

.account-menu li {
    padding: 8px 0;
    color: #444;
    font-size: 16px;
    cursor: pointer;
    transition: font-weight 0.3s ease;
}

.account-menu li:hover{
    font-weight: 700;
}

.account-menu li:not(:last-child) {
    margin-bottom: 4px;
}

.main-header-image a,
img {
    width: 150px;
}

.main-header-option {
    display: flex;
    justify-content: space-evenly;
    align-items: center;
}

.main-header-option ul,
.search-header ul {
    display: flex;
}

.main-header-option li {
    margin: 0 50px;
    list-style: none;
}

.main-header-option a {
    text-decoration: none;
    color: black;
    transition: font-weight 0.3s ease;
    font-weight: 400;
}

.main-header-option a:hover {
    font-weight: 700;
}

#become-a-host {
    background-color: #484848;
    color: white;
    padding: 13px 40px;
    border-radius: 20px;
}

#account {
    position: relative;
    background-color: white;
    padding: 10px;
    border-radius: 30px;
    height: 50px;
    width: 100px;
    display: flex;
    justify-content: flex-end;
    align-items: center;

}

#account img {
    position: absolute;
    top: 0;
    right: 2px;
    width: 50px;
    height: 50px;
}

.main-image {
    background-position: center;
    background-size: cover;
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 550px;
    z-index: -1;
    /* ẩn đằng sau chữ, giúp không che chữ đằng sau*/
    overflow: hidden;
    pointer-events: none;
    /* để không ảnh hưởng đến menu */
}

.main-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    opacity: 0.3;
}

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .pulse {
            animation: pulse 2s infinite;
        }
        </style>
        
    </head>
    <body>
        <div id="chat-icon" onclick="toggleChatbox()">
    <span>💬</span>
</div>
        <div id="chatbox">
    
    <div id="chat-header">
        <div>
            <i class="fas fa-user-tie me-2"></i>
            Lễ tân An - Tư vấn phòng
        </div>
        <button onclick="clearHistory()" title="Xóa lịch sử" style="background:none; border:none; color:white; font-size:16px; cursor:pointer; margin-right:10px;">🗑️</button>
        <span class="close-btn" onclick="toggleChatbox()">✖</span>
    </div>
    <div id="chat-body">
       
        <div id="messages">
            <div class="message bot-message">
                👋 Xin chào! Tôi là An - lễ tân khách sạn.<br>
                Tôi có thể giúp bạn tìm phòng phù hợp. Bạn cần loại phòng nào?
            </div>
        </div>
        <div id="quickReplies" class="quick-replies"></div>
        <div class="typing-indicator" id="typing">
            <span class="typing-dots">An đang trả lời</span>
        </div>
        
        
    </div>
    <div id="chat-input">
        <input type="text" id="userInput" placeholder="Nhập tin nhắn của bạn..." onkeypress="handleKeyPress(event)" />
        <button onclick="sendMessage()" id="sendBtn">
            <i class="fas fa-paper-plane"></i>
        </button>
    </div>
</div>

    </body>
   <script>
let chatboxOpen = false;
let conversationHistory = [];

function toggleChatbox() {
    const box = document.getElementById("chatbox");
    const icon = document.getElementById("chat-icon");

    if (chatboxOpen) {
        box.style.display = "none";
        chatboxOpen = false;
        icon.classList.remove("pulse");
    } else {
        box.style.display = "flex";
        chatboxOpen = true;
        setTimeout(() => document.getElementById("userInput").focus(), 100);
        icon.classList.remove("pulse");
        loadConversation(); // 🔁 Tải lại lịch sử nếu có
    }
}

function handleKeyPress(event) {
    if (event.key === 'Enter') {
        event.preventDefault();
        sendMessage();
    }
}

function sendQuickReply(message) {
    document.getElementById("userInput").value = message;
    sendMessage();
}

async function sendMessage() {
    const input = document.getElementById("userInput");
    const message = input.value.trim();
    if (!message) return;

    const sendBtn = document.getElementById("sendBtn");
    const typing = document.getElementById("typing");

    sendBtn.disabled = true;
    input.value = "";

    addMessage(message, 'user');
    typing.style.display = 'block';
    hideQuickReplies();
    scrollToBottom();

    try {
        const response = await fetch('chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                message: message,
                showMore: message.toLowerCase().includes('xem thêm') || message.toLowerCase().includes('thêm phòng')
            })
        });

        typing.style.display = 'none';

        if (response.ok) {
            const data = await response.json();
            if (data.success) {
                addMessage(data.message, 'bot');

                // Hiện quick reply nếu chatbot hỏi
                if (data.message.includes('xem thêm')) {
                    showMoreOptions();
                } else {
                    resetQuickReplies(); // Gợi ý cơ bản lại
                }

            } else {
                addMessage(data.message || '❌ Có lỗi xảy ra, vui lòng thử lại.', 'bot');
            }
        } else {
            throw new Error('Lỗi kết nối server');
        }

    } catch (error) {
        console.error('Lỗi:', error);
        typing.style.display = 'none';
        setTimeout(() => {
            addMessage('❌ Xin lỗi, tôi đang gặp sự cố kết nối. Bạn vui lòng thử lại sau.', 'bot');
        }, 500);
    }

    sendBtn.disabled = false;
    input.focus();
}

function addMessage(text, type) {
    const messages = document.getElementById("messages");
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${type}-message`;
    messageDiv.innerHTML = text.replace(/\n/g, '<br>');
    messages.appendChild(messageDiv);

    conversationHistory.push({ type, message: text, timestamp: new Date().toISOString() });
    saveConversation();
    scrollToBottom();
}

function saveConversation() {
    localStorage.setItem('chatHistory', JSON.stringify(conversationHistory));
}

function loadConversation() {
    const history = localStorage.getItem('chatHistory');
    if (history) {
        conversationHistory = JSON.parse(history);
        conversationHistory.forEach(item => addMessage(item.message, item.type));
        resetQuickReplies(); // Hiện lại gợi ý sau khi load
    }
}

function clearHistory() {
    localStorage.removeItem('chatHistory');
    conversationHistory = [];
    document.getElementById("messages").innerHTML = "";

    // 💬 Thêm tin nhắn chào lại
    addMessage("👋 Xin chào! Tôi là An - lễ tân khách sạn.<br>Tôi có thể giúp bạn tìm phòng phù hợp. Bạn cần loại phòng nào?", 'bot');

    // 🔄 Gợi ý mặc định
    resetQuickReplies();
}

function hideQuickReplies() {
    const quickReplies = document.getElementById("quickReplies");
    if (quickReplies) quickReplies.style.display = 'none';
}

function showMoreOptions() {
    const quickReplies = document.getElementById("quickReplies");
    if (quickReplies) {
        quickReplies.innerHTML = `
            <button class="quick-reply-btn" onclick="sendQuickReply('Có, xem thêm phòng')">✅ Có, xem thêm</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Không, cảm ơn')">❌ Không, cảm ơn</button>
            <button class="quick-reply-btn" onclick="resetQuickReplies()">🔄 Menu chính</button>
        `;
        quickReplies.style.display = 'flex';
    }
}

function resetQuickReplies() {
    const quickReplies = document.getElementById("quickReplies");
    if (quickReplies) {
        quickReplies.innerHTML = `
            <button class="quick-reply-btn" onclick="sendQuickReply('Phòng dưới 500k')">Phòng dưới 500k</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Phòng suit 2 người')">Phòng suit 2 người</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Phòng đơn giá rẻ')">Phòng đơn giá rẻ</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Xem thêm phòng')">Xem thêm phòng</button>
        `;
        quickReplies.style.display = 'flex';
    }
}

function scrollToBottom() {
    const chatBody = document.getElementById("chat-body");
    setTimeout(() => {
        chatBody.scrollTop = chatBody.scrollHeight;
    }, 100);
}

document.addEventListener('DOMContentLoaded', () => {
    const chatbox = document.getElementById("chatbox");
    chatbox.style.display = "none";
    chatboxOpen = false;
  resetQuickReplies();
    setTimeout(() => {
        document.getElementById("chat-icon").classList.add("pulse");
    }, 2000);
});
</script>


</html>
