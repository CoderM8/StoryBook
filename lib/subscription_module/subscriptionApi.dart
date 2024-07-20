import 'dart:convert';
import 'dart:io';
import 'package:wixpod/ads.dart';
import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/controller/subscription_controller.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'storeConfig.dart';

String splitString(String value) {
  return value.split(':').first;
}

///BUY SUBSCRIPTION
Future<bool> buySubscription({required StoreProduct item, required String id}) async {
  try {
    isLoading.value = true;
    final customerInfo = await Purchases.purchaseStoreProduct(item);
    final isActive = customerInfo.entitlements.active.containsKey(entitlementKey);
    if (kDebugMode) {
      print('HELLO REVENUE-CAT SUB BUY $isActive');
    }
    if (isActive) {
      print('isActive');
      await handleSuccessSubscription(purchasedItem: item, id: id);
    }
    return isActive;
  } on PlatformException catch (e) {
    isLoading.value = false;
    if (kDebugMode) {
      print('HELLO REVENUE-CAT SUB ERROR ${e.message}');
    }
  }
  return false;
}

///API ENTRY SUBSCRIPTION
Future<void> handleSuccessSubscription({required StoreProduct purchasedItem, required String id}) async {
  final Map<String, dynamic> map = await getTransactionId(identifier: splitString(purchasedItem.identifier), type: PurchasesType.sub);
  if (map.isNotEmpty) {
    if (kDebugMode) {
      print("HELLO REVENUE-CAT SUB PURCHASE-ID ${splitString(purchasedItem.identifier)}");
    }
    print('get subscription userid ${userid} tid ${map['store_transaction_id']} pid ${id}');
    await AllServices().buySubscription(tid: map['store_transaction_id'], pid: id, purchaseId: purchasedItem.identifier).whenComplete(() async {
      await getSubscriptionData();
    });
    isLoading.value = false;
    subscribe.value = true;
    await getAdData();
  }
}

///GET TRANSACTION ID
Future<Map<String, dynamic>> getTransactionId({required String identifier, required PurchasesType type}) async {
  print('identifier ------ ${identifier}');
  final url = Uri.parse('https://api.revenuecat.com/v1/subscribers/${await Purchases.appUserID}');
  final Map<String, String> headers;
  if (Platform.isIOS) {
    headers = {"X-Platform": "ios", "accept": "application/json", "Authorization": "Bearer $appleApiKey"};
  } else {
    headers = {"X-Platform": "android", "accept": "application/json", "Authorization": "Bearer $googleApiKey"};
  }
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    final request = jsonDecode(response.body);
    if (type == PurchasesType.sub) {
      print('HELLO REVENUE-CAT RESPONSE 00000m ${type.name} ${request['subscriber']}');
      print('HELLO REVENUE-CAT RESPONSE 111111 ${type.name} ${request['subscriber']['subscriptions']}');
      if (Map.from(request['subscriber']['subscriptions']).isNotEmpty && request['subscriber']['subscriptions'].toString().contains(identifier)) {
        if (kDebugMode) {
          print('HELLO REVENUE-CAT RESPONSE ${type.name} ${request['subscriber']['subscriptions'][identifier]}');
          print('HELLO REVENUE-CAT TransactionId ${request['subscriber']['subscriptions'][identifier]['store_transaction_id']}');
        }
        return {
          "productId": identifier,
          "store_transaction_id": request['subscriber']['subscriptions'][identifier]['store_transaction_id'],
          "purchase_date": request['subscriber']['subscriptions'][identifier]['purchase_date'],
          "expires_date": request['subscriber']['subscriptions'][identifier]['expires_date'],
        };
      }
      return {};
    }
    return {};
  }
  return {};
}

