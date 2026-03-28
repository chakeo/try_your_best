# 习惯打卡 (Try Your Best)

一个简洁优雅的 Flutter 应用，包含习惯追踪和任务管理两大模块。

## ✨ 功能特性

**习惯打卡模块**
- 📝 创建自定义习惯，设置每日目标次数和目标天数
- ✅ 每日多次打卡支持（可设置 1-10 次/天）
- 🔥 连续打卡天数统计（Streak）
- 📊 打卡历史日历视图
- 📈 打卡统计数据展示
- 🔄 习惯列表拖拽排序

**任务管理模块**
- 📋 任务创建与管理
- ⏱️ 时间会话追踪
- 📝 子任务支持
- 📅 截止日期提醒
- 📊 进度可视化

**通用特性**
- 🎨 优雅的 UI 设计和流畅动画
- 💾 本地数据持久化存储

## 📱 截图

（待添加应用截图）

## 🚀 快速开始

### 环境要求

- Flutter SDK: ^3.10.7
- Dart SDK: ^3.10.7

### 安装步骤

1. 克隆项目
```bash
git clone <repository-url>
cd try_your_best
```

2. 安装依赖
```bash
flutter pub get
```

3. 运行应用
```bash
flutter run
```

## 🛠️ 技术栈

- **Flutter** - 跨平台 UI 框架
- **SharedPreferences** - 本地数据持久化
- **Intl** - 国际化和日期格式化
- **Lunar** - 农历日期支持

## 📦 项目结构

```
lib/
├── models/
│   ├── habit.dart              # 习惯数据模型
│   ├── task.dart               # 任务数据模型
│   ├── subtask.dart            # 子任务模型
│   └── time_session.dart       # 时间会话模型
├── services/
│   ├── storage_service.dart    # 习惯存储服务
│   └── task_storage_service.dart # 任务存储服务
├── screens/
│   ├── habit_detail_screen.dart # 习惯详情页
│   ├── task_list_screen.dart   # 任务列表页
│   └── task_detail_screen.dart # 任务详情页
├── widgets/
│   ├── add_habit_dialog.dart   # 添加习惯对话框
│   ├── add_task_dialog.dart    # 添加任务对话框
│   ├── task_card.dart          # 任务卡片组件
│   └── header_widget.dart      # 头部组件
└── main.dart                   # 应用入口

test/
├── models/
│   ├── habit_test.dart         # 习惯模型测试
│   ├── task_test.dart          # 任务模型测试
│   ├── subtask_test.dart       # 子任务模型测试
│   └── time_session_test.dart  # 时间会话模型测试
├── services/
│   ├── storage_service_test.dart # 习惯存储测试
│   └── task_storage_service_test.dart # 任务存储测试
└── widgets/
    ├── add_habit_dialog_test.dart # 习惯对话框测试
    ├── task_card_test.dart     # 任务卡片测试
    └── header_widget_test.dart # 头部组件测试
```

## 🧪 测试

运行所有测试：
```bash
flutter test
```

运行特定测试文件：
```bash
flutter test test/models/habit_test.dart
```

测试覆盖：
- 所有模型类（Habit, Task, Subtask, TimeSession）
- 所有服务类（StorageService, TaskStorageService）
- 主要组件和屏幕

## 📝 开发命令

```bash
# 获取依赖
flutter pub get

# 运行应用（调试模式）
flutter run

# 运行应用（指定设备）
flutter run -d <device-id>

# 构建发布版本
flutter build apk          # Android
flutter build ios          # iOS
flutter build macos        # macOS

# 代码分析
flutter analyze

# 运行测试
flutter test
```

## 🎯 核心功能说明

### 习惯模型
- 支持自定义每日目标次数（1-10次）
- 可设置目标天数（7/14/21/30/60/90/100天）
- 自动计算连续打卡天数
- 记录每日打卡次数

### 数据持久化
- 使用 SharedPreferences 本地存储
- JSON 序列化/反序列化
- 自动保存习惯列表和打卡记录

### UI 特性
- Material Design 3 设计风格
- 流畅的动画效果
- 响应式布局
- 拖拽排序支持

## 📄 许可证

本项目仅供学习和个人使用。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

Made with ❤️ using Flutter
