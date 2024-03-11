import 'dart:developer';
import 'package:envo_admin_dashboard/cubits/actions/actions_cubit.dart';
import 'package:envo_admin_dashboard/cubits/auth/auth_cubit.dart';
import 'package:envo_admin_dashboard/cubits/posts/posts_cubit.dart';
import 'package:envo_admin_dashboard/utils/meta_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'auth.dart';
import 'models/posts.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionsCubit, ActionsState>(
      builder: (context, state) {
        if (state is ActionsLoaded) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Activities",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<PostsCubit, PostsState>(
                      builder: (context, state) {
                        log("Building posts");
                        if (state is PostsLoaded) {
                          return DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: MetaColors.primaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TabBar(
                                        indicatorColor: Colors.white,
                                        unselectedLabelColor:
                                            Colors.white.withOpacity(0.5),
                                        labelColor: Colors.white,
                                        tabs: [
                                          Tab(
                                            child: Text("Verified Posts"),
                                          ),
                                          Tab(
                                            child: Text("Unverified Posts"),
                                          )
                                        ]),
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      Container(
                                        child: ResponsiveGridListBuilder(
                                            horizontalGridSpacing:
                                                16, // Horizontal space between grid items
                                            verticalGridSpacing:
                                                16, // Vertical space between grid items
                                            horizontalGridMargin:
                                                50, // Horizontal space around the grid
                                            verticalGridMargin:
                                                50, // Vertical space around the grid
                                            minItemWidth:
                                                300, // The minimum item width (can be smaller, if the layout constraints are smaller)
                                            minItemsPerRow:
                                                2, // The minimum items to show in a single row. Takes precedence over minItemWidth
                                            maxItemsPerRow:
                                                5, // The maximum items to show in a single row. Can be useful on large screens
                                            gridItems: state.posts
                                                .where((element) =>
                                                    element.active == true)
                                                .map((e) => PostTile(post: e))
                                                .toList() // The list of widgets in the grid
                                            , // The list of widgets in the grid
                                            builder: (context, items) {
                                              if (items.isEmpty)
                                                return Center(
                                                  child: Text("No posts yet!"),
                                                );
                                              return ListView(
                                                children: items,
                                              );
                                              // Place to build a List or Column to access all properties.
                                              // Set [items] as children attribute for example.
                                            }),
                                      ),
                                      Container(
                                        child: ResponsiveGridListBuilder(
                                            horizontalGridSpacing:
                                                16, // Horizontal space between grid items
                                            verticalGridSpacing:
                                                16, // Vertical space between grid items
                                            horizontalGridMargin:
                                                50, // Horizontal space around the grid
                                            verticalGridMargin:
                                                50, // Vertical space around the grid
                                            minItemWidth:
                                                300, // The minimum item width (can be smaller, if the layout constraints are smaller)
                                            minItemsPerRow:
                                                2, // The minimum items to show in a single row. Takes precedence over minItemWidth
                                            maxItemsPerRow:
                                                5, // The maximum items to show in a single row. Can be useful on large screens
                                            gridItems: state.posts
                                                .where((element) =>
                                                    element.active != true)
                                                .map((e) => PostTile(post: e))
                                                .toList(), //st of widgets in the grid
                                            builder: (context, items) {
                                              if (items.isEmpty)
                                                return Center(
                                                  child: Text("No posts yet!"),
                                                );
                                              return ListView(
                                                children: items,
                                              );
                                              // Place to build a List or Column to access all properties.
                                              // Set [items] as children attribute for example.
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (state is PostsLoading)
                          return Center(
                            child: Loader(),
                          );
                        if (state is PostsError)
                          return Center(
                            child: Text(state.error),
                          );
                        return SizedBox.shrink();
                      },
                    ),
                  ))
                ],
              ),
            ),
          );
        }

        if (state is ActionsLoading) {
          return Center(
            child: Loader(),
          );
        }
        if (state is ActionsError) {
          return Center(
            child: Text(state.error),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class PostTile extends StatefulWidget {
  const PostTile({Key? key, required this.post}) : super(key: key);
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
    Rxn<double> value = Rxn(0.0);
    RxBool enabled = true.obs;
    return ScaleTransition(
      scale:
          CurvedAnimation(parent: _animationController!, curve: Curves.easeIn),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: InkWell(
          onDoubleTap: () {},
          onTap: () {
            Get.to(() => PostEnlargedView(widget.post));
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color:
                          Color.fromARGB(255, 118, 134, 134).withOpacity(0.1),
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
                            backgroundImage:
                                NetworkImage(widget.post.photoUrl ?? ''),
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
                                    Expanded(
                                      child: Text(
                                        (context.read<ActionsCubit>().state
                                                    as ActionsLoaded)
                                                .actions
                                                .firstWhereOrNull((element) =>
                                                    element.id ==
                                                    widget.post.action)
                                                ?.action ??
                                            '',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    (context.read<ActionsCubit>().state
                                                    as ActionsLoaded)
                                                .actions
                                                .firstWhereOrNull((element) =>
                                                    element.id ==
                                                    widget.post.action) !=
                                            null
                                        ? CircleAvatar(
                                            radius: 10,
                                            backgroundImage: NetworkImage(
                                                (context
                                                        .read<ActionsCubit>()
                                                        .state as ActionsLoaded)
                                                    .actions
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
                                // if (value) {
                                //   _controller?.play();
                                // } else {
                                //   _controller?.pause();
                                // }
                              },
                              child: VideoPlayer(_controller!))
                          : Image.network(
                              widget.post.postUrl!,
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
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            context.read<PostsCubit>().verifyPost(widget.post);
                            // setState(() {
                            //   widget.post.active = !widget.post.active!;
                            // });
                            setState(() {
                              
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: widget.post.active! != true
                                      ? Colors.grey
                                      : Colors.green,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.post.active! != true
                                      ? "Unverified"
                                      : "Verified",
                                ),
                                SizedBox(
                                  width: 10,
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
                                ),
                                Text("likes"),
                              ],
                            ),
                          ),
                        ),
                        if (widget.post.active! != true)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                context
                                    .read<PostsCubit>()
                                    .verifyPost(widget.post);
                                // setState(() {
                                //   widget.post.active = !widget.post.active!;
                                // });
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.green.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: Offset(0, 5))
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Verify",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.verified, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )

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
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child:
                              Icon(Icons.arrow_back_ios, color: Colors.white)),
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
                                    (context.read<ActionsCubit>().state
                                                as ActionsLoaded)
                                            .actions
                                            .firstWhereOrNull((element) =>
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
                                  (context.read<ActionsCubit>().state
                                                  as ActionsLoaded)
                                              .actions
                                              .firstWhereOrNull((element) =>
                                                  element.id ==
                                                  widget.post.action) !=
                                          null
                                      ? CircleAvatar(
                                          radius: 10,
                                          backgroundImage: NetworkImage((context
                                                  .read<ActionsCubit>()
                                                  .state as ActionsLoaded)
                                              .actions
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
                        : Image.network(
                            widget.post.postUrl!,
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
                          if (widget.post.active! != true) {
                            context.read<PostsCubit>().verifyPost(widget.post);
                            widget.post.active = true;
                            setState(() {});
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.verified,
                                  color: widget.post.active! != true
                                      ? Colors.grey
                                      : Colors.green),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.post.active! != true
                                    ? "Unverified"
                                    : "Verified",
                              ),
                              SizedBox(
                                width: 10,
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
                              ),
                              Text("likes"),
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
