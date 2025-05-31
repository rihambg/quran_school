import 'package:flutter/material.dart';
import '../widgets/grids/students/student_show.dart';
import 'system_ui.dart';

class AddStudent extends StatelessWidget {
  const AddStudent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: SystemUI(
        title: "Students Management",
        child: StudentScreen(),
      ),
    );
  }
}
