# 任务追踪功能文档

## 功能概述

任务追踪模块是一个基于时长的任务管理系统，帮助用户记录和分析时间分配。用户可以创建任务、设置目标时长和截止日期，通过计时器记录工作时间，并通过可视化图表了解时间分布。

## 核心功能

### 1. 任务管理
- **创建任务**：设置任务名称、目标时长（小时）、截止日期
- **任务状态**：进行中、已完成、已放弃
- **任务列表**：查看所有任务及其进度
- **任务详情**：查看单个任务的详细信息和时间记录

### 2. 时间追踪
- **开始计时**：点击开始按钮记录工作开始时间
- **结束计时**：点击结束按钮保存本次工作时长
- **时间记录**：自动保存每次工作的时间段（开始-结束时间）
- **进度显示**：实时显示任务完成百分比

### 3. 数据可视化
- **进度条**：直观显示任务完成进度
- **时间分布图**：饼图展示今日各任务时长占比
- **统计数据**：总时长、剩余时长、完成百分比

### 4. 数据持久化
- 使用 SharedPreferences 本地存储
- 应用重启后数据不丢失
- JSON 格式序列化存储

## 使用指南

### 创建任务

1. 在任务列表页面点击右下角的"+"按钮
2. 填写任务信息：
   - **任务名称**：例如"学习 Flutter"
   - **目标时长**：选择 1-20 小时
   - **截止日期**：选择任务完成的最后期限
3. 点击"确认"保存任务

### 开始工作

1. 在任务列表中找到要开始的任务
2. 点击任务卡片上的"开始"按钮
3. 系统开始记录工作时间
4. 按钮变为"结束"状态

### 结束工作

1. 完成一段工作后，点击"结束"按钮
2. 系统自动保存本次工作时长
3. 任务进度自动更新
4. 可以查看任务详情中的时间记录

### 查看任务详情

1. 点击任务卡片进入详情页
2. 查看任务信息和进度
3. 查看所有时间记录列表
4. 查看统计数据（总时长、剩余时长）

### 管理任务状态

1. 长按任务卡片显示操作菜单
2. 可选择：
   - **标记为完成**：任务已完成
   - **标记为放弃**：不再继续该任务
   - **删除任务**：永久删除任务数据

### 查看时间分布

在任务列表页面底部查看今日时间分布饼图：
- 显示今日各任务的时长占比
- 不同任务使用不同颜色
- 显示任务名称和时长图例

## 数据模型

### Task（任务）

```dart
class Task {
  final String id;              // 唯一标识
  final String name;            // 任务名称
  final int targetMinutes;      // 目标时长（分钟）
  final DateTime deadline;      // 截止日期
  final TaskStatus status;      // 任务状态
  final List<TimeSession> sessions; // 时间记录列表
}
```

**关键方法：**
- `getProgress()`: 计算任务完成百分比
- `getTotalMinutes()`: 计算总工作时长
- `toJson()` / `fromJson()`: JSON 序列化

### TimeSession（时间记录）

```dart
class TimeSession {
  final String id;              // 唯一标识
  final DateTime startTime;     // 开始时间
  final DateTime endTime;       // 结束时间
  final int durationMinutes;    // 持续时长（分钟）
}
```

### TaskStatus（任务状态）

```dart
enum TaskStatus {
  active,      // 进行中
  completed,   // 已完成
  abandoned    // 已放弃
}
```

## 技术架构

### 文件结构

```
lib/
├── models/
│   ├── task.dart                    # Task 数据模型
│   └── time_session.dart            # TimeSession 数据模型
├── services/
│   └── task_storage_service.dart    # 任务存储服务
├── screens/
│   ├── task_list_screen.dart        # 任务列表页面
│   └── task_detail_screen.dart      # 任务详情页面
└── widgets/
    ├── add_task_dialog.dart         # 添加任务对话框
    ├── task_card.dart               # 任务卡片组件
    └── time_distribution_chart.dart # 时间分布饼图

test/
├── models/
│   └── task_test.dart               # Task 模型测试
└── services/
    └── task_storage_service_test.dart # 存储服务测试
```

### 架构模式

采用 **Model-Service-Screen** 三层架构：

1. **Model 层**：定义数据结构和业务逻辑
   - `Task` 和 `TimeSession` 模型
   - 进度计算、时长统计等方法

2. **Service 层**：处理数据持久化
   - `TaskStorageService` 负责读写 SharedPreferences
   - JSON 序列化/反序列化

3. **Screen/Widget 层**：UI 展示和交互
   - 任务列表、详情页面
   - 任务卡片、对话框等组件

### 数据流

```
用户操作 → Screen/Widget → 更新状态 → Service 保存 → SharedPreferences
                ↑                                           ↓
                └─────────── Service 加载 ←─────────────────┘
```

### 存储实现

**存储键：** `'tasks'`

