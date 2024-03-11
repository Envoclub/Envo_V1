import 'dart:io';

import 'package:envo_mobile/modules/auth_module/user_details_update_module/binding.dart';
import 'package:envo_mobile/modules/auth_module/user_details_update_module/controller.dart';
import 'package:envo_mobile/modules/home/binding.dart';
import 'package:envo_mobile/modules/home/view.dart';
import 'package:envo_mobile/utils/meta_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/meta_assets.dart';
import '../../../utils/validators.dart';
import '../auth_screens/auth_helper_widgets.dart';
import '../controller.dart';

import 'package:intl/intl.dart';

class UserDetailsUpdateScreen extends StatelessWidget {
  UserDetailsUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserDetailsUpdateBinding().dependencies();

    UserDetailsController controller = UserDetailsController.to;
    return Stack(
      children: [
        Image.asset(
          MetaAssets.userDetailsBackground,
          fit: BoxFit.fill,
          height: double.maxFinite,
          width: double.maxFinite,
        ),
        Form(
          key: controller.formKey,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            children: [
              PhoneNumberScreen(controller: controller),
              NameScreen(controller: controller),
              ProfileandGenderScreen(
                controller: controller,
              ),
              DateOfBirthScreen(controller: controller),
            ],
          ),
        ),
      ],
    );
  }
}

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({
    super.key,
    required this.controller,
  });

  final UserDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(),
        body: Container(
          child: SingleChildScrollView(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .1),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TitleWidget(
                      title: "Contact Number",
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SubtitleWidget(
                    title: "Where do we call you?",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FormFieldWidget(
                  // isUnderLineStyle: true,
                  isPhone: true,
                  enabled: !AuthController.to.authLoading.value,
                  textController: controller.phoneController,
                  label: "",
                  validator: validatePhone,
                ),
                // FormFieldWidget(
                //   enabled: !AuthController.to.authLoading.value,
                //   textController: nameController,
                //   label: "Name",
                //   validator: (val) {
                //     if (val!.trim().isNotEmpty) {
                //       return null;
                //     } else {
                //       return "Please Enter a valid name";
                //     }
                //   },
                // ),
                // FormFieldWidget(
                //   enabled: !AuthController.to.authLoading.value,
                //   readOnly: true,
                //   textController: dobCOntroller,
                //   label: "Date of Birth",
                //   onTap: () async {
                //     DateTime? date = await showDatePicker(
                //         builder: (ctx, child) {
                //           return Theme(
                //               data: Theme.of(context).copyWith(
                //                   colorScheme: ColorScheme.light(
                //                       primary: MetaColors.primaryColor)),
                //               child: child!);
                //         },
                //         context: context,
                //         initialDate: DateTime(2005),
                //         firstDate: DateTime(1950),
                //         lastDate: DateTime(2005));
                //     if (date != null) {
                //       setState(() {
                //         dateOfBirth = date;
                //         dobCOntroller.text =
                //             DateFormat('dd MMM ,yyyy').format(dateOfBirth);
                //       });
                //     }
                //   },
                //   validator: (val) {},
                // ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomRoundButton(handler: () {
                    if (!controller.formKey.currentState!.validate()) return;
                    controller.pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  }),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
        ),
      ),
    ));
  }
}

class CustomRoundButton extends StatelessWidget {
  const CustomRoundButton({super.key, required this.handler});
  final void Function()? handler;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: handler,
          child: CircleAvatar(
            backgroundColor: MetaColors.primaryColor,
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          )),
    );
  }
}

class NameScreen extends StatelessWidget {
  const NameScreen({
    super.key,
    required this.controller,
  });

  final UserDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.transparent,
        body: Container(
          child: SingleChildScrollView(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .1),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TitleWidget(
                      title: "Name",
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SubtitleWidget(
                    title: "What should we call you?",
                  ),
                ),

                FormFieldWidget(
                  enabled: !AuthController.to.authLoading.value,
                  textController: controller.nameController,
                  label: "",
                  validator: (val) {
                    if (val!.trim().isNotEmpty) {
                      return null;
                    } else {
                      return "Please Enter a valid name";
                    }
                  },
                ),
                // FormFieldWidget(
                //   enabled: !AuthController.to.authLoading.value,
                //   readOnly: true,
                //   textController: dobCOntroller,
                //   label: "Date of Birth",
                //   onTap: () async {
                //     DateTime? date = await showDatePicker(
                //         builder: (ctx, child) {
                //           return Theme(
                //               data: Theme.of(context).copyWith(
                //                   colorScheme: ColorScheme.light(
                //                       primary: MetaColors.primaryColor)),
                //               child: child!);
                //         },
                //         context: context,
                //         initialDate: DateTime(2005),
                //         firstDate: DateTime(1950),
                //         lastDate: DateTime(2005));
                //     if (date != null) {
                //       setState(() {
                //         dateOfBirth = date;
                //         dobCOntroller.text =
                //             DateFormat('dd MMM ,yyyy').format(dateOfBirth);
                //       });
                //     }
                //   },
                //   validator: (val) {},
                // ),
                Align(
                    alignment: Alignment.centerRight,
                    child: CustomRoundButton(handler: () {
                      if (!controller.formKey.currentState!.validate()) return;
                      controller.pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    })),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
        ),
      ),
    ));
  }
}

