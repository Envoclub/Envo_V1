import 'dart:io';

import 'package:envo_admin_dashboard/auth.dart';
import 'package:envo_admin_dashboard/cubits/auth/auth_cubit.dart';
import 'package:envo_admin_dashboard/cubits/employee/employee_cubit.dart';
import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/auth_helper_widgets.dart';
import 'package:envo_admin_dashboard/utils/helper_widgets.dart';
import 'package:envo_admin_dashboard/utils/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:random_password_generator/random_password_generator.dart';

import 'reward_controller.dart';

class AddReward extends GetView<RewardsController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(
      () => Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(25),
            child: SingleChildScrollView(
              child: Form(
                  key: controller.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: controller.loading.value!
                        ? Center(
                            child: Loader(),
                          )
                        : Container(
                            width: 600,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Add Reward",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Obx(
                                    () => InkWell(
                                      onTap: () async {
                                        await controller.selectImage();
                                      },
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.grey.withOpacity(.1)),
                                        child: controller.image.value == null
                                            ? Center(
                                                child: Text(
                                                    "Click to Select and Image"),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.network(
                                                    controller.image.value!.path,
                                                    fit: BoxFit.fill,
                                                    width: double.maxFinite,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  FormFieldWidget(
                                    textController: controller.titleController,
                                    label: "Title",
                                    validator: (value) {
                                      if (value!.trim().isEmpty)
                                        return "Please Enter a valid Title";
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  FormFieldWidget(
                                    textController:
                                        controller.descriptionController,
                                    label: "Description",
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return "Please Enter a valid description";
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  FormFieldWidget(
                                    textController: controller.rewardsController,
                                    label: "Coins Required",
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return "Please Enter a valid Coins required";
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  CustomButton(
                                    loading: controller.loading.value!, 
                                      handler: () async {
                                        controller.loading.value = true;
                                        var done = await controller.addReward(
                                            (context.read<AuthCubit>().state
                                                    as AuthLoggedIn)
                                                .user
                                                .company!);
                                        controller.loading.value = false;
                                        Get.back();
                                        if (done is bool) {
                                          showSnackBar(
                                              "Successfully Added Reward",
                                              isError: false);
                                        } else {
                                          showSnackBar("$done}", isError: true);
                                        }
                                      },
                                      label: "Add")
                                ],
                              ),
                            ),
                          ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
