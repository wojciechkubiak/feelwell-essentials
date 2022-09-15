import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../components/components.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      showBack: false,
      showSettings: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green,
        child: Center(
          child: Lottie.asset(
            'assets/lotties/loading.json',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
