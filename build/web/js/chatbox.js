let chatboxOpen = false;
let conversationHistory = [];

function toggleChatbox() {
    const box = document.getElementById("chatbox");
    const icon = document.getElementById("chat-icon");

    if (chatboxOpen) {
        box.style.display = "none";
        chatboxOpen = false;
    } else {
        box.style.display = "flex";
        chatboxOpen = true;
        setTimeout(() => document.getElementById("userInput").focus(), 100);
        loadConversation();
    }
}

function handleKeyPress(event) {
    if (event.key === 'Enter') {
        event.preventDefault();
        sendMessage();
    }
}

function sendQuickReply(msg) {
    document.getElementById("userInput").value = msg;
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

    try {
        const response = await fetch('chat', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ message })
        });

        typing.style.display = 'none';

        if (response.ok) {
            const data = await response.json();
            addMessage(data.message || '❌ Lỗi phản hồi từ bot.', 'bot');

            if (data.message && data.message.includes("xem thêm"))
                showMoreOptions();
            else
                resetQuickReplies();
        } else {
            throw new Error("Lỗi server");
        }
    } catch (err) {
        console.error(err);
        typing.style.display = 'none';
        addMessage("❌ Không thể kết nối đến máy chủ.", 'bot');
    }

    sendBtn.disabled = false;
}

function addMessage(text, type) {
    const container = document.getElementById("messages");
    const div = document.createElement('div');
    div.className = `message ${type}-message`;
    div.innerHTML = text.replace(/\n/g, "<br>");
    container.appendChild(div);
    conversationHistory.push({ type, message: text });
    saveConversation();
    scrollToBottom();
}

function saveConversation() {
    localStorage.setItem("chatHistory", JSON.stringify(conversationHistory));
}
function loadConversation() {
    const history = localStorage.getItem("chatHistory");
    if (history) {
        JSON.parse(history).forEach(m => addMessage(m.message, m.type));
        resetQuickReplies();
    }
}
function clearHistory() {
    localStorage.removeItem("chatHistory");
    conversationHistory = [];
    document.getElementById("messages").innerHTML = "";
    addMessage("👋 Xin chào! Tôi là An - lễ tân khách sạn.<br>Bạn cần loại phòng nào?", 'bot');
    resetQuickReplies();
}
function showMoreOptions() {
    const quick = document.getElementById("quickReplies");
    quick.innerHTML = `
        <button class="quick-reply-btn" onclick="sendQuickReply('Có, xem thêm phòng')">✅ Có</button>
        <button class="quick-reply-btn" onclick="sendQuickReply('Không, cảm ơn')">❌ Không</button>
        <button class="quick-reply-btn" onclick="resetQuickReplies()">🔄 Menu</button>
    `;
    quick.style.display = "flex";
}
function resetQuickReplies() {
    const quick = document.getElementById("quickReplies");
    quick.innerHTML = `
        <button class="quick-reply-btn" onclick="sendQuickReply('Phòng dưới 500k')">Phòng dưới 500k</button>
        <button class="quick-reply-btn" onclick="sendQuickReply('Phòng suite 2 người')">Suite 2 người</button>
        <button class="quick-reply-btn" onclick="sendQuickReply('Phòng đơn giá rẻ')">Đơn giá rẻ</button>
        <button class="quick-reply-btn" onclick="sendQuickReply('Xem thêm phòng')">Xem thêm</button>
    `;
    quick.style.display = "flex";
}
function hideQuickReplies() {
    document.getElementById("quickReplies").style.display = "none";
}
function scrollToBottom() {
    const body = document.getElementById("chat-body");
    setTimeout(() => body.scrollTop = body.scrollHeight, 100);
}
