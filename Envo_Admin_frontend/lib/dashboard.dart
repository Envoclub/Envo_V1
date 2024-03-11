import 'dart:developer';

import 'package:envo_admin_dashboard/chart.dart';
import 'package:envo_admin_dashboard/cubits/actions/actions_cubit.dart';
import 'package:envo_admin_dashboard/cubits/auth/auth_cubit.dart';
import 'package:envo_admin_dashboard/cubits/bar_chart/barchart_cubit.dart';
import 'package:envo_admin_dashboard/cubits/linechart/linechart_cubit.dart';
import 'package:envo_admin_dashboard/cubits/navigation/navigation_cubit.dart';
import 'package:envo_admin_dashboard/cubits/pie_chart/piechart_cubit.dart';
import 'package:envo_admin_dashboard/cubits/tile_data/tile_data_cubit.dart';
import 'package:envo_admin_dashboard/employees.dart';
import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/auth_helper_widgets.dart';
import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/auth_view.dart';
import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/sign_in_view.dart';
import 'package:envo_admin_dashboard/pie_chart.dart';
import 'package:envo_admin_dashboard/posts_view.dart';
import 'package:envo_admin_dashboard/repositories/post_repository.dart';
import 'package:envo_admin_dashboard/reward_controller.dart';
import 'package:envo_admin_dashboard/rewards_view.dart';
import 'package:envo_admin_dashboard/utils/meta_assets.dart';
import 'package:envo_admin_dashboard/utils/meta_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth.dart';
import 'bar_chart.dart';
import 'cubits/employee/employee_cubit.dart';
import 'cubits/posts/posts_cubit.dart';
import 'repositories/auth_repository.dart';
import 'utils/helper_widgets.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key, required this.title});

  final String title;

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.put(
          RewardsController(PostRepository(context.read<AuthRepository>())));
      context.read<ActionsCubit>()..getData();
      context.read<LinechartCubit>()
        ..getData((context.read<AuthCubit>().state as AuthLoggedIn)
            .user
            .company
            .toString());
      context.read<PiechartCubit>()..getData();
      context.read<BarchartCubit>()..getData();
      context.read<EmployeeCubit>()..getData();
      context.read<PostsCubit>()..getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        drawer: (constraints.maxWidth > 1000)
            ? null
            : const Drawer(
                child: SideMenu(
                isDrawer: true,
              )),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue.shade100.withOpacity(0.5),
                        blurRadius: 30,
                        offset: const Offset(
                          8,
                          8,
                        ))
                  ],
                  color: const Color(0xFFF3F6F8)),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (constraints.maxWidth > 1000) const SideMenu(),
                  Expanded(
                    child: BlocBuilder<NavigationCubit, NavigationState>(
                      builder: (context, state) {
                        if (state.index == 1) return const EmployeesScreen();

                        if (state.index == 2) return const PostsView();
                        if (state.index == 3) return RewardsView();
                        if (state.index == 4) return SettingsScreen();
                        return const Home();
                      },
                    ),
                  )
                ],
              ))),
        ),
      );
    });
  }
}

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: const TopBarWidget()),
        SliverToBoxAdapter(child: const BasicStatsWidget()),
        SliverToBoxAdapter(
          child: BarGraph(),
        ),
        SliverToBoxAdapter(
          child: Co2GraphView(),
        ),
        SliverToBoxAdapter(child: ActionsTypePieView()),
      ],
    );
  }
}

class ActionsTypePieView extends StatelessWidget {
  const ActionsTypePieView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 250,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  18,
                ),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      "Action Type Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    )),
                BlocBuilder<PiechartCubit, PiechartState>(
                  builder: (context, state) {
                    if (state is PieChartLoaded) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LayoutBuilder(builder: (context, constraints) {
                          if (constraints.maxWidth > 1000) {
                            return Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                      height: 350,
                                      child: PieChartSample1(
                                          data: state.data
                                            ..sort((a, b) =>
                                                b.count!.compareTo(a.count!)))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: state.data
                                            .map((e) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              e.color,
                                                          radius: 5,
                                                        ),
                                                      ),
                                                      Text(
                                                        e.action.toString(),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ))
                                            .toList()),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                SizedBox(
                                    height: 350,
                                    child: PieChartSample1(
                                        data: state.data
                                          ..sort((a, b) =>
                                              b.count!.compareTo(a.count!)))),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: state.data
                                            .map((e) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              e.color,
                                                          radius: 5,
                                                        ),
                                                      ),
                                                      Text(
                                                        e.action.toString(),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ))
                                            .toList()),
                                  ),
                                )
                              ],
                            );
                          }
                        }),
                      );
                    }
                    if (state is PieChartLoading) {
                      return Center(
                        child: Loader(),
                      );
                    }
                    if (state is PieChartError) {
                      return Center(
                        child: Text(state.error),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            )),
      ),
    );
  }
}

