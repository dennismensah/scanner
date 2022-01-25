// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Disable landscape mode
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  // Dark text on light background
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));
  await Hive.initFlutter();
  await Hive.openBox<String>('name');
  await Hive.openBox<String>('token');
  runApp( App());
}

