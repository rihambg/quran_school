import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'system_ui.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  OverlayEntry? overlayEntry;
  RxnInt id = RxnInt();

  @override
  void initState() {
    super.initState();
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final scaffoldBackgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: SystemUI(
        title: "Exam Management",
        child: Card(
          child: GridView(
            padding: const EdgeInsets.all(40.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 40.0,
              crossAxisSpacing: 40.0,
              childAspectRatio: 6,
            ),
            children: [
              ExamButton(
                  title: "سجل الاختبارات",
                  icon: Icons.list,
                  onPressed: () {
                    Get.toNamed('/exams/records');
                  }),
              ExamButton(
                  title: "تقديرات الاختبارات",
                  icon: Icons.list,
                  onPressed: () {
                    Get.toNamed('/exams/notes');
                  }),
              ExamButton(
                  title: "ادارة لجنة الاختبارات",
                  icon: Icons.list,
                  onPressed: () {
                    Get.toNamed('/exams/teachers');
                  }),
              ExamButton(
                  title: "انواع الاختبارات",
                  icon: Icons.list,
                  onPressed: () {
                    Get.toNamed('/exams/types');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const ExamButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff169b88),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(40.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 16),
          Icon(icon, size: 40),
        ],
      ),
    );
  }
}
