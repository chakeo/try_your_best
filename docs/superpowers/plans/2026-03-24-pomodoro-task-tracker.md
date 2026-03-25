# 番茄时钟任务追踪功能实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为习惯打卡应用新增独立的任务管理模块，支持基于时长的任务追踪和时间分布可视化

**Architecture:** 采用与现有习惯打卡相同的架构模式：Model-Service-Screen 三层结构，使用 SharedPreferences 本地存储，通过底部导航栏切换页面

**Tech Stack:** Flutter, SharedPreferences, CustomPaint (饼图)

---

## File Structure

**New Files:**
- `lib/models/task.dart` - 任务数据模型
- `lib/models/time_session.dart` - 时间记录模型
- `lib/services/task_storage_service.dart` - 任务存储服务
- `lib/screens/task_list_screen.dart` - 任务列表页面
- `lib/screens/task_detail_screen.dart` - 任务详情页面
- `lib/widgets/add_task_dialog.dart` - 添加任务对话框
- `lib/widgets/task_card.dart` - 任务卡片组件
- `lib/widgets/time_distribution_chart.dart` - 时间分布饼图
- `test/models/task_test.dart` - 任务模型测试
- `test/services/task_storage_service_test.dart` - 存储服务测试

**Modified Files:**
- `lib/main.dart` - 添加底部导航栏和路由

---

## Implementation Steps

### Step 1: 创建数据模型
- [ ] 创建 `lib/models/time_session.dart`
  - TimeSession 类：id, startTime, endTime, durationMinutes
  - toJson/fromJson 方法
- [ ] 创建 `lib/models/task.dart`
  - Task 类：id, name, targetMinutes, deadline, status, sessions
  - TaskStatus 枚举：active, completed, abandoned
  - getProgress() 方法计算完成百分比
  - getTotalMinutes() 方法计算总时长
  - toJson/fromJson 方法

### Step 2: 实现存储服务
- [ ] 创建 `lib/services/task_storage_service.dart`
  - loadTasks() 方法从 SharedPreferences 加载
  - saveTasks() 方法保存到 SharedPreferences
  - 使用存储键 'tasks'

### Step 3: 创建任务列表页面
- [ ] 创建 `lib/screens/task_list_screen.dart`
  - 显示任务列表
  - 添加任务按钮（FloatingActionButton）
  - 每个任务显示：名称、进度条、截止日期、开始按钮
  - 点击任务卡片进入详情页

### Step 4: 创建任务卡片组件
- [ ] 创建 `lib/widgets/task_card.dart`
  - 显示任务名称、进度条、截止日期
  - 开始/继续按钮
  - 状态标签（进行中/已完成/已放弃）

### Step 5: 创建添加任务对话框
- [ ] 创建 `lib/widgets/add_task_dialog.dart`
  - 输入任务名称
  - 选择目标时长（小时，下拉菜单：1-20小时）
  - 选择截止日期（DatePicker）
  - 确认/取消按钮

### Step 6: 创建任务详情页面
- [ ] 创建 `lib/screens/task_detail_screen.dart`
  - 显示任务信息和进度条
  - 开始/结束计时按钮
  - 显示当前计时时长（如果正在计时）
  - 时间记录列表（每次工作的开始-结束时间）
  - 统计数据：总时长、剩余时长

### Step 7: 创建时间分布图
- [ ] 创建 `lib/widgets/time_distribution_chart.dart`
  - 使用 CustomPaint 绘制简单饼图
  - 显示今日各任务时长占比
  - 不同任务使用不同颜色
  - 显示图例（任务名称和时长）

### Step 8: 添加底部导航栏
- [ ] 修改 `lib/main.dart`
  - 创建主页面包含 BottomNavigationBar
  - 两个 Tab：习惯打卡、任务管理
  - 使用 IndexedStack 切换页面
  - 保持各页面状态

### Step 9: 编写单元测试
- [ ] 创建 `test/models/task_test.dart`
  - 测试 Task 创建、JSON 序列化
  - 测试 getProgress() 计算
  - 测试 getTotalMinutes() 计算
- [ ] 创建 `test/services/task_storage_service_test.dart`
  - 测试保存和加载任务
  - 测试空数据情况

---

## Implementation Notes

**计时器实现：**
- 使用 DateTime.now() 记录开始时间
- 结束时保存 TimeSession
- 不需要实时更新显示（简化实现）

**进度条：**
- 使用 LinearProgressIndicator
- 显示百分比文字

**饼图绘制：**
- 只显示今日数据
- 最多显示前5个任务
- 使用预定义颜色列表

**状态管理：**
- 使用 StatefulWidget + setState
- 不引入额外状态管理库

---

## Acceptance Criteria

- [ ] 可以创建任务并设置目标时长和截止日期
- [ ] 可以开始/结束任务计时
- [ ] 进度条正确显示任务完成百分比
- [ ] 任务详情页显示所有时间记录
- [ ] 今日时间分布图正确显示各任务占比
- [ ] 可以标记任务为完成/放弃
- [ ] 数据持久化，重启应用后数据不丢失
- [ ] 所有单元测试通过




