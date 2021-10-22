import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/screens/add_task_screen.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/input_field.dart';
import 'package:todo/ui/widgets/my_button.dart';
import 'package:todo/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  var _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _taskController.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.brightness_4_outlined, color: context.theme.colorScheme.onSurface), onPressed: () => ThemeServices.switchTheme()),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red.shade400),
            onPressed: () => {_taskController.deleteAllTasks(), NotifyHelper.cancelAllNotifications()},
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat.yMMMMd().format(DateTime.now()), style: subHeadingStyle),
                      Text('Today', style: headingStyle),
                    ],
                  ),
                  MyButton(label: '+ Add Task', onTap: () => Get.to(() => const AddTaskScreen())),
                ],
              ),
              DatePicker(
                DateTime.now().isBefore(DateFormat.yMd().parse(_taskController.getFirstTask()?.date! ?? DateFormat.yMd().format(DateTime.now())))
                    ? DateTime.now()
                    : DateFormat.yMd().parse(_taskController.getFirstTask()?.date! ?? DateFormat.yMd().format(DateTime.now())),
                width: 70,
                height: 100,
                initialSelectedDate: _selectedDate,
                selectedTextColor: Colors.white,
                selectionColor: context.theme.colorScheme.primary,
                onDateChange: (newDate) => setState(() => _selectedDate = newDate),
                dateTextStyle: context.theme.textTheme.headline5!.copyWith(color: context.theme.colorScheme.onSurface),
                dayTextStyle: context.theme.textTheme.bodyText1!.copyWith(color: context.theme.colorScheme.onSurface),
                monthTextStyle: context.theme.textTheme.bodyText1!.copyWith(color: context.theme.colorScheme.onSurface),
              ),
              Expanded(
                child: _taskController.taskList.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('images/task.svg', color: context.theme.colorScheme.onSurface.withOpacity(0.5), height: 48),
                          const SizedBox(height: 8),
                          const Text("You don't have any tasks yet"),
                        ],
                      )
                    : Obx(
                        () => ListView(
                          children: List.generate(
                            _taskController.taskList.length,
                            (index) {
                              final task = _taskController.taskList[index];
                              final date = DateFormat.jm().parse(task.startTime!);
                              final myTime = DateFormat('HH:mm').format(date).toString();
                              final hour = int.parse(myTime.split(':').first);
                              final minute = int.parse(myTime.split(':').last);
                              NotifyHelper.scheduledNotification(hour, minute, task);
                              if (task.repeat == 'Daily' ||
                                  task.date == DateFormat.yMd().format(_selectedDate) ||
                                  task.repeat == 'Weekly' && DateFormat.yMd().parse(task.date!).weekday == _selectedDate.weekday ||
                                  task.repeat == 'Monthly' && DateFormat.yMd().parse(task.date!).day == _selectedDate.day) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 300),
                                    child: SlideAnimation(
                                      horizontalOffset: 300,
                                      child: FadeInAnimation(
                                        child: InkWell(
                                          onTap: () {
                                            showBottomSheet(task);
                                          },
                                          child: TaskTile(
                                            isCompleted: task.isCompleted == 1,
                                            color: task.realColor,
                                            startTime: task.startTime ?? '',
                                            endTime: task.endTime ?? '',
                                            title: task.title ?? '',
                                            body: task.body ?? '',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showBottomSheet(Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: SizeConfig.orientation == Orientation.landscape
            ? task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.5
                : SizeConfig.screenHeight * 0.8
            : task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.3
                : SizeConfig.screenHeight * 0.39,
        color: context.theme.colorScheme.background,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Get.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 20),
            if (task.isCompleted == 0)
              _buildBottomSheetElement(
                  label: 'Mark as completed',
                  onTap: () => {
                        _taskController.markTaskAsCompleted(task),
                        Get.back(),
                      },
                  color: primaryColor),
            _buildBottomSheetElement(
                label: 'Delete task',
                onTap: () => {
                      _taskController.deleteTask(task),
                      NotifyHelper.cancelNotification(task.id!),
                      Get.back(),
                    },
                color: Colors.red.shade300),
            const Divider(color: Colors.grey),
            _buildBottomSheetElement(label: 'Cancel', onTap: () => Get.back(), color: primaryColor),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetElement({required String label, required void Function() onTap, required Color color, bool isClose = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : color,
          ),
          borderRadius: BorderRadius.circular(20.0),
          color: isClose ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(label, style: isClose ? titleStyle : titleStyle.copyWith(color: white)),
        ),
      ),
    );
  }
}
