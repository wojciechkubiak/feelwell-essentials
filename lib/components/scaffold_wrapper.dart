import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home/home_bloc.dart';

class ScaffoldWrapper extends StatelessWidget {
  final Widget body;
  final bool showBack;
  final bool showSettings;
  final SystemUiOverlayStyle? overlayStyle;
  final Color? backgroundColor;

  const ScaffoldWrapper({
    Key? key,
    required this.body,
    this.overlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
    this.backgroundColor = Colors.green,
    this.showBack = true,
    this.showSettings = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: overlayStyle,
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: Colors.green),
        elevation: 0,
        leading: showBack
            ? GestureDetector(
                onTap: () => BlocProvider.of<HomeBloc>(context).add(
                  HomeShowPageBack(),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 32,
                  color: Colors.white,
                ),
              )
            : null,
        actions: [
          if (showSettings)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () => BlocProvider.of<HomeBloc>(context).add(
                  HomeShowSettings(),
                ),
                child: const Icon(
                  Icons.settings,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: ConditionalWillPopScope(
        shouldAddCallback: true,
        onWillPop: () async {
          BlocProvider.of<HomeBloc>(context).add(
            HomeShowPageBack(),
          );

          return Future.value(false);
        },
        child: body,
      ),
    );
  }
}
