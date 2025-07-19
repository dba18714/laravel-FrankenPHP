<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TelegramBotController;

Route::get('/', function () {
    return view('welcome');
});

// FrankenPHP 测试路由
Route::get('/frankenphp-info', function () {
    $serverInfo = [
        'server' => $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown',
        'php_version' => PHP_VERSION,
        'laravel_version' => app()->version(),
        'octane_server' => config('octane.server'),
        'memory_limit' => ini_get('memory_limit'),
        'max_execution_time' => ini_get('max_execution_time'),
        'date' => now()->toDateTimeString(),
    ];
    
    return response()->json([
        'message' => '🎉 FrankenPHP 运行正常！',
        'status' => 'success',
        'server_info' => $serverInfo
    ], 200, [], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
});

// Telegram Bot 路由
Route::group(['prefix' => 'telegram-bot'], function () {
    // Webhook处理路由 - Telegram会向这个URL发送消息
    Route::post('/webhook', [TelegramBotController::class, 'webhook']);
    
    // 管理路由
    Route::get('/set-webhook', [TelegramBotController::class, 'setWebhook']);
    Route::get('/bot-info', [TelegramBotController::class, 'getBotInfo']);
});

// Bot状态页面
Route::get('/bot-status', function () {
    $config = [
        'bot_token_set' => !empty(config('telegram.bot_token')),
        'webhook_url_set' => !empty(config('telegram.webhook_url')),
        'bot_username' => config('telegram.bot_username'),
    ];
    
    return response()->json([
        'message' => '🤖 Telegram Bot 配置状态',
        'config' => $config,
        'endpoints' => [
            'webhook' => url('/telegram-bot/webhook'),
            'set_webhook' => url('/telegram-bot/set-webhook'),
            'bot_info' => url('/telegram-bot/bot-info'),
        ]
    ], 200, [], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
});
