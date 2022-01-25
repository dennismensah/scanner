import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:auto_route/auto_route.dart';
import 'package:scanner/routes/router.gr.dart';

class SplashPage extends HookWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        Hive.boxExists('name').then((exists) {
          if (exists && Hive.box<String>('name').isNotEmpty) {
            context.router.replace(const HomeRoute());
          } else {
            context.router.replace(const LoginRoute());
          }
        });
      });

    }, const []);
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      body: Container(
        decoration:  const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(
            //     Colors.black.withOpacity(0.24), BlendMode.dstATop),
            image: AssetImage("assets/images/splash.png"),
          ),
        ),
      ),
    );
  }
}
