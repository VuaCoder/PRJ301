<!DOCTYPE html>
<html>
<head>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <meta charset="UTF-8">
    <style>
        /* Chat Icon */
        #chat-icon {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 28px;
            cursor: pointer;
            z-index: 999;
            box-shadow: 0 6px 24px rgba(102,126,234,0.32);
            transition: all 0.3s cubic-bezier(.4,2,.6,1);
            border: none;
            animation: pulse 2s infinite;
        }
        #chat-icon:hover {
            animation: shake 0.5s;
            animation-iteration-count: 1;
            box-shadow: 0 12px 36px rgba(102,126,234,0.45);
            transform: scale(1.13) rotate(-8deg);
        }
        @keyframes shake {
            0% { transform: scale(1) rotate(0deg); }
            10% { transform: scale(1.08) rotate(-10deg); }
            20% { transform: scale(1.12) rotate(8deg); }
            30% { transform: scale(1.13) rotate(-8deg); }
            40% { transform: scale(1.12) rotate(8deg); }
            50% { transform: scale(1.13) rotate(-8deg); }
            60% { transform: scale(1.12) rotate(8deg); }
            70% { transform: scale(1.08) rotate(-10deg); }
            80% { transform: scale(1.05) rotate(4deg); }
            90% { transform: scale(1.02) rotate(-2deg); }
            100% { transform: scale(1) rotate(0deg); }
        }
        /* Chatbox Container */
        #chatbox {
            display: none;
            position: fixed;
            bottom: 90px;
            right: 20px;
            width: 390px;
            height: 540px;
            background: rgba(255,255,255,0.98);
            border: none;
            border-radius: 32px;
            box-shadow: 0 16px 48px 0 rgba(102,126,234,0.22), 0 2px 8px 0 rgba(0,0,0,0.08);
            z-index: 1000;
            overflow: hidden;
            flex-direction: column;
            backdrop-filter: blur(2px);
            display: flex;
        }
        /* Chat Header */
        #chat-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 20px 28px 16px 28px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-shrink: 0;
            font-size: 1.13rem;
            letter-spacing: 0.01em;
            box-shadow: 0 2px 12px rgba(102,126,234,0.10);
            border-top-left-radius: 32px;
            border-top-right-radius: 32px;
        }
        #chat-header .header-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        #chat-header .close-btn,
        #chat-header .clear-btn {
            cursor: pointer;
            font-size: 18px;
            opacity: 0.88;
            transition: all 0.3s;
            background: none;
            border: none;
            color: white;
            padding: 8px;
            border-radius: 50%;
        }
        #chat-header .close-btn:hover,
        #chat-header .clear-btn:hover {
            opacity: 1;
            background: rgba(255,255,255,0.22);
            transform: scale(1.18);
        }
        /* Chat Body */
        #chat-body {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: linear-gradient(135deg, #f8fafc 80%, #e0e7ff 100%);
            overflow: hidden;
        }
        #messages {
            flex: 1;
            padding: 22px 18px 14px 18px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 18px;
        }
        /* Messages */
        .message {
            max-width: 88%;
            padding: 14px 18px;
            border-radius: 22px;
            font-size: 16px;
            line-height: 1.7;
            word-wrap: break-word;
            animation: fadeInUp 0.3s ease;
            box-shadow: 0 2px 12px rgba(102,126,234,0.10);
            background: #fff;
            border: 1.5px solid #e0e7ff;
        }
        .user-message {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            align-self: flex-end;
            margin-left: auto;
            border-radius: 22px 22px 10px 28px;
            border: none;
            font-weight: 700;
            box-shadow: 0 4px 18px rgba(102,126,234,0.22);
            text-align: right;
            max-width: 88%;
        }
        .bot-message {
            background: #fff;
            color: #222;
            align-self: flex-start;
            margin-right: auto;
            border-radius: 22px 22px 28px 10px;
            border: 1.5px solid #e0e7ff;
            font-weight: 500;
            box-shadow: 0 2px 8px rgba(102,126,234,0.10);
            text-align: left;
            max-width: 70%;
        }
        /* Typing Indicator */
        .typing-indicator {
            display: none;
            padding: 12px 16px;
            font-style: italic;
            color: #666;
            font-size: 14px;
            background: #fff;
            border-radius: 16px;
            border-bottom-left-radius: 10px;
            align-self: flex-start;
            max-width: 85%;
            border: 1.5px solid #e0e7ff;
        }
        .typing-dots::after {
            content: '...';
            animation: dots 1.5s infinite;
        }
        @keyframes dots {
            0%, 20% { content: '.'; }
            40% { content: '..'; }
            60%, 100% { content: '...'; }
        }
        /* Quick Replies */
        .quick-replies {
            padding: 14px 22px 12px 22px;
            background: #f8fafc;
            border-top: 1.5px solid #e5e7eb;
            flex-shrink: 0;
        }
        .quick-replies-container {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            justify-content: flex-start;
        }
        .quick-reply-btn {
            background: linear-gradient(135deg, #e0e7ff, #f3e8ff);
            border: 1.5px solid #c7d2fe;
            border-radius: 22px;
            padding: 10px 20px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
            color: #4f46e5;
            white-space: nowrap;
            font-weight: 600;
            box-shadow: 0 1px 6px rgba(102,126,234,0.10);
        }
        .quick-reply-btn:hover {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-color: #667eea;
            color: #fff;
            transform: translateY(-2px) scale(1.06);
            box-shadow: 0 4px 16px rgba(102,126,234,0.22);
        }
        .quick-reply-btn:active {
            transform: translateY(0);
            box-shadow: 0 1px 2px rgba(102,126,234,0.12);
        }
        /* Chat Input */
        #chat-input {
            display: flex;
            border-top: 1.5px solid #e0e0e0;
            background: #fff;
            flex-shrink: 0;
            border-bottom-left-radius: 32px;
            border-bottom-right-radius: 32px;
        }
        #chat-input input {
            flex: 1;
            padding: 16px 20px;
            border: none;
            outline: none;
            font-size: 16px;
            background: transparent;
            border-radius: 22px;
        }
        #chat-input input::placeholder {
            color: #aaa;
        }
        #chat-input button {
            padding: 16px 24px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 700;
            border-radius: 50%;
            font-size: 1.15rem;
            margin: 8px 8px 8px 0;
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        #chat-input button:hover:not(:disabled) {
            background: linear-gradient(135deg, #764ba2, #667eea);
        }
        #chat-input button:disabled {
            background: #ccc;
            cursor: not-allowed;
            opacity: 0.6;
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
        /* Scrollbar */
        #messages::-webkit-scrollbar {
            width: 4px;
        }
        #messages::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 2px;
        }
        #messages::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 2px;
        }
        #messages::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }
        /* Room suggestion styling */
        .room-suggestion {
            margin: 12px 0;
            padding: 14px;
            border: 1px solid #e0e0e0;
            border-radius: 16px;
            background: #fafafa;
            transition: all 0.3s ease;
        }
        .room-suggestion:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transform: translateY(-1px);
        }
        @media (max-width: 600px) {
            #chatbox {
                width: 98vw;
                height: 80vh;
                right: 1vw;
                bottom: 1vh;
                border-radius: 18px;
            }
            #chat-header, #chat-input {
                border-radius: 18px 18px 0 0;
            }
        }
    </style>
