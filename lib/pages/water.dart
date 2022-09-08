import 'package:feelwell_essentials/components/button.dart';
import 'package:feelwell_essentials/components/scaffold_wrapper.dart';
import 'package:feelwell_essentials/models/ids.dart';
import 'package:feelwell_essentials/services/water.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../components/loader.dart';
import '../models/water.dart';

class Water extends StatefulWidget {
  const Water({super.key});

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  late WaterModel water;
  WaterService waterService = WaterService();

  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadSettings() async {
    int id = Ids.getRecordId();
    WaterModel? waterData = await waterService.getWater(id: id);

    if (waterData is WaterModel) {
      setState(() {
        water = waterData;
      });
    }
  }

  Widget waterBody({required WaterModel? waterModel}) {
    if (waterModel is WaterModel) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Woda stanowi średnio 70% masy dorosłego człowieka, w przypadku noworodka ok. 15% więcej.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: LiquidCircularProgressIndicator(
                    value: waterModel.drunk /
                        waterModel.toDrink, // Defaults to 0.5.
                    valueColor: const AlwaysStoppedAnimation(
                      Colors.blue,
                    ),
                    backgroundColor: Colors.white,
                    borderColor: Colors.white,
                    borderWidth: 2,
                    direction: Axis.vertical,
                    center: Text(
                      '${waterModel.drunk}ML',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 72,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Button(text: 'Dodaj szklankę', onPressed: () {}),
              ),
              Button(
                text: 'Usuń szklankę',
                onPressed: () {},
                backgroundColor: Colors.white,
                textColor: Colors.black54,
              ),
            ],
          ),
        ),
      );
    }

    return const Center(child: Loader());
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      title: 'Woda',
      body: waterBody(waterModel: water),
    );
  }
}
