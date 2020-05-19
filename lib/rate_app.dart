import 'dart:io';

import 'package:app_review/app_review.dart';
import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRate {
  AppRate.rateIfAvailable(context) {
    trigger(context);
  }
  AppRate.requestReview() {
    requestReview();
  }

  requestReview() {
    if (Platform.isAndroid)
      return AppReview.storeListing;
    else
      return AppReview.requestReview;
  }

  trigger(context) async {
    // final pref = await SharedPreferences.getInstance();
    // pref.setBool('appreview', null);
    // pref.setString('reviewdate',null);
    if (await checkPrefernces(context)) requestReview();
    // saveToPrefernces(await );
  }

  Future saveToPrefernces(bool response) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('appreview', response);
    pref.setString('reviewdate', DateTime.now().toString());
  }

  Future<bool> checkPrefernces(context) async {
    return SharedPreferences.getInstance().then((pref) async {
      DateTime lastPromptDate = pref.getString('reviewdate') != null
          ? DateTime.tryParse(pref.getString('reviewdate'))
          : DateTime.now().add(Duration(days: -10));
      bool datePassed =
          DateTime.now().isAfter(lastPromptDate.add(Duration(days: 5)));
      bool lastDecision = pref.getBool('appreview');
      bool shouldPrompt = datePassed && (lastDecision == null ? true : false);
      bool shouldReview = false;
      print('LAST DECISION WAS: $lastDecision');
      print('LAST DATE WAS: ${lastPromptDate.toString()}');
      print('SHOULDPROMPT: $shouldPrompt');
      print('SHOULDREVIEW: $shouldReview');
      if (shouldPrompt) {
        shouldReview = await showRateDialog(context);
        await saveToPrefernces(shouldReview);
      }
      return shouldReview;

      // bool lastDecision = await showRateDialog(context);
      // await saveToPrefernces(lastDecision);
      // return shouldReview && (lastDecision == null ? true : false);
    });
  }

  Future showRateDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Txt(
                'تقييم التطبيق',
                style: TxtStyle()
                  ..textAlign.right()
                  ..textDirection(TextDirection.rtl)
                  ..fontFamily('bein'),
              ),
              content: Txt(
                'رأيك يهمنا, من فضلك ضع تقييماََ للتطبيق',
                style: TxtStyle()
                  ..textAlign.right()
                  ..textDirection(TextDirection.rtl)
                  ..fontFamily('bein'),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: Txt(
                      'لاحقاََ',
                      style: TxtStyle()
                        ..textAlign.right()
                        ..textDirection(TextDirection.rtl)
                        ..fontFamily('bein'),
                    )),
                FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Txt(
                      'نعم',
                      style: TxtStyle()
                        ..textAlign.right()
                        ..textDirection(TextDirection.rtl)
                        ..fontFamily('bein'),
                    )),
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Txt(
                      'لا تظهر مجددا',
                      style: TxtStyle()
                        ..textAlign.right()
                        ..textDirection(TextDirection.rtl)
                        ..fontFamily('bein'),
                    )),
              ],
              // titleTextStyle: TextStyle,
            ));
  }
}

// import 'package:flutter/material.dart';
// import 'package:rate_my_app/rate_my_app.dart';

// /// The app's main content widget.
// class ContentWidget extends StatefulWidget {
//   /// The Rate my app instance.
//   final RateMyApp rateMyApp;

//   /// Creates a new content widget instance.
//   const ContentWidget({
//     @required this.rateMyApp,
//   });

//   @override
//   State<StatefulWidget> createState() => _ContentWidgetState();
// }

// /// The content widget state.
// class _ContentWidgetState extends State<ContentWidget> {
//   /// Contains all debuggable conditions.
//   List<DebuggableCondition> debuggableConditions = [];

//   /// Whether the dialog should be opened.
//   bool shouldOpenDialog = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       refresh();

//       if(mounted && widget.rateMyApp.shouldOpenDialog) {
//         widget.rateMyApp.showRateDialog(context);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 40),
//         child:Scaffold(
//           body: Builder(
//             builder: (context) {
//               return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 for (DebuggableCondition condition in debuggableConditions) //
//                   textCenter(condition.valuesAsString),
//                 textCenter('Are conditions met ? ' + (shouldOpenDialog ? 'Yes' : 'No')),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: RaisedButton(
//                     child: const Text('Launch "Rate my app" dialog'),
//                     onPressed: () async {
//                       await widget.rateMyApp.showRateDialog(context); // We launch the default Rate my app dialog.
//                       refresh();
//                     },
//                   ),
//                 ),
//                 RaisedButton(
//                   child: const Text('Launch "Rate my app" star dialog'),
//                   onPressed: () async {
//                     await widget.rateMyApp.showStarRateDialog(context, actionsBuilder: (_, stars) => starRateDialogActionsBuilder(context, stars)); // We launch the Rate my app dialog with stars.
//                     refresh();
//                   },
//                 ),
//                 RaisedButton(
//                   child: const Text('Reset'),
//                   onPressed: () async {
//                     await widget.rateMyApp.reset(); // We reset all Rate my app conditions values.
//                     refresh();
//                   },
//                 ),
//               ],
//         );
//             }
//           ),),
//       );

//   /// Returns a centered text.
//   Text textCenter(String content) => Text(
//         content,
//         textAlign: TextAlign.center,
//       );

//   /// Allows to refresh the widget state.
//   void refresh() {
//     setState(() {
//       debuggableConditions = widget.rateMyApp.conditions.whereType<DebuggableCondition>().toList();
//       shouldOpenDialog = widget.rateMyApp.shouldOpenDialog;
//     });
//   }

//   List<Widget> starRateDialogActionsBuilder(BuildContext context, double stars) {
//     final Widget cancelButton = RateMyAppNoButton(
//       // We create a custom "Cancel" button using the RateMyAppNoButton class.
//       widget.rateMyApp,
//       text: MaterialLocalizations.of(context).cancelButtonLabel.toUpperCase(),
//       callback: refresh,
//     );
//     if (stars == null || stars == 0) {
//       // If there is no rating (or a 0 star rating), we only have to return our cancel button.
//       return [cancelButton];
//     }

//     // Otherwise we can do some little more things...
//     String message = 'You put ' + stars.round().toString() + ' star(s). ';
//     Color color;
//     switch (stars.round()) {
//       case 1:
//         message += 'Did this app hurt you physically ?';
//         color = Colors.red;
//         break;
//       case 2:
//         message += 'That\'s not really cool man.';
//         color = Colors.orange;
//         break;
//       case 3:
//         message += 'Well, it\'s average.';
//         color = Colors.yellow;
//         break;
//       case 4:
//         message += 'This is cool, like this app.';
//         color = Colors.lime;
//         break;
//       case 5:
//         message += 'Great ! <3';
//         color = Colors.green;
//         break;
//     }

//     return [
//       FlatButton(
//         child: Text(MaterialLocalizations.of(context).okButtonLabel.toUpperCase()),
//         onPressed: () async {
//           print(message);
//           Scaffold.of(context).showSnackBar(
//             SnackBar(
//               content: Text(message),
//               backgroundColor: color,
//             ),
//           );

//           // This allow to mimic a click on the default "Rate" button and thus update the conditions based on it ("Do not open again" condition for example) :
//           await widget.rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
//           Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
//           refresh();
//         },
//       ),
//       cancelButton,
//     ];
//   }
// }
