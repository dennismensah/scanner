import 'dart:ui';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scanner/helpers/notifications.dart';
import 'package:scanner/helpers/screen.dart';
import 'package:scanner/pages/home.dart';
import 'package:auto_route/auto_route.dart';
import 'package:scanner/routes/router.gr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

class LoginPage extends HookWidget {
  // const LoginPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  Future<void> login(BuildContext context, ValueNotifier<bool> loading,
      String username, String password) async {
    print('$username $password');
    if (_formKey.currentState!.validate()) {
      if (await DataConnectionChecker().hasConnection) {
        try {
          loading.value = true;
          final res = await Dio().post(
              'https://pcgebenezer.com/api/v1/admin/auth/usher-login',
              data: {'email': username, 'password': password});
          loading.value = false;
          switch (res.data['code']) {
            case 200:
              await Hive.box<String>('name')
                  .add(res.data['data']['user']['first_name']);
              await Hive.box<String>('token').add(res.data['data']['token']);
              context.router.replace(const HomeRoute());
              break;
            case 400:
            case 403:
              NotificationHelper.error(context, res.data['message']);
              break;
            case 422:
              break;
          }
          print(res);
        } on DioError catch (e) {
          loading.value = false;
          print(e.response);
          NotificationHelper.error(context,
              'An error occured while processing your request. Please try again.');
        }
      } else {
        NotificationHelper.error(
            context, 'Please check your internet connection');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = useTextEditingController();
    final password = useTextEditingController();
    final loading = useState(false);
    final size = MediaQuery.of(context).size;
    final isTablet =  Screen.diagonalInches(context) >= 7;
    return ModalProgressHUD(
      inAsyncCall: loading.value,
      progressIndicator: const SizedBox.shrink(),
      child: Scaffold(
        // backgroundColor: Colors.blueGrey,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              // colorFilter: ColorFilter.mode(
              //     Colors.black.withOpacity(0.8), BlendMode.dstATop),
              image: AssetImage("assets/images/splash.png"),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10) ,
                          child: Image.asset('assets/images/logo.png',),
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        SizedBox(
                          width: 0.8.sw,
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: username,
                            onFieldSubmitted: (v) => username.text = v,
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: isTablet? 25.sp: 32.sp),
                            validator: (v) {
                              if (username.text.isEmpty) return 'Required';
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Username',
                              hintStyle: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: isTablet? 25.sp: 32.sp),
                              filled: true,
                              fillColor: Colors.white54,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                         SizedBox(
                          height: 0.03.sh,
                        ),
                        SizedBox(
                          width: 0.8.sw,
                          child: TextFormField(
                            textInputAction: TextInputAction.go,
                            controller: password,
                            onFieldSubmitted: (v) => password.text = v,
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: isTablet? 25.sp: 32.sp),
                            validator: (v) {
                              if (password.text.isEmpty) {
                                return 'Required';
                              } else if (password.text.length < 6) {
                                return 'Password is too short';
                              }
                              return null;
                            },
                            onEditingComplete: () async {
                              await login(
                                  context, loading, username.text, password.text);
                            },
                            obscureText: true,
                            decoration: InputDecoration(

                              hintText: 'Password',
                              hintStyle: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: isTablet? 25.sp: 32.sp),
                              filled: true,
                              fillColor: Colors.white54,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding: MaterialStateProperty.all(
                                   EdgeInsets.symmetric(
                                      horizontal: 0.03.sw, vertical: 0.015.sh)),
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(fontSize: 20)),
                            ),
                            onPressed: () async {
                              await login(
                                  context, loading, username.text, password.text);
                            },
                            child: loading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Login',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            ?.copyWith(color: Colors.black,fontSize: isTablet? 20.sp: 30.sp),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const FaIcon(
                                        FontAwesomeIcons.arrowRight,
                                        size: 15,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20,),
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
                        ?.copyWith(color: Colors.white,fontSize: 24.sp ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
