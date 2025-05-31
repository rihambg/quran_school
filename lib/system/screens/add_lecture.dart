import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/grids/lectures/lecture_show.dart';
import 'system_ui.dart';
import '../../controllers/lecture.dart';

class AddLecture extends StatelessWidget {
  const AddLecture({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LectureController>();
    final theme = Theme.of(context);
    final scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: SystemUI(
        title: "Lectures Management",
        child: LectureShow(
          controller: controller,
        ),
      ),
    );
  }
}
