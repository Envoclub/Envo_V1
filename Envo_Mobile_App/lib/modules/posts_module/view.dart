import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:envo_mobile/models/posts.dart';
import 'package:envo_mobile/modules/home/controller.dart';
import 'package:envo_mobile/modules/posts_module/controller.dart';
import 'package:envo_mobile/utils/constants.dart';
import 'package:envo_mobile/utils/helper_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../utils/custom_slider.dart';
import '../../utils/meta_assets.dart';
import '../../utils/meta_colors.dart';
import '../auth_module/controller.dart';

class PostsView extends GetView<PostsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.loading.value!
          ? Center(
              child: Loader(),
            )
          : Scaffold(
              appBar: AppBar(
                  leadingWidth: 0,
                  title: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          HomeController.to.currentIndex.value = 3;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                AuthController.to.user.value?.photoUrl ?? ''),
                            backgroundColor: MetaColors.primaryColor,
                            radius: 15,
                          ),
                        ),
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Hi ",
                              style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: MetaColors.secondaryColor),
                              children: [
                            TextSpan(
                                text:
                                    "${AuthController.to.user.value!.username ?? ''}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: MetaColors.secondaryColor))
                          ])),
                    ],
                  )),
              body: RefreshIndicator(
                onRefresh: () {
                  return controller.getPosts();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: PageView.builder(
                    padEnds: false,
                    controller: controller.pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: controller.posts.value!.length,
                    itemBuilder: (context, index) {
                      return PostTile(post: controller.posts.value![index]);
                    },
                  ),
                ),
              ),
            ),
    );
  }
}

class PostTile extends StatefulWidget {
  const PostTile({super.key, required this.post});
  final Post post;
  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..forward();
    if (isVideo(widget.post.postUrl!)) {
      _controller = VideoPlayerController.network(widget.post.postUrl!);

      _controller?.addListener(() {
        setState(() {});
      });
      _controller?.setLooping(true);
      _controller?.initialize().then((_) => setState(() {}));
    }
  }

  bool isVideo(String url) => url.contains(".mp4");

  @override
  void dispose() {
    _animationController!.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.post.postUrl.toString());
    Rxn<double> value = Rxn(0.0);
    RxBool enabled = true.obs;
    return ScaleTransition(
      scale:
          CurvedAnimation(parent: _animationController!, curve: Curves.easeIn),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: InkWell(
          onDoubleTap: () {
            log("Liked");
            PostsController.to.likePost(widget.post);
          },
          onTap: () {
            Get.to(() => PostEnlargedView(widget.post));
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: MetaColors.primaryColor.withOpacity(0.1),
                      spreadRadius: 5,
                      offset: Offset(0, 5),
                      blurRadius: 10)
                ]),
            child: Center(
                child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                widget.post.photoUrl ?? ''),
                            radius: 15,
                            backgroundColor: MetaColors.primaryColor,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post.myUsername ?? '',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.post.description ?? '',
                              style: TextStyle(
                                  color: MetaColors.tertiaryTextColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(colors: [
                                    Colors.white,
                                    Colors.white,
                                    // MetaColors.secondaryGradient
                                  ])),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      HomeController.to.actions.value
                                              ?.firstWhereOrNull((element) =>
                                                  element.id ==
                                                  widget.post.action)
                                              ?.action ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    HomeController.to.actions.value
                                                ?.firstWhereOrNull((element) =>
                                                    element.id ==
                                                    widget.post.action) !=
                                            null
                                        ? CircleAvatar(
                                            radius: 10,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    HomeController
                                                        .to.actions.value!
                                                        .firstWhere((element) =>
                                                            element.id ==
                                                            widget.post.action)
                                                        .image!),
                                          )
                                        : Icon(
                                            CupertinoIcons.tree,
                                            color: MetaColors.secondaryGradient,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      child: isVideo(widget.post.postUrl!)
                          ? Focus(
                              focusNode: FocusNode(canRequestFocus: true),
                              onFocusChange: (value) {
                                if (value) {
                                  _controller?.play();
                                } else {
                                  _controller?.pause();
                                }
                              },
                              child: VideoPlayer(_controller!))
                          : CachedNetworkImage(
                              imageUrl: widget.post.postUrl!,
                              fit: BoxFit.cover,
                              width: double.maxFinite,
                            )),
                )),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(5, 10),
                              color: MetaColors.secondaryColor.withOpacity(0.1),
                              blurRadius: 10)
                        ],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: MetaColors.secondaryColor.withOpacity(0.2))),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            PostsController.to.likePost(widget.post);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.hand_thumbsup_fill,
                                  color: widget.post.likes?.firstWhereOrNull(
                                              (element) =>
                                                  element.usernames ==
                                                  AuthController.to.user.value!
                                                      .username) ==
                                          null
                                      ? Colors.grey
                                      : Colors.amberAccent,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0)
                                      .copyWith(top: 0, bottom: 0),
                                  child: Text(
                                    widget.post.likeCount.toString(),
                                    style: GoogleFonts.monoton(
                                        color: MetaColors.secondaryColor,
                                        fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        // Obx(() => Expanded(
                        //         child: SliderTheme(
                        //       data: Get.theme.sliderTheme
                        //           .copyWith(thumbShape: SliderThumbImage()),
                        //       child: Slider(
                        //           activeColor: MetaColors.primaryColor,
                        //           thumbColor: MetaColors.primaryColor,
                        //           value: value.value!,
                        //           onChanged: (val) {
                        //             if (enabled.value) value.value = val;
                        //           }),
                        //     )))
                      ],
                    ),
                  ),
                ),
                // Container(
                //   width: double.maxFinite,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.only(
                //           bottomLeft: Radius.circular(12),
                //           bottomRight: Radius.circular(12)),
                //       gradient: LinearGradient(colors: [
                //         Colors.white,
                //         Colors.white,
                //         MetaColors.secondaryGradient
                //       ])),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       children: [
                //         Icon(
                //           CupertinoIcons.tree,
                //           color: MetaColors.secondaryGradient,
                //         ),
                //         Text(
                //           "Planted a tree",
                //           style: TextStyle(
                //               fontSize: 18, fontWeight: FontWeight.w700),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

