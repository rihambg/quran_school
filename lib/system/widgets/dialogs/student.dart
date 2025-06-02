import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/guardian.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/lecture.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/model.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/services/network/api_endpoints.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dialogs/guardian.dart';
import '../timer.dart';
import '../custom_container.dart';
import '../input_field.dart';
import '../../../controllers/validator.dart';
import '../../models/post/student.dart';

import '../multiselect.dart';
import '../../utils/const/student.dart';
import '../../../controllers/generate.dart';
import '../drop_down.dart';
import '../../../controllers/submit_form.dart';
import '../picker.dart';
import '../image.dart';
import '../../../controllers/form_controller.dart' as form;

class LectureIdName implements Model {
  final int id;
  final String name;

  LectureIdName({required this.id, required this.name});

  factory LectureIdName.fromJson(Map<String, dynamic> json) {
    return LectureIdName(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class StudentDialog extends StatefulWidget {
  const StudentDialog({super.key});

  @override
  State<StudentDialog> createState() => _StudentDialogState();
}

class _StudentDialogState extends State<StudentDialog> {
  Future<void> loadData() async {
    try {
      final fetchedSessionNames =
          await getItems<Lecture>(ApiEndpoints.getLectures, Lecture.fromJson);
      final fetchedGuardianAccounts = await getItems<Guardian>(
          ApiEndpoints.getGuardianAccounts, Guardian.fromJson);

      dev.log('sessionNames: ${fetchedSessionNames.toString()}');
      dev.log('guardianAccounts: ${fetchedGuardianAccounts.toString()}');

      setState(() {
        sessionResult = fetchedSessionNames;
        guardianResult = fetchedGuardianAccounts;
      });
    } catch (e) {
      dev.log("Error loading data: $e");
    }
  }

  final GlobalKey<FormState> studentFormKey = GlobalKey<FormState>();

  late Generate generate;
  late form.FormController formController;
  final StudentInfoDialog studentInfo = StudentInfoDialog();

  bool isClicked = false;
  RxBool isExempt = false.obs;
  Rx<String?> enrollmentDate = Rxn<String>();
  Rx<String?> exitDate = Rxn<String>();

  MultiSelectResult<Lecture>? sessionResult;
  MultiSelectResult? guardianResult;
  late ScrollController scrollController;

  //picker
  late Picker imagePicker;
  @override
  void initState() {
    super.initState();
    generate = Get.find<Generate>();
    formController = Get.find<form.FormController>();
    formController.controllers[7].text = generate.generatePassword();
    scrollController = ScrollController();
    loadData();
  }

  RxBool isComplete = true.obs;

  @override
  void dispose() {
    scrollController.dispose();
    formController.dispose();
    generate.dispose();
    Get.delete<Generate>();
    Get.delete<form.FormController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: Get.width * 0.7,
        maxHeight: Get.height * 0.8,
        minHeight: 400,
        minWidth: 300,
      ),
      child: Dialog(
        shape: BeveledRectangleBorder(),
        backgroundColor: colorScheme.surface,
        child: Scrollbar(
          controller: scrollController,
          child: Column(
            children: [
              //header
              Stack(children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.dstIn),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ClipRRect(
                    child: CustomImage(imagePath: "assets/back.png"),
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: colorScheme.onSurface,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ],
                )
              ]),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: studentFormKey,
                    child: Column(
                      children: [
                        // Session
                        CustomContainer(
                          headerIcon: Icons.book,
                          headerText: "session",
                          child: MultiSelect<Lecture>(
                            getPickedItems: (pickedItems) {
                              studentInfo.lectures =
                                  pickedItems.map((e) => e.obj).toList();
                            },
                            hintText: "search for sessions",
                            preparedData: sessionResult?.items ?? [],
                            maxSelectedItems: null,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Personal Info
                        CustomContainer(
                          headerIcon: Icons.person,
                          headerText: "Students' Personal Info",
                          child: Column(
                            children: [
                              // Name fields
                              Row(
                                children: [
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "First name in Arabic",
                                      child: CustomTextField(
                                        controller:
                                            formController.controllers[0],
                                        validator: (value) =>
                                            Validator.notEmptyValidator(
                                                value, "يجب ادخال الاسم"),
                                        focusNode: formController.focusNodes[0],
                                        onSaved: (p0) => studentInfo
                                            .personalInfo.firstNameAr = p0!,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "Last name in Arabic",
                                      child: CustomTextField(
                                        controller:
                                            formController.controllers[1],
                                        validator: (value) =>
                                            Validator.notEmptyValidator(
                                                value, "يجب ادخال الاسم"),
                                        focusNode: formController.focusNodes[1],
                                        onSaved: (p0) => studentInfo
                                            .personalInfo.lastNameAr = p0!,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Latin name fields
                              Row(
                                children: [
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "First name in Latin",
                                      child: CustomTextField(
                                        controller:
                                            formController.controllers[2],
                                        textDirection: TextDirection.ltr,
                                        onChanged: (_) => formController
                                                .controllers[6].text =
                                            generate.generateUsername(
                                                formController.controllers[2],
                                                formController.controllers[3]),
                                        onSaved: (p0) => studentInfo
                                            .personalInfo.firstNameEn = p0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "Last name in Latin",
                                      child: CustomTextField(
                                        controller:
                                            formController.controllers[3],
                                        textDirection: TextDirection.ltr,
                                        onChanged: (_) => formController
                                                .controllers[6].text =
                                            generate.generateUsername(
                                                formController.controllers[2],
                                                formController.controllers[3]),
                                        onSaved: (p0) => studentInfo
                                            .personalInfo.lastNameEn = p0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Sex and DOB
                              Row(
                                children: [
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "Sex",
                                      child: DropDownWidget(
                                        items: sex,
                                        initialValue: sex[0],
                                        onSaved: (p0) =>
                                            studentInfo.personalInfo.sex = p0!,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "Date of Birth",
                                      child: CustomTextField(
                                        controller:
                                            formController.controllers[4],
                                        onSaved: (p0) => studentInfo
                                            .personalInfo.dateOfBirth = p0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Nationality and Address
                              Row(
                                children: [
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "Place of Birth",
                                      child: CustomTextField(
                                        controller:
                                            formController.controllers[4],
                                        onSaved: (p0) => studentInfo
                                            .personalInfo.placeOfBirth = p0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "Address",
                                      child: CustomTextField(
                                        controller:
                                            formController.controllers[5],
                                        onSaved: (p0) => studentInfo
                                            .personalInfo.homeAddress = p0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "Nationality",
                                      child: DropDownWidget(
                                        items: nationalities,
                                        initialValue: nationalities[1],
                                        onSaved: (p0) => studentInfo
                                            .personalInfo.nationality = p0,
                                      ),
                                      /*CustomTextField(
                                        controller: validator.controllers[6],
                                        onSaved: (p0) =>
                                            studentInfo.nationality = p0!,
                                      ),*/
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Account Info
                        CustomContainer(
                          headerIcon: Icons.account_box,
                          headerText: "account info",
                          child: Row(
                            children: [
                              Expanded(
                                child: InputField(
                                  inputTitle: "username",
                                  child: CustomTextField(
                                    controller: formController.controllers[6],
                                    onSaved: (p0) =>
                                        studentInfo.accountInfo.username = p0!,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InputField(
                                  inputTitle: "password",
                                  child: CustomTextField(
                                    controller: formController.controllers[7],
                                    onSaved: (p0) =>
                                        studentInfo.accountInfo.passcode = p0!,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Health Info
                        CustomContainer(
                          headerIcon: Icons.health_and_safety,
                          headerText: "health info",
                          child: Row(
                            children: [
                              Expanded(
                                child: InputField(
                                  inputTitle: "blood type",
                                  child: DropDownWidget(
                                    items: bloodType,
                                    initialValue: null,
                                    onSaved: (p0) =>
                                        studentInfo.medicalInfo.bloodType = p0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InputField(
                                  inputTitle: "has disease",
                                  child: DropDownWidget(
                                    items: yesNo,
                                    initialValue: null,
                                    onSaved: (p0) =>
                                        studentInfo.medicalInfo.diseases = p0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InputField(
                                  inputTitle: "disease causes",
                                  child: CustomTextField(
                                    controller: formController.controllers[8],
                                    onSaved: (p0) => studentInfo
                                        .medicalInfo.diseasesCauses = p0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InputField(
                                  inputTitle: "allergies",
                                  child: CustomTextField(
                                    controller: formController.controllers[9],
                                    onSaved: (p0) =>
                                        studentInfo.medicalInfo.allergies = p0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Contact Info
                        CustomContainer(
                          headerIcon: Icons.phone,
                          headerText: "contact info",
                          child: Row(
                            children: [
                              Expanded(
                                child: InputField(
                                  inputTitle: "phone number",
                                  child: CustomTextField(
                                    controller: formController.controllers[10],
                                    validator: (value) =>
                                        Validator.isValidPhoneNumber(value),
                                    focusNode: formController.focusNodes[10],
                                    onSaved: (p0) => studentInfo
                                        .contactInfo.phoneNumber = p0!,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InputField(
                                  inputTitle: "email address",
                                  child: CustomTextField(
                                    controller: formController.controllers[11],
                                    validator: (value) =>
                                        Validator.isValidEmail(value),
                                    focusNode: formController.focusNodes[11],
                                    onSaved: (p0) =>
                                        studentInfo.contactInfo.email = p0!,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Parent Status
                        Row(
                          children: [
                            Expanded(
                              child: CustomContainer(
                                headerIcon: Icons.person,
                                headerText: "father state",
                                child: DropDownWidget(
                                  items: state,
                                  initialValue: state[0],
                                  onSaved: (p0) => studentInfo
                                      .personalInfo.fatherStatus = p0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomContainer(
                                headerIcon: Icons.person,
                                headerText: "mother state",
                                child: DropDownWidget(
                                  items: state,
                                  initialValue: state[0],
                                  onSaved: (p0) => studentInfo
                                      .personalInfo.motherStatus = p0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Guardian Info
                        CustomContainer(
                            headerIcon: Icons.family_restroom,
                            headerText: "info about guardian",
                            child: Column(children: [
                              // Name fields
                              Row(
                                children: [
                                  Expanded(
                                      child: InputField(
                                    inputTitle: "guardian's account",
                                    child: MultiSelect(
                                      getPickedItems: (pickedItems) {
                                        studentInfo
                                            .guardian.guardianId = pickedItems[
                                                0]
                                            .id; // Assuming only one guardian is selected
                                      },
                                      preparedData: guardianResult?.items ?? [],
                                      hintText: "search for guardian account",
                                      maxSelectedItems: 1,
                                    ),
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Obx(
                                      () => OutlinedButton(
                                        onPressed: () async {
                                          Get.dialog(GuardianDialog());
                                        },
                                        child: Text(enrollmentDate.value ??
                                            "Add Guardian"),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ])),
                        const SizedBox(height: 10),

                        // Subscription Info
                        CustomContainer(
                          headerText: "subscription information",
                          headerIcon: Icons.subscriptions,
                          child: Column(
                            children: [
                              Row(children: [
                                Expanded(
                                  child: InputField(
                                    inputTitle: "enrollment date",
                                    child: Obx(
                                      () => OutlinedButton(
                                        onPressed: () async {
                                          await dateSelector(Get.context!)
                                              .then((value) {
                                            if (value != null) {
                                              enrollmentDate.value = value;
                                              studentInfo.subscriptionInfo
                                                  .enrollmentDate = value;
                                            }
                                          });
                                        },
                                        child: Text(enrollmentDate.value ??
                                            "select date"),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InputField(
                                    inputTitle: "is exempt from payment",
                                    child: DropDownWidget<bool>(
                                      items: trueFalse,
                                      initialValue: trueFalse[1],
                                      onChanged: (p0) {
                                        isExempt.value = p0!;
                                        dev.log("isExempt: $isExempt");
                                      },
                                      onSaved: (p0) => studentInfo
                                          .subscriptionInfo
                                          .isExemptFromPayment = p0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: InputField(
                                    inputTitle: "exemption percentage",
                                    child: Obx(
                                      () => AbsorbPointer(
                                        absorbing: !isExempt.value,
                                        child: Opacity(
                                          opacity: isExempt.value ? 1.0 : 0.5,
                                          child: DropDownWidget<double>(
                                            items: exemptionPercentage,
                                            initialValue: isExempt.value
                                                ? studentInfo.subscriptionInfo
                                                    .exemptionPercentage
                                                : null,
                                            onChanged: (p0) {
                                              studentInfo.subscriptionInfo
                                                      .exemptionPercentage =
                                                  isExempt.value ? p0 : null;
                                            },
                                            onSaved: (p0) => studentInfo
                                                .subscriptionInfo
                                                .exemptionPercentage = p0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 8),
                              Row(children: [
                                Expanded(
                                  child: InputField(
                                    inputTitle: "exit date",
                                    child: Obx(
                                      () => OutlinedButton(
                                        onPressed: () async {
                                          await dateSelector(Get.context!)
                                              .then((value) {
                                            if (value != null) {
                                              exitDate.value = value;
                                              studentInfo.subscriptionInfo
                                                  .exitDate = value;
                                            }
                                          });
                                        },
                                        child: Text(
                                            exitDate.value ?? "select date"),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InputField(
                                    inputTitle: "exit reason",
                                    child: CustomTextField(
                                      controller:
                                          formController.controllers[12],
                                      onSaved: (p0) => studentInfo
                                          .subscriptionInfo.exitReason = p0,
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                              ])
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Formal Education
                        CustomContainer(
                          headerText: "formal education",
                          headerIcon: Icons.school,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "school type",
                                      child: DropDownWidget(
                                        items: schoolType,
                                        initialValue: null,
                                        onSaved: (p0) => studentInfo
                                            .formalEducationInfo
                                            .schoolType = p0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "school name",
                                      child: CustomTextField(
                                        controller:
                                            formController.controllers[13],
                                        onSaved: (p0) => studentInfo
                                            .formalEducationInfo
                                            .schoolName = p0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "academic level",
                                      child: DropDownWidget(
                                        items: academicLevel,
                                        onSaved: (p0) => studentInfo
                                            .formalEducationInfo
                                            .academicLevel = p0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: InputField(
                                      inputTitle: "grade",
                                      child: DropDownWidget(
                                        items: grades,
                                        onSaved: (p0) => studentInfo
                                            .formalEducationInfo.grade = p0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Image
                        CustomContainer(
                          headerIcon: Icons.image,
                          headerText: "add account image",
                          child: OutlinedButton(
                            onPressed: () {
                              imagePicker;
                            },
                            child: Text("pick image"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Submit button
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      isComplete.value = false;
                      final success = await submitForm<StudentInfoDialog>(
                          studentFormKey,
                          studentInfo,
                          ApiEndpoints.submitStudentForm,
                          StudentInfoDialog.fromJson);
                      if (success) {
                        Get.back(); // Close the dialog
                      }
                      isComplete.value = true;
                    },
                    child: Obx(() => isComplete.value
                        ? Text('Submit')
                        : CircularProgressIndicator()),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
