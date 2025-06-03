import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/services/network/api_endpoints.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/management_buttons_menu.dart';
import '../../../../controllers/exam.dart';
import 'exam.dart';
import '../../error_illustration.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/three_bounce.dart';

class ExamTypesScreen extends StatefulWidget {
  const ExamTypesScreen({super.key});

  @override
  State<ExamTypesScreen> createState() => _ExamTypesScreenState();
}

class _ExamTypesScreenState extends State<ExamTypesScreen> {
  Duration duration = const Duration(seconds: 5);
  bool minimumLoadTimeCompleted = false;
  late ExamController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ExamController>();
    _loadData();
  }

  void _loadData() {
    controller.isLoading.value = true;

    Future.wait([
      Future.delayed(duration),
      controller.getData(ApiEndpoints.getExams),
    ]).then((_) {
      if (mounted) {
        //why check if mounted? bcs the method is being called in the init state method + the future method
        // and bcs it is async by the time the 2 future methods are completed the widget might be disposed
        controller.isLoading.value = false;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    Get.delete<ExamController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TopButtons(),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: ThreeBounce());
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return ErrorIllustration(
                illustrationPath: 'assets/illustration/bad-connection.svg',
                title: 'Connection Error',
                message: controller.errorMessage.value,
                onRetry: _loadData,
              );
            }

            if (controller.exams.isEmpty) {
              return ErrorIllustration(
                illustrationPath: 'assets/illustration/empty-box.svg',
                title: 'No Students Found',
                message:
                    'There are no students registered yet. Click the add button to create one.',
              );
            }

            return ExamGrid(
              data: controller.exams,
              onRefresh: () {
                _loadData();
                return controller.getData(ApiEndpoints.getStudents);
              },
              onDelete: (id) => controller.postDelete(id),
            );
          }),
        ),
      ],
    );
  }
}
