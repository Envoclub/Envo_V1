import 'dart:ui';

import 'package:envo_mobile/utils/meta_assets.dart';
import 'package:envo_mobile/utils/meta_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MessageWidget extends StatefulWidget {
  MessageWidget(
      {Key? key,
      required this.message,
      this.isError = false,
      this.isProcessing = false})
      : super(key: key);
  String message;
  bool isError;
  bool isProcessing;
  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class Loader extends StatelessWidget {
  Loader({super.key, this.isWhite = false});

  bool isWhite;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: isWhite
            ? Lottie.asset(MetaAssets.loaderWhite)
            : Lottie.asset(MetaAssets.loaderBlue));
  }
}

class _MessageWidgetState extends State<MessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: (CurvedAnimation(
                parent: controller..forward(), curve: Curves.easeIn)
            .drive(Tween(begin: 0.2, end: 1))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            // height: 150,
            color: Colors.white,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: widget.isError
                        ? widget.isProcessing
                            ? Colors.amber.withOpacity(.1)
                            : Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    // gradient: widget.isError ? null : MetaColors.gradient,
                    border: Border.all(
                        color: widget.isError
                            ? widget.isProcessing
                                ? Colors.amber
                                : Colors.red
                            : Colors.green),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: widget.isError
                            ? widget.isProcessing
                                ? Icon(
                                    Icons.error_outline,
                                    color: Colors.amber,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close),
                                  )
                            : Icon(
                                Icons.safety_check_rounded,
                                color: Colors.green,
                              ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.isError
                                  ? widget.isProcessing
                                      ? "Processing"
                                      : 'Uh oh!'
                                  : "Congratulations!",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              widget.message,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

// SnackbarController showSnackBar(String message, {bool isError = true}) {
//   return Get.showSnackbar(GetSnackBar(
//     duration: Duration(seconds: 2),
//     backgroundColor: Colors.transparent,
//     messageText: MessageWidget(
//       isError: isError,
//       message: message,
//     ),
//   ));
// }

String formatDuration(Duration d) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (days != 0) {
    tokens.add('${days}d');
  }
  if (tokens.isNotEmpty || hours != 0) {
    tokens.add('${hours}h');
  }
  if (tokens.isNotEmpty || minutes != 0) {
    tokens.add('${minutes}m');
  }
  tokens.add('${seconds}s');

  return tokens.join(':');
}
