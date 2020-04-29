import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Size size;
  @override
  Widget build(BuildContext context) {
    getNotifications();
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: notificationsWidgetRebuilder(),
      ),
    );
  }

  Widget buildNotificationCard(dynamic notification) {
    return Dismissible(
      key: UniqueKey(),
      child: Container(
        height: size.height / 8,
        width: size.width * 0.7,
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          border: Border.all(color: ColorsD.main),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.close), onPressed: null),
            Txt('${notification.body}',
                style: TxtStyle()
                  ..width(size.width * 0.59)
                  ..textAlign.end()
                  ..padding(right: 10)),
            Container(
              height: size.height / 12,
              width: size.height / 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ColorsD.main),
                image: DecorationImage(
                    image: AssetImage('assets/icons/logo.png'),
                    fit: BoxFit.cover),
              ),
            )
          ],
        ),
      ),
    );
  }

  final authRM = Injector.getAsReactive<AuthStore>();
  getNotifications() {
    authRM.setState((state) => state.getNotifications(), onError: (context,error)=>print('$error'));
  }

  Widget notificationsWidget() {
    final notification = authRM.state.notificationModel.data.allNotifications;

    return notification.isEmpty
        ? Center(
            child: Txt('لا توجد إشاعرات'),
          )
        : ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: notification.length,
            itemExtent: size.height / 8,
            itemBuilder: (contect, index) =>
                buildNotificationCard(notification[index]),
          );
  }

  Widget notificationsWidgetRebuilder() {
    return WhenRebuilder(
        onIdle: () => Container(),
        onWaiting: () => authRM.state.notificationModel == null
            ? WaitingWidget()
            : notificationsWidget(),
        onError: (e) =>
            authRM.state.notificationModel == null ? Container() : notificationsWidget(),
        onData: (data) => notificationsWidget(),
        models: [authRM]);
  }
}
