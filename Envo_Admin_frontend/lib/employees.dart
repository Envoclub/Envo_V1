// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:envo_admin_dashboard/add_employee.dart';
import 'package:envo_admin_dashboard/auth.dart';
import 'package:envo_admin_dashboard/cubits/auth/auth_cubit.dart';
import 'package:envo_admin_dashboard/cubits/employee/employee_cubit.dart';
import 'package:envo_admin_dashboard/utils/helper_widgets.dart';
import 'package:envo_admin_dashboard/utils/meta_assets.dart';
import 'package:envo_admin_dashboard/utils/meta_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  List<String> columns = [
    "Employee",
    "Email",
    "Contact",
    "Employee Id",
    "Type"
  ];
  List<Employees> employees = [
    Employees(
        image: MetaAssets.logo,
        name: "Sarthak",
        country: "Ireland",
        designation: "CTO",
        startDate: DateTime.now(),
        reportingTo: "Saransh")
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  18,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (MediaQuery.of(context).size.width < 1000)
                    InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(
                        CupertinoIcons.list_bullet_indent,
                        color: Colors.black,
                      ),
                    ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Employees",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (ctx) => AddEmployee());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: MetaColors.primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Add Employee",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.shade100.withOpacity(0.5),
                          blurRadius: 30,
                          offset: Offset(
                            8,
                            8,
                          ))
                    ],
                    color: Colors.white),
                child: BlocBuilder<EmployeeCubit, EmployeeState>(
                  builder: (context, state) {
                    if (state is EmployeeLoaded) {
                      return Container(
                        width: double.maxFinite,
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                                state.data.length,
                                (index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        elevation: 10,
                                        color: Colors.white,
                                        shadowColor: MetaColors.primaryColor
                                            .withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(12),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          hoverColor: Colors.grey.shade100,
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(state
                                                                        .data[
                                                                            index]
                                                                        .photoUrl ??
                                                                    ''),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "${state.data[index].username}",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      state.data[index].type
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  state.data[index].bio
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: MetaColors
                                                        .tertiaryTextColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Contact :${state.data[index].email}, ${state.data[index].phoneNumber}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: MetaColors
                                                                .secondaryColor),
                                                      ),
                                                    ),
                                                    Material(
                                                      color:
                                                          Colors.red.shade900,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        hoverColor: Colors.red,
                                                        onHover: (value) {},
                                                        onTap: () async {
                                                          dynamic? done = await context
                                                              .read<
                                                                  EmployeeCubit>()
                                                              .deleteEmployee(
                                                                  pk: state
                                                                      .data[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  companyID: (context
                                                                          .read<
                                                                              AuthCubit>()
                                                                          .state as AuthLoggedIn)
                                                                      .user
                                                                      .company
                                                                      .toString()
                                                                      .toString());
                                                          if (done is bool) {
                                                            showSnackBar(
                                                                "Employee Deleted Successfully",
                                              
                                                                isError: false);
                                                          } else {
                                                            showSnackBar(
                                                                "$done",
                                                            
                                                                isError: true);
                                                          }
                                                        },
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        8),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .delete_outline_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  "Delete",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                if (state.data[index]
                                                        .lastLogin !=
                                                    null)
                                                  Text(
                                                    "Last active at ${DateFormat("dd MMM, yyyy hh:mm:ss a").format(state.data[index].lastLogin!)}",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.green),
                                                  )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                      );
                      
                      
                       // return Padding(
                      //   padding: const EdgeInsets.all(18.0),
                      //   child: DataTable(
                      //     dataRowHeight: 80,
                      //     // dividerThickness: 1,
                      //     border: TableBorder(
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(2)),
                      //         top: BorderSide(
                      //             width: .5, color: Colors.grey.shade400),
                      //         bottom: BorderSide(
                      //             width: .5, color: Colors.grey.shade400),
                      //         right: BorderSide(
                      //             width: .5, color: Colors.grey.shade400),
                      //         left: BorderSide(
                      //             width: .5, color: Colors.grey.shade400),
                      //         horizontalInside: BorderSide(
                      //             width: .5, color: Colors.grey.shade400)),
                      //     columns: columns
                      //         .map((e) => DataColumn(
                      //                 label: SizedBox(
                      //               width:
                      //                   MediaQuery.of(context).size.width * .1,
                      //               child: Text(
                      //                 e.toString(),
                      //                 style: TextStyle(
                      //                     color: MetaColors.tertiaryTextColor,
                      //                     fontSize: 12,
                      //                     fontWeight: FontWeight.w600),
                      //                 textAlign: TextAlign.center,
                      //                 overflow: TextOverflow.ellipsis,
                      //               ),
                      //             )))
                      //         .toList(),
                      //     rows: state.data
                      //         .map((e) => DataRow(cells: [
                      //               DataCell(Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.start,
                      //                 children: [
                      //                   Padding(
                      //                     padding:
                      //                         const EdgeInsets.all(8.0),
                      //                     child: e.photoUrl != null &&
                      //                             e.photoUrl
                      //                                 .toString()
                      //                                 .trim()
                      //                                 .isNotEmpty
                      //                         ? CircleAvatar(
                      //                             backgroundImage:
                      //                                 NetworkImage(
                      //                                     e.photoUrl))
                      //                         : CircleAvatar(
                      //                             backgroundImage:
                      //                                 AssetImage(
                      //                                     MetaAssets.logo),
                      //                           ),
                      //                   ),
                      //                   Text(
                      //                     e.username.toString(),
                      //                     overflow: TextOverflow.ellipsis,
                      //                   ),
                      //                 ],
                      //               )),
                      //               DataCell(Align(
                      //                 alignment: Alignment.centerLeft,
                      //                 child: Text(
                      //                   e.email.toString(),
                      //                   overflow: TextOverflow.ellipsis,
                      //                 ),
                      //               )),
                      //               DataCell(Center(
                      //                 child: Text(
                      //                   e.phoneNumber.toString(),
                      //                   overflow: TextOverflow.ellipsis,
                      //                 ),
                      //               )),
                      //               DataCell(Center(
                      //                 child: Text(
                      //                   e.id.toString(),
                      //                   overflow: TextOverflow.ellipsis,
                      //                 ),
                      //               )),
                      //               DataCell(Center(
                      //                 child: Text(
                      //                   e.type.toString(),
                      //                   overflow: TextOverflow.ellipsis,
                      //                 ),
                      //               ))
                      //             ]))
                      //         .toList(),
                      //   ),
                      // );
                    }
                    if (state is EmployeeLoading) {
                      return Center(
                        child: Loader(),
                      );
                    }
                    if (state is EmployeeError) {
                      return Center(
                        child: Text(state.error),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Employees {
  String name;
  String country;
  DateTime startDate;
  String reportingTo;
  String image;
  String designation;
  Employees({
    required this.name,
    required this.image,
    required this.designation,
    required this.country,
    required this.startDate,
    required this.reportingTo,
  });
}