class Co2GraphView extends StatelessWidget {
  const Co2GraphView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: MediaQuery.of(context).size.height * .6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  18,
                ),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      "Co2 emmission Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    )),
                Expanded(
                  child: Row(
                    children: [
                      RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Co2 Emmissions in kg"),
                          )),
                      Expanded(
                        child: BlocBuilder<LinechartCubit, LinechartState>(
                          builder: (context, state) {
                            if (state is LineChartLoaded) {
                              if (state.data.isEmpty) {
                                return Center(
                                  child: Text("Not enough Data"),
                                );
                              }
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: LineChartSample2(data: state.data),
                              );
                            }
                            if (state is LineChartLoading) {
                              return const Center(
                                child: Loader(),
                              );
                            }
                            if (state is LineChartError) {
                              return Center(
                                child: Text(state.error),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class BarGraph extends StatelessWidget {
  const BarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              18,
            ),
            color: MetaColors.primaryColor),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * .6,
                  child: BlocBuilder<BarchartCubit, BarchartState>(
                    builder: (context, state) {
                      if (state is BarChartLoaded) {
                        return BarChartSample1(
                          data: state.data,
                        );
                      } else if (state is BarChartLoading) {
                        return Center(
                          child: Loader(),
                        );
                      } else if (state is BarChartError) {
                        return Center(
                          child: Text(
                            "${state.error}",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
    this.isDrawer = false,
  }) : super(key: key);
  final bool isDrawer;
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, constraints) {
      log("here $constraints");

      return Container(
        width: size.width * .2,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  18,
                ),
                bottomLeft: Radius.circular(18)),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: const LogoWidget()),
              const SizedBox(
                height: 20,
              ),
              const Expanded(
                  child: SingleChildScrollView(child: SideMenuWidget())),
              // if (widget.isDrawer)
              //   FittedBox(
              //     fit: BoxFit.fitWidth,
              //     child: BlocBuilder<EmployeeCubit, EmployeeState>(
              //       builder: (context, state) {
              //         if (state is EmployeeLoaded) {
              //           return Center(
              //             child: SizedBox(
              //                 child: Center(
              //                     child: Padding(
              //               padding: const EdgeInsets.all(16.0),
              //               child: Text(
              //                 "Active Users : ${state.data.length}",
              //                 style: TextStyle(fontWeight: FontWeight.w700),
              //               ),
              //             ))),
              //           );
              //         }
              //         return SizedBox.shrink();
              //       },
              //     ),
              //   )
              // else
              //   BlocBuilder<EmployeeCubit, EmployeeState>(
              //     builder: (context, state) {
              //       if (state is EmployeeLoaded) {
              //         return Center(
              //           child: SizedBox(
              //               child: Center(
              //                   child: Padding(
              //             padding: const EdgeInsets.all(16.0),
              //             child: Text(
              //               "Active Users : ${state.data.length}",
              //               style: TextStyle(fontWeight: FontWeight.w700),
              //             ),
              //           ))),
              //         );
              //       }
              //       return SizedBox.shrink();
              //     },
              //   ),
              if (widget.isDrawer)
                FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Center(
                        child: CustomButton(
                      handler: () {
                        context.read<AuthCubit>().logout();
                      },
                      label: "Log Out",
                      isDashBoard: true,
                    )))
              else
                Center(
                  child: SizedBox(
                      child: Center(
                          child: CustomButton(
                    handler: () {
                      context.read<AuthCubit>().logout();
                    },
                    label: "Log Out",
                    isDashBoard: true,
                  ))),
                )
            ],
          ),
        ),
      );
    });
  }
}

