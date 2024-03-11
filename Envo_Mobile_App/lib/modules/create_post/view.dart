import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:envo_mobile/modules/auth_module/auth_screens/auth_helper_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../utils/meta_colors.dart';
import 'controller.dart';

class CreatePostView extends GetView<CreatePostController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Obx(() => Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  color: Colors.black,
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: controller.image.value != null
                      ? controller.pickVideo
                          ? Container(
                              child: AspectRatio(
                                aspectRatio:
                                    MediaQuery.of(context).size.aspectRatio,
                                child: controller.controller.value != null
                                    ? Obx(() => VideoPlayer(
                                        controller.controller.value!))
                                    : SizedBox.shrink(),
                              ),
                            )
                          : Image.file(
                              File(controller.image.value!.path),
                            )
                      : Center(
                          child: InkWell(
                            onTap: () {
                              controller.getImage();
                            },
                            child: Text(
                              "Tap to add ${controller.pickVideo ? "video" : "image"}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.handleImageSelection();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Obx(() => Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          controller.selectedAction.value !=
                                                  null
                                              ? controller.selectedAction.value!
                                                      .action ??
                                                  ''
                                              : "Click to Select an Action",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    controller.selectedAction.value?.image !=
                                                null &&
                                            controller.selectedAction.value!
                                                .image!.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    controller.selectedAction
                                                        .value!.image!),
                                          )
                                        : Icon(
                                            CupertinoIcons.tree,
                                            color: MetaColors.secondaryGradient,
                                          ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                    CustomButton(
                        loading: controller.loading.value,
                        handler: controller.selectedAction.value != null &&
                                controller.image.value != null
                            ? controller.handlePost
                            : null,
                        label: "Post")
                  ],
                )
              ],
            )),
      ),
    );
  }
}
