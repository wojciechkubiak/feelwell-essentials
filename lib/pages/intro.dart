import 'package:feelwell_essentials/components/app_name.dart';
import 'package:feelwell_essentials/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Intro extends StatelessWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lotties/loading.json',
            fit: BoxFit.fitWidth,
          ),
          const AppName(),
          const Loader(color: Colors.white),
        ],
      ),
    );
  }
}
