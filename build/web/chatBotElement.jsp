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
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            cursor: pointer;
            z-index: 999;
            box-shadow: 0 4px 12px rgba(0,123,255,0.4);
            transition: all 0.3s ease;
            border: none;
        }

        #chat-icon:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 20px rgba(0,123,255,0.6);
        }

        /* Chatbox Container */
        #chatbox {
            display: none;
            position: fixed;
            bottom: 90px;
            right: 20px;
            width: 350px;
            height: 450px;
            background: white;
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            z-index: 1000;
            overflow: hidden;
            flex-direction: column;
        }

        /* Chat Header */
        #chat-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 15px 20px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-shrink: 0;
        }

        #chat-header .header-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        #chat-header .close-btn,
        #chat-header .clear-btn {
            cursor: pointer;
            font-size: 16px;
            opacity: 0.8;
            transition: all 0.3s;
            background: none;
            border: none;
            color: white;
            padding: 5px;
            border-radius: 50%;
        }

        #chat-header .close-btn:hover,
        #chat-header .clear-btn:hover {
            opacity: 1;
            background: rgba(255,255,255,0.1);
            transform: scale(1.1);
        }

        /* Chat Body */
        #chat-body {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #f8f9fa;
            overflow: hidden;
        }

        #messages {
            flex: 1;
            padding: 15px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        /* Messages */
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
            margin-left: auto;
        }

        .bot-message {
            background: white;
            color: #333;
            align-self: flex-start;
            border: 1px solid #e0e0e0;
            border-bottom-left-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-right: auto;
        }

        /* Typing Indicator */
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
            border: 1px solid #e0e0e0;
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

        /* Quick Replies - FIXED CSS */
        .quick-replies {
            padding: 10px 15px;
            background: white;
            border-top: 1px solid #f0f0f0;
            flex-shrink: 0;
        }

        .quick-replies-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: flex-start;
        }

        .quick-reply-btn {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 18px;
            padding: 8px 12px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #495057;
            white-space: nowrap;
            flex: 0 0 auto;
            min-width: fit-content;
        }

        .quick-reply-btn:hover {
            background: #e3f2fd;
            border-color: #007bff;
            color: #007bff;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,123,255,0.2);
        }

        .quick-reply-btn:active {
            transform: translateY(0);
            box-shadow: 0 1px 2px rgba(0,123,255,0.2);
        }

        /* Chat Input */
        #chat-input {
            display: flex;
            border-top: 1px solid #e0e0e0;
            background: white;
            flex-shrink: 0;
        }

        #chat-input input {
            flex: 1;
            padding: 12px 15px;
            border: none;
            outline: none;
            font-size: 14px;
            background: transparent;
        }

        #chat-input input::placeholder {
            color: #aaa;
        }

        #chat-input button {
            padding: 12px 18px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
            border-radius: 0;
        }

        #chat-input button:hover:not(:disabled) {
            background: linear-gradient(135deg, #0056b3, #004085);
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
            border-radius: 12px;
            background: #fafafa;
            transition: all 0.3s ease;
        }

        .room-suggestion:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transform: translateY(-1px);
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
            // Gọi với showMore = true
            sendMessageWithShowMore(message, true);
        } else {
            document.getElementById("userInput").value = message;
            sendMessage();
        }
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
                showMore: showMore
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
        const messages = document.getElementById("messages");
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${type}-message`;
        messageDiv.innerHTML = text.replace(/\n/g, '<br>');
        messages.appendChild(messageDiv);

        conversationHistory.push({ 
            type, 
            message: text, 
            timestamp: new Date().toISOString() 
        });
        saveConversation();
        scrollToBottom();
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

    function clearHistory() {
        try {
            sessionStorage.removeItem('chatHistory');
            conversationHistory = [];
            
            // Reset messages to welcome only
            const messages = document.getElementById("messages");
            messages.innerHTML = `
                <div class="message bot-message">
                    👋 Xin chào! Tôi là An - lễ tân khách sạn.<br>
                    Tôi có thể giúp bạn tìm phòng phù hợp. Bạn cần loại phòng nào?
                </div>
            `;
            
            resetQuickReplies();
            scrollToBottom();
        } catch (e) {
            console.warn('Could not clear conversation history');
        }
    }

    function showMoreOptions() {
        const quickReplies = document.getElementById("quickReplies");
        quickReplies.innerHTML = `
            <button class="quick-reply-btn" onclick="sendQuickReply('Có, xem thêm phòng')">✅ Có, xem thêm</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Không, cảm ơn')">❌ Không, cảm ơn</button>
            <button class="quick-reply-btn" onclick="resetQuickReplies()">🔄 Menu chính</button>
        `;
    }

    function resetQuickReplies() {
        const quickReplies = document.getElementById("quickReplies");
        quickReplies.innerHTML = `
            <button class="quick-reply-btn" onclick="sendQuickReply('Phòng dưới 500k')">💰 Dưới 500k</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Phòng suit 2 người')">🏨 Suite 2 người</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Phòng đơn giá rẻ')">🛏️ Phòng đơn</button>
            <button class="quick-reply-btn" onclick="sendQuickReply('Xem thêm phòng')">👀 Xem thêm</button>
        `;
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
        
        // Add pulse effect after 2 seconds
        setTimeout(() => {
            document.getElementById("chat-icon").classList.add("pulse");
        }, 2000);
    });
</script>
</body>
</html>