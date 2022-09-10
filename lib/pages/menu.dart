import 'package:feelwell_essentials/components/app_name.dart';
import 'package:feelwell_essentials/components/navigation_button.dart';
import 'package:feelwell_essentials/components/scaffold_wrapper.dart';
import 'package:feelwell_essentials/pages/exercise.dart';
import 'package:feelwell_essentials/pages/fasting.dart';
import 'package:feelwell_essentials/pages/meditation.dart';
import 'package:feelwell_essentials/pages/settings.dart';
import 'package:feelwell_essentials/pages/water.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home/home_bloc.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      overlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NavigationButton(
                      icon: Icons.directions_run_outlined,
                      text: 'Ćwiczenie',
                      onPressed: () => BlocProvider.of<HomeBloc>(context).add(
                        HomeShowWater(),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NavigationButton(
                      icon: Icons.food_bank_outlined,
                      text: 'Post',
                      onPressed: () => BlocProvider.of<HomeBloc>(context).add(
                        HomeShowFasting(),
                      ),
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
                      text: 'Woda',
                      onPressed: () => BlocProvider.of<HomeBloc>(context).add(
                        HomeShowWater(),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NavigationButton(
                      icon: Icons.air_sharp,
                      text: 'Medytacja',
                      onPressed: () => BlocProvider.of<HomeBloc>(context).add(
                        HomeShowWater(),
                      ),
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
                        text: 'Ustawienia',
                        onPressed: () => BlocProvider.of<HomeBloc>(context).add(
                          HomeShowSettings(),
                        ),
                        isFilled: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
