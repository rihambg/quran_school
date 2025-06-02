import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String baseUrl = dotenv.env['DB_REST_API_URL'] ??
      'http://192.168.100.50/quran/ahl_quran_backend/api/v1';

  // AccountInfo endpoints
  static final String getAccountInfos = '$baseUrl/accountinfos';
  static String getAccountInfoById(int id) => '$baseUrl/accountinfos/$id';

  // Appreciation endpoints
  static final String getAppreciations = '$baseUrl/appreciations';
  static String getAppreciationById(int id) => '$baseUrl/appreciations/$id';

  // ContactInfo endpoints
  static final String getContactInfos = '$baseUrl/contactinfos';
  static String getContactInfoById(int id) => '$baseUrl/contactinfos/$id';

  // Exam endpoints
  static final String getExams = '$baseUrl/exams';
  static String getExamById(int id) => '$baseUrl/exams/$id';

  // ExamLevel endpoints
  static final String getExamLevels = '$baseUrl/examlevels';
  static String getExamLevelById(int id) => '$baseUrl/examlevels/$id';

  // ExamStudent endpoints
  static final String getExamStudents = '$baseUrl/examstudents';
  static String getExamStudentById(int examId, int studentId) =>
      '$baseUrl/examstudents/exams/$examId/students/$studentId';

  // ExamTeacher endpoints
  static final String getExamTeachers = '$baseUrl/examteachers';
  static String getExamTeacherById(int examId, int teacherId) =>
      '$baseUrl/examteachers/exams/$examId/teachers/$teacherId';

  // FormalEducationInfo endpoints
  static final String getFormalEducationInfos = '$baseUrl/formaleducationinfos';
  static String getFormalEducationInfoById(int id) =>
      '$baseUrl/formaleducationinfos/$id';

  // GoldenRecord endpoints
  static final String getGoldenRecords = '$baseUrl/goldenrecords';
  static String getGoldenRecordById(int id) => '$baseUrl/goldenrecords/$id';

  // Guardian endpoints
  static final String getGuardians = '$baseUrl/guardians';
  static String getGuardianById(int id) => '$baseUrl/guardians/$id';

  // LectureContent endpoints
  static final String getLectureContents = '$baseUrl/lecturecontents';
  static String getLectureContentById(int id) => '$baseUrl/lecturecontents/$id';

  // Lecture endpoints
  static final String getLectures = '$baseUrl/lectures';
  static String getLectureById(int id) => '$baseUrl/lectures/$id';

  // LectureStudent endpoints
  static final String getLectureStudents = '$baseUrl/lecturestudents';
  static String getLectureStudentById(int lectureId, int studentId) =>
      '$baseUrl/lecturestudents/lectures/$lectureId/students/$studentId';

  // LectureTeacher endpoints
  static final String getLectureTeachers = '$baseUrl/lectureteachers';
  static String getLectureTeacherById(int lectureId, int teacherId) =>
      '$baseUrl/lectureteachers/lectures/$lectureId/teachers/$teacherId';

  // MedicalInfo endpoints
  static final String getMedicalInfos = '$baseUrl/medicalinfos';
  static String getMedicalInfoById(int id) => '$baseUrl/medicalinfos/$id';

  // PersonalInfo endpoints
  static final String getPersonalInfos = '$baseUrl/personalinfos';
  static String getPersonalInfoById(int id) => '$baseUrl/personalinfos/$id';

  // RequestCopy endpoints
  static final String getRequestCopys = '$baseUrl/requestcopys';
  static String getRequestCopyById(int id) => '$baseUrl/requestcopys/$id';

  // Student endpoints
  static final String getStudents = '$baseUrl/special/students';
  static String getStudentById(int id) => '$baseUrl/students/$id';

  // SubscriptionInfo endpoints
  static final String getSubscriptionInfos = '$baseUrl/subscriptioninfos';
  static String getSubscriptionInfoById(int id) =>
      '$baseUrl/subscriptioninfos/$id';

  // Supervisor endpoints
  static final String getSupervisors = '$baseUrl/supervisors';
  static String getSupervisorById(int id) => '$baseUrl/supervisors/$id';

  // Teacher endpoints
  static final String getTeachers = '$baseUrl/teachers';
  static String getTeacherById(int id) => '$baseUrl/teachers/$id';

  // TeamAccomplishment endpoints
  static final String getTeamAccomplishments = '$baseUrl/teamaccomplishments';
  static String getTeamAccomplishmentById(int id) =>
      '$baseUrl/teamaccomplishments/$id';

  // TeamAccomplishmentStudent endpoints
  static final String getTeamAccomplishmentStudents =
      '$baseUrl/teamaccomplishmentstudents';
  static String getTeamAccomplishmentStudentById(int teamId, int studentId) =>
      '$baseUrl/teamaccomplishmentstudents/teamaccomplishments/$teamId/students/$studentId';

  // WeeklySchedule endpoints
  static final String getWeeklySchedules = '$baseUrl/weeklyschedules';

  static String getLatestAchievements = '$baseUrl/achievements/latest';

  static String getGuardianAccounts = '$baseUrl/guardians';

  static String getLectureIdName = '$baseUrl/lectures/ar_name-and-id';

  static String getStudentAchievements = '$baseUrl/achievements';

  static String getSpecialAchievements = '$baseUrl/special/achievements';

  static String submitStudentForm = '$baseUrl/special/students/submit';
  static String getWeeklyScheduleById(int id) => '$baseUrl/weeklyschedules/$id';

  static String getStudentsByLecture(int idLecture) =>
      '$baseUrl/lecturestudents/lectures/$idLecture/students';
}
