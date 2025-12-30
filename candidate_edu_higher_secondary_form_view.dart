import 'package:bgc_mobile/Candidate/Dashboard/view/candidate_education_details_view.dart';
import 'package:bgc_mobile/Candidate/Dashboard/viewmodel/candidate_education_form_viewmodel.dart';
import 'package:bgc_mobile/Login/View/change_password_view.dart';
import 'package:bgc_mobile/Utils/appbar_util.dart';
import 'package:bgc_mobile/Utils/color_constraints.dart';
import 'package:bgc_mobile/Utils/elevated_button_util.dart';
import 'package:bgc_mobile/Utils/show_dailog_util.dart';
import 'package:bgc_mobile/Utils/static_text.dart';
import 'package:bgc_mobile/Utils/tap_gesture_textfield.dart';
import 'package:bgc_mobile/Utils/textfeild_util.dart';
import 'package:bgc_mobile/Utils/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class CandidateHigherSecondaryFormView extends StatefulWidget {
  final String category;
  const CandidateHigherSecondaryFormView({super.key, required this.category});

  @override
  State<CandidateHigherSecondaryFormView> createState() =>
      _CandidateHigherSecondaryFormViewState();
}

class _CandidateHigherSecondaryFormViewState
    extends State<CandidateHigherSecondaryFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController interCity = TextEditingController();
  TextEditingController interEnrollmentNo = TextEditingController();
  TextEditingController interInstituteName = TextEditingController();
  TextEditingController interSpecialization = TextEditingController();
  TextEditingController interDegree = TextEditingController();
  TextEditingController interYearofenrollment = TextEditingController();
  TextEditingController interYearofpassout = TextEditingController();
  TextEditingController interCountry = TextEditingController();
  TextEditingController interState = TextEditingController();
  TextEditingController interPincode = TextEditingController();
  TextEditingController interAddress = TextEditingController();
  TextEditingController interCrtfile = TextEditingController();
  TextEditingController interEducationProof = TextEditingController();
  final specializationFieldKey = GlobalKey<FormFieldState>();
  final interenrollFieldKey = GlobalKey<FormFieldState>();
  final interpassoutFieldKey = GlobalKey<FormFieldState>();
  final interProofFieldKey = GlobalKey<FormFieldState>();
  final pincodeFieldKey = GlobalKey<FormFieldState>();
  bool pinCodeTouched = false;
  final pinCodeFocusNode = FocusNode();
  bool _keyboardWasActive = false;

  void _handleBack(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      FocusScope.of(context).unfocus();
      _keyboardWasActive = true;
    } else if (_keyboardWasActive) {
      _keyboardWasActive = false;
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();

    pinCodeFocusNode.addListener(() {
      if (!pinCodeFocusNode.hasFocus && !pinCodeTouched) {
        setState(() {
          pinCodeTouched = true;
        });
        pincodeFieldKey.currentState?.validate();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      
        if (!mounted) return;
        final viewModel = Provider.of<CandidateEducationFormViewModel>(context,
            listen: false);
        viewModel.clearState();
        await viewModel.fetchHigherSecondaryDetails(
            context);
        final info = viewModel.higherSecondaryEducationInfo;

        if (info != null) {
          setState(() {
            interEnrollmentNo.text = info.enrollmentNumber ?? '';
            interInstituteName.text = info.instituteName ?? '';
            interDegree.text = info.qualification ?? '';
            interSpecialization.text = info.specialization ?? '';
            interYearofenrollment.text = info.enrolledYear ?? '';
            interYearofpassout.text = info.passingYear ?? '';
            interCountry.text = info.country ?? '';
            interState.text =
                info.stateRegionProvince ?? ''; // <- this will now update in the UI
            interCity.text = info.city ?? '';
            interPincode.text = info.zipCode ?? '';
            interAddress.text = info.address ?? '';
            interEducationProof.text = info.certificateFileUrl;
          });
        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppbar(
        title: StaticText().higherSecondaryDetails,
        height: 70,
        onPressed: () => _handleBack(context),
        actions: [
          PopupMenuButton<String>(
            icon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Center(
                child: const Icon(
                  Icons.settings,
                  size: 23,
                  color: Colors.white,
                ),
              ),
            ),
            offset: const Offset(0, 70), // adjust vertically as needed
            onSelected: (value) {
              if (value == 'change_password') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordView(),
                  ),
                );
              } else if (value == 'logout') {
                CustomShowDailogs.showdailogLogout(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'change_password',
                child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.lock_outline,
                      size: 20, color: ColorsConst().green),
                  title: const Text('Change Password',
                      style: TextStyle(fontSize: 16)),
                  contentPadding: const EdgeInsets.only(left: 13, right: 0),
                  minLeadingWidth: 0,
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.logout, size: 20, color: Colors.red[400]),
                  title: const Text('Logout', style: TextStyle(fontSize: 16)),
                  contentPadding: const EdgeInsets.only(left: 15, right: 0),
                  minLeadingWidth: 00,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
            create: (_) => CandidateEducationFormViewModel(),
            child: Consumer<CandidateEducationFormViewModel>(
                builder: (context, viewModel, child) {
              return Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextFormField(
                              controller: interEnrollmentNo,
                              labelText: StaticText().enrollmentNoOptional,
                              prefixIcon: Icons.touch_app_outlined,
                              //validator: viewModel.validateEnrollNo,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeAlphanumericNoSpaces(val);
                                interEnrollmentNo.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                              },
                              maxLength: 20,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: interInstituteName,
                              labelText: StaticText().instituteNameOptional,
                              prefixIcon: Icons.business_rounded,
                              //validator: viewModel.validateInstituteName,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                interInstituteName.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                              },
                              maxLength: 40,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: interDegree..text = "Intermediate",
                              labelText: StaticText().qualification,
                              prefixIcon: Icons.school_outlined,
                              // dropdownItems: viewModel.qualificationsByCategory[
                              //     viewModel.selectedCategory]!,
                              // dropdownValue: viewModel.selectedQualification,
                              // onDropdownChanged: (newValue) {
                              //   viewModel.updateQualification(newValue!);
                              //   degree.text = newValue;
                              // },
                              validator: viewModel.validateQualification,
                              readOnly: true,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              fieldKey: specializationFieldKey,
                              controller: interSpecialization,
                              labelText: StaticText().specialization,
                              prefixIcon: Icons.school_outlined,
                              validator: viewModel.validateSpecialization,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                interSpecialization.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                                specializationFieldKey.currentState?.validate();
                              },
                              maxLength: 40,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormFieldWithTap(
                              fieldKey: interenrollFieldKey,
                              onTap: () async {
                                await viewModel.selectEnrollDate(context,
                                    interYearofenrollment, interenrollFieldKey);
                              },
                              controller: interYearofenrollment,
                              labelText: StaticText().yearOfEmrollment,
                              prefixIcon: Icons.cake_outlined,
                              suffixIcon: Icon(
                                Icons.calendar_month_outlined,
                                color: ColorsConst().purple,
                              ),
                              validator: (value) =>
                                  viewModel.validateEnroll(value),
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormField(
                              fieldKey: interpassoutFieldKey,
                              onTap: () async {
                                await viewModel.selectPassoutDate(
                                  context,
                                  interYearofpassout,
                                  interYearofenrollment.text,
                                  interpassoutFieldKey,
                                );
                              },
                              controller: interYearofpassout,
                              labelText: StaticText().yearOfPassout,
                              prefixIcon: Icons.cake_outlined,
                              suffixIcon: Icon(
                                Icons.calendar_month_outlined,
                                color: ColorsConst().purple,
                              ),
                              validator: (value) => viewModel.validatePassout(
                                value,
                                interYearofenrollment.text,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: interAddress,
                              labelText: StaticText().addressOptional,
                              prefixIcon: Icons.home_outlined,
                              maxLength: 40,
                              //validator: viewModel.validateAddressLine,
                              onChanged: (val) {
                                final cleaned = viewModel.sanitizeText(val);
                                interAddress.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: interCity,
                              labelText: StaticText().cityOptional,
                              prefixIcon: Icons.location_city_rounded,
                              maxLength: 20,
                              //validator: viewModel.validateCity,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                interCity.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: interState,
                              labelText: StaticText().stateOptional,
                              prefixIcon: Icons.map_outlined,
                              isCSCPicker: true,
                              cscFieldType: 'state',
                              onStateChanged: (value) {
                                // Handle state change
                                debugPrint("Selected State: $value");
                              },
                              //validator: viewModel.validateState,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: interCountry..text = "India",
                              labelText: StaticText().country,
                              prefixIcon: Icons.public,
                              readOnly: true,
                              validator: viewModel.validateCountry,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              fieldKey: pincodeFieldKey,
                              focusNode: pinCodeFocusNode,
                              controller: interPincode,
                              labelText: StaticText().pincodeOptional,
                              prefixIcon: Icons.pin_drop_outlined,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              validator: (value) {
                                if (!pinCodeTouched) return null;
                                return viewModel.validatePinCode(value);
                              },
                              onChanged: (val) {
                                if (pinCodeTouched) {
                                  pincodeFieldKey.currentState?.validate();
                                }
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormFieldWithTap(
                              fieldKey: interProofFieldKey,
                              onTap: () {
                                viewModel.pickFilesEducation(
                                  controller: interEducationProof,
                                  fieldKey: interProofFieldKey,
                                  onFilePicked: (file) {
                                    viewModel.higherEducationProofFile = file;
                                  },
                                );
                              },
                              controller: interEducationProof,
                              labelText: StaticText().educationProof,
                              prefixIcon: Icons.library_books_outlined,
                              suffixIcon: Icon(
                                Icons.file_upload_outlined,
                                color: ColorsConst().purple,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return StaticText().emptyEducationImage;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomElevatedButton(
                                  text: StaticText().cancel,
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CandidateEducationDetailsView(),
                                      ),
                                    );
                                  },
                                ),
                                CustomElevatedButton(
                                    text: StaticText().submit,
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        if (Provider.of<CandidateEducationFormViewModel>(
                                                    context,
                                                    listen: false)
                                                .higherEducationProofFile ==
                                            null) {
                                          ToastUtils.showToast(
                                            context: context,
                                            message:
                                                'Please upload Higher Secondary certificate.',
                                            type: ToastificationType.warning,
                                          );
                                          return;
                                        }
                                        // Prepare the request object
                                        var reqObj = <String, dynamic>{};
                                        reqObj["enrollmentNumber"] =
                                            interEnrollmentNo.text.trim();
                                        reqObj["instituteName"] =
                                            interInstituteName.text.trim();
                                        reqObj["qualification"] =
                                            interDegree.text.trim();
                                        reqObj["specialization"] =
                                            interSpecialization.text.trim();
                                        reqObj["enrolledYear"] =
                                            interYearofenrollment.text.trim();
                                        reqObj["passingYear"] =
                                            interYearofpassout.text.trim();
                                        reqObj["address"] =
                                            interAddress.text.trim();
                                        reqObj["city"] =
                                            interCity.text.trim();
                                        reqObj["stateRegionProvince"] =
                                            interState.text.trim();
                                        reqObj["country"] =
                                            interCountry.text.trim();
                                        reqObj["zipCode"] =
                                            interPincode.text.trim();
                                        reqObj["certificateFileUrl"] =
                                            await MultipartFile.fromFile(
                                          viewModel
                                              .higherEducationProofFile!.path,
                                          filename: viewModel
                                              .higherEducationProofFile!.path
                                              .split('/')
                                              .last,
                                          contentType:
                                              MediaType('application', 'pdf'),
                                        );
                                        if (!context.mounted) return;
                                        viewModel.submitHigherSecondaryDetails(
                                            context,
                                            reqObj,
                                            );
                                      }
                                    }),
                              ],
                            ),
                          ],
                        )),
                  ));
            }),
          ),
        ),
      ),
    );
  }
}