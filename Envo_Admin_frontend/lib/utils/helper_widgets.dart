import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackBar(String message, {bool isError = true}) {
  Get.showSnackbar(GetSnackBar(

      // margin: EdgeInsets.only(top: kToolbarHeight),
      // padding: EdgeInsets.only(
      //    top: kToolbarHeight+5),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      dismissDirection: DismissDirection.horizontal,
      messageText: MessageWidget(
        message: message,
        isError: isError,
      )));
}

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