</head>
<body>
    <!-- Chat Icon -->
    <div id="chat-icon" onclick="toggleChatbox()">
        <span>💬</span>
    </div>

    <!-- Chatbox -->
    <div id="chatbox">
        <!-- Header -->
        <div id="chat-header">
            <div>
                <span>🏨</span> Lễ tân An - Tư vấn phòng
            </div>
            <div class="header-actions">
                <button class="clear-btn" onclick="clearHistory()" title="Xóa lịch sử">🗑️</button>
                <button class="close-btn" onclick="toggleChatbox()">✖</button>
            </div>
        </div>

        <!-- Chat Body -->
        <div id="chat-body">
            <!-- Messages -->
            <div id="messages">
                <div class="message bot-message">
                    👋 Xin chào! Tôi là An - lễ tân khách sạn.<br>
                    Tôi có thể giúp bạn tìm phòng phù hợp. Bạn cần loại phòng nào?
                </div>
            </div>

            <!-- Typing Indicator -->
            <div class="typing-indicator" id="typing">
                <span class="typing-dots">An đang trả lời</span>
            </div>
        </div>

        <!-- Quick Replies -->
        <div class="quick-replies" id="quickRepliesSection">
            <div class="quick-replies-container" id="quickReplies">
                <!-- Quick reply buttons will be inserted here -->
            </div>
        </div>

        <!-- Input -->
        <div id="chat-input">
            <input type="text" id="userInput" placeholder="Nhập tin nhắn của bạn..." onkeypress="handleKeyPress(event)" />
            <button onclick="sendMessage()" id="sendBtn">
                📤
            </button>
        </div>
    </div>

    <!-- Thay thế phần <script> trong chatBotElement.jsp -->
