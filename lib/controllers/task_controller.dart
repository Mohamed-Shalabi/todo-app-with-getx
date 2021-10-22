import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';

class TaskController extends GetxController {
  //
  final taskList = <Task>[].obs;

  void getTasks() async {
    final tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((e) => Task.fromMap(e)));
  }

  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void markTaskAsCompleted(Task task) async {
    await DBHelper.updateAsCompleted(task);
    getTasks();
  }

  void addTask({required Task task}) async {
    await DBHelper.insert(task);
    getTasks();
  }

  Task? getFirstTask() {
    if (taskList.isEmpty) return null;
    var firstTask = taskList[0];
    for (final task in taskList) {
      if (DateFormat.yMd().parse(task.date!).isBefore(DateFormat.yMd().parse(firstTask.date!))) {
        firstTask = task;
      }
    }
    return firstTask;
  }

  void deleteAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }
}
