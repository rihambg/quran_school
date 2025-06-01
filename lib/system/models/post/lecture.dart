import 'abstract_class.dart';

class Lecture extends AbstractClass {
  //lecture info
  //required
  late String lectureNameAr;
  late String lectureNameEn;
  late String circleType;
  late List<int> teachersId;
  late int showOnwebsite; //TODO bool
  late String category; //drop down

  //lecture schedule
  Map<String, Map<String, dynamic>>? schedule;

  static var fromJson = (Map<String, dynamic> json) {
    return Lecture()
      ..lectureNameAr = json['info']['lecture_name_ar'] ?? ''
      ..lectureNameEn = json['info']['lecture_name_en'] ?? ''
      ..circleType = json['info']['circle_type'] ?? ''
      ..category = json['info']['category'] ?? ''
      ..teachersId = List<int>.from(json['info']['teacher_ids'] ?? [])
      ..showOnwebsite = json['info']['show_on_website'] ?? 0
      ..schedule = json['schedule'] != null
          ? Map<String, Map<String, dynamic>>.from(json['schedule'])
          : null;
  };

  @override
  bool get isComplete {
    return lectureNameAr.isNotEmpty &&
        lectureNameEn.isNotEmpty &&
        circleType.isNotEmpty &&
        teachersId.isNotEmpty &&
        schedule != null;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "info": {
        "lecture_name_ar": lectureNameAr,
        "lecture_name_en": lectureNameEn,
        "circle_type": circleType,
        "category": category,
        "teacher_ids": teachersId,
        "show_on_website": showOnwebsite
      },
      "schedule": schedule,
    };
  }
}