<script>
     const BASE_URL = '<%= request.getContextPath() %>';
    let chatboxOpen = false;
    let conversationHistory = [];
    let lastUserMessage = '';
    let currentLanguage = 'vi';

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
            loadConversation();
        }
    }

    function handleKeyPress(event) {
        if (event.key === 'Enter') {
            event.preventDefault();
            sendMessage();
        }
    }

    function sendQuickReply(message) {
        if (message === 'Có, xem thêm phòng') {
            // Gọi với showMore = true, dùng lại message gốc cuối cùng
            if (lastUserMessage) {
                sendMessageWithShowMore(lastUserMessage, true);
            } else {
                // fallback: gửi lại quick reply như cũ
                sendMessageWithShowMore(message, true);
            }
        } else {
            document.getElementById("userInput").value = message;
            sendMessage();
        }
    }

    async function sendMessage() {
        const input = document.getElementById("userInput");
        const message = input.value.trim();
        if (!message) return;

        lastUserMessage = message; // Lưu lại message gốc cuối cùng

        const sendBtn = document.getElementById("sendBtn");
        const typing = document.getElementById("typing");

        sendBtn.disabled = true;
        input.value = "";

        addMessage(message, 'user');
        typing.style.display = 'block';
        scrollToBottom();

        try {
            // ✅ GỌI THẬT ĐẾN DATABASE
            const response = await callRealAPI(message, false);
            
            typing.style.display = 'none';

            if (response.success) {
                addMessage(response.message, 'bot');

                // Show appropriate quick replies
                if (response.message.includes('xem thêm')) {
                    showMoreOptions();
                } else {
                    resetQuickReplies();
                }
            } else {
                addMessage(response.message || '❌ Có lỗi xảy ra, vui lòng thử lại.', 'bot');
            }

        } catch (error) {
            console.error('Lỗi:', error);
            typing.style.display = 'none';
            setTimeout(() => {
                addMessage('❌ Xin lỗi, tôi đang gặp sự cố kết nối. Bạn vui lòng thử lại sau.', 'bot');
                resetQuickReplies();
            }, 500);
        }

        sendBtn.disabled = false;
        input.focus();
    }

    // ✅ HÀM GỌI API THẬT ĐẾN DATABASE
    async function callRealAPI(message, showMore = false) {
        console.log('🚀 Calling API:', { message, showMore });
        
        const response = await fetch(BASE_URL + '/chat', {
 
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({
                message: message,
                showMore: showMore,
                language: currentLanguage
            })
        });

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }

        const result = await response.json();
        console.log('✅ API Response:', result);
        return result;
    }

    // ✅ HÀM GỬI VỚI SHOW MORE
    async function sendMessageWithShowMore(message, showMore = false) {
        const sendBtn = document.getElementById("sendBtn");
        const typing = document.getElementById("typing");

        sendBtn.disabled = true;
        addMessage(message, 'user');
        typing.style.display = 'block';
        scrollToBottom();

        try {
            const response = await callRealAPI(message, showMore);
            typing.style.display = 'none';

            if (response.success) {
                addMessage(response.message, 'bot');
                if (response.message.includes('xem thêm')) {
                    showMoreOptions();
                } else {
                    resetQuickReplies();
                }
            } else {
                addMessage(response.message || '❌ Có lỗi xảy ra, vui lòng thử lại.', 'bot');
            }

        } catch (error) {
            console.error('Lỗi:', error);
            typing.style.display = 'none';
            addMessage('❌ Xin lỗi, tôi đang gặp sự cố kết nối. Bạn vui lòng thử lại sau.', 'bot');
            resetQuickReplies();
        }

        sendBtn.disabled = false;
    }

    function addMessage(text, type) {
        const container = document.getElementById("messages");
        const div = document.createElement('div');
        div.className = `message ${type}-message`;
        // Loại bỏ dấu * khi là bot
        let cleanText = text;
        if (type === 'bot') {
            cleanText = cleanText.replace(/\*\*/g, '').replace(/\*/g, '');
        }
        div.innerHTML = cleanText.replace(/\n/g, "<br>");
        if (type === 'bot') {
            // Hiện typing indicator
            const typing = document.getElementById('typing');
            typing.style.display = 'block';
            setTimeout(() => {
                typing.style.display = 'none';
                container.appendChild(div);
                conversationHistory.push({ type, message: text });
                saveConversation();
                scrollToBottom();
            }, 1200); // delay 1.2s
        } else {
            container.appendChild(div);
            conversationHistory.push({ type, message: text });
            saveConversation();
            scrollToBottom();
        }
    }

    function saveConversation() {
        try {
            sessionStorage.setItem('chatHistory', JSON.stringify(conversationHistory));
        } catch (e) {
            console.warn('Could not save conversation history');
        }
    }

    function loadConversation() {
        try {
            const history = sessionStorage.getItem('chatHistory');
            if (history) {
                const parsed = JSON.parse(history);
                // Clear existing messages except welcome message
                const messages = document.getElementById("messages");
                const welcomeMessage = messages.children[0];
                messages.innerHTML = '';
                messages.appendChild(welcomeMessage);
                
                // Load saved messages
                parsed.forEach(item => {
                    if (item.type && item.message) {
                        const messageDiv = document.createElement('div');
                        messageDiv.className = `message ${item.type}-message`;
                        messageDiv.innerHTML = item.message.replace(/\n/g, '<br>');
                        messages.appendChild(messageDiv);
                    }
                });
                conversationHistory = parsed;
            }
        } catch (e) {
            console.warn('Could not load conversation history');
        }
        resetQuickReplies();
    }

    // Xoá hoàn toàn logic đa ngôn ngữ, chỉ giữ lại tiếng Việt
    function resetQuickReplies() {
        const quickReplies = document.getElementById("quickReplies");
        quickReplies.innerHTML = `
            <button class="quick-reply-btn" onclick="sendQuickReply('Phòng trên 500k')">💰 Trên 500k</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Phòng suit 2 người')">🏨 Suit 2 người</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Phòng đơn giá rẻ')">🛏️ Phòng đơn</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Xem thêm phòng')">👀 Xem thêm</button>
        `;
    }
    function showMoreOptions() {
        const quickReplies = document.getElementById("quickReplies");
        quickReplies.innerHTML = `
            <button class="quick-reply-btn" onclick="sendQuickReply('Có, xem thêm phòng')">✅ Có, xem thêm</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Không, cảm ơn')">❌ Không, cảm ơn</button>
            <button class="quick-reply-btn" onclick="resetQuickReplies()">🔄 Menu chính</button>
        `;
    }
    function clearHistory() {
        try {
            sessionStorage.removeItem('chatHistory');
            conversationHistory = [];
            // Reset messages to welcome only
            const messages = document.getElementById("messages");
            messages.innerHTML = `<div class="message bot-message">👋 Xin chào! Tôi là An - lễ tân khách sạn.<br>Tôi có thể giúp bạn tìm phòng phù hợp. Bạn cần loại phòng nào?</div>`;
            resetQuickReplies();
            scrollToBottom();
        } catch (e) {
            console.warn('Could not clear conversation history');
        }
    }

    function scrollToBottom() {
        const messages = document.getElementById("messages");
        setTimeout(() => {
            messages.scrollTop = messages.scrollHeight;
        }, 100);
    }

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', () => {
        resetQuickReplies();
        // KHÔNG tự động mở chatbox khi load trang nữa
        // Nếu có đoạn nào như: document.getElementById("chatbox").style.display = "flex"; thì hãy xóa hoặc comment lại
        // Chỉ add hiệu ứng pulse cho icon
        setTimeout(() => {
            document.getElementById("chat-icon").classList.add("pulse");
        }, 2000);
    });
</script>
</body>
</html>