**存储格式：** JSON 数组
```json
[
  {
    "id": "uuid",
    "name": "学习 Flutter",
    "targetMinutes": 600,
    "deadline": "2026-03-31T00:00:00.000",
    "status": 0,
    "sessions": [
      {
        "id": "uuid",
        "startTime": "2026-03-25T09:00:00.000",
        "endTime": "2026-03-25T10:30:00.000",
        "durationMinutes": 90
      }
    ]
  }
]
```

## 核心算法

### 进度计算

```dart
double getProgress() {
  int totalMinutes = getTotalMinutes();
  return totalMinutes / targetMinutes;
}

int getTotalMinutes() {
  return sessions.fold(0, (sum, s) => sum + s.durationMinutes);
}
```

**说明：**
- 累加所有时间记录的时长
- 除以目标时长得到完成百分比
- 返回值范围：0.0 - 1.0+（可能超过 100%）

### 时间分布计算

```dart
// 筛选今日的时间记录
List<TimeSession> todaySessions = sessions.where((s) {
  return isSameDay(s.startTime, DateTime.now());
}).toList();

// 计算各任务今日时长
Map<String, int> distribution = {};
for (var task in tasks) {
  int todayMinutes = task.getTodayMinutes();
  if (todayMinutes > 0) {
    distribution[task.name] = todayMinutes;
  }
}
```

## UI 组件

### TaskCard（任务卡片）

**显示内容：**
- 任务名称
- 进度条（LinearProgressIndicator）
- 完成百分比文字
- 截止日期
- 状态标签（进行中/已完成/已放弃）
- 开始/继续按钮

**交互：**
- 点击卡片：进入任务详情
- 点击开始按钮：开始计时
- 长按卡片：显示操作菜单

### AddTaskDialog（添加任务对话框）

**输入字段：**
- 任务名称（TextField）
- 目标时长（DropdownButton，1-20 小时）
- 截止日期（DatePicker）

**按钮：**
- 确认：保存任务
- 取消：关闭对话框

### TimeDistributionChart（时间分布图）

**实现方式：**
- 使用 `CustomPaint` 绘制饼图
- 根据时长占比计算扇形角度
- 使用预定义颜色列表

**显示规则：**
- 只显示今日数据
- 最多显示前 5 个任务
- 显示图例（任务名称 + 时长）

## 测试

### 单元测试

**Task 模型测试** (`test/models/task_test.dart`)
- 创建任务对象
- JSON 序列化/反序列化
- 进度计算正确性
- 总时长计算正确性

**TaskStorageService 测试** (`test/services/task_storage_service_test.dart`)
- 保存任务到 SharedPreferences
- 从 SharedPreferences 加载任务
- 空数据处理
- 数据完整性验证

### 运行测试

```bash
# 运行所有测试
flutter test

# 运行特定测试文件
flutter test test/models/task_test.dart
flutter test test/services/task_storage_service_test.dart
```

## 性能优化

### 列表性能
- 使用 `ListView.builder` 按需构建列表项
- 避免在 build 方法中进行复杂计算
- 缓存计算结果（如总时长、进度）

### 存储性能
- 批量保存任务数据，避免频繁写入
- 使用异步操作避免阻塞 UI
- 数据变更时才触发保存

### 绘图性能
- 时间分布图使用 `CustomPaint` 直接绘制
- 避免使用第三方图表库减少依赖
- 限制显示任务数量（最多 5 个）

## 最佳实践

### 任务创建
- 设置合理的目标时长（建议 1-20 小时）
- 选择明确的截止日期
- 使用清晰的任务名称

### 时间记录
- 每次工作结束后及时点击"结束"按钮
- 避免长时间不结束计时（影响数据准确性）
- 定期查看任务进度，调整工作计划

### 任务管理
- 及时标记已完成的任务
- 放弃不再进行的任务，保持列表整洁
- 定期清理过期任务

## 常见问题

### Q: 如何修改任务信息？
A: 目前版本不支持编辑任务。如需修改，请删除后重新创建。

### Q: 计时器会在后台运行吗？
A: 不会。计时器只记录开始和结束时间，不需要后台运行。

### Q: 数据会同步到云端吗？
A: 不会。所有数据仅存储在本地设备，不涉及网络请求。

### Q: 可以导出任务数据吗？
A: 目前版本不支持数据导出功能。

### Q: 任务完成后还能继续记录时间吗？
A: 可以。标记为完成的任务仍可继续记录时间。

## 未来规划

- [ ] 任务编辑功能
- [ ] 数据导出（CSV/JSON）
- [ ] 周/月统计报表
- [ ] 任务标签和分类
- [ ] 番茄钟模式（25 分钟工作 + 5 分钟休息）
- [ ] 任务提醒通知
- [ ] 数据备份和恢复

## 相关文档

- [实现计划](superpowers/plans/2026-03-24-pomodoro-task-tracker.md)
- [设计文档](superpowers/specs/2026-03-24-pomodoro-task-tracker-design.md)
- [项目 README](../README.md)
- [CLAUDE.md](../CLAUDE.md)
