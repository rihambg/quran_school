import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/exam.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/services/network/api_endpoints.dart';

class ExamController extends GetxController {
  RxnInt lectureId = RxnInt();
  RxString date = ''.obs;
  RxList<Exam> exams = <Exam>[].obs;
  RxBool isLoading = true.obs;
  RxBool isrequestCompleted = false.obs;
  RxString errorMessage = ''.obs;

  void setDate(String newDate) {
    date.value = newDate;
  }

  Future<void> getData(String fetchUrl, {VoidCallback? onFinished}) async {
    try {
      errorMessage.value = '';
      final result =
          await ApiService.fetchList<Exam>(fetchUrl, (Exam.fromJson));
      if (result.isEmpty) {
        errorMessage.value = 'No students found';
      } else {
        errorMessage.value = '';
        exams.value = result;
      }
    } catch (e) {
      errorMessage.value =
          'Failed to connect to server. Please check your connection.';
      exams.clear();
    } finally {
      onFinished?.call(); // Wait for timer before turning off loading
    }
  }

  Future<void> postDelete(int id) async {
    try {
      await ApiService.delete(ApiEndpoints.getExamById(id));
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server');
    }
  }
}
