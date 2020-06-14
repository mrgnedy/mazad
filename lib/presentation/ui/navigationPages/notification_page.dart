import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/notification_mode.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:mazad/core/api_utils.dart';
import '../../router.gr.dart';

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
        appBar: PreferredSize(
            child: Txt(
              'الاشعارات',
              style: TxtStyle()
                ..textColor(ColorsD.main)
                ..fontSize(24)
                ..textAlign.right()
                ..alignment.coordinate(0.8, 0.5),
            ),
            preferredSize: Size.fromHeight(size.height / 16)),
        body: notificationsWidgetRebuilder(),
      ),
    );
  }

  Future bidderDetailsDialog(BuildContext context, User user) async {
    return await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: size.height / 2.4,
          child: Center(child: bidderDetailsWidget(user)),
        ),
      ),
    );
  }

  int loadAt = -1;
  Widget buildNotificationCard(dynamic notification, int index) {
    return InkWell(
      onTap: () {
        if (notification is Newcommission || notification is Commissions) {
          print('THIS COMMISION VALUE${notification.value}');
          ExtendedNavigator.rootNavigator.pushNamed(Routes.commisionPage,
              arguments: CommisionPageArguments(
                  value: notification.value.toString(),
                  isSeller: true,
                  notID: notification.id));
        } else if (notification is WelcomeMsgs)
          return;
        else if (notification is Finished) {
          bidderDetailsDialog(context, notification.user);
        } else if (notification.auction == null)
          AlertDialogs.failed(
              context: context, content: 'هذا المزاد لم يعد متاح');
        else
          ExtendedNavigator.rootNavigator.pushNamed(Routes.auctionPage,
              arguments:
                  AuctionPageArguments(auctionData: notification.auction));
      },
      child: Dismissible(
        onDismissed:
            notification is Commissions || notification is Newcommission
                ? null
                : (d) {
                    setState(() => loadAt = index);
                    deleteNotification(notification.id.toString())
                        .then((s) => setState(() => loadAt = -1));
                  },
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
              Txt(
                'المزيد',
                style: TxtStyle()
                  ..textColor(ColorsD.main)
                  ..padding(left: 10),
              ),
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
                      image: notification is Operations ||
                              notification is Finished ||
                              notification is Finishedforuser
                          ? NetworkImage(
                              '${APIs.imageBaseUrl}${notification.auction.images.first.image}')
                          : AssetImage('assets/icons/logo.png'),
                      fit: BoxFit.cover),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final authRM = Injector.getAsReactive<AuthStore>();
  getNotifications() {
    authRM.setState((state) => state.getNotifications(),
        onError: (context, error) => print('$error'));
  }

  Widget notificationsWidget() {
    final notification = authRM.state.notificationModel?.data?.allNotifications;

    return notification.isEmpty
        ? Center(
            child: Txt('لا توجد إشعارات'),
          )
        : ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: notification.length,
            itemExtent: size.height / 8,
            itemBuilder: (contect, index) => loadAt == index
                ? WaitingWidget()
                : buildNotificationCard(notification[index], index),
          );
  }

  Widget notificationsWidgetRebuilder() {
    return WhenRebuilder(
        onIdle: () => Container(),
        onWaiting: () => authRM.state.notificationModel == null
            ? WaitingWidget()
            : notificationsWidget(),
        onError: (e) => authRM.state.notificationModel == null
            ? Container()
            : notificationsWidget(),
        onData: (data) => notificationsWidget(),
        models: [authRM]);
  }

  Future deleteNotification(String notID) {
    return authRM.setState((state) => state.delNotification(notID),
        onData: (context, data) =>
            authRM.setState((state) => state.getNotifications()));
  }

  Widget bidderDetailsWidget(User profile) {
    // final profile =
    //     Injector.getAsReactive<AuthStore>().state.currentBidderProfile;
    return SingleChildScrollView(
      child: Container(
        height: size.height / 2.6,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Txt(
              'تفاصيل المزايد',
              style: TxtStyle()
                ..textColor(ColorsD.main)
                ..fontSize(22),
            ),
            Container(
              height: size.height / 10,
              width: size.height / 10,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorsD.main),
                  image: DecorationImage(
                      image: NetworkImage(
                          '${APIs.imageProfileUrl}${profile.image}'),
                      fit: BoxFit.cover)),
            ),
            Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.transparent,
                      ),
                      StylesD.richText(
                          'إسم المستخدم', '${profile.name}', size.width * 0.6),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.phone),
                      StylesD.richText(
                          'رقم الجوال', '${profile.phone}', size.width * 0.6),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.location_on),
                      StylesD.richText(
                          'العنوان', '${profile.address}', size.width * 0.6),
                    ],
                  ),
                ])
          ],
        ),
      ),
    );
  }
}
