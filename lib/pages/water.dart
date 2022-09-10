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
  Widget body() {
    return ScaffoldWrapper(
      onBack: () => BlocProvider.of<HomeBloc>(context).add(
        HomeShowPage(),
      ),
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
                  Padding(
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
                  ),
                  Text(
                    'Woda stanowi średnio 70% masy dorosłego człowieka, w przypadku noworodka ok. 15% więcej.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SizedBox(
                width: 250,
                height: 250,
                child: LiquidCircularProgressIndicator(
                  value: widget.water.drunk /
                      widget.water.toDrink, // Defaults to 0.5.
                  valueColor: const AlwaysStoppedAnimation(
                    Colors.blue,
                  ),
                  backgroundColor: Colors.green,
                  borderColor: Colors.white,
                  borderWidth: 5,
                  direction: Axis.vertical,
                  center: Text(
                    '${widget.water.drunk}ML',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 72,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TransparentButton(
                      onPressed: () {},
                      body: Text(
                        '-',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 42,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TransparentButton(
                      onPressed: () {},
                      body: Text(
                        '+',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 42,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Aktualna pojemność szklanki ${widget.glassSize}ml',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w200,
              ),
              textAlign: TextAlign.start,
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
