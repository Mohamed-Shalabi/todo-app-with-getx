import 'package:flutter/material.dart';
import 'package:todo/ui/theme.dart';

class TaskTile extends StatelessWidget {
  //
  const TaskTile({Key? key, required this.isCompleted, required this.color, required this.startTime, required this.endTime, required this.title, required this.body}) : super(key: key);

  final bool isCompleted;
  final Color color;
  final String startTime;
  final String endTime;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: subHeadingStyle.copyWith(color: white)),
                const SizedBox(height: 8.0),
                Text('$startTime - $endTime', style: subTitleStyle.copyWith(color: white)),
                const SizedBox(height: 8.0),
                Text(body, style: bodyStyle.copyWith(color: white)),
              ],
            ),
          ),
          const VerticalDivider(color: white, thickness: 2.0),
          RotatedBox(quarterTurns: 3, child: Text(isCompleted ? 'completed' : 'TODO', style: body2Style.copyWith(color: white))),
        ],
      ),
    );
  }
}
