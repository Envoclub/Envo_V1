import 'dart:developer';

import 'package:envo_admin_dashboard/auth.dart';
import 'package:envo_admin_dashboard/chart.dart';
import 'package:envo_admin_dashboard/cubits/auth/auth_cubit.dart';
import 'package:envo_admin_dashboard/cubits/bar_chart/barchart_cubit.dart';
import 'package:envo_admin_dashboard/cubits/linechart/linechart_cubit.dart';
import 'package:envo_admin_dashboard/cubits/navigation/navigation_cubit.dart';
import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/auth_view.dart';
import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/reset_password.dart';
import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/sign_in_view.dart';
import 'package:envo_admin_dashboard/pie_chart.dart';
import 'package:envo_admin_dashboard/repositories/auth_repository.dart';
import 'package:envo_admin_dashboard/repositories/chart_repository.dart';
import 'package:envo_admin_dashboard/utils/meta_assets.dart';
import 'package:envo_admin_dashboard/utils/meta_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cubits/actions/actions_cubit.dart';
import 'cubits/employee/employee_cubit.dart';
import 'cubits/pie_chart/piechart_cubit.dart';
import 'cubits/posts/posts_cubit.dart';
import 'dashboard.dart';
import 'package:url_strategy/url_strategy.dart';

import 'repositories/employee_repository.dart';
import 'repositories/post_repository.dart';

void main() {
  // Here we set the URL strategy for our web app.
  // It is safe to call this function when running on mobile or desktop as well.
  setPathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository()..initTokens(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthCubit(context.read<AuthRepository>())..init(),
          ),
          BlocProvider(create: (context) => NavigationCubit()),
          BlocProvider(
              create: (context) => LinechartCubit(
                  ChartRepository(context.read<AuthRepository>()))),
          BlocProvider(
              create: (context) => BarchartCubit(
                  ChartRepository(context.read<AuthRepository>()))),
          BlocProvider(
              create: (context) =>
                  PostsCubit(PostRepository(context.read<AuthRepository>()))),
          BlocProvider(
              create: (context) =>
                  ActionsCubit(PostRepository(context.read<AuthRepository>()))),
          BlocProvider(
              create: (context) => PiechartCubit(
                  ChartRepository(context.read<AuthRepository>()))),
          BlocProvider(
              create: (context) => EmployeeCubit(
                  EmployeeRepository(context.read<AuthRepository>())))
        ],
        child: GetMaterialApp(
          initialRoute: "/",
          onGenerateRoute: (settings) {
            log(settings.name.toString());
            if (settings.name!.contains("/activate") &&
                settings.name!.split("/").length == 4) {
              log(settings.name!.split("/").toString());
              return MaterialPageRoute(
                  builder: (context) => ActivationScreen(
                        uid: settings.name!.split("/")[2],
                        token: settings.name!.split("/").last,
                      ));
            } else if (settings.name!.contains("/password/reset") &&
                settings.name!.split("/").length == 6) {
              log(settings.name!.split("/").toString());
              return MaterialPageRoute(
                  builder: (context) => ResetPassword(
                        uid: settings.name!.split("/")[4],
                        token: settings.name!.split("/").last,
                      ));
            } else {
              return MaterialPageRoute(
                  builder: (context) => Scaffold(
                      body: Container(
                          color: Colors.blue.shade100.withOpacity(0.1),
                          child: Auth())));
            }
          },
          debugShowCheckedModeBanner: false,
          title: 'Envo Dashboard',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: GoogleFonts.poppinsTextTheme()),
          home: Scaffold(
              body: Container(
                  color: Colors.blue.shade100.withOpacity(0.1), child: Auth())),
        ),
      ),
    );
  }
}

class ActivationScreen extends StatefulWidget {
  ActivationScreen({
    super.key,
    required this.token,
    required this.uid,
  });
  String uid;
  String token;
  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  @override
  void initState() {
    activate();
  }

  bool loading = false;
  String? error;
  activate() async {
    setState(() {
      loading = true;
    });
    var response = await AuthRepository().activate(widget.uid, widget.token);
    if (response[0]) {
      setState(() {
        loading = false;
      });
    } else {
      error = response[1];
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: loading
          ? Center(
              child: Loader(),
            )
          : error != null
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "OH oh!!",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(error!),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              MetaAssets.logo,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "envo",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Congratulations",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "You have successfully activated your organisations envo admin account.\nPlease visit your email for further instructions",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
    ));
  }
}
