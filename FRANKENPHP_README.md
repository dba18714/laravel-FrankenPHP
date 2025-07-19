# Laravel + FrankenPHP 项目

这是一个使用 Laravel Octane 和 FrankenPHP 的高性能 Laravel 项目。

## 🚀 快速开始

### 1. 安装依赖
```bash
composer install
```

### 2. 环境配置
复制 `.env.example` 到 `.env` 并添加以下配置：
```env
OCTANE_SERVER=frankenphp
OCTANE_HTTPS=false
```

### 3. 启动服务器

#### 方法一：使用启动脚本（推荐 - 稳定版本）
```bash
./start-frankenphp.sh
```

#### 方法二：带文件监控的启动脚本（实验性）
```bash
./start-frankenphp-with-watch.sh
```
⚠️ **注意**: 文件监控功能在项目路径包含空格或特殊字符时可能会出现问题。

#### 方法三：直接使用 Artisan 命令
```bash
# 稳定版本（不带文件监控）
php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=8000

# 带文件监控版本（可能在某些路径下有问题）
php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=8000 --watch
```

### 4. 验证安装
启动服务器后，访问以下地址：
- 主页: http://localhost:8000
- FrankenPHP 信息: http://localhost:8000/frankenphp-info

## ⚠️ 常见问题解决

### 路径包含空格的问题
如果项目路径包含空格或特殊字符（如 "Google Drive"），可能会遇到以下错误：
```
Error: adapting config using caddyfile: parsing caddyfile tokens for 'frankenphp': unknown 'worker' subdirective
```

**解决方案**:
1. 使用 `./start-frankenphp.sh`（不带 --watch 参数）
2. 或者将项目移动到不包含空格的路径下
3. 或者手动启动时不使用 `--watch` 参数

## 📋 项目特性

- ✅ **高性能**: 使用 FrankenPHP 提供卓越的性能
- ✅ **稳定启动**: 包含处理路径问题的启动脚本
- ✅ **可选文件监控**: 提供带文件监控的备选启动方式
- ✅ **现代架构**: 基于 Laravel 12 和 Octane 2.11
- ✅ **生产就绪**: 包含 Caddyfile 配置用于生产部署
- ✅ **易于调试**: 包含服务器信息测试路由

## 🛠️ 可用命令

### 启动服务器
```bash
# 稳定版本
php artisan octane:start --server=frankenphp

# 带文件监控（如果路径支持）
php artisan octane:start --server=frankenphp --watch
```

### 重启服务器
```bash
php artisan octane:restart --server=frankenphp
```

### 停止服务器
```bash
php artisan octane:stop --server=frankenphp
```

### 查看服务器状态
```bash
php artisan octane:status --server=frankenphp
```

## 📁 项目结构

```
├── frankenphp                      # FrankenPHP 二进制文件
├── Caddyfile                       # Caddy/FrankenPHP 配置文件
├── start-frankenphp.sh             # 稳定启动脚本（推荐）
├── start-frankenphp-with-watch.sh  # 带文件监控的启动脚本
├── config/octane.php               # Octane 配置文件
└── routes/web.php                  # 包含 FrankenPHP 测试路由
```

## 🔧 性能优化

### 生产环境优化
```bash
# 优化自动加载
composer install --optimize-autoloader --no-dev

# 缓存配置
php artisan config:cache

# 缓存路由
php artisan route:cache

# 缓存视图
php artisan view:cache
```

### Octane 特定优化
在生产环境中，确保：
1. 使用 `--workers` 参数设置适当的工作进程数
2. 启用 OPcache
3. 配置合适的内存限制

## 🐳 Docker 部署（可选）

你也可以使用 Docker 来部署这个项目：

```dockerfile
FROM dunglas/frankenphp

COPY . /app
WORKDIR /app

RUN composer install --optimize-autoloader --no-dev
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

EXPOSE 80

CMD ["frankenphp", "run", "--config", "/app/Caddyfile"]
```

## 📚 更多资源

- [Laravel Octane 文档](https://laravel.com/docs/octane)
- [FrankenPHP 文档](https://frankenphp.dev/)
- [Caddy 文档](https://caddyserver.com/docs/)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目基于 MIT 许可证开源。 