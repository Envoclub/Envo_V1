import 'package:envo_admin_dashboard/add_reward.dart';
import 'package:envo_admin_dashboard/reward_controller.dart';
import 'package:envo_admin_dashboard/utils/meta_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class RewardsView extends GetView<RewardsController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          child: Obx(() => Column(
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
                                    "Rewards",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Get.dialog(AddReward());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: MetaColors.primaryColor),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Add Rewards",
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
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller
                                              .rewardsList.value![index].title!,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            controller.rewardsList.value![index]
                                                .description!,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13)),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            "Coins Required " +
                                                controller.rewardsList
                                                    .value![index].coinrequired!
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,fontWeight: FontWeight.w600,
                                                fontSize: 13)),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            "Redeem by " +
                                                controller
                                                    .rewardsList
                                                    .value![index]
                                                    .redeemedCount!
                                                    .toString() +
                                                " people",
                                            style: TextStyle(
                                                color: Colors.black54,fontWeight: FontWeight.w600,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.network(
                                      controller
                                          .rewardsList.value![index].banner!,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: controller.rewardsList.value!.length,
                    ),
                  ),
                ],
              ))),
    );
  }
}
