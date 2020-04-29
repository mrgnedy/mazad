import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mazad/core/utils.dart';

class WaitingWidget extends StatelessWidget {
  final Color color;

  const WaitingWidget({Key key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        color: color??ColorsD.main,

      ),
    );
  }
}
