import 'package:feelwell_essentials/components/button.dart';
import 'package:feelwell_essentials/components/scaffold_wrapper.dart';
import 'package:feelwell_essentials/models/ids.dart';
import 'package:feelwell_essentials/services/water.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../blocs/home/home_bloc.dart';
import '../components/loader.dart';
import '../components/transparent_button.dart';
import '../models/water.dart';

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
        'DZIENNIK PŁYNÓW',
        style: GoogleFonts.poppins(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget description() {
    return Text(
      'Woda stanowi średnio 70% masy dorosłego człowieka, w przypadku noworodka ok. 15% więcej.',
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget metter() {
    String percentage =
        (waterCopy.drunk / waterCopy.toDrink * 100).toStringAsFixed(0);
    String drunkLiters = (waterCopy.drunk / 1000).toStringAsFixed(2);
    String toDrinkLiters = (waterCopy.toDrink / 1000).toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SizedBox(
        width: 250,
        height: 250,
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
      '(Aktualna pojemność szklanki ${widget.glassSize}ml)',
      style: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.white70,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget error() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Text(
        'Coś poszło nie tak przy próbie dodania wody. Spróbuj ponownie.',
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
                    sign: '-',
                    onClick: () async {
                      setState(() => isError = false);

                      int newWaterDrunk = waterCopy.drunk - widget.glassSize;
                      bool isWaterUpdated =
                          await _waterService.updateDrunkWater(
                              drunk: newWaterDrunk > 0 ? newWaterDrunk : 0);

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
                    sign: '+',
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
            if (isError) error(),
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
