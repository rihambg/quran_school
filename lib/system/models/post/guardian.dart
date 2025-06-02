import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/account_info.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/contact_info.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/guardian.dart';

import 'abstract_class.dart';

class GuardianInfoDialog extends AbstractClass {
  //info
  Guardian guardian = Guardian();
  AccountInfo accountInfo = AccountInfo();
  ContactInfo contactInfo = ContactInfo();

  GuardianInfoDialog();
  @override
  bool get isComplete {
    return guardian.firstName.isNotEmpty &&
        guardian.lastName.isNotEmpty &&
        guardian.relationship.isNotEmpty &&
        accountInfo.username.isNotEmpty &&
        accountInfo.passcode.isNotEmpty;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'info': guardian.toJson(),
      'contact_info': contactInfo.toJson(),
      'account_info': accountInfo.toJson(),
    };
  }

  GuardianInfoDialog.fromMap(Map<String, dynamic> map) {
    guardian = Guardian.fromJson(map['info']);
    contactInfo = ContactInfo.fromJson(map['contact_info']);
    accountInfo = AccountInfo.fromJson(map['account_info']);
  }
}
