# Django-Super-Blog

## 项目概述

Django-Super-Blog是一个功能丰富的博客平台，基于Django框架开发。该项目包含丰富的博客管理功能，支持用户认证、文章管理、评论系统、标签分类、全文搜索、图片处理等功能。
结合了FakeV2EX项目和https://tendcode.com/

## 技术栈

- Django 2.0.6
- Celery 4.3.0
- Redis 4.3.6
- Django Rest Framework 3.8.2
- Whoosh 2.7.4 (全文搜索引擎)
- Django-haystack 2.8.1
- Django-allauth 0.36.0
- MySQL/SQLite 数据库

## 环境要求

- Python 3.6+
- Redis 服务器
- MySQL 数据库（可选，默认使用SQLite）

## 安装步骤

1. 克隆仓库
```bash
git clone https://github.com/yourusername/Django-Super-Blog.git
cd Django-Super-Blog
```

2. 创建并激活虚拟环境
```bash
python -m venv venv
# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate
```

3. 安装依赖
```bash
pip install -r requirements.txt
```

4. 配置环境变量
编辑 `env.json` 文件，设置必要的配置项

5. 执行数据库迁移
```bash
python manage.py migrate
```

6. 创建超级用户
```bash
python manage.py createsuperuser
```

## 启动项目

1. 确保Redis服务器已启动
```bash
# 在Linux/Mac上启动Redis
redis-server

# 或在Windows上可以通过安装包启动Redis服务
```

2. 启动Celery worker（可选，用于后台任务）
```bash
celery -A 2zzy worker -l info
```

3. 运行开发服务器
```bash
python manage.py runserver
```

4. 访问网站
在浏览器中访问 http://127.0.0.1:8000

## 生产环境部署

使用gunicorn作为WSGI服务器:
```bash
gunicorn -c gunicorn.conf 2zzy.wsgi
```

## 许可证

本项目遵循MIT许可证 