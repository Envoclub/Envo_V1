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
import 'package:random_password_generator/random_password_generator.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final password = RandomPasswordGenerator();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(25),
          child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
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
                                      "Add Employee",
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
                              FormFieldWidget(
                                textController: emailController,
                                label: "Email",
                                validator: validateEmail,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              FormFieldWidget(
                                textController: userNameController,
                                label: "Full Name",
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return "Please Enter a valid Name";
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              CustomButton(
                                  handler: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic? done = await context
                                        .read<EmployeeCubit>()
                                        .addEmployee(
                                            email: emailController.text.trim(),
                                            username:
                                                userNameController.text.trim(),
                                            password: password.randomPassword(
                                                numbers: true,
                                                passwordLength: 9,
                                                specialChar: true,
                                                uppercase: true),
                                            companyID: (context
                                                    .read<AuthCubit>()
                                                    .state as AuthLoggedIn)
                                                .user
                                                .company!);
                                    setState(() {
                                      loading = false;
                                    });
                                    Get.back();
                                    if (done is bool) {
                                      showSnackBar(
                                          "Successfully Added Employee",
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
    );
  }
}
