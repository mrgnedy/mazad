import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

import 'auction_details.dart';

class TimeRemaining extends StatefulWidget {
  final String timeRemaining;
  final bool isDone;

  const TimeRemaining({Key key, this.timeRemaining, this.isDone})
      : super(key: key);
  @override
  _TimeRemainingState createState() => _TimeRemainingState();
}

class _TimeRemainingState extends State<TimeRemaining> {
  @override
  Widget build(BuildContext context) {
    // int totalTime = 2*24*60*60;
    totalTimeRemaining();
    return widget.isDone == true
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/icons/timer.png',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              Txt(
                widget.timeRemaining,
                style: TxtStyle()
                  ..textColor(ColorsD.main)
                  ..fontSize(20),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // CircularCountdown(
              //   countdownTotal: 10,
              //   countdownTotalColor: Colors.yellow,
              //   countdownCurrentColor: Colors.blue,
              //   countdownRemainingColor: Colors.teal,
              //   countdownRemaining: 7,
              // ),
              Image.asset(
                'assets/icons/timer.png',
                height: 50,
                // width: 20,
                fit: BoxFit.cover,
              ),
              // SizedBox(width: 16),
              Container(
                height: size.height / 14,
                child: SlideCountdownClock(
                  // width: 100,
                  // height: 230,
                  duration: timeSlicer(),
                  shouldShowDays: true,
                  separator: ':',
                  tightLabel: true,
                  textStyle: TextStyle(color: ColorsD.main, fontSize: 28),
                  // padding: EdgeInsets.all(5),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // color: ColorsD.main,
                  ),
                ),
              ),
            ],
          );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset(
          'assets/icons/timer.png',
          height: 50,
          width: 20,
          fit: BoxFit.cover,
        ),
        Txt(
          widget.timeRemaining,
          style: TxtStyle()
            ..textColor(ColorsD.main)
            ..fontSize(20),
        )
      ],
    );
  }

  Duration timeSlicer() {
    final durationsStr = widget.timeRemaining.split(':');
    final List<int> durationsList = List.generate(
        durationsStr.length, (index) => int.parse(durationsStr[index]));
    return Duration(
        days: durationsList[0],
        hours: durationsList[1],
        minutes: durationsList[2],
        seconds: durationsList[3]);
  }

  int totalTimeRemaining() {
    final durationsStr = widget.timeRemaining.split(':');
    final List<int> durationsList = List.generate(
        durationsStr.length, (index) => int.parse(durationsStr[index]));
    final convertList = [1, 60, 60, 24];
    print(durationsList);
    int total = 0;
    for (int i = 0; i < durationsList.length; i++) {
      int currentTotalTime = 1;
      for (int j = 0; j < durationsList.length - i; j++) {
        currentTotalTime = durationsList[i] * convertList[j] * currentTotalTime;
      }
      total += currentTotalTime;
    }
    print('THIS IS  $total');
    return total;
  }
}
