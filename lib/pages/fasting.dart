import 'package:feelwell_essentials/components/scaffold_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home/home_bloc.dart';

class Fasting extends StatelessWidget {
  const Fasting({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      onBack: () => BlocProvider.of<HomeBloc>(context).add(
        HomeShowPage(),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            // Navigate to second route when tapped.
          },
        ),
      ),
    );
  }
}
