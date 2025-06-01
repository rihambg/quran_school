import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/model.dart';

class Lecture implements Model {
  final String id;
  final String lectureNameAr;
  final String lectureNameEn;
  final String circleType;
  final List<String> teacherIds;
  final int studentCount;

  Lecture({
    required this.id,
    required this.lectureNameAr,
    required this.lectureNameEn,
    required this.circleType,
    required this.teacherIds,
    required this.studentCount,
  });

  factory Lecture.fromJson(Map<String, dynamic> map) {
    return Lecture(
      id: map['lecture_id'].toString(),
      lectureNameAr: map['lecture_name_ar'] ?? '',
      lectureNameEn: map['lecture_name_en'] ?? '',
      circleType: map['circle_type'] ?? '',
      teacherIds: map['teacher_ids'] != null
          ? (map['teacher_ids'] as String)
              .split(',')
              .map((e) => e.trim())
              .toList()
          : [],
      studentCount: int.tryParse(map['student_count'].toString()) ?? 0,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'lecture_id': id,
      'lecture_name_ar': lectureNameAr,
      'lecture_name_en': lectureNameEn,
      'circle_type': circleType,
      'teacher_ids': teacherIds.join(','),
      'student_count': studentCount,
    };
  }
}
