# 🚀 Laravel FrankenPHP Zeabur 部署指南

这份指南将帮助你将Laravel + FrankenPHP项目快速部署到Zeabur云平台。

## 📋 部署前准备

### 1. 确保项目文件完整
检查以下文件是否存在：
- ✅ `Dockerfile` - Docker构建文件
- ✅ `zeabur.json` - Zeabur配置文件
- ✅ `.dockerignore` - Docker忽略文件
- ✅ `deploy.sh` - 部署脚本

### 2. 代码提交到Git
确保所有代码已提交到Git仓库（GitHub、GitLab等）：
```bash
git add .
git commit -m "准备部署到Zeabur"
git push origin main
```

## 🎯 Zeabur 部署步骤

### 步骤 1: 准备Zeabur账户
1. 访问 [Zeabur](https://zeabur.com)
2. 使用GitHub账户登录
3. 确保你的GitHub仓库可以被Zeabur访问

### 步骤 2: 创建新项目
1. 在Zeabur控制台点击 "New Project"
2. 选择合适的区域（推荐香港或新加坡）
3. 为项目命名，例如 "laravel-frankenphp-app"

### 步骤 3: 添加服务
1. 点击 "Add Service"
2. 选择 "Git Repository"
3. 选择你的GitHub仓库
4. 选择分支（通常是 `main` 或 `master`）

### 步骤 4: 配置环境变量
在服务设置中添加以下环境变量：

#### 必需的环境变量
```env
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:YOUR_GENERATED_KEY_HERE
APP_URL=https://your-app.zeabur.app
OCTANE_SERVER=frankenphp
SERVER_NAME=:8080
```

#### 数据库配置（SQLite - 默认）
```env
DB_CONNECTION=sqlite
DB_DATABASE=/app/database/database.sqlite
```

#### 缓存和会话配置
```env
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync
```

### 步骤 5: 启动部署
1. 确认所有配置正确
2. 点击 "Deploy" 开始部署
3. 等待构建完成（通常需要3-10分钟）

## 🔧 高级配置

### 使用MySQL数据库
如果需要MySQL数据库：

1. 在同一项目中添加MySQL服务
2. 更新环境变量：
```env
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

### 使用Redis缓存
添加Redis服务并配置：
```env
REDIS_HOST=redis
REDIS_PASSWORD=
REDIS_PORT=6379
CACHE_DRIVER=redis
SESSION_DRIVER=redis
```

### 文件存储配置
对于文件上传，推荐使用云存储：
```env
FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_DEFAULT_REGION=your_region
AWS_BUCKET=your_bucket
```

## 🧪 本地测试

在部署到Zeabur之前，建议先进行本地测试：

### 使用部署脚本
```bash
./deploy.sh
```

### 手动Docker测试
```bash
# 构建生产镜像
docker build -t laravel-frankenphp --target production .

# 运行测试容器
docker run -p 8080:8080 \
  -e APP_ENV=production \
  -e APP_KEY=base64:$(openssl rand -base64 32) \
  laravel-frankenphp

# 测试访问
curl http://localhost:8080/frankenphp-info
```

### 使用Docker Compose
```bash
# 启动完整环境
docker-compose up

# 带MySQL和Redis
docker-compose --profile mysql --profile redis up
```

## 🔍 故障排除

### 常见问题及解决方案

#### 1. 应用密钥未设置
**错误**: `The only supported ciphers are AES-128-CBC and AES-256-CBC`

**解决**: 确保设置了正确的APP_KEY
```bash
# 在本地生成密钥
php artisan key:generate --show
# 复制输出的密钥到Zeabur环境变量
```

#### 2. 数据库连接失败
**错误**: `could not find driver`

**解决**: 检查数据库配置和驱动安装
- 确保Dockerfile中安装了正确的PHP扩展
- 验证数据库环境变量设置

#### 3. 文件权限问题
**错误**: `Permission denied`

**解决**: 确保storage目录权限正确
- 检查Dockerfile中的权限设置
- 使用持久化存储卷

#### 4. 内存限制
**错误**: `Allowed memory size exhausted`

**解决**: 
- 在zeabur.json中增加内存限制
- 优化Laravel缓存配置

### 查看日志
在Zeabur控制台中查看应用日志：
1. 进入服务详情页
2. 点击 "Logs" 标签
3. 查看实时日志和错误信息

## 📊 性能优化

### 1. Laravel优化
```bash
# 在Dockerfile中添加
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize
```

### 2. FrankenPHP优化
在`Caddyfile`中配置：
```
{
    frankenphp {
        num_threads auto
    }
}

:8080 {
    root * public
    php_server
    file_server
}
```

### 3. 资源限制调整
在`zeabur.json`中：
```json
{
  "resources": {
    "cpu": "0.5",
    "memory": "1Gi"
  }
}
```

## 🔐 安全建议

1. **环境变量安全**
   - 不要在代码中硬编码敏感信息
   - 使用Zeabur的环境变量管理

2. **HTTPS配置**
   - Zeabur自动提供HTTPS
   - 确保APP_URL使用https://

3. **数据库安全**
   - 使用强密码
   - 限制数据库访问权限

## 🚀 生产部署清单

部署到生产环境前，检查以下项目：

- [ ] 所有环境变量已正确配置
- [ ] APP_DEBUG设置为false
- [ ] 数据库迁移已完成
- [ ] 静态资源已构建
- [ ] 错误日志配置正确
- [ ] 备份策略已制定
- [ ] 监控和告警已设置

## 📚 相关资源

- [Zeabur官方文档](https://docs.zeabur.com)
- [Laravel Octane文档](https://laravel.com/docs/octane)
- [FrankenPHP文档](https://frankenphp.dev)
- [Docker最佳实践](https://docs.docker.com/develop/dev-best-practices/)

## 🆘 获取帮助

如果遇到问题：
1. 查看本项目的 `FRANKENPHP_README.md`
2. 参考Zeabur官方文档
3. 检查GitHub Issues
4. 联系技术支持

---

🎉 恭喜！你的Laravel FrankenPHP应用现在应该在Zeabur上运行了！ 