class PostEnlargedView extends StatefulWidget {
  Post post;
  PostEnlargedView(this.post);

  @override
  State<PostEnlargedView> createState() => _PostEnlargedViewState();
}

class _PostEnlargedViewState extends State<PostEnlargedView> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    if (isVideo(widget.post.postUrl!)) {
      _controller = VideoPlayerController.network(widget.post.postUrl!);

      _controller?.addListener(() {
        setState(() {});
      });
      _controller?.setLooping(true);
      _controller?.initialize().then((_) => setState(() {}));
      _controller?.play();
    }
  }

  bool isVideo(String url) => url.contains(".mp4");

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(0).copyWith(top: kToolbarHeight),
          child: Center(
              child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: MetaColors.primaryColor,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.myUsername ?? "",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            widget.post.description ?? "",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    HomeController.to.actions.value
                                            ?.firstWhereOrNull((element) =>
                                                element.id ==
                                                widget.post.action)
                                            ?.action ??
                                        '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  HomeController.to.actions.value
                                              ?.firstWhereOrNull((element) =>
                                                  element.id ==
                                                  widget.post.action) !=
                                          null
                                      ? CircleAvatar(
                                          radius: 10,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  HomeController
                                                      .to.actions.value!
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          widget.post.action)
                                                      .image!),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            CupertinoIcons.tree,
                                            color: MetaColors.secondaryGradient,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    child: isVideo(widget.post.postUrl!)
                        ? VideoPlayer(_controller!)
                        : CachedNetworkImage(
                            imageUrl: widget.post.postUrl!,
                            fit: BoxFit.cover,
                            width: double.maxFinite,
                          )),
              )),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(5, 10),
                            color: MetaColors.secondaryColor.withOpacity(0.1),
                            blurRadius: 10)
                      ],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: MetaColors.secondaryColor.withOpacity(0.2))),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          PostsController.to.likePost(widget.post);
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.hand_thumbsup_fill,
                                color: widget.post.likes?.firstWhereOrNull(
                                            (element) =>
                                                element.usernames ==
                                                AuthController
                                                    .to.user.value!.username) ==
                                        null
                                    ? Colors.grey
                                    : Colors.amberAccent,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0)
                                    .copyWith(top: 0, bottom: 0),
                                child: Text(
                                  widget.post.likeCount.toString(),
                                  style: GoogleFonts.monoton(
                                      color: MetaColors.secondaryColor,
                                      fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // Obx(() => Expanded(
                      //         child: SliderTheme(
                      //       data: Get.theme.sliderTheme
                      //           .copyWith(thumbShape: SliderThumbImage()),
                      //       child: Slider(
                      //           activeColor: MetaColors.primaryColor,
                      //           thumbColor: MetaColors.primaryColor,
                      //           value: value.value!,
                      //           onChanged: (val) {
                      //             if (enabled.value) value.value = val;
                      //           }),
                      //     )))
                    ],
                  ),
                ),
              ),
              // Container(
              //   width: double.maxFinite,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.only(
              //           bottomLeft: Radius.circular(12),
              //           bottomRight: Radius.circular(12)),
              //       gradient: LinearGradient(colors: [
              //         Colors.white,
              //         Colors.white,
              //         MetaColors.secondaryGradient
              //       ])),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       children: [
              //         Icon(
              //           CupertinoIcons.tree,
              //           color: MetaColors.secondaryGradient,
              //         ),
              //         Text(
              //           "Planted a tree",
              //           style: TextStyle(
              //               fontSize: 18, fontWeight: FontWeight.w700),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          )),
        ),
      ),
    );
  }
}
