local bot_token = os.getenv("8293866950:AAGtZX7JLgxN7XR-Oa84FMxc_KayEYG6x8s")
if not bot_token then error("Token is missing") end

-- Функция отправки сообщений
local function send_message(chat_id, text)
    local response = http.request("POST", string.format(
        "https://api.telegram.org/bot%s/sendMessage",
        bot_token
    ), {
        ["Content-Type"] = "application/json",
        body = json.encode({
            chat_id = chat_id,
            text = text
        })
    })
    
    if response.status ~= 200 then
        print("Error sending message:", response.body)
    else
        print("Message sent successfully.")
    end
end

-- Обработчик обновления
local function handle_update(update)
    if update.message and update.message.text == "/start" then
        local channel_link = "@durov" -- заменить на нужный канал
        local welcome_text = [[
Привет!
Чтобы получать больше интересного контента, пожалуйста, подпишись на мой канал %s 👇

Подписался? Теперь продолжаем общение! 😊
]]
        
        send_message(update.message.chat.id, string.format(welcome_text, channel_link))
    end
end

-- Основной цикл обработки обновлений
while true do
    local updates = http.request("GET", string.format(
        "https://api.telegram.org/bot%s/getUpdates",
        bot_token
    ))
    
    for _, update in ipairs(json.decode(updates.body)) do
        handle_update(update.result)
    end
    
    sleep(1) -- задержка перед следующим циклом
end
