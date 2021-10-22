import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/input_field.dart';
import 'package:todo/ui/widgets/my_button.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  //
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _taskController = Get.put(TaskController());

  var _selectedDate = DateTime.now();
  var _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  var _endTime = DateFormat('hh:mm a').format(DateTime.now().add(const Duration(minutes: 15))).toString();

  var _selectedRemind = 5;
  final _remindList = [5, 10, 15, 20, 25];
  var _selectedRepeat = 'None';
  final _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  final _colorMap = <Color, bool>{pinkColor: true, primaryColor: false, orangeColor: false};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorMap.keys.where((color) => _colorMap[color] ?? true).first,
        title: Text('Add Task', style: headingStyle.copyWith(color: white)),
        centerTitle: true,
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: MyButton(
          label: 'Add Task',
          onTap: () {
            _validateData();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 30),
                InputField(title: 'Title', hint: 'Write the title', controller: _titleController),
                const SizedBox(height: 20),
                InputField(title: 'Body', hint: 'Write the body', controller: _bodyController),
                const SizedBox(height: 20),
                InputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(_selectedDate),
                  suffix: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.grey),
                    onPressed: () {
                      getDateFromUser();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        title: 'Start Time',
                        hint: _startTime,
                        enabled: false,
                        suffix: IconButton(
                          icon: const Icon(Icons.watch_later_outlined, color: Colors.grey),
                          onPressed: () {
                            getTimeFromUser(isStartTime: true);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InputField(
                        title: 'End Time',
                        hint: _endTime,
                        enabled: false,
                        suffix: IconButton(
                          icon: const Icon(Icons.watch_later_outlined, color: Colors.grey),
                          onPressed: () {
                            getTimeFromUser(isStartTime: false);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                InputField(
                  title: 'Remind',
                  hint: '$_selectedRemind minutes early',
                  enabled: false,
                  suffix: DropdownButton<int>(
                    items: _remindList.map((remindMinutes) => DropdownMenuItem(value: remindMinutes, child: Text(remindMinutes.toString()))).toList(),
                    underline: const SizedBox(),
                    style: subTitleStyle,
                    onChanged: (value) => setState(() => _selectedRemind = value ?? 5),
                  ),
                ),
                const SizedBox(height: 20),
                InputField(
                  title: 'Repeat',
                  hint: _selectedRepeat,
                  enabled: false,
                  suffix: DropdownButton<String>(
                    items: _repeatList.map((repeat) => DropdownMenuItem(value: repeat, child: Text(repeat))).toList(),
                    underline: const SizedBox(),
                    style: subTitleStyle,
                    onChanged: (value) => setState(() => _selectedRepeat = value ?? 'None'),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  for (final color in _colorMap.keys)
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _colorMap.forEach((key, value) => _colorMap[key] = false);
                              _colorMap[color] = true;
                            });
                          },
                          child: Stack(
                            children: [
                              Container(width: 30, height: 30, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15))),
                              if (_colorMap[color] ?? false) const Icon(Icons.check, color: white, size: 30),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateData() {
    debugPrint(_titleController.text);
    debugPrint(_bodyController.text);
    if (_titleController.text.trim().isNotEmpty && _bodyController.text.trim().isNotEmpty) {
      _addTaskToDatabase();
      Get.back();
    } else {
      Get.snackbar('Required', 'All fields are required.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _addTaskToDatabase() {
    _taskController.addTask(
      task: Task(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _colorMap[pinkColor]!
            ? 0
            : _colorMap[primaryColor]!
                ? 1
                : 2,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
  }

  void getDateFromUser() async {
    final pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(DateTime.now().year),
          lastDate: DateTime(DateTime.now().year + 15),
        ) ??
        _selectedDate;
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void getTimeFromUser({required bool isStartTime}) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? TimeOfDay.fromDateTime(DateTime.now()) : TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15))),
    );
    setState(() {
      if (pickedTime != null) {
        isStartTime ? _startTime = pickedTime.format(context) : _endTime = pickedTime.format(context);
      }
    });
  }
}
