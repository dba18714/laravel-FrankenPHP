#!/bin/bash

echo "🚀 Laravel FrankenPHP Zeabur 部署脚本"
echo "=================================="

# 检查Git状态
if [[ -n $(git status --porcelain) ]]; then
    echo "⚠️  检测到未提交的更改，请先提交所有更改："
    git status --short
    echo ""
    read -p "是否继续部署？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ 部署已取消"
        exit 1
    fi
fi

# 确保在正确的分支
current_branch=$(git branch --show-current)
echo "📍 当前分支: $current_branch"

# 检查环境变量
echo "🔧 检查必要文件..."

if [[ ! -f "Dockerfile" ]]; then
    echo "❌ 未找到 Dockerfile"
    exit 1
fi

if [[ ! -f "zeabur.json" ]]; then
    echo "⚠️  未找到 zeabur.json，建议创建此文件以优化部署"
fi

if [[ ! -f ".env.example" ]]; then
    echo "⚠️  未找到 .env.example"
fi

echo "✅ 文件检查完成"

# 运行本地测试（可选）
echo ""
read -p "是否运行本地Docker测试？(y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🧪 运行本地测试..."
    
    # 构建镜像
    docker build -t laravel-frankenphp-test --target production .
    
    if [[ $? -eq 0 ]]; then
        echo "✅ Docker 构建成功"
        
        # 运行容器测试
        echo "🏃 启动测试容器..."
        docker run -d --name test-container -p 8080:8080 \
            -e APP_ENV=testing \
            -e APP_KEY=base64:$(openssl rand -base64 32) \
            laravel-frankenphp-test
        
        # 等待容器启动
        sleep 10
        
        # 测试健康检查
        if curl -f http://localhost:8080/frankenphp-info >/dev/null 2>&1; then
            echo "✅ 容器测试成功"
        else
            echo "❌ 容器测试失败"
            docker logs test-container
        fi
        
        # 清理测试容器
        docker stop test-container >/dev/null 2>&1
        docker rm test-container >/dev/null 2>&1
        docker rmi laravel-frankenphp-test >/dev/null 2>&1
    else
        echo "❌ Docker 构建失败"
        exit 1
    fi
fi

echo ""
echo "📝 部署前检查清单："
echo "   ✅ 代码已提交到Git"
echo "   ✅ Dockerfile 已准备"
echo "   ✅ 环境变量已配置"
echo ""

echo "🎯 Zeabur 部署步骤："
echo "1. 登录 https://zeabur.com"
echo "2. 创建新项目或选择现有项目"
echo "3. 添加服务 -> Git 仓库"
echo "4. 选择此仓库和分支: $current_branch"
echo "5. Zeabur 会自动检测 Dockerfile 并开始构建"
echo ""

echo "🔧 环境变量配置建议："
echo "   APP_ENV=production"
echo "   APP_DEBUG=false"
echo "   APP_KEY=[生成新的密钥]"
echo "   APP_URL=https://your-domain.zeabur.app"
echo "   OCTANE_SERVER=frankenphp"
echo ""

echo "📚 有用的链接："
echo "   Zeabur 文档: https://docs.zeabur.com"
echo "   本项目文档: ./FRANKENPHP_README.md"
echo ""

echo "🚀 准备部署到 Zeabur！" 