import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/services/api_client.dart';

import '../system/models/post/abstract_class.dart';

Future<bool> submitForm<T>(
  GlobalKey<FormState> formKey,
  AbstractClass obj,
  String url,
  T Function(Map<String, dynamic>) fromJson,
) async {
  if (!formKey.currentState!.validate()) return false;

  formKey.currentState!.save();

  if (!obj.isComplete) {
    Get.snackbar('Error', 'Please complete all required fields');
    return false;
  }

  try {
    await ApiService.post<T>(url, obj as Map<String, dynamic>, fromJson);
    Get.snackbar('Success', 'Form submitted successfully');
    return true;
  } catch (e) {
    Get.snackbar('Error', 'Failed to submit form - ${e.toString()}');
    return false;
  }
}
//
