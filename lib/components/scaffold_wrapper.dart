import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';

class ScaffoldWrapper extends StatelessWidget {
  final Widget body;
  final Function onBack;

  const ScaffoldWrapper({
    Key? key,
    required this.body,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.green,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.green,

          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.green),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => onBack(),
          child: const Icon(
            Icons.arrow_back,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      body: ConditionalWillPopScope(
        shouldAddCallback: true,
        onWillPop: () => onBack(),
        child: body,
      ),
    );
  }
}