///GET USER SUBSCRIPTION
Future<void> getSubscriptionData() async {
  try {
    subscribe.value = false;
    final customerInfo = await Purchases.getCustomerInfo();
    if (kDebugMode) {
      print('HELLO REVENUE-CAT SUB USERID ${await Purchases.appUserID} PLAN ${customerInfo.activeSubscriptions.length}');
    }
    if (userid != null) {
      await AllServices().getSubscription().then((val) async {
        if (val!.audioBook[0].success != 0) {
          if (kDebugMode) {
            print('HELLO REVENUE-CAT SUB all response ${val.toJson()}');
            print('HELLO REVENUE-CAT SUB condition ${DateTime.now().toUtc().isBefore(val.audioBook[0].planEndDate)}');
          }
          if (DateTime.now().toUtc().isBefore(val.audioBook[0].planEndDate)) {
            isActivePlan.value = int.parse(val.audioBook[0].planId);
            isMemberAdd.value = val.audioBook[0].isMemeberAdd;
            isSuccess.value = val.audioBook[0].success;
            subscribe.value = true;
            await getAdData();
          } else {
            if (customerInfo.entitlements.active.containsKey(entitlementKey) && customerInfo.activeSubscriptions.isNotEmpty) {
              final isRenew = (DateTime.parse(customerInfo.entitlements.all['pro']!.expirationDate!).isAfter(val.audioBook[0].planEndDate));
              if (kDebugMode) {
                print(
                    'HELLO REVENUE-CAT SUB IS-RENEW $isRenew END-DATE [API] ${val.audioBook[0].planEndDate} END-DATE [REV] ${customerInfo.entitlements.all['pro']!.expirationDate}');
              }
              if (isRenew) {
                await AllServices()
                    .buySubscription(pid: val.audioBook[0].planId, update: true, endDate: customerInfo.entitlements.all['pro']!.expirationDate)
                    .whenComplete(() async {
                  await getSubscriptionData();
                });
                subscribe.value = true;
                await getAdData();
              }
            } else {
              print('else nu else ----');
            }
          }
        } else {
          subscribe.value = false;
        }
      });
    } else {
      subscribe.value = false;
    }
    if (kDebugMode) {
      print('HELLO REVENUE-CAT SUB ACTIVE ${subscribe.value}');
    }
  } on PlatformException catch (e) {
    subscribe.value = false;
    print('GET SUBSCRIPTION ERROR [${e.code}] ${e.message}');
  }
}