class BasicStatsWidget extends StatelessWidget {
  const BasicStatsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) =>
          TileDataCubit(context.read<AuthRepository>())..getData(),
      child: BlocBuilder<TileDataCubit, TileDataState>(
        builder: (context, state) {
          if (state is TileDataLoaded) {
            return Container(
              child: size.width > 1000
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // width: 500,
                        height: MediaQuery.of(context).size.height * .32,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                fit: FlexFit.tight,
                                child: Co2EmmissionsTile(
                                    percentage: state.data.percentageCo2Change,
                                    value: state.data.carbonEmmisionSaved)),
                            Flexible(
                                fit: FlexFit.tight,
                                child: EmployeeParticipationStatsTile(
                                  percentage: state
                                      .data.percentageEmployeeParticipation,
                                  value: state.data.totalParticipation,
                                )),
                            Flexible(
                                fit: FlexFit.tight,
                                child: EnvironmentActionsStatsTile(
                                    percentage: state.data.percentageTotalPost,
                                    value: state.data.totalPostToday)),

                            // Flexible(
                            //   fit: FlexFit.tight,
                            //   child: PiechartWidget(),
                            // ),
                          ],
                        ),
                      ))
                  : Column(
                      children: [
                        SizedBox(
                            height: 200,
                            child: Co2EmmissionsTile(
                                percentage: state.data.percentageCo2Change,
                                value: state.data.carbonEmmisionSaved)),
                        SizedBox(
                            height: 200,
                            child: EmployeeParticipationStatsTile(
                              percentage:
                                  state.data.percentageEmployeeParticipation,
                              value: state.data.totalParticipation,
                            )),
                        SizedBox(
                            height: 200,
                            child: EnvironmentActionsStatsTile(
                                percentage: state.data.percentageTotalPost,
                                value: state.data.totalPostToday)),

                        // SizedBox(
                        //   height: 200,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Container(
                        //         decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(
                        //               18,
                        //             ),
                        //             color: Colors.white),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: PieChartSample1(),
                        //         )),
                        //   ),
                        // ),
                      ],
                    ),
            );
          }
          if (state is TileDataError) {
            return Center(
              child: Text(state.error),
            );
          }
          if (state is TileDataLoading) {
            return Center(
              child: Loader(),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}

// class PiechartWidget extends StatelessWidget {
//   const PiechartWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(
//                 18,
//               ),
//               color: Colors.white),
//           child: const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: PieChartSample1(),
//           )),
//     );
//   }
// }

class EmployeeParticipationStatsTile extends StatelessWidget {
  const EmployeeParticipationStatsTile(
      {Key? key, required this.value, required this.percentage})
      : super(key: key);
  final int? value;
  final double? percentage;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: size.height * .2,
          // width: size.width * .2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(
                      8,
                      8,
                    ))
              ],
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: CircleAvatar(
                //     backgroundColor: Colors.blueAccent.withOpacity(0.1),
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: SvgPicture.asset(
                //         MetaAssets.employeesIcon,
                //         colorFilter: ColorFilter.mode(
                //             Colors.blueAccent, BlendMode.srcIn),
                //       ),
                //     ),
                //   ),
                // ),
                const Text(
                  "Employee Participation",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      color: MetaColors.secondaryTextColor),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "${value ?? '0'}",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (percentage?.isNegative ?? false)
                          Icon(
                            Icons.arrow_circle_down_sharp,
                            color: Colors.red,
                          )
                        else
                          Icon(
                            Icons.arrow_circle_up_sharp,
                            color: Colors.green,
                          ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "${percentage?.abs()}%",
                            style: TextStyle(
                              fontSize: 11,
                              color: percentage?.isNegative ?? false
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "Since last month",
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: MetaColors.tertiaryTextColor,
                          fontSize: 11),
                    )
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0).copyWith(left: 0),
                //   child: SizedBox(
                //     height: 10,
                //     width: MediaQuery.of(context).size.width * .1,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(8),
                //       child: LinearProgressIndicator(
                //         color: Colors.green,
                //         backgroundColor: Colors.lightGreen,
                //         value: 0.75,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EnvironmentActionsStatsTile extends StatelessWidget {
  EnvironmentActionsStatsTile({Key? key, this.value, this.percentage})
      : super(key: key);
  int? value;
  double? percentage;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: size.height * .2,
          // width: size.width * .2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(
                      8,
                      8,
                    ))
              ],
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: CircleAvatar(
                //     backgroundColor: Colors.green.withOpacity(0.1),
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: SvgPicture.asset(
                //         MetaAssets.upwardTrend,
                //         colorFilter:
                //             ColorFilter.mode(Colors.green, BlendMode.srcIn),
                //       ),
                //     ),
                //   ),
                // ),
                const Text(
                  "Environmental Actions",
                  style: TextStyle(
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                      color: MetaColors.secondaryTextColor),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "${value}",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (percentage?.isNegative ?? false)
                          Icon(
                            Icons.arrow_circle_down_sharp,
                            color: Colors.red,
                          )
                        else
                          Icon(
                            Icons.arrow_circle_up_sharp,
                            color: Colors.green,
                          ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "${percentage?.abs().toStringAsFixed(1)}%",
                            style: TextStyle(
                              fontSize: 11,
                              color: percentage?.isNegative ?? false
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "Since last month",
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: MetaColors.tertiaryTextColor,
                          fontSize: 11),
                    )
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0).copyWith(left: 0),
                //   child: SizedBox(
                //     height: 10,
                //     width: MediaQuery.of(context).size.width * .1,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(8),
                //       child: LinearProgressIndicator(
                //         color: Colors.green,
                //         backgroundColor: Colors.lightGreen,
                //         value: 0.75,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Co2EmmissionsTile extends StatelessWidget {
  Co2EmmissionsTile({super.key, this.value, required this.percentage});
  double? value;
  double? percentage;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: size.height * .2,
        // width: size.width * .2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient:
                RadialGradient(center: Alignment.topRight, radius: .9, colors: [
              MetaColors.secondaryGradient,
              MetaColors.primaryColor,
            ]),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(
                    8,
                    8,
                  ))
            ],
            color: MetaColors.primaryColor),
        child: Padding(
          padding: const EdgeInsets.all(18.0).copyWith(right: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                // flex: 2,
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset(
                          MetaAssets.emmissionImage,
                          height: double.maxFinite,
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Carbon Emmissions Saved",
                            style: TextStyle(
                                fontSize: 15,
                                overflow: TextOverflow.visible,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "${value?.toStringAsFixed(2) ?? '0'} tCO2",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              // if (size.width > 1000)
              // Expanded(child: )
            ],
          ),
        ),
      ),
    );
  }
}

