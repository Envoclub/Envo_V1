import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:envo_mobile/modules/home/controller.dart';
import 'package:envo_mobile/modules/profile_module/controller.dart';
import 'package:envo_mobile/utils/helper_widgets.dart';
import 'package:envo_mobile/utils/meta_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/meta_colors.dart';
import '../auth_module/auth_screens/auth_helper_widgets.dart';
import 'controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Obx(
        () => controller.loading.value!
            ? Center(
                child: Loader(),
              )
            : controller.isEditing.value!
                ? controller.isReset.value!
                    ? Container(
                        child: Form(
                        key: controller.formKey,
                        child: SingleChildScrollView(
                            child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                              Text("Reset Password",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormFieldWidget(
                                    obscureText:
                                        controller.obscurePassword.value!,
                                    enabled: !controller.loading.value!,
                                    textController:
                                        controller.passwordCOntroller,
                                    label: "New Password",
                                    validator: (val) {
                                      if (val!.trim().length > 8) {
                                        return null;
                                      } else {
                                        return "Please Enter a valid password, atleast 8 characters";
                                      }
                                    },
                                    suffix: InkWell(
                                        onTap: () {
                                          controller.obscurePassword.value =
                                              !controller
                                                  .obscurePassword.value!;
                                        },
                                        child: Obx(() => controller
                                                .obscurePassword.value!
                                            ? Icon(
                                                CupertinoIcons.eye,
                                                color: MetaColors.primaryColor,
                                              )
                                            : Icon(
                                                CupertinoIcons.eye_slash,
                                                color: MetaColors.primaryColor,
                                              )))),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormFieldWidget(
                                  enabled: !controller.loading.value!,
                                  obscureText:
                                      controller.obscurePassword.value!,
                                  textController:
                                      controller.resetpasswordCOntroller,
                                  label: "Confirm Password",
                                  validator: (val) {
                                    if (val!.trim() !=
                                        controller.passwordCOntroller.text
                                            .trim())
                                      return "Passwords not matching";
                                    if (val.trim().length > 8) {
                                      return null;
                                    } else {
                                      return "Please Enter a valid password, atleast 8 characters";
                                    }
                                  },
                                  suffix: InkWell(
                                    onTap: () {
                                      controller.obscurePassword.value =
                                          !controller.obscurePassword.value!;
                                    },
                                    child: Obx(
                                        () => controller.obscurePassword.value!
                                            ? Icon(
                                                CupertinoIcons.eye,
                                                color: MetaColors.primaryColor,
                                              )
                                            : Icon(
                                                CupertinoIcons.eye_slash,
                                                color: MetaColors.primaryColor,
                                              )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                  handler: () {
                                    controller.resetPassword();
                                  },
                                  label: "Update")
                            ]))),
                      ))
                    : Container(
                        child: Form(
                        key: controller.formKey,
                        child: SingleChildScrollView(
                            child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: MetaColors.primaryColor,
                                          width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              .15),
                                      child: InkWell(
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                .15,
                                        onTap: () {
                                          controller.pickImage();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .15),
                                            child: Obx(() => controller
                                                        .pickedImage.value ==
                                                    null
                                                ? controller
                                                                .profileController
                                                                .data
                                                                .value
                                                                ?.photoUrl !=
                                                            null &&
                                                        controller
                                                            .profileController
                                                            .data
                                                            .value!
                                                            .photoUrl!
                                                            .isNotEmpty
                                                    ? Image.network(
                                                        controller
                                                            .profileController
                                                            .data
                                                            .value!
                                                            .photoUrl!,
                                                        fit: BoxFit.cover,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .3,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .3,
                                                      )
                                                    : Image.asset(
                                                        MetaAssets
                                                            .userDetailsBackground,
                                                        fit: BoxFit.cover,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .3,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .3,
                                                      )
                                                : Image.file(
                                                    File(
                                                      controller.pickedImage
                                                          .value!.path,
                                                    ),
                                                    fit: BoxFit.cover,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .3,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .3,
                                                  )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: FormFieldWidget(
                              //     enabled: !AuthController.to.authLoading.value,
                              //     textController: controller.nameController,
                              //     label: "User Name",
                              //     validator: (val) {
                              //       if (val!.trim().isNotEmpty) {
                              //         return null;
                              //       } else {
                              //         return "Please Enter a valid name";
                              //       }
                              //     },
                              //   ),
                              // ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormFieldWidget(
                                  enabled: !AuthController.to.authLoading.value,
                                  textController: controller.bioCOntroller,
                                  label: "Bio",
                                  validator: (val) {
                                    if (val!.trim().isNotEmpty) {
                                      return null;
                                    } else {
                                      return "Please Enter a valid bio";
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                  handler: () {
                                    controller.updateData();
                                  },
                                  label: "Update")
                            ]))),
                      ))
                : Container(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  controller.profileController.data.value
                                          ?.photoUrl ??
                                      ''),
                              radius: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                controller.profileController.data.value
                                        ?.username ??
                                    '',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                            child: Text(
                                controller
                                        .profileController.data.value?.email ??
                                    '',
                                style: TextStyle(
                                  color: MetaColors.tertiaryTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(5, 10),
                                        color: MetaColors.primaryColor
                                            .withOpacity(0.1),
                                        blurRadius: 10)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: MetaColors.primaryColor
                                          .withOpacity(0.9),
                                      width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("My Coins",
                                                  style: TextStyle(
                                                    color: MetaColors
                                                        .tertiaryTextColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ))),
                                        ),
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.asset(
                                                MetaAssets.logo,
                                                height: 30,
                                                width: 30,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                                controller.profileController
                                                    .data.value!.reward
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(5, 10),
                                      color: MetaColors.primaryColor
                                          .withOpacity(0.1),
                                      blurRadius: 10)
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  "Invite your Colleague",
                                                  style: TextStyle(
                                                    color: MetaColors
                                                        .tertiaryTextColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ))),
                                        ),
                                        Icon(
                                          Icons.arrow_circle_right_outlined,
                                          color: MetaColors.primaryColor,
                                        )
                                      ],
                                    ),
                                    Divider(
                                      color: MetaColors.secondaryColor,
                                      indent: 10,
                                      endIndent: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.isEditing.value = true;
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text("Edit Details",
                                                    style: TextStyle(
                                                      color: MetaColors
                                                          .tertiaryTextColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ))),
                                          ),
                                          Icon(
                                            Icons.arrow_circle_right_outlined,
                                            color: MetaColors.primaryColor,
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: MetaColors.secondaryColor,
                                      indent: 10,
                                      endIndent: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.isReset.value = true;
                                        controller.isEditing.value = true;
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text("Reset Password",
                                                    style: TextStyle(
                                                      color: MetaColors
                                                          .tertiaryTextColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ))),
                                          ),
                                          Icon(
                                            Icons.arrow_circle_right_outlined,
                                            color: MetaColors.primaryColor,
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: MetaColors.secondaryColor,
                                      indent: 10,
                                      endIndent: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("Help",
                                                  style: TextStyle(
                                                    color: MetaColors
                                                        .tertiaryTextColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ))),
                                        ),
                                        Icon(
                                          Icons.arrow_circle_right_outlined,
                                          color: MetaColors.primaryColor,
                                        )
                                      ],
                                    ),
                                    Divider(
                                      color: MetaColors.secondaryColor,
                                      indent: 10,
                                      endIndent: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          CustomButton(
                              handler: () {
                                AuthController.to.logout();
                                HomeController.to.currentIndex.value = 0;
                                Get.back();
                              },
                              label: "Log Out")
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