class DateOfBirthScreen extends StatefulWidget {
  const DateOfBirthScreen({
    super.key,
    required this.controller,
  });

  final UserDetailsController controller;

  @override
  State<DateOfBirthScreen> createState() => _DateOfBirthScreenState();
}

class _DateOfBirthScreenState extends State<DateOfBirthScreen> {
  DateTime dateOfBirth = DateTime(2005);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.transparent,
        body: Container(
          child: SingleChildScrollView(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .1),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TitleWidget(
                      title: "Date Of Birth",
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SubtitleWidget(
                    title: "When do we wish you Happy Birthday!!!?",
                  ),
                ),
                FormFieldWidget(
                  enabled: !AuthController.to.authLoading.value,
                  readOnly: true,
                  textController: widget.controller.dobCOntroller,
                  label: "",
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                        builder: (ctx, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                      primary: MetaColors.primaryColor)),
                              child: child!);
                        },
                        context: context,
                        initialDate: DateTime(2005),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2005));
                    if (date != null) {
                      setState(() {
                        dateOfBirth = date;
                        widget.controller.dobCOntroller.text =
                            DateFormat('dd MMM ,yyyy').format(dateOfBirth)[0] ==
                                    '0'
                                ? DateFormat('dd MMM ,yyyy')
                                    .format(dateOfBirth)
                                    .substring(1)
                                : DateFormat('dd MMM ,yyyy')
                                    .format(dateOfBirth);
                      });
                    }
                  },
                  validator: (val) {},
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: CustomRoundButton(handler: () {
                      if (!widget.controller.formKey.currentState!.validate())
                        return;
                      widget.controller.pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                      Get.to(HomeView(), binding: HomeBinding());
                    })),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
        ),
      ),
    ));
  }
}

class ProfileandGenderScreen extends StatelessWidget {
  const ProfileandGenderScreen({
    super.key,
    required this.controller,
  });

  final UserDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.transparent,
        body: Container(
          child: SingleChildScrollView(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .1),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TitleWidget(
                      title: "Image",
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SubtitleWidget(
                    title: "Add a profile Image",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: MetaColors.primaryColor, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * .1),
                      child: InkWell(
                        radius: MediaQuery.of(context).size.width * .1,
                        onTap: () {
                          controller.pickImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * .1),
                            child: Obx(() => controller.pickedImage.value ==
                                    null
                                ? Image.asset(
                                    MetaAssets.userDetailsBackground,
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width * .2,
                                    height:
                                        MediaQuery.of(context).size.width * .2,
                                  )
                                : Image.file(
                                    File(
                                      controller.pickedImage.value!.path,
                                    ),
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width * .2,
                                    height:
                                        MediaQuery.of(context).size.width * .2,
                                  )),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                // FormFieldWidget(
                //   enabled: !AuthController.to.authLoading.value,
                //   readOnly: true,
                //   textController: dobCOntroller,
                //   label: "Date of Birth",
                //   onTap: () async {
                //     DateTime? date = await showDatePicker(
                //         builder: (ctx, child) {
                //           return Theme(
                //               data: Theme.of(context).copyWith(
                //                   colorScheme: ColorScheme.light(
                //                       primary: MetaColors.primaryColor)),
                //               child: child!);
                //         },
                //         context: context,
                //         initialDate: DateTime(2005),
                //         firstDate: DateTime(1950),
                //         lastDate: DateTime(2005));
                //     if (date != null) {
                //       setState(() {
                //         dateOfBirth = date;
                //         dobCOntroller.text =
                //             DateFormat('dd MMM ,yyyy').format(dateOfBirth);
                //       });
                //     }
                //   },
                //   validator: (val) {},
                // ),
                ,
                Align(
                    alignment: Alignment.centerRight,
                    child: CustomRoundButton(handler: () {
                      if (controller.pickedImage.value == null) {
                        showSnackBar("Please Select an Image");
                        return;
                      }
                      controller.pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    })),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
        ),
      ),
    ));
  }
}
