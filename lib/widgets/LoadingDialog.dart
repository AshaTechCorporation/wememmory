import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wememmory/constants.dart';

class LoadingDialog {
  static Future<void> open(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.5),
      builder: (BuildContext buildContext) {
        return PopScope(
          canPop: false,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              LoadingAnimationWidget.discreteCircle(color: mainColor, size: 100),
              // Positioned(
              //   child: SizedBox(
              //     width: 250,
              //     height: 250,
              //     child: Image.asset(
              //       "assets/icons/logoNCI.png",
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  static void close(BuildContext context) {
    Navigator.pop(context);
  }
}
