# 二手交易平台系统

## 一、系统结构设计

采用MVC三层架构：

- **Controller层**: Servlet接收请求，调用Service
- **Service层**: 业务逻辑处理（权限校验、数据加密等）
- **DAO层**: 数据库访问（DBUtil封装JDBC操作）
- **View层**: JSP页面展示

## 二、数据库结构说明

### 数据库表设计

系统使用MySQL数据库

#### 1. user表（用户信息表）

存储所有用户信息，用于用户注册、登录和权限管理。

**字段说明：**

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | bigint | PRIMARY KEY, AUTO_INCREMENT | 用户唯一标识，自增主键 |
| username | varchar(50) | NOT NULL, UNIQUE | 用户名，唯一且不可为空 |
| password | varchar(100) | NOT NULL | 用户密码（MD5加密存储） |
| email | varchar(100) | DEFAULT NULL | 用户邮箱，可选 |
| phone | varchar(20) | DEFAULT NULL | 用户手机号，可选 |
| create_time | datetime | DEFAULT CURRENT_TIMESTAMP | 用户注册时间，自动记录 |

**索引说明：**
- 主键索引：`id`
- 唯一索引：`username`

#### 2. item表（物品信息表）

存储二手物品信息，包括物品详情、价格、状态等信息。

**字段说明：**

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | bigint | PRIMARY KEY, AUTO_INCREMENT | 物品唯一标识，自增主键 |
| title | varchar(200) | NOT NULL | 物品标题，最大长度200字符 |
| description | text | DEFAULT NULL | 物品详细描述，支持长文本 |
| price | decimal(10,2) | NOT NULL | 物品价格（10位整数，2位小数） |
| user_id | bigint | NOT NULL | 发布者ID，关联用户表 |
| status | varchar(20) | DEFAULT 'on_sale' | 物品状态：`on_sale`(在售)/`sold`(已售出) |
| create_time | datetime | DEFAULT CURRENT_TIMESTAMP | 物品发布时间，自动记录 |
| deleted | int | DEFAULT 0 | 软删除标志：0未删除/1已删除 |

**索引说明：**
- 主键索引：`id`
- 普通索引：`idx_user` (`user_id`)

**外键约束：**
- `fk_item_user`: 确保`user_id`引用`user`表的`id`字段，保证数据完整性

## 三、使用方法

### 1. 访问

```
http://10.100.164.17:8080/SecondHand-1.0-SNAPSHOT/
```

### 2. 功能操作

- 首页搜索、查看详情、购买
- 登录后发布、编辑、删除、标记售出
- 我的发布查看个人物品

## 四、测试账号密码

| 用户名 | 密码 |
|--------|------|
| **admin** | **123** |
| **only** | **789** |

### 测试建议

- 用only账号购买admin的物品
- 测试搜索关键词
- 验证只能编辑/删除自己的物品
- 检查已售出物品不可再编辑