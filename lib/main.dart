import 'dart:async';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_context/one_context.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/controller/user_controller.dart';
import 'ads.dart';
import 'firebase_options.dart';
import 'localization/applanguage.dart';
import 'subscription_module/storeConfig.dart';
import 'subscription_module/subscriptionApi.dart';
import 'ui/splash_screen/splash_screen.dart';

SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
  systemNavigationBarColor: blackColor,
  statusBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
);

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  await getVersion();

  ///REVENUE-CAT PURCHASES CONFIGURATION
  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appStore,
      apiKey: appleApiKey,
    );
  }
  if (Platform.isAndroid) {
    StoreConfig(
      store: Store.playStore,
      apiKey: googleApiKey,
    );
  }
  await configureSDK();
  getUserLanguage();
  SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await getUserId();
  await getSubscriptionData();
  await getAdData();

  ///one signal notification
  const String oneSignalAppId = "95174ece-4a9a-4f90-b888-64d636e0f460";
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(oneSignalAppId);
  OneSignal.Notifications.requestPermission(true);

  /// firebase analytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  if (userid != null) {
    FirebaseCrashlytics.instance.setUserIdentifier(userid!);
  }

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics;

  /// appTracking
  await appTracking();

 // runApp(MyApp());

  /// This widget use for App Restart
  OnePlatform.app = () => MyApp();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        SystemChrome.setSystemUIOverlayStyle(overlayStyle);
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState detached');
        break;
      case AppLifecycleState.hidden:
        print('appLifeCycleState hidden');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: AppTranslations(),
          locale: Locale(languagecode),
          title: "Wixpod",
          builder: OneContext().builder,
          navigatorKey: OneContext().key,
          theme: ThemeData(
            appBarTheme: AppBarTheme(backgroundColor: blackColor),
            scaffoldBackgroundColor: blackColor,
            useMaterial3: false,
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: whiteColor),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
