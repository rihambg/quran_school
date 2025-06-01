import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/exam.dart';

class ExamTypesController extends GetxController {
  final RxList<Exam> exams = <Exam>[
    Exam(
      examId: 0,
      examNameAr: 'الاختبار الشهري',
      examNameEn: 'Test 1',
      examType: 'حفظ',
      examSucessMinPoint: 50,
      examMaxPoint: 100,
    ),
    Exam(
      examId: 1,
      examNameAr: 'الاختبار الشهري',
      examNameEn: 'Test 1',
      examType: 'تجويد',
      examSucessMinPoint: 50,
      examMaxPoint: 100,
    ),
  ].obs;
}

class ExamTypesScreen extends StatelessWidget {
  ExamTypesScreen({super.key});

  final List<String> columns = [
    "الدرجة العظمى",
    "الدرجة الصغرى للنجاح",
    "نوع الاختبار"
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: GetX<ExamTypesController>(
                init: ExamTypesController(),
                builder: (controller) => Text(
                  'الاختبارات (${controller.exams.length})',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            body: Column(
              children: [
                TopButtons(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Header Row
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        color: Colors.teal,
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 4,
                              child: Center(
                                child: Text(
                                  'الاختبارات',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            ...columns.where((s) => s != "").map((column) {
                              return Expanded(
                                flex: 1,
                                child: Text(
                                  column,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      // Exam List
                      Expanded(
                        child: GetX<ExamTypesController>(
                          init: ExamTypesController(),
                          builder: (controller) => ListView.builder(
                            itemCount: controller.exams.length,
                            itemBuilder: (context, index) {
                              final exam = controller.exams[index];
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                color: index % 2 == 0
                                    ? Colors.grey[200]
                                    : Colors.white,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child:
                                          Center(child: Text(exam.examNameAr)),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                          child: Text(
                                              exam.examMaxPoint.toString())),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                          child: Text(exam.examSucessMinPoint
                                              .toString())),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(child: Text(exam.examType)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            // Add exam logic here
          },
          child: const Text('إضافة اختبار'),
        ),
        ElevatedButton(
          onPressed: () {
            // Edit exam logic here
          },
          child: const Text('تعديل اختبار'),
        ),
        ElevatedButton(
          onPressed: () {
            // Delete exam logic here
          },
          child: const Text('حذف اختبار'),
        ),
      ],
    );
  }
}
