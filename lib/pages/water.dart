import 'package:easy_localization/easy_localization.dart';
import 'package:feelwell_essentials/lang/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../services/services.dart';
import '../components/components.dart';
import '../models/models.dart';

class Water extends StatefulWidget {
  final WaterModel water;
  final int glassSize;

  const Water({
    super.key,
    required this.water,
    required this.glassSize,
  });

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  final WaterService _waterService = WaterService();
  late WaterModel waterCopy;

  bool isError = false;

  @override
  void initState() {
    setState(() => waterCopy = widget.water);
    super.initState();
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        LocaleKeys.water_header,
        style: GoogleFonts.poppins(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ).tr(),
    );
  }

  Widget description() {
    return Text(
      LocaleKeys.water_info,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.start,
    ).tr();
  }

  String parseAsFixed({required double value, int digits = 0}) {
    return value.toStringAsFixed(digits);
  }

  Widget metter() {
    String percentage =
        parseAsFixed(value: (waterCopy.drunk / waterCopy.toDrink * 100));
    String drunkLiters = parseAsFixed(
      value: (waterCopy.drunk / 1000),
      digits: 2,
    );
    String toDrinkLiters = parseAsFixed(
      value: (waterCopy.toDrink / 1000),
      digits: 2,
    );
    double size = 250;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SizedBox(
        width: size,
        height: size,
        child: LiquidCircularProgressIndicator(
          value: waterCopy.drunk / waterCopy.toDrink, // Defaults to 0.5.
          valueColor: const AlwaysStoppedAnimation(
            Colors.white54,
          ),
          backgroundColor: Colors.green,
          borderColor: Colors.white,
          borderWidth: 2,
          direction: Axis.vertical,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$percentage%',
                style: GoogleFonts.bebasNeue(
                  fontSize: 66,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${drunkLiters}L/${toDrinkLiters}L',
                style: GoogleFonts.bebasNeue(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button({
    required String sign,
    required Function() onClick,
    EdgeInsets padding = const EdgeInsets.only(right: 8.0),
  }) {
    return Padding(
      padding: padding,
      child: TransparentButton(
        onPressed: onClick,
        body: Text(
          sign,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 42,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget subtext() {
    return Text(
      LocaleKeys.water_subinfo,
      style: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.white70,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.start,
    ).tr(namedArgs: {'glassSize': widget.glassSize.toString()});
  }

  Widget error() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Text(
        LocaleKeys.water_error,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.white70,
          fontWeight: FontWeight.w200,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget body() {
    const String minusSign = '-';
    const String plusSign = '+';

    return ScaffoldWrapper(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 42,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(),
                  description(),
                ],
              ),
            ),
            metter(),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  button(
                    sign: minusSign,
                    onClick: () async {
                      setState(() => isError = false);

                      int newWaterDrunk = waterCopy.drunk - widget.glassSize;
                      bool isWaterUpdated =
                          await _waterService.updateDrunkWater(
                        drunk: newWaterDrunk > 0 ? newWaterDrunk : 0,
                      );

                      if (isWaterUpdated) {
                        setState(() {
                          waterCopy.drunk =
                              newWaterDrunk > 0 ? newWaterDrunk : 0;
                        });
                      } else {
                        setState(() => isError = true);
                      }
                    },
                  ),
                  button(
                    sign: plusSign,
                    onClick: () async {
                      setState(() => isError = false);

                      int newWaterDrunk = waterCopy.drunk + widget.glassSize;
                      bool isWaterUpdated = await _waterService
                          .updateDrunkWater(drunk: newWaterDrunk);

                      if (isWaterUpdated) {
                        setState(() {
                          waterCopy.drunk = newWaterDrunk;
                        });
                      } else {
                        setState(() => isError = true);
                      }
                    },
                    padding: const EdgeInsets.only(left: 8.0),
                  ),
                ],
              ),
            ),
            subtext(),
            if (isError)
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: error(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }
}
