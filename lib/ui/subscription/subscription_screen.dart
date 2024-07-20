// ignore_for_file: deprecated_member_use

import 'package:wixpod/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/constants/widget/textfiledwidget.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:wixpod/controller/subscription_controller.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:wixpod/subscription_module/subscriptionApi.dart';
import 'package:wixpod/ui/home/bottom_navigationbar.dart';

class SubscriptionScreen extends StatelessWidget {
  SubscriptionScreen({super.key});

  final SubscriptionController subscriptionController = Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Styles.regular('Subscription'.tr, fw: FontWeight.bold, fs: 20.sp, ff: "Poppins-Bold"),
        centerTitle: true,
        leading: Backbutton(),
        elevation: 0,
      ),
      body: Obx(() {
        return ModalProgressHUD(
          inAsyncCall: isLoading.value,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() {
                  if (subscriptionController.isLoading.value == false) {
                    if (subscriptionController.subscriptionProducts.isNotEmpty) {
                      return ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                        itemCount: subscriptionController.subscriptionProducts.length,
                        itemBuilder: (context, i) {
                          Map plan = {};
                          final storeProduct = subscriptionController.subscriptionProducts[i];
                          Ids.forEach((element) {
                            if (element['sku'] == splitString(storeProduct.identifier)) {
                              plan.addAll(element);
                            }
                          });
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Card(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r), side: BorderSide(color: whiteColor, width: 1.w)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Styles.regular(storeProduct.title.replaceAll(RegExp(r'\([^]*\)'), '').trim(),
                                          ta: TextAlign.center, fs: 20.sp, ff: "Poppins-Bold"),
                                      Divider(color: whiteColor),
                                      Styles.regular(storeProduct.priceString + ' / ' + (plan.isEmpty ? '' : plan['plantype'] ?? ""),
                                          ta: TextAlign.center, fs: 30.sp, ff: "Poppins-Bold"),
                                      SizedBox(height: 10.h),
                                      Styles.regular(plan.isEmpty ? storeProduct.description : plan['description'] ?? "",
                                          ta: TextAlign.center, fs: 18.sp, ff: "Poppins-Regular", lns: 2),
                                      SizedBox(height: 10.h),
                                      Obx(() {
                                        isActivePlan.value;
                                        isSuccess.value;
                                        return InkWell(
                                            onTap: isSuccess.value == '0'
                                                ? () async {
                                                    String id = plan['id'].toString();
                                                    await buySubscription(item: storeProduct, id: id).then((v) {
                                                      if (v) {
                                                        Get.to(() => MyBottomNavigationBar());
                                                      }
                                                    });
                                                  }
                                                : null,
                                            child: Button(
                                                title: isSuccess.value == '1'
                                                    ? isActivePlan.value == (i + 1)
                                                        ? 'Activated'.tr
                                                        : 'Buy Plan'.tr
                                                    : 'Buy Plan'.tr));
                                      }),
                                      SizedBox(height: 5.h),
                                    ],
                                  ),
                                ),
                              ),
                              Obx(() {
                                isActivePlan.value;
                                if (isActivePlan.value == 2) {
                                  if (i == 1) {
                                    if (isMemberAdd.value == 0) {
                                      return InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                                                    child: Form(
                                                      key: subscriptionController.adduserkey,
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          TextFieldWidget(
                                                            labelText: 'EmailAddress'.tr,
                                                            controller: subscriptionController.addUser,
                                                            textInputType: TextInputType.emailAddress,
                                                            color: blackColor,
                                                            hint: 'EmailAddress'.tr,
                                                            prefixIcon: Padding(
                                                              padding: EdgeInsets.all(15.0.r),
                                                              child: SvgPicture.asset(
                                                                "assets/icons/emailicon.svg",
                                                              ),
                                                            ),
                                                            border: false,
                                                            validation: (value) {
                                                              if (value!.isEmpty) {
                                                                return 'EnterEmail'.tr;
                                                              }
                                                              String pattern =
                                                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                              RegExp regex = RegExp(pattern);
                                                              if (!regex.hasMatch(value)) {
                                                                return 'EnterEmail'.tr;
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(height: 20.h),
                                                          InkWell(
                                                            onTap: () {
                                                              if (subscriptionController.adduserkey.currentState!.validate()) {
                                                                AllServices().addUserFamilySubscription(fname: subscriptionController.addUser.text);
                                                                subscriptionController.isRefresh.value = !subscriptionController.isRefresh.value;
                                                              }
                                                              subscriptionController.addUser.clear();
                                                              Get.back();
                                                            },
                                                            child: Button(
                                                              title: 'Add'.tr,
                                                              titleColor: whiteColor,
                                                              color: blackColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ));
                                            },
                                          );
                                        },
                                        child: Container(
                                            height: 30.w,
                                            width: 30.w,
                                            margin: EdgeInsets.only(right: 10.w, top: 10.h),
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: greyColor),
                                            child: Icon(Icons.add, color: whiteColor)),
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                } else {
                                  return SizedBox.shrink();
                                }
                              }),
                            ],
                          );
                        },
                        separatorBuilder: (context, i) {
                          return SizedBox(height: 10.h);
                        },
                      );
                    } else {
                      return Column(
                        children: [
                          Styles.regular('tryagain'.tr, fw: FontWeight.bold, fs: 20.sp, ff: "Poppins-Bold"),
                          SizedBox(height: 10.h),
                          InkWell(
                              onTap: () {
                                subscriptionController.fetchProductData();
                              },
                              child: Button(title: 'Reload'.tr)),
                        ],
                      );
                    }
                  } else {
                    return Center(
                      child: Shimmer.fromColors(
                          child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                              itemBuilder: (context, i) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 1.w, color: whiteColor)),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 25.h,
                                        width: 150.w,
                                        decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                                      ),
                                      Divider(color: whiteColor),
                                      Container(
                                        height: 40.h,
                                        width: 300.w,
                                        margin: EdgeInsets.symmetric(vertical: 10.h),
                                        decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                                      ),
                                      Container(
                                        height: 20.h,
                                        width: MediaQuery.sizeOf(context).width,
                                        margin: EdgeInsets.symmetric(vertical: 6.h),
                                        decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                                      ),
                                      Container(
                                        height: 15.h,
                                        width: 200.w,
                                        decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                                      ),
                                      Container(
                                        height: 50.h,
                                        width: 268.w,
                                        margin: EdgeInsets.symmetric(vertical: 6.h),
                                        decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, i) {
                                return SizedBox(height: 10.h);
                              },
                              itemCount: 2),
                          baseColor: shimmerGray,
                          highlightColor: greyColor),
                    );
                  }
                }),
                SizedBox(height: 20.h),
                Obx(() {
                  if (subscribe.value) return SizedBox.shrink();
                  return InkWell(
                    onTap: () async {
                      await getRestoreSubscription(context);
                    },
                    child: Button(title: 'Restore Purchase'),
                  );
                }),
                Obx(() {
                  subscriptionController.isRefresh.value;
                  if (isActivePlan == '2') {
                    return FutureBuilder(
                        future: AllServices().getSubscription(),
                        builder: (context, snap) {
                          if (snap.hasData && snap.connectionState == ConnectionState.done) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Styles.regular('Family Members :'.tr, fs: 20.sp, ff: "Poppins-Bold"),
                                  SizedBox(height: 10.h),
                                  ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snap.data!.audioBook[0].member.length,
                                      itemBuilder: (context, i) {
                                        var data = snap.data!.audioBook[0].member[i];
                                        return Styles.regular(data.email, ta: TextAlign.start);
                                      },
                                      separatorBuilder: (context, i) {
                                        return SizedBox(
                                          height: 8.h,
                                        );
                                      }),
                                ],
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        });
                  } else {
                    return SizedBox.shrink();
                  }
                }),
                SizedBox(height: 10.h),
                RichStyles(text: 'dis1'.tr),
                RichStyles(text: 'dis2'.tr),
                RichStyles(text: 'dis3'.tr),
                RichStyles(text: 'dis4'.tr),
                SizedBox(height: 20.h)
              ],
            ),
          ),
        );
      }),
    );
  }
}

class RichStyles extends StatelessWidget {
  final String text;

  const RichStyles({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 10.w,
              width: 10.w,
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(shape: BoxShape.circle, color: whiteColor)),
          Expanded(
            child: Styles.regular(text, ff: 'Poppins-Regular', ta: TextAlign.start, fs: 12.sp),
          ),
        ],
      ),
    );
  }
}
