import 'package:flutter/material.dart';

//import '/widgets/custom_text_form_feild.dart';
class InputField extends StatelessWidget {
  final String inputTitle;
  final Widget child;

  const InputField({
    required this.inputTitle,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          inputTitle,
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        child
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  // labelText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final TextDirection textDirection;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.onSaved,
    this.validator,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.textDirection = TextDirection.rtl,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      onChanged: onChanged,
      onSaved: onSaved,
      keyboardType: keyboardType,
      textDirection: textDirection,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
        hoverColor: Theme.of(context).inputDecorationTheme.hoverColor,
      ),
      style: TextStyle(
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
    );
  }
}

/*Widget TextField(
    {String? Function(String?)? validator,
    TextEditingController controller,
    TextAlign textAlign,
    TextDirection textDirection}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    textDirection: textDirection,
    textAlign: textAlign,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      enabledBorder: borderStyle,
      focusedBorder: borderStyle,
    ),
    style: const TextStyle(
      color: Color(0xffceaa63),
    ),
  );
}*/

Future function(BuildContext context) async {
  DateTime? time;
  await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  ).then((value) {
    time = value;
    return dateToString(time);
  });
}

String dateToString(DateTime? time) {
  if (time == null) {
    return "";
  } else {
    return time.toString(); //formattedDate(time);
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          await function(context);
        },
        child: Text("pick date"));
  }
}