///RESTORE SUBSCRIPTION
Future getRestoreSubscription(context) async {
  try {
    subscribe.value = false;
    isLoading.value = false;
    isLoading.value = true;
    ShowSnackBar(message: 'Processing....');
    final customerInfo = await Purchases.restorePurchases();
    final List<String> items = customerInfo.activeSubscriptions;
    final bool isRevenueCat = items.isNotEmpty;
    if (kDebugMode) {
      print('HELLO REVENUE-CAT RESTORE REV ACTIVE $isRevenueCat ');
    }

    /// REVENUE-CAT FOR NEW USER FIRST TIME
    if (customerInfo.entitlements.all.isNotEmpty) {
      final bool isActive = (customerInfo.entitlements.active.containsKey(entitlementKey) && isRevenueCat);
      if (kDebugMode) {
        print(
            'HELLO REVENUE-CAT RESTORE REV-ACTIVE $isActive \nID ${customerInfo.entitlements.all['pro']!.productIdentifier}\nSTART ${customerInfo.entitlements.all['pro']!.latestPurchaseDate}\nEND ${customerInfo.entitlements.all['pro']!.expirationDate}');
      }

      final List<StoreProduct> product = await Purchases.getProducts([customerInfo.entitlements.all['pro']!.productIdentifier]);
      final purchasedItem = product.first;
      final String identifier = splitString(purchasedItem.identifier);
      final purchaseId = await getTransactionId(identifier: splitString(purchasedItem.identifier), type: PurchasesType.sub);
      if (kDebugMode) {
        print("HELLO REVENUE-CAT RESTORE PURCHASE-ID $identifier");
      }
      await AllServices().getSubscription().then((val) async {
        /// plan active no hoy to
        if (val!.audioBook[0].success == '0') {
          if (isActive) {
            Map plan = {};
            Ids.forEach((element) {
              if (element['sku'] == splitString(purchasedItem.identifier)) {
                plan.addAll(element);
              }
            });
            print('HELLO REVENUE-CAT RESTORE plan ${plan}');
            if (plan.isNotEmpty) {
              await AllServices().buySubscription(pid: plan['id'], endDate: purchaseId['expires_date'], update: true).then((value) {
                if (value!.audioBook[0].success == "1") {
                  subscribe.value = true;
                }
              });
            }
          }
        } else {
          if (DateTime.now().toUtc().isBefore(val.audioBook[0].planEndDate)) {
            subscribe.value = true;
          } else {
            if (isActive) {
              final String endDate = customerInfo.entitlements.all['pro']!.expirationDate!;
              final bool isRenew = (DateTime.parse(endDate).isAfter(val.audioBook[0].planEndDate));

              if (kDebugMode) {
                print('HELLO REVENUE-CAT RESTORE IS-RENEW $isRenew END-DATE [B4A] ${val.audioBook[0].planEndDate} END-DATE [REV] $endDate');
              }
              if (isRenew) {
                Map plan = {};
                Ids.forEach((element) {
                  if (element['sku'] == splitString(purchasedItem.identifier)) {
                    plan.addAll(element);
                  }
                });
                print('HELLO REVENUE-CAT RESTORE plan ${plan}');
                if (plan.isNotEmpty) {
                  await AllServices().buySubscription(pid: plan['id'], endDate: purchaseId['expires_date'], update: true).then((value) {
                    if (value!.audioBook[0].success == "1") {
                      subscribe.value = true;
                    }
                  });
                }
              }
            }
          }
        }
      });
    } else {
      /// REVENUE-CAT FOR OLD USER FIRST TIME

      await AllServices().getSubscription().then((val) async {
        if (val!.audioBook[0].success == "1") {
          if (DateTime.now().toUtc().isBefore(val.audioBook[0].planEndDate)) {
            subscribe.value = true;
          } else {
            if (isRevenueCat) {
              final identifier = splitString(items.first);
              final Map<String, dynamic> subscriber = await getTransactionId(identifier: identifier, type: PurchasesType.sub);
              if (subscriber.isNotEmpty) {
                final isRenew = (DateTime.parse(subscriber['expires_date']).isAfter(val.audioBook[0].planEndDate));
                if (kDebugMode) {
                  print(
                      'HELLO REVENUE-CAT RESTORE IS-RENEW $isRenew END-DATE [B4A] ${val.audioBook[0].planEndDate} END-DATE [REV] ${subscriber['expires_date']}');
                }
                if (isRenew) {
                  Map plan = {};
                  Ids.forEach((element) {
                    if (element['sku'] == identifier) {
                      plan.addAll(element);
                    }
                  });
                  print('HELLO REVENUE-CAT RESTORE plan ${plan}');
                  if (plan.isNotEmpty) {
                    await AllServices().buySubscription(pid: plan['id'], endDate: subscriber['expires_date'], update: true).then((value) {
                      if (value!.audioBook[0].success == "1") {
                        subscribe.value = true;
                      }
                    });
                  }
                }
              }
            }
          }
        }
      });
    }
    isLoading.value = false;
    debugPrint('HELLO REVENUE-CAT RESTORE ACTIVE $subscribe');
    if (!subscribe.value) {
      ShowSnackBar(message: 'No plan Active');
    } else {
      await getSubscriptionData();
    }
  } on PlatformException catch (e) {
    isLoading.value = false;
    if (kDebugMode) {
      print('HELLO REVENUE-CAT SUB ERROR ${e.message}');
    }
    ShowSnackBar(message: e.message);
  }
}
