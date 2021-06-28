import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flexible/subscription/models/are_you_sure_popup_config.dart';
import 'package:flexible/subscription/models/oto_types_config.dart';
import 'package:flexible/subscription/remoteconf_defaults.dart';

class RemoteConfigRepository {
  // init and set defaults from file
  RemoteConfig remoteConfig = RemoteConfig.instance
    ..setDefaults(remoConfDefaults);

  // Synchronize immediately
  Future<bool> syncRemote() async {
    late bool updated;
    try {
      remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 0),
          minimumFetchInterval: Duration(seconds: 0)));
      updated = await remoteConfig.fetchAndActivate();
      return updated;
    } catch (e) {
      return false;
    }
  }

  Map get getAll => remoteConfig.getAll();

  // Bools
  //
  get hideOTO => remoteConfig.getBool('HideOTO');
  get showInfoPopup => remoteConfig.getBool('show_Info_popup');
  get showAreYouSurePopup => remoteConfig.getBool('showAreYouSurePopup');
  get showOTOOnAppStart => remoteConfig.getBool('showOTOOnAppStart');
  get rewardOFF => remoteConfig.getBool('RewardOFF');
  get noThanksBtnOFF => remoteConfig.getBool('NoThanksBtnOFF');

  // OTO configs
  //
  OtoConfig get offerType =>
      oTOTypesConfigs.firstWhere((element) => element.id == offerTypeString);

  get offerTypeString => remoteConfig.getString('Offer_Type');

  List get oTOTypesConfigsRawList =>
      jsonDecode(remoteConfig.getString('OTO_Types_Configs'));

  List<OtoConfig> get oTOTypesConfigs =>
      oTOTypesConfigsRawList.map((e) => OtoConfig.fromMap(e)).toList();

  // Areyousure configs
  //
  List get areYouSurePopupConfigsRawList =>
      jsonDecode(remoteConfig.getString('AreYouSurePopupConfigs'));

  List<AysConfig> get areYouSurePopupConfigs =>
      areYouSurePopupConfigsRawList.map((e) => AysConfig.fromMap(e)).toList();
}
