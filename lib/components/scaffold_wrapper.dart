import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';

class ScaffoldWrapper extends StatelessWidget {
  final Widget body;
  final Function? onBack;
  final SystemUiOverlayStyle? overlayStyle;
  final Color? backgroundColor;

  const ScaffoldWrapper({
    Key? key,
    required this.body,
    this.onBack,
    this.overlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
    this.backgroundColor = Colors.green,
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
        leading: onBack is Function
            ? GestureDetector(
                onTap: () => onBack!(),
                child: const Icon(
                  Icons.arrow_back,
                  size: 32,
                  color: Colors.white,
                ),
              )
            : null,
      ),
      body: ConditionalWillPopScope(
        shouldAddCallback: true,
        onWillPop: () => onBack is Function ? onBack!() : null,
        child: body,
      ),
    );
  }
}
