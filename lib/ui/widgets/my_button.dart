import 'package:flutter/material.dart';
import 'package:todo/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  final String label;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 45,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primaryColor),
        alignment: Alignment.center,
        child: Text(label, style: bodyStyle.copyWith(color: white), textAlign: TextAlign.center),
      ),
    );
  }
}
