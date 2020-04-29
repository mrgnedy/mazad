import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/register_model.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/FCM.dart';
import 'package:mazad/presentation/widgets/tet_field_with_title.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../router.gr.dart';

class AuthPage extends StatefulWidget {
  final int userType;

  const AuthPage({Key key, this.userType}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<AuthPage> {
  Size size;

  bool isCreate = false;
  TextEditingController nameCtrler = TextEditingController();
  TextEditingController emailCtrler = TextEditingController();
  TextEditingController phoneCtrler = TextEditingController();
  TextEditingController addressCtrler = TextEditingController();
  TextEditingController accountCtrler = TextEditingController();
  TextEditingController passwordCtrler = TextEditingController();
  TextEditingController confirmPasswordCtrler = TextEditingController();
  @override
  void dispose() {
    nameCtrler.dispose();
    emailCtrler.dispose();
    phoneCtrler.dispose();
    addressCtrler.dispose();
    accountCtrler.dispose();
    passwordCtrler.dispose();
    confirmPasswordCtrler.dispose();
    // TODO: implement dispose
    super.dispose();
  }  getToken(String token){
        print('$token');
        fcmToken = token;
      }

      String fcmToken;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    authRM = Injector.getAsReactive<AuthStore>();
      FirebaseNotifications firebaseNotifications= FirebaseNotifications.getToken(getToken);

    super.initState();
  }
  Position position;
  double lat;
  double lng;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/icons/logo.png',
                    height: size.height / 5,
                    width: size.height / 5,
                  ),
                  Txt(
                    'تسجيل ${isCreate ? 'جديد' : 'الدخول'}',
                    style: TxtStyle()
                      ..fontSize(24)
                      ..textColor(ColorsD.main),
                  ),
                  TetFieldWithTitle(
                    title: 'إسم المستخدم',
                    textEditingController: nameCtrler,
                    isVisible: isCreate,
                  ),
                  TetFieldWithTitle(
                    title: 'رقم الجوال',
                    textEditingController: phoneCtrler,
                  ),
                  TetFieldWithTitle(
                    title: 'البريد الالكترونى',
                    isVisible: isCreate,
                    textEditingController: emailCtrler,
                  ),
                  TetFieldWithTitle(
                    title: 'كلمة المرور',
                    textEditingController: passwordCtrler,
                    isPassword: true,
                  ),
                  TetFieldWithTitle(
                    title: 'رقم الحساب',
                    textEditingController: accountCtrler,
                    isPassword: true,
                    isVisible: isCreate,
                    icon: Parent(child: Icon(Icons.remove_red_eye)),
                  ),
                  TetFieldWithTitle(
                    title: 'العنوان',
                    textEditingController: addressCtrler,
                    isVisible: isCreate,
                    icon:
                        Parent(child: InkWell(
                          onTap: ()async{
                            if((await Geolocator().checkGeolocationPermissionStatus()) == GeolocationStatus.disabled)
                            AppSettings.openLocationSettings();
                            position = (await ExtendedNavigator.rootNavigator.pushNamed(Routes.mapScreen))as Position;
                            addressCtrler.text = (await Geocoder.local.findAddressesFromCoordinates(Coordinates(position.latitude, position.longitude))).first.addressLine;
                            lat = position?.latitude??0.0;
                            lng = position?.longitude??0.0;
                          },
                          child: Icon(Icons.location_on))),
                  ),
                  buildRegister(),
                  accountOrNot()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ReactiveModel<AuthStore> authRM;

  error(e) {
    return AlertDialogs.failed(content: e, context: context);
  }

  authenticate() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    Credentials registerData = Credentials(
      name: nameCtrler.text,
      phone: phoneCtrler.text,
      password: passwordCtrler.text,
      accountNumber: accountCtrler.text,
      address: addressCtrler.text,
      userType: '1',
      email: emailCtrler.text,
      lat: '$lat',
      lng: '$lng',
      googleToken: '$fcmToken',
    );
    if (isCreate)
      authRM.setState((state) => state.register(registerData),
          onError: StylesD.showErrorDialog,
          onData: (_, store) =>
              ExtendedNavigator.rootNavigator.pushNamed(Routes.verifyScreen));
    else
      authRM.setState((state) => state.login(registerData),
          onError: (context, error) {
            return StylesD.showErrorDialog(context, error).then((e) {
              if (error.toString().contains('active'))
                ExtendedNavigator.rootNavigator.pushNamed(Routes.verifyScreen);
            });
          },
          onData: (_, store) => ExtendedNavigator.rootNavigator
              .pushNamedAndRemoveUntil(
                  Routes.mainPage, (Route<dynamic> route) => false,
                  arguments: MainPageArguments(
                      isSeller: authRM.state.userType == '1' ? true : false)));
  }

  Widget onAuthRebuilder() {
    return Txt(
      '${isCreate ? 'تسجيل' : 'دخول'}',
      gesture: Gestures()..onTap(authenticate),
      style: StylesD.mazadBtnStyle.clone()
        ..margin(top: 10)
        ..fontSize(22)
        ..height(size.height / 16)
        ..width(size.width * 0.32),
    );
  }

  Widget buildRegister() {
    return WhenRebuilder(
        onIdle: () => onAuthRebuilder(),
        onWaiting: () => WaitingWidget(),
        onError: (e) => onAuthRebuilder(),
        onData: (data) => onAuthRebuilder(),
        models: [authRM]);
  }

  Widget accountOrNot() {
    return InkWell(
      onTap: () => setState(() => isCreate = !isCreate),
      child: RichText(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          text: TextSpan(children: [
            TextSpan(
                text: isCreate ? 'لديك حساب؟ ' : "ليس لديك حساب؟ ",
                style: TextStyle(color: Colors.black, fontFamily: 'bein')),
            TextSpan(
                text: isCreate ? 'تسجيل الدخول' : 'انشاء حساب',
                style: TextStyle(color: ColorsD.main, fontFamily: 'bein')),
          ])),
    );
  }
}
