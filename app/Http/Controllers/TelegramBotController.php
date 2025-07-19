<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use TelegramBot\Api\BotApi;
use TelegramBot\Api\Exception;
use Illuminate\Support\Facades\Log;

class TelegramBotController extends Controller
{
    private $telegram;

    public function __construct()
    {
        $this->telegram = new BotApi(config('telegram.bot_token'));
    }

    /**
     * 处理Telegram webhook
     */
    public function webhook(Request $request)
    {
        try {
            $update = json_decode($request->getContent(), true);
            
            // 记录接收到的消息用于调试
            Log::info('Telegram webhook received:', $update);

            // 检查是否有消息
            if (isset($update['message'])) {
                $message = $update['message'];
                $chatId = $message['chat']['id'];
                $text = $message['text'] ?? '';

                // 如果用户发送了文本消息，就回声这个消息
                if (!empty($text)) {
                    $this->sendEchoMessage($chatId, $text);
                }
                // 如果收到其他类型的消息（图片、贴纸等）
                else {
                    $this->sendMessage($chatId, '我只能回声文本消息哦！ 😊');
                }
            }

            return response()->json(['status' => 'ok']);

        } catch (Exception $e) {
            Log::error('Telegram Bot Error: ' . $e->getMessage());
            return response()->json(['status' => 'error'], 500);
        }
    }

    /**
     * 发送回声消息
     */
    private function sendEchoMessage($chatId, $text)
    {
        try {
            // 创建回声消息
            $echoText = "🔄 您说：\n\n" . $text;
            
            $this->telegram->sendMessage($chatId, $echoText);
            
        } catch (Exception $e) {
            Log::error('Error sending echo message: ' . $e->getMessage());
        }
    }

    /**
     * 发送普通消息
     */
    private function sendMessage($chatId, $text)
    {
        try {
            $this->telegram->sendMessage($chatId, $text);
        } catch (Exception $e) {
            Log::error('Error sending message: ' . $e->getMessage());
        }
    }

    /**
     * 设置webhook（用于初始化Bot）
     */
    public function setWebhook()
    {
        try {
            $webhookUrl = config('telegram.webhook_url');
            $result = $this->telegram->setWebhook($webhookUrl);

            Log::info('Telegram Bot setWebhook result:', $result);
            
            if ($result) {
                return response()->json([
                    'status' => 'success',
                    'message' => 'Webhook设置成功！',
                    'webhook_url' => $webhookUrl
                ]);
            } else {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Webhook设置失败'
                ], 500);
            }
            
        } catch (Exception $e) {
            Log::error('Error setting webhook: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Webhook设置出错: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * 获取Bot信息
     */
    public function getBotInfo()
    {
        try {
            $me = $this->telegram->getMe();
            return response()->json([
                'status' => 'success',
                'bot_info' => $me
            ]);
        } catch (Exception $e) {
            Log::error('Error getting bot info: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => '获取Bot信息失败: ' . $e->getMessage()
            ], 500);
        }
    }
}
