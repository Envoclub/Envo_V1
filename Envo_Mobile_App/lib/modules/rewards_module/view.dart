import 'package:cached_network_image/cached_network_image.dart';
import 'package:envo_mobile/modules/auth_module/auth_screens/auth_helper_widgets.dart';
import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:envo_mobile/utils/helper_widgets.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/rewards_model.dart';
import '../../utils/custom_slider.dart';
import '../../utils/meta_assets.dart';
import '../../utils/meta_colors.dart';
import 'controller.dart';

class RewardsView extends GetView<RewardsController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Rewards",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Obx(
          () => ListView.builder(
              itemCount: controller.rewardsList.value!.length,
              itemBuilder: (context, index) {
                return RewardTile(
                  data: controller.rewardsList.value![index],
                );
              }),
        ));
  }
}

class RewardTile extends StatelessWidget {
  const RewardTile({super.key, required this.data});

  final RewardsModel data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: InkWell(
        onTap: () {
          Get.to(RewardDetailedView(data));
        },
        child: Container(
          height: 350,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(5, 10),
                    color: MetaColors.secondaryColor.withOpacity(0.1),
                    blurRadius: 10)
              ],
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Hero(
                tag: data.id.toString(),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: data.banner!,
                    fit: BoxFit.fill,
                    width: double.maxFinite,
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data.title.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${data.redeemedCount} people claimed this Item",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: MetaColors.tertiaryTextColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            MetaAssets.logo,
                            height: 15,
                            width: 15,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(data.coinrequired.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ))
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      SliderTheme(
                        data: Get.theme.sliderTheme
                            .copyWith(thumbShape: SliderThumbImage()),
                        child: Slider(
                            activeColor: MetaColors.primaryColor,
                            thumbColor: MetaColors.primaryColor,
                            value: AuthController.to.user.value!.reward! /
                                        data.coinrequired! <=
                                    1
                                ? AuthController.to.user.value!.reward! /
                                    data.coinrequired!
                                : 1,
                            onChanged: (val) {}),
                      ),
                      if (AuthController.to.user.value!.reward! <
                          data.coinrequired!)
                        Padding(
                          padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                          child: Text(
                            "${AuthController.to.user.value!.reward.toString()} / ${data.coinrequired}",
                            style: const TextStyle(
                                fontSize: 10,
                                color: MetaColors.tertiaryTextColor,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                    ],
                  ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RewardDetailedView extends GetView {
  RewardsModel data;
  RewardDetailedView(this.data);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Obx(
        () => RewardsController.to.loading.value!
            ? Center(
                child: Loader(),
              )
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Hero(
                            tag: data.id.toString(),
                            child: Container(
                              height: MediaQuery.of(context).size.height * .4,
                              child: CachedNetworkImage(
                                imageUrl: data.banner!,
                                fit: BoxFit.fill,
                                width: double.maxFinite,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data.title.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${data.redeemedCount} people claimed this Item",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color:
                                                  MetaColors.tertiaryTextColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        MetaAssets.logo,
                                        height: 15,
                                        width: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(data.coinrequired.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                children: [
                                  SliderTheme(
                                    data: Get.theme.sliderTheme.copyWith(
                                        thumbShape: SliderThumbImage()),
                                    child: Slider(
                                        activeColor: MetaColors.primaryColor,
                                        thumbColor: MetaColors.primaryColor,
                                        value: AuthController.to.user.value!
                                                        .reward! /
                                                    data.coinrequired! <=
                                                1
                                            ? AuthController
                                                    .to.user.value!.reward! /
                                                data.coinrequired!
                                            : 1,
                                        onChanged: (val) {}),
                                  ),
                                  if (AuthController.to.user.value!.reward! <
                                      data.coinrequired!)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0)
                                          .copyWith(top: 0),
                                      child: Text(
                                        "${AuthController.to.user.value!.reward.toString()} / ${data.coinrequired}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: MetaColors.tertiaryTextColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(5, 10),
                                        color: MetaColors.secondaryColor
                                            .withOpacity(0.1),
                                        blurRadius: 10)
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: MetaColors.secondaryColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              data.description.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (AuthController.to.user.value!.reward! >=
                      data.coinrequired!)
                    CustomButton(
                        handler: () {
                          RewardsController.to.redeemData(data);
                        },
                        label: "Redeem")
                ],
              ),
      ),
    );
  }
}
