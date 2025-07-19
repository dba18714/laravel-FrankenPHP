# Telegram Bot 回声机器人 🤖

这是一个简单的Telegram回声机器人，使用Laravel和FrankenPHP构建。机器人会重复用户发送的任何文本消息。

## 功能特性

- 📢 **回声功能**: 重复用户发送的文本消息
- 🔄 **实时响应**: 通过Webhook实时处理消息
- 📊 **日志记录**: 记录所有消息和错误便于调试
- 🛠 **管理接口**: 提供Bot状态查看和Webhook设置

## 快速开始

### 1. 创建Telegram Bot

1. 在Telegram中找到 @BotFather
2. 发送 `/newbot` 命令
3. 按照提示设置Bot名称和用户名
4. 保存Bot Token（格式类似：`123456789:ABCdefGHIjklMNOpqrsTUVwxyz`）

### 2. 配置环境变量

在您的 `.env` 文件中添加以下配置：

```env
# Telegram Bot 配置
TELEGRAM_BOT_TOKEN=您的Bot Token
TELEGRAM_WEBHOOK_URL=https://您的域名.com/telegram-bot/webhook
TELEGRAM_BOT_USERNAME=您的Bot用户名
```

**重要说明**:
- `TELEGRAM_BOT_TOKEN`: 从 @BotFather 获取的Token
- `TELEGRAM_WEBHOOK_URL`: 您的应用程序公开URL + `/telegram-bot/webhook`
- `TELEGRAM_BOT_USERNAME`: Bot的用户名（可选）

### 3. 设置Webhook

在浏览器中访问以下URL来设置Webhook：

```
https://您的域名.com/telegram-bot/set-webhook
```

如果设置成功，您会看到类似以下的响应：

```json
{
    "status": "success",
    "message": "Webhook设置成功！",
    "webhook_url": "https://您的域名.com/telegram-bot/webhook"
}
```

## API 端点

### Webhook处理
- **URL**: `POST /telegram-bot/webhook`
- **描述**: Telegram发送消息更新的端点
- **注意**: 此端点由Telegram自动调用，无需手动访问

### 管理端点
- **设置Webhook**: `GET /telegram-bot/set-webhook`
- **获取Bot信息**: `GET /telegram-bot/bot-info`
- **查看Bot状态**: `GET /bot-status`

### 示例响应

#### Bot状态查看
访问 `/bot-status` 会返回：

```json
{
    "message": "🤖 Telegram Bot 配置状态",
    "config": {
        "bot_token_set": true,
        "webhook_url_set": true,
        "bot_username": "your_bot_username"
    },
    "endpoints": {
        "webhook": "https://您的域名.com/telegram-bot/webhook",
        "set_webhook": "https://您的域名.com/telegram-bot/set-webhook",
        "bot_info": "https://您的域名.com/telegram-bot/bot-info"
    }
}
```

## 使用方法

1. **完成上述配置后**，在Telegram中搜索您的Bot
2. **启动对话**，发送 `/start` 或任何文本消息
3. **测试回声功能**，Bot会回复：
   ```
   🔄 您说：
   
   [您发送的消息]
   ```

## 文件结构

```
app/Http/Controllers/
└── TelegramBotController.php    # Bot控制器

config/
└── telegram.php                 # Bot配置文件

routes/
└── web.php                     # 路由定义（已更新）
```

## 功能说明

### TelegramBotController 方法

- `webhook()`: 处理来自Telegram的消息更新
- `setWebhook()`: 设置Telegram Webhook URL
- `getBotInfo()`: 获取Bot信息
- `sendEchoMessage()`: 发送回声消息
- `sendMessage()`: 发送普通消息

### 支持的消息类型

- ✅ **文本消息**: 完全支持回声功能
- ❌ **其他类型**: 图片、贴纸、文件等会收到提示消息

## 调试

### 查看日志
Bot会记录所有接收到的消息和错误，您可以通过Laravel日志查看：

```bash
# 查看实时日志
php artisan pail

# 或者查看日志文件
tail -f storage/logs/laravel.log
```

### 常见问题

1. **Webhook设置失败**
   - 检查 `TELEGRAM_WEBHOOK_URL` 是否为有效的HTTPS URL
   - 确保服务器可以从互联网访问

2. **Bot不响应消息**
   - 检查 `TELEGRAM_BOT_TOKEN` 是否正确
   - 查看应用程序日志是否有错误
   - 确认Webhook已正确设置

3. **HTTPS要求**
   - Telegram要求Webhook URL必须使用HTTPS
   - 本地开发可以使用ngrok等工具

## 开发扩展

如果您想扩展Bot功能，可以在 `TelegramBotController` 中添加更多命令处理：

```php
// 在 webhook() 方法中添加命令处理
if (strpos($text, '/') === 0) {
    $this->handleCommand($chatId, $text);
} else {
    $this->sendEchoMessage($chatId, $text);
}
```

## 部署注意事项

- 确保生产环境使用HTTPS
- 设置适当的日志级别
- 定期监控Bot的响应性能
- 考虑添加速率限制

## 支持

如果遇到问题，请检查：
1. Laravel日志文件
2. Bot配置是否正确
3. 网络连接是否正常
4. Telegram API是否可访问

---

**祝您使用愉快！** 🎉 