class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SideMenuItem(
                  index: 0,
                  title: "Home",
                  asset: MetaAssets.homeIcon,
                ),
                const SideMenuItem(
                  index: 1,
                  title: "Employees",
                  asset: MetaAssets.employeesIcon,
                ),
                SideMenuItem(
                  index: 2,
                  title: "Activities",
                  asset: MetaAssets.activityIcon,
                ),
                const SideMenuItem(
                  index: 3,
                  title: "Rewards",
                  asset: MetaAssets.rewards,
                ),
                SideMenuItem(
                  index: 4,
                  title: "Settings",
                  asset: MetaAssets.settingsIcon,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SideMenuItem extends StatefulWidget {
  const SideMenuItem(
      {super.key,
      required this.asset,
      required this.title,
      this.handler,
      required this.index});
  final String title;
  final String asset;
  final int index;
  final void Function()? handler;

  @override
  State<SideMenuItem> createState() => _SideMenuItemState();
}

class _SideMenuItemState extends State<SideMenuItem> {
  bool hasFocus = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusNode: FocusNode(),
      onTap: widget.handler ??
          () {
            context.read<NavigationCubit>().changeIndex(widget.index);
          },
      onFocusChange: (value) {
        setState(() {
          hasFocus = value;
        });
      },
      onHover: (hover) {
        setState(() {
          hasFocus = hover;
        });
      },
      child: Container(
        child: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: hasFocus || state.index == widget.index
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: MetaColors.primaryColor)
                    : null,
                // width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.all(18.0).copyWith(left: 8),
                  child: AnimatedDefaultTextStyle(
                    style: hasFocus || state.index == widget.index
                        ? GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white)
                        : GoogleFonts.poppins(
                            color: MetaColors.tertiaryTextColor),
                    duration: const Duration(milliseconds: 100),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          widget.asset,height: 30,
                          colorFilter: ColorFilter.mode(
                              hasFocus || widget.index == state.index
                                  ? Colors.white
                                  : MetaColors.tertiaryTextColor,
                              BlendMode.srcIn),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.title,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            18,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(
                    8,
                    8,
                  ))
            ], borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (MediaQuery.of(context).size.width < 1000)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: const Icon(
                        CupertinoIcons.list_bullet_indent,
                        color: Colors.black,
                      ),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Your Eco Overview",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoggedIn) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              (state.user.username!),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://cdn.pixabay.com/photo/2014/02/27/16/10/flowers-276014_1280.jpg"),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          MetaAssets.logo,
          height: 60,
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
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
                      child: const Icon(
                        CupertinoIcons.list_bullet_indent,
                        color: Colors.black,
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Settings",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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
                            offset: const Offset(
                              8,
                              8,
                            ))
                      ],
                      color: Colors.white),
                  child: Center(child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoggedIn) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      state.user.username!,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(state.user.email!),
                            ),
                            SizedBox(
                              width: 300,
                              child: CustomButton(
                                  loading: loading,
                                  handler: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    var response = await AuthRepository()
                                        .reset(state.user.email!);
                                    setState(() {
                                      loading = false;
                                    });
                                    if (response[0]) {
                                      showSnackBar(
                                          "Password Reset email sent successfully. Please check your email",
                                          isError: false);
                                    } else {
                                      showSnackBar(
                                        response[1] ?? "",
                                      );
                                    }
                                  },
                                  label: "Reset Password"),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Contact Details",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Email : info@envo.club",
                                style: TextStyle(
                                    color: MetaColors.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Phone : +353 83 899 6555",
                                style: TextStyle(
                                    color: MetaColors.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ))),
            ),
          ),
        ],
      ),
    );
  }
}
