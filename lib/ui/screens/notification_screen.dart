import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
    required this.taskName,
    required this.description,
    required this.date,
  }) : super(key: key);

  final String taskName;
  final String description;
  final String date;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text('Hello, Mohamed', style: context.theme.textTheme.headline4?.copyWith(color: Get.isDarkMode ? white : darkGreyColor), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Text('You have a new reminder', style: context.theme.textTheme.bodyText1?.copyWith(color: Get.isDarkMode ? white : darkGreyColor), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: context.theme.backgroundColor, borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: SingleChildScrollView(
                child: Text('${widget.taskName}\n\n${widget.description}\n\n${widget.date}', style: context.theme.textTheme.bodyText1?.copyWith(color: white), textAlign: TextAlign.center),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
