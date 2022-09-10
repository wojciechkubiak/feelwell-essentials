import 'package:feelwell_essentials/components/scaffold_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
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
