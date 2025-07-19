#!/bin/bash

# 启动FrankenPHP开发服务器
echo "🚀 启动 Laravel FrankenPHP 服务器..."
echo "📍 服务器地址: http://localhost:8000"
echo "🛑 使用 Ctrl+C 停止服务器"
echo ""

# 设置环境变量
export OCTANE_SERVER=frankenphp

# 启动Octane服务器（移除--watch参数以避免路径解析问题）
php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=8000 