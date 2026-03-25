# 番茄时钟任务追踪功能设计

## 概述

为习惯打卡应用新增独立的任务管理模块，支持基于时长的任务追踪，帮助用户记录和分析时间分配。

## 需求

### 核心功能
1. 创建任务（名称、目标时长、截止日期）
2. 开始/结束任务计时
3. 记录每次任务执行的时间段
4. 显示任务完成进度
5. 展示今日任务时间分布

### 用户场景
- 用户创建任务"学习Flutter"，目标时长10小时，截止日期3月31日
- 点击开始任务，开始计时
- 完成后点击结束，记录本次工作时长
- 查看任务进度条显示已完成30%
- 查看今日时间分布图，了解时间花费

## 数据模型

### Task 模型
```dart
class Task {
  String id;              // 唯一标识
  String name;            // 任务名称
  int targetMinutes;      // 目标时长（分钟）
  DateTime deadline;      // 截止日期
  TaskStatus status;      // 状态：进行中/已完成/已放弃
  List<TimeSession> sessions; // 时间记录列表
}
```

### TimeSession 模型
```dart
class TimeSession {
  String id;
  DateTime startTime;     // 开始时间
  DateTime endTime;       // 结束时间
  int durationMinutes;    // 持续时长（分钟）
}
```

### TaskStatus 枚举
```dart
enum TaskStatus {
  active,      // 进行中
  completed,   // 已完成
  abandoned    // 已放弃
}
```

## UI 设计

### 页面结构

**底部导航栏：**
- 习惯打卡（现有）
- 任务管理（新增）

**任务列表页：**
- 顶部：添加任务按钮
- 任务卡片显示：
  - 任务名称
  - 进度条（已完成/目标时长）
  - 截止日期
  - 开始/继续按钮
  - 状态标签
- 底部：今日时间分布饼图

**任务详情页：**
- 任务信息
- 进度条
- 开始/结束计时按钮
- 时间记录列表（显示每次工作的时间段）
- 统计数据（总时长、剩余时长）

### 关键交互

1. **创建任务**
   - 点击"+"按钮
   - 输入：任务名称、目标时长（小时）、截止日期
   - 保存后显示在列表中

2. **开始任务**
   - 点击"开始"按钮
   - 按钮变为"结束"
   - 显示计时器

3. **结束任务**
   - 点击"结束"按钮
   - 保存本次时间记录
   - 更新任务进度

4. **任务状态管理**
   - 长按任务卡片显示菜单
   - 可标记为：完成/放弃/删除

## 技术实现

### 文件结构
```
lib/
├── models/
│   ├── task.dart           # Task 模型
│   └── time_session.dart   # TimeSession 模型
├── services/
│   └── task_storage_service.dart  # 任务存储服务
├── screens/
│   ├── task_list_screen.dart      # 任务列表页
│   └── task_detail_screen.dart    # 任务详情页
└── widgets/
    ├── add_task_dialog.dart       # 添加任务对话框
    ├── task_card.dart             # 任务卡片
    └── time_distribution_chart.dart # 时间分布图
```

### 数据存储
- 使用 SharedPreferences 存储任务数据
- JSON 序列化/反序列化
- 存储键：'tasks'

### 进度计算
```dart
double getProgress() {
  int totalMinutes = sessions.fold(0, (sum, s) => sum + s.durationMinutes);
  return totalMinutes / targetMinutes;
}
```

### 时间分布图
- 使用 Flutter CustomPaint 绘制简单饼图
- 显示今日各任务时长占比
- 不同任务使用不同颜色

### 导航实现
```dart
// 底部导航栏
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: '习惯'),
    BottomNavigationBarItem(icon: Icon(Icons.timer), label: '任务'),
  ],
)
```

## 实现步骤

1. 创建数据模型（Task, TimeSession）
2. 实现存储服务（TaskStorageService）
3. 创建任务列表页面
4. 创建添加任务对话框
5. 实现计时功能
6. 创建任务详情页
7. 实现时间分布图
8. 添加底部导航栏
9. 编写单元测试

## 测试计划

- Task 模型测试（JSON 序列化、进度计算）
- TaskStorageService 测试（保存/加载）
- 任务卡片 Widget 测试
- 计时器功能测试

## 非功能需求

- 性能：列表滚动流畅（60fps）
- 数据安全：本地存储，无网络请求
- 用户体验：操作响应时间 < 100ms

