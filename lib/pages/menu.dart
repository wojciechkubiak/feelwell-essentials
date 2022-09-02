import 'package:feelwell_essentials/components/app_name.dart';
import 'package:feelwell_essentials/components/navigation_button.dart';
import 'package:feelwell_essentials/pages/exercise.dart';
import 'package:feelwell_essentials/pages/fasting.dart';
import 'package:feelwell_essentials/pages/meditation.dart';
import 'package:feelwell_essentials/pages/settings.dart';
import 'package:feelwell_essentials/pages/water.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  void onRouteChange(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppName(color: Colors.black87),
            const SizedBox(height: 32),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NavigationButton(
                      icon: Icons.directions_run_outlined,
                      text: 'Exercise',
                      route: const Exercise(),
                      onPressed: onRouteChange,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NavigationButton(
                      icon: Icons.food_bank_outlined,
                      text: 'Fasting',
                      route: const Fasting(),
                      onPressed: onRouteChange,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NavigationButton(
                      icon: Icons.water_drop_outlined,
                      text: 'Water',
                      route: const Water(),
                      onPressed: onRouteChange,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NavigationButton(
                      icon: Icons.air_sharp,
                      text: 'Meditation',
                      route: const Meditation(),
                      onPressed: onRouteChange,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 160,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      NavigationButton(
                        icon: Icons.settings,
                        text: 'Settings',
                        route: const Settings(),
                        onPressed: onRouteChange,
                        isFilled: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
