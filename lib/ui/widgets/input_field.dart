import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField({Key? key, required this.title, required this.hint, this.controller, this.suffix, this.validator, this.enabled = true}) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: titleStyle),
        Container(
          decoration: BoxDecoration(border: Border.all(color: context.theme.colorScheme.onSurface, width: 1.0), borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: validator,
                    enabled: enabled,
                    style: bodyStyle.copyWith(color: context.theme.colorScheme.onSurface),
                    decoration: InputDecoration(border: InputBorder.none, hintText: hint, hintStyle: subTitleStyle.copyWith(color: context.theme.colorScheme.onSurface)),
                    controller: controller,
                  ),
                ),
                suffix ?? const SizedBox(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
