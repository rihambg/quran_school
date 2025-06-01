import 'abstract_class.dart';

class Guardian extends AbstractClass {
  //info
  late String firstName;
  late String lastName;
  late String relationship;
  String? dateOfBirth;
  String? address;
  String? job;

  //account info
  late String email;
  late String phoneNumber;
  //contact info
  late String username;
  late String passcode;
  //account image
  String? imagePath;

  Guardian();
  @override
  bool get isComplete {
    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        relationship.isNotEmpty &&
        username.isNotEmpty &&
        passcode.isNotEmpty;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "info": {
        "first_name": firstName,
        "last_name": lastName,
        "relationship": relationship,
        "date_of_birth": dateOfBirth,
        "home_address": address,
        "job": job,
      },
      "account_info": {
        "username": username,
        "passcode": passcode,
        "profile_image": imagePath,
      },
      "contact_info": {
        "email": email,
        "phone_number": phoneNumber,
      }
    };
  }

  Guardian.fromMap(Map<String, dynamic> map) {
    firstName = map['info']['first_name'] ?? '';
    lastName = map['info']['last_name'] ?? '';
    relationship = map['info']['relationship'] ?? '';
    dateOfBirth = map['info']['date_of_birth'];
    address = map['info']['home_address'];
    job = map['info']['job'];

    email = map['contact_info']['email'] ?? '';
    phoneNumber = map['contact_info']['phone_number'] ?? '';

    username = map['account_info']['username'] ?? '';
    passcode = map['account_info']['passcode'] ?? '';
    imagePath = map['account_info']['profile_image'];
  }
}
