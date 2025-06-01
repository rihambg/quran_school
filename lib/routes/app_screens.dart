import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/exam_management.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/exams/exam_types.dart';
import '../system/screens/copy.dart';
import '../bindings/copy.dart';
import '../system/screens/add_student.dart';
import '../bindings/student.dart';
import '../system/screens/add_guardian.dart';
import '../bindings/guardian.dart';
import '../system/screens/add_lecture.dart';
import '../bindings/lecture.dart';
import '../system/screens/add_acheivement.dart';
import '../bindings/acheivement.dart';
import '../testpage.dart';
import '../bindings/theme.dart';
import '../system/screens/login.dart';
import '../system/widgets/attendance/attendance.dart';
import '../bindings/attendance.dart';

class Routes {
  static const test = '/test';
  static const copy = '/copy';
  static const logIn = '/logIn';
  static const addStudent = '/add_student';
  static const addGuardian = '/add_guardian';
  static const addLecture = '/add_lecture';
  static const addAcheivement = '/add_acheivement';
  static const Attendance = '/Attendance';

  static const examPage = '/exams';
  static const examRrcords = '/exams/records';
  static const examResultsNotes = '/exams/notes';
  static const examTypes = '/exams/types';
  static const examTeachers = '/exams/teachers';

  static const String financialManagement = '/financial_management';
}

class AppScreens {
  static final routes = [
    GetPage(
      name: Routes.copy,
      page: () => CopyPage(),
      binding: CopyBinding(),
    ),
    GetPage(
      name: Routes.addStudent,
      page: () => AddStudent(),
      binding: StudentBinding(),
    ),
    GetPage(
      name: Routes.addGuardian,
      page: () => AddGuardian(),
      binding: GuardianBinding(),
    ),
    GetPage(
      name: Routes.addLecture,
      page: () => AddLecture(),
      binding: LectureBinding(),
    ),
    GetPage(
      name: Routes.addAcheivement,
      page: () => AddAcheivement(),
      binding: AcheivementBinding(),
    ),
    GetPage(
      name: Routes.copy,
      page: () => CopyPage(),
      binding: CopyBinding(),
    ),
    GetPage(
      name: Routes.test,
      page: () => TestPage(),
      binding: ThemeBinding(),
    ),
    GetPage(
      name: Routes.logIn,
      page: () => LogInPage(),
      //  binding:,
    ),
    GetPage(
      name: Routes.Attendance,
      page: () => AttendanceScreen(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: Routes.examPage,
      page: () => ExamPage(),
    ),
    GetPage(
      name: Routes.examTypes,
      page: () => ExamTypesScreen(),
    ),
    GetPage(
      name: Routes.financialManagement,
      page: () => TestPage(), // Placeholder for financial management screen
      binding: ThemeBinding(), // Replace with actual binding when available
    ),
  ];
}
