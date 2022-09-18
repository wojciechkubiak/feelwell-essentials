import 'package:feelwell_essentials/components/components.dart';
import 'package:feelwell_essentials/lang/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/home/home_bloc.dart';

class ScaffoldWrapper extends StatefulWidget {
  final Widget body;
  final bool showBack;
  final bool showSettings;
  final bool isDialog;
  final SystemUiOverlayStyle? overlayStyle;
  final Color? backgroundColor;

  const ScaffoldWrapper({
    Key? key,
    required this.body,
    this.overlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
    this.backgroundColor = Colors.green,
    this.showBack = true,
    this.showSettings = true,
    this.isDialog = false,
  }) : super(key: key);

  @override
  State<ScaffoldWrapper> createState() => _ScaffoldWrapperState();
}

class _ScaffoldWrapperState extends State<ScaffoldWrapper> {
  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              LocaleKeys.dialog_header,
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ).tr(),
            content: Text(
              LocaleKeys.dialog_info,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.start,
            ).tr(),
            actions: [
              Button(
                text: LocaleKeys.dialog_decline.tr(),
                onPressed: () => Navigator.of(context).pop(false),
                fontSize: 14,
              ),
              Button(
                text: LocaleKeys.dialog_submit.tr(),
                onPressed: () => Navigator.of(context).pop(true),
                fontSize: 14,
              ),
            ],
          ),
        ) ??
        false;
  }

  void goPreviousPage() {
    BlocProvider.of<HomeBloc>(context).add(
      HomeShowPageBack(),
    );
  }

  Future<void> handlePreviousPage() async {
    if (widget.isDialog) {
      bool isDialogConfirm = await showExitPopup();

      if (isDialogConfirm) {
        goPreviousPage();
      }
    } else {
      goPreviousPage();
    }
  }

  void goSettingsPage() {
    BlocProvider.of<HomeBloc>(context).add(
      HomeShowSettings(),
    );
  }

  Future<void> handleSettingsPage() async {
    if (widget.isDialog) {
      bool isDialogConfirm = await showExitPopup();

      if (isDialogConfirm) {
        goSettingsPage();
      }
    } else {
      goSettingsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: widget.overlayStyle,
        backgroundColor: widget.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.green),
        elevation: 0,
        leading: widget.showBack
            ? GestureDetector(
                onTap: handlePreviousPage,
                child: const Icon(
                  Icons.arrow_back,
                  size: 32,
                  color: Colors.white,
                ),
              )
            : null,
        actions: [
          if (widget.showSettings)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: handleSettingsPage,
                child: const Icon(
                  Icons.settings,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: ConditionalWillPopScope(
        shouldAddCallback: true,
        onWillPop: () async {
          handlePreviousPage();

          return Future.value(false);
        },
        child: widget.body,
      ),
    );
  }
}
