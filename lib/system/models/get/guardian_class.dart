import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/model.dart';

class Guardian implements Model {
  final String id;
  final String lastName;
  final String firstName;
  final String dateOfBirth;
  final String relationship;
  final String phoneNumber;
  final String email;
  String? guardianAccount;
  List<String>? children;

  @override
  Map<String, dynamic> toJson() {
    return {
      'guardian_id': id,
      'lastName': lastName,
      'first_name': firstName,
      'date_of_birth': dateOfBirth,
      'relationship': relationship,
      'phone_number': phoneNumber,
      'email': email,
      'guardian_account': guardianAccount,
      'children': children?.join(',') ?? '',
    };
  }

  Guardian({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.dateOfBirth,
    required this.relationship,
    required this.phoneNumber,
    required this.email,
    this.guardianAccount,
    this.children,
  });

  factory Guardian.fromJson(Map<String, dynamic> map) {
    // Handle children: empty string → empty list or null
    List<String>? parsedChildren;
    final rawChildren = map['children'];
    if (rawChildren != null &&
        rawChildren is String &&
        rawChildren.trim().isNotEmpty) {
      parsedChildren = rawChildren.split(',').map((e) => e.trim()).toList();
    }

    return Guardian(
      id: map['id'].toString(),
      lastName: map['lastName'] ?? '',
      firstName: map['firstName'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      relationship: map['relationship'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      email: map['email'] ?? '',
      guardianAccount: map['guardianAccount'],
      children: parsedChildren,
    );
  }
}
