# UI 视觉优化实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 通过优化配色、间距、圆角、阴影等视觉元素，提升应用的现代感和美观度

**Architecture:** 渐进式优化现有UI组件，保持布局和功能不变，仅调整视觉样式参数

**Tech Stack:** Flutter, Material Design

---

## File Structure

**Files to modify:**
- `lib/main.dart` - 主题配色、习惯列表卡片样式
- `lib/screens/habit_detail_screen.dart` - 日历视图、统计卡片样式

---

### Task 1: 优化主题配色和习惯列表卡片

**Files:**
- Modify: `lib/main.dart:16-24` (主题配置)
- Modify: `lib/main.dart:105-155` (卡片样式)

- [ ] **Step 1: 更新主题配色**

在 `lib/main.dart` 中修改 MaterialApp 的 theme：

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF5B8DEE),
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  useMaterial3: true,
),
```

- [ ] **Step 2: 优化习惯卡片样式**

在 `lib/main.dart` 的 Card widget (第105行) 修改：

```dart
Card(
  key: ValueKey(habit.id),
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  color: Colors.white,
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Padding(
    padding: const EdgeInsets.all(16),
```

- [ ] **Step 3: 优化打卡图标容器样式**

在 `lib/main.dart` 的打卡图标 Container (第124行) 修改：

```dart
Container(
  decoration: BoxDecoration(
    color: const Color(0xFFE8F5E9),
    borderRadius: BorderRadius.circular(8),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
```

- [ ] **Step 4: 优化打卡图标颜色**

在 `lib/main.dart` 的 Icon widget (第138行) 修改：

```dart
Icon(
  checked ? Icons.check_circle : Icons.circle_outlined,
  color: checked ? const Color(0xFF4CAF50) : Colors.grey,
  size: 20,
),
```

- [ ] **Step 5: 优化习惯名称字体**

在 `lib/main.dart` 的习惯名称 Text (第117行) 修改：

```dart
Text(
  habit.name,
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
),
```

- [ ] **Step 6: 优化次要信息字体**

在 `lib/main.dart` 的统计信息 Text (第118行) 修改：

```dart
Text(
  '连续 ${habit.getStreakDays()} 天 | 目标 ${habit.targetDays} 天',
  style: TextStyle(
    fontSize: 13,
    color: Colors.grey[600],
  ),
),
```

- [ ] **Step 7: 运行应用验证主界面效果**

```bash
flutter run
```

预期：主界面卡片显示柔和配色、圆角、阴影效果

- [ ] **Step 8: 提交更改**

```bash
git add lib/main.dart
git commit -m "feat: 优化主题配色和习惯列表卡片样式

- 更新主题色为柔和蓝色
- 优化卡片圆角、阴影、间距
- 改进打卡图标容器样式
- 优化字体大小和颜色

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

### Task 2: 优化详情页日历和统计卡片

**Files:**
- Modify: `lib/screens/habit_detail_screen.dart:109-128` (统计卡片)
- Modify: `lib/screens/habit_detail_screen.dart:165-201` (日历视图)

- [ ] **Step 1: 优化统计卡片容器**

在 `lib/screens/habit_detail_screen.dart` 的统计 Padding (第109行) 修改为：

```dart
Padding(
  padding: const EdgeInsets.all(16.0),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    padding: const EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              '${widget.habit.checkedDates.length}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B8DEE),
              ),
            ),
            const Text('总打卡数'),
          ],
        ),
        Column(
          children: [
            Text(
              '${_getMaxStreak()}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50),
              ),
            ),
            const Text('最长连续'),
          ],
        ),
      ],
    ),
  ),
),
```

- [ ] **Step 2: 优化日历已打卡圆圈**

在 `lib/screens/habit_detail_screen.dart` 的已打卡 Container (第173行) 修改：

```dart
if (isChecked)
  Container(
    width: 36,
    height: 36,
    decoration: const BoxDecoration(
      color: Color(0xFF4CAF50),
      shape: BoxShape.circle,
    ),
  ),
```

- [ ] **Step 3: 优化今日标识圆圈**

在 `lib/screens/habit_detail_screen.dart` 的今日标识 Container (第181行) 修改：

```dart
if (isToday)
  Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color(0xFFFF9800),
        width: 2,
      ),
      shape: BoxShape.circle,
    ),
  ),
```

- [ ] **Step 4: 优化日历文字样式**

在 `lib/screens/habit_detail_screen.dart` 的日期 Text (第190行) 修改：

```dart
Text(
  isChecked ? '$checkCount/${widget.habit.dailyGoal}' : '$dayNum',
  style: TextStyle(
    color: isChecked ? Colors.white : Colors.black,
    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
    fontSize: isChecked ? 11 : 14,
  ),
),
```

- [ ] **Step 5: 运行应用验证详情页效果**

```bash
flutter run
```

预期：详情页统计卡片有阴影和圆角，日历视图颜色更柔和

- [ ] **Step 6: 提交更改**

```bash
git add lib/screens/habit_detail_screen.dart
git commit -m "feat: 优化详情页日历和统计卡片样式

- 添加统计卡片背景、圆角、阴影
- 优化统计数字字体大小和颜色
- 改进日历已打卡和今日标识颜色
- 调整日历圆圈尺寸和文字大小

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

### Task 3: 最终验证和测试

**Files:**
- Test: 手动测试所有界面

- [ ] **Step 1: 完整测试主界面**

```bash
flutter run
```

验证项：
- 主题背景色为浅灰色
- 卡片有圆角和阴影
- 打卡图标颜色柔和
- 字体大小合适

- [ ] **Step 2: 测试详情页**

点击任意习惯进入详情页，验证：
- 统计卡片有背景和阴影
- 日历颜色柔和
- 今日标识清晰

- [ ] **Step 3: 测试添加习惯**

点击 + 按钮，验证对话框正常显示

- [ ] **Step 4: 测试打卡交互**

在主界面点击打卡图标，验证交互正常

- [ ] **Step 5: 运行代码分析**

```bash
flutter analyze
```

预期：无错误和警告

- [ ] **Step 6: 最终提交（如有遗漏）**

如果有未提交的改动：

```bash
git add .
git commit -m "chore: 最终调整

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## 完成标准

- ✅ 主题配色更新为柔和色调
- ✅ 卡片有圆角、阴影、合适间距
- ✅ 打卡图标颜色优化
- ✅ 字体层级清晰
- ✅ 详情页统计卡片有视觉层次
- ✅ 日历视图颜色柔和
- ✅ 所有功能正常工作
- ✅ 代码分析无错误
