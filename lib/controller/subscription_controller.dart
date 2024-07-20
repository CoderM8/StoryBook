import 'package:wixpod/services/all_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:html/parser.dart';

List<Map> Ids = [];

class SubscriptionController extends GetxController {
  GlobalKey<FormState> adduserkey = GlobalKey<FormState>();
  TextEditingController addUser = TextEditingController();

  RxBool isRefresh = false.obs;
  RxBool isLoading = false.obs;

  RxList<StoreProduct> subscriptionProducts = <StoreProduct>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchProductData();
  }

  /// REVENUE-CAT GET PRODUCT
  Future<void> fetchProductData() async {
    isLoading.value = true;
    /// SUBSCRIPTION
    List<String> subIds = [];
    try {
      await AllServices().subscriptionPlans().then((value) async {
        Ids.clear();
        for (int i = 0; i < value!.audioBook.length; i++) {
          subIds.add(value.audioBook[i].skuId);
          final description = parse(value.audioBook[i].planDescription).documentElement!.text;
          Ids.add({
            'id': value.audioBook[i].id,
            'sku': value.audioBook[i].skuId,
            'plantype': value.audioBook[i].planType,
            'description': description.trim()
          });
        }
        subscriptionProducts.value = await Purchases.getProducts(subIds, productCategory: ProductCategory.subscription);
        subscriptionProducts.sort((a, b) => b.identifier.compareTo(a.identifier));
      });
      isLoading.value = false;

    } on PlatformException catch (e) {
        isLoading.value = false;
        print('HELLO REVENUE-CAT Error $e');

    }
  }
}
