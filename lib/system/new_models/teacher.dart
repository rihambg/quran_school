import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/model.dart';
class Teacher implements Model {
 dynamic teacherId;
 dynamic workHours;
 dynamic teacherContactId;
 dynamic teacherAccountId;
 dynamic firstName;
 dynamic lastName;
 dynamic profileImage;

  Teacher({
    this.teacherId,
    this.workHours,
    this.teacherContactId,
    this.teacherAccountId,
    this.firstName,
    this.lastName,
    this.profileImage,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    teacherId: json['teacher_id'],
    workHours: json['work_hours'],
    teacherContactId: json['teacher_contact_id'],
    teacherAccountId: json['teacher_account_id'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    profileImage: json['profile_image'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'teacher_id': teacherId,
    'work_hours': workHours,
    'teacher_contact_id': teacherContactId,
    'teacher_account_id': teacherAccountId,
    'first_name': firstName,
    'last_name': lastName,
    'profile_image': profileImage,
  };
}

