import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanner/routes/router.gr.dart';

class App extends StatelessWidget {
  // const App({Key? key}) : super(key: key);
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(729, 1280),
      builder: () => MaterialApp.router(
        title: 'Scanner',
        builder: (context, widget) {
          //add this line
          ScreenUtil.setContext(context);
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        debugShowCheckedModeBanner: false,
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey),
        ),
      ),
    );
  }
}
