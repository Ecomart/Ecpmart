import 'package:inspireui/utils/logs.dart';

import '../frameworks/frameworks.dart';
import '../models/cart/cart_model.dart';
import 'base_services.dart';
import 'wordpress/blognews_api.dart';

class Config {
  ConfigType? type;
  String? url;
  String? blog;
  String? consumerKey;
  String? consumerSecret;
  String? forgetPassword;
  String? accessToken;
  bool? isCacheImage;
  bool isBuilder = false;

  static final Config _instance = Config._internal();

  factory Config() => _instance;

  String get typeName => type!.typeName;

  Config._internal();

  bool get isListingType {
    return [
      ConfigType.listeo,
      ConfigType.listpro,
      ConfigType.mylisting,
    ].contains(type);
  }

  bool get isWooType {
    return [
      ConfigType.listeo,
      ConfigType.listpro,
      ConfigType.mylisting,
      ConfigType.dokan,
      ConfigType.wcfm,
      ConfigType.woo,
    ].contains(type);
  }

  bool get isStrapi {
    return typeName == 'strapi';
  }

  bool isVendorManagerType() {
    return ConfigType.vendorAdmin == type;
  }

  bool isVendorType() {
    return typeName == 'wcfm' || typeName == 'dokan';
  }

  void setConfig(config) {
    type = ConfigType.values.firstWhere(
      (element) => element.typeName == config['type'],
      orElse: () => ConfigType.woo,
    );
    url = config['url'];
    blog = config['blog'];
    consumerKey = config['consumerKey'];
    consumerSecret = config['consumerSecret'];
    forgetPassword = config['forgetPassword'];
    accessToken = config['accessToken'];
    isCacheImage = config['isCacheImage'];
    isBuilder = config['isBuilder'] ?? false;
  }
}

mixin ConfigMixin {
  late BaseServices api;
  late BaseFrameworks widget;
  BlogNewsApi? blogApi;

  /// mock services for FluxBuilder
  void configBase({required BaseServices apiServices, required appConfig}) {
    setAppConfig(appConfig);
    api = apiServices;
  }

  void configOpencart(appConfig) {}

  void configMagento(appConfig) {}

  void configShopify(appConfig) {}

  void configPrestashop(appConfig) {}

  void configTrapi(appConfig) {}

  void configDokan(appConfig) {}

  void configWCFM(appConfig) {}

  void configWoo(appConfig) {}

  void configListing(appConfig) {}

  void configVendorAdmin(appConfig) {}

  void setAppConfig(appConfig) {
    Config().setConfig(appConfig);
    CartInject().init(appConfig);

    printLog('[🌍appConfig] ${appConfig['type']} $appConfig');

    switch (appConfig['type']) {
      case 'opencart':
        configOpencart(appConfig);
        break;
      case 'magento':
        configMagento(appConfig);
        break;
      case 'shopify':
        configShopify(appConfig);
        break;
      case 'presta':
        configPrestashop(appConfig);
        break;
      case 'strapi':
        configTrapi(appConfig);
        break;
      case 'dokan':
        configDokan(appConfig);
        break;
      case 'wcfm':
        configWCFM(appConfig);
        break;
      case 'listeo':
        configListing(appConfig);
        break;
      case 'listpro':
        configListing(appConfig);
        break;
      case 'mylisting':
        configListing(appConfig);
        break;
      case 'vendorAdmin':
        configVendorAdmin(appConfig);
        break;
      case 'woo':
      default:
        configWoo(appConfig);
        break;
    }
  }
}

enum ConfigType {
  opencart,
  magento,
  shopify,
  presta,
  strapi,
  dokan,
  wcfm,
  listeo,
  listpro,
  mylisting,
  vendorAdmin,
  woo,
}

extension ConfigTypeExtension on ConfigType {
  String get typeName {
    return toString().replaceFirst('ConfigType.', '');
  }
}
