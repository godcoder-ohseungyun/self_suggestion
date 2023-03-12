import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdManager {
  static String getAdIdByPlatform() {
    return Platform.isIOS
        ? 'ca-app-pub-6526090402830489/5524960667'
        : 'ca-app-pub-6526090402830489/3939033362';
  }

  static Widget getAdBanner() {
    return Center(
      child: Container(
        child: AdmobBanner(
          adUnitId: getAdIdByPlatform(),
          adSize: AdmobBannerSize.BANNER,
          onBannerCreated:
              (AdmobBannerController cotroller) {

          },
        ),
      ),
    );
  }
}