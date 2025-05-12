import 'package:flutter/material.dart';
import 'package:sylcpn_io/data_structures/downloader/native_downloader.dart'
    if (dart.library.js) 'package:sylcpn_io/data_structures/downloader/web_downloader.dart';

abstract class Downloader {
  static Downloader init() {
    return getDownloader();
  }

  Future<void> download(BuildContext context, String url, String nameFile);
}
