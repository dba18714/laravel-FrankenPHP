<?php

use Illuminate\Support\Facades\Route;

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
