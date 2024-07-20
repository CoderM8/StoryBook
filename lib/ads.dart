import 'dart:convert';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:wixpod/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

String bannerIOS = '';
String bannerAndroid = '';
String interstitialAndroid = '';
String interstitialIOS = '';
InterstitialAd? interstitialAd;

Future<void> appTracking() async {
  final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.notDetermined) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  } else if (status == TrackingStatus.denied) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
  if (status == TrackingStatus.authorized) {
    await AppTrackingTransparency.getAdvertisingIdentifier();
  }
}

getAdData() async {
  MobileAds.instance.initialize();
  try {
    final request = http.MultipartRequest('POST', Uri.parse(Api.mainApi));
    request.fields['data'] = '{"method_name":"app_details"}';
    http.Response response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      var finalres = json.decode(response.body);
      bannerIOS = finalres['AUDIO_BOOK'][0]['ios_banner_ad_id'];
      bannerAndroid = finalres['AUDIO_BOOK'][0]['banner_ad_id'];
      interstitialAndroid = finalres['AUDIO_BOOK'][0]['interstital_ad_id'];
      interstitialIOS = finalres['AUDIO_BOOK'][0]['ios_interstital_ad_id'];
    }
  //  admobads().createInterstitialAd();
  //  admobads().bannerads();
  } catch (e) {
    print('error in get data $e');
  }
}

String get getBannerAdUnitId {
  if (Platform.isIOS) {
    return bannerAndroid;
  } else if (Platform.isAndroid) {
    return bannerIOS;
  }
  return 'Platform Exception';
}

String get interstitalAd {
  if (Platform.isIOS) {
    return interstitialIOS;
  } else if (Platform.isAndroid) {
    return interstitialAndroid;
  }
  return 'Platform Exception';
}

class admobads {
  Widget bannerads() {
    if (subscribe.value == false) {
      final googleBannerAd = BannerAd(
        adUnitId: getBannerAdUnitId,
        size: AdSize.banner,
        listener: const BannerAdListener(),
        request: AdRequest(),
      )..load();
      return Container(
        color: Colors.black12,
        alignment: Alignment.bottomCenter,
        width: googleBannerAd.size.width.toDouble(),
        height: googleBannerAd.size.height.toDouble(),
        child: AdWidget(ad: googleBannerAd),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  /// Interstitial Ads

  int maxFailedLoadAttempts = 3;
  int numInterstialAdLoadAttempt = 0;

  static final AdRequest request = AdRequest(
    keywords: ['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd? createInterstitialAd() {
    try {
      InterstitialAd.load(
          adUnitId: interstitalAd,
          request: request,
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              interstitialAd = ad;
              maxFailedLoadAttempts = 0;
              interstitialAd!.setImmersiveMode(true);
              // _interstitialAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {
              numInterstialAdLoadAttempt += 1;
              if (numInterstialAdLoadAttempt < maxFailedLoadAttempts) {
                admobads().createInterstitialAd();
              }
            },
          ));
    } catch (e) {}
    return null;
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      return;
    }
    if (subscribe.value == false) {
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {},
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          createInterstitialAd();
        },
      );
      interstitialAd!.show();
      interstitialAd = null;
    }
  }
}
