#!/bin/bash

# 启动FrankenPHP开发服务器（带文件监控）
echo "🚀 启动 Laravel FrankenPHP 服务器（带文件监控）..."
echo "📍 服务器地址: http://localhost:8000"
echo "🛑 使用 Ctrl+C 停止服务器"
echo "⚠️  注意：文件监控在包含空格的路径中可能会有问题"
echo ""

# 设置环境变量
export OCTANE_SERVER=frankenphp

# 启动Octane服务器（包含--watch参数）
php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=8000 --watch 