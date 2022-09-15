import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../components/components.dart';

class Intro extends StatelessWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      showBack: false,
      showSettings: false,
      body: Container(
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
      ),
    );
  }
}
