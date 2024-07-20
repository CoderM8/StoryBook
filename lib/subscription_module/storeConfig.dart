import 'package:purchases_flutter/purchases_flutter.dart';

const appleApiKey = 'appl_oMdXPFoDOvCrbTlEcVvNwwLEukJ';

const googleApiKey = 'goog_ZqXDJjZMFqyJVohrLTLMaGJzAFz';

const entitlementKey = 'pro';

class StoreConfig {
  final Store store;
  final String apiKey;
  static StoreConfig? _instance;

  factory StoreConfig({required Store store, required String apiKey}) {
    _instance ??= StoreConfig._internal(store, apiKey);
    return _instance!;
  }

  StoreConfig._internal(this.store, this.apiKey);

  static StoreConfig get instance {
    return _instance!;
  }
}

Future<void> configureSDK() async {
  await Purchases.setLogLevel(LogLevel.debug);
  await Purchases.configure(PurchasesConfiguration(StoreConfig.instance.apiKey));
  await Purchases.enableAdServicesAttributionTokenCollection();
}
