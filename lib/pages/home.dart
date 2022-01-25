import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:scan/scan.dart';
import 'package:scanner/helpers/notifications.dart';
import 'package:scanner/routes/router.gr.dart';

class HomePage extends HookWidget {
  ScanController controller = ScanController();

  attend(BuildContext context, ValueNotifier<bool> loading,
      ValueNotifier<bool> scanning, String mask) async {
    scanning.value = false;
    controller.pause();
    if (await DataConnectionChecker().hasConnection) {
      try {
        loading.value = true;
        final res = await Dio().post(
            'https://pcgebenezer.com/api/v1/admin/attendance',
            data: {'mask': mask});
        loading.value = false;
        switch (res.data['code']) {
          case 200:
            NotificationHelper.info(context, res.data['message']);
            break;
          case 400:
            NotificationHelper.error(context, res.data['message']);
            break;
          case 422:
            NotificationHelper.error(context, res.data['message']);
            break;
        }
        print(res);
      } on DioError catch (e) {
        loading.value = false;
        print(e.response);
        if (e.response!.statusCode == 422) {
          NotificationHelper.error(
              context,
              e.response?.data['message'] ??
                  'An error occured while processing your request. Please try again.');
        } else {
          NotificationHelper.error(context,
              'An error occured while processing your request. Please try again.');
        }
      }
    } else {
      NotificationHelper.error(
          context, 'Please check your internet connection');
    }
  }

  Future<String?> getName() async {
    final box = Hive.box<String>('name');
    return Future.value(box.isEmpty ? null : box.values.first);
  }

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);
    final scanning = useState(false);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/splash.png"),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  children: [
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        radius: 0.037.sh,
                        child: IconButton(
                          onPressed: () async {
                            await Hive.box<String>('name').clear();
                            await Hive.box<String>('token').clear();
                            await context.router.replace(const LoginRoute());
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.powerOff,
                            size: 0.028.sh,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                    SizedBox(
                      height: 0.09.sh,
                    ),
                    FutureBuilder(
                      future: getName(),
                      builder: (context, AsyncSnapshot<String?> snapshot) {
                        final name = snapshot.hasData ? snapshot.data : null;
                        return Text(
                          'Hello, ${name ?? ''}',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontSize: 45.sp, color: Colors.white),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Visibility(
                      visible: scanning.value,
                      child: SizedBox(
                        width: 0.85.sw, // custom wrap size
                        height: 0.45.sh,
                        child: ScanView(
                          controller: controller,
                          scanAreaScale: .7,
                          scanLineColor: Colors.green.shade400,
                          onCapture: (data) async {
                            await FlutterBeep.beep();
                            await attend(context, loading, scanning, data);
                          },
                        ),
                      ),
                      replacement: GestureDetector(
                        onTap: () {
                          // player.setAsset('assets/beep.mp3').then((value) => player.play() );
                          scanning.value = true;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blueGrey,
                          ),
                          height: 0.25.sh,
                          width: 0.6.sw,
                          child: Text(
                            'SCAN',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.white, fontSize: 60.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 18, left: 20, right: 20),
              child: Text(
                'Powered by Datapluzz',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.white, fontSize: 24.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
