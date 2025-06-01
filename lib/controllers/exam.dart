import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/exam.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/services/api_client.dart';
import '/system/services/network/api_endpoints.dart';
import 'package:flutter/material.dart';

class ExamController extends GetxController {
  RxnInt lectureId = RxnInt();
  RxString date = ''.obs;
  RxList<Exam> achievementList = <Exam>[].obs;
  RxBool isLoading = true.obs;
  RxBool isrequestCompleted = false.obs;
  RxString errorMessage = ''.obs;

  void setLectureId(int? id) {
    if (id == null) return;
    lectureId.value = id;
    fetchData();
  }

  void setDate(String newDate) {
    date.value = newDate;
  }

  Future<void> fetchData({VoidCallback? onFinished}) async {
    errorMessage.value = '';

    try {
      final result = await ApiService.fetchList<Exam>(
          ApiEndpoints.getExams, Exam.fromJson);

      if (result.isNotEmpty) {
        isrequestCompleted.value = true;
        achievementList.value = result;
      } else {
        isrequestCompleted.value = true;
        errorMessage.value = 'Unknown error fetching students';
      }
    } catch (e) {
      isrequestCompleted.value = true;
      errorMessage.value =
          'Failed to connect to server. Please check your connection.';
    } finally {
      onFinished?.call();
    }
  }
}
