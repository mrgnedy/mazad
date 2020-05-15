import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/register_model.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/tet_field_with_title.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:toast/toast.dart';
import 'package:mazad/core/api_utils.dart';

import '../../router.gr.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Size size;
  File _image;
  bool get isImage => _image != null;
  bool isEdit = false;
  TextEditingController nameCtrler;
  TextEditingController phoneCtrler;
  TextEditingController accountCtrler;
  TextEditingController addressCtrler;
  @override
  void initState() {
    // TODO: implement initState
    final creds = authRM.state.credentialsModel.data;
    nameCtrler = TextEditingController(text: '${creds.name}');
    phoneCtrler = TextEditingController(text: '${creds.phone}');
    accountCtrler = TextEditingController(text: '${creds.accountNumber}');
    addressCtrler = TextEditingController(text: '${creds.address}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            child: Container(
              width: size.width*0.5,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => setState(() => isEdit = !isEdit),
                  ),
                  Txt(
                    'الصفحة الشخصية',
                    style: TxtStyle()
                      ..textColor(ColorsD.main)
                      ..width(size.width*0.5)
                      ..fontSize(24)
                      ..textAlign.right()
                      ..alignmentContent.coordinate(-0.4,0.5)
                      // ..alignment.coordinate(0.5, 0.5),
                  ),
                ],
              ),
            ),
            preferredSize: Size(size.width * 0.8, size.height / 16)),
        body: Center(
          child: SingleChildScrollView(child: profileWidget()),
        ),
      ),
    );
  }

  // getProfileData() {
  //   authRM.setState((state) => state.getProfile());
  // }
  Position position;
  double lat = 0.0;
  double lng = 0.0;
  Widget profileWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: isEdit
              ? () async {
                  _image = await StylesD.getProfilePicture(context);
                  setState(() {});
                }
              : null,
          child: Container(
            child: Align(
                alignment: FractionalOffset(1, 1),
                child: Image.asset('assets/icons/cam.png')),
            height: size.height / 8,
            width: size.height / 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ColorsD.main),
              image: DecorationImage(
                  image: isImage
                      ? FileImage(_image)
                      : NetworkImage(
                          // height: size.height / 8,
                          // width: size.height / 8,
                          // imageUrl:
                          '${APIs.imageProfileUrl}${authRM.state.credentialsModel.data.image}',
                          // placeholder: (context, imageS) =>
                          //     imageS.contains('null')
                          //         ? StylesD.noImageWidget()
                          // : WaitingWidget(),
                        ),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(height: 30),
        TetFieldWithTitle(
          title: 'اسم المستخدم',
          isEditable: isEdit,
          textEditingController: nameCtrler,
        ),
        TetFieldWithTitle(
          title: 'رقم الجوال',
          isEditable: isEdit,
          textEditingController: phoneCtrler,
        ),
        TetFieldWithTitle(
          title: 'رقم الحساب',
          isEditable: isEdit,
          isPassword: true,
          isVisible: false,
          textEditingController: accountCtrler,
        ),
        TetFieldWithTitle(
          title: 'العنوان',
          isEditable: isEdit,
          icon: InkWell(
            child: Icon(Icons.location_on),
            onTap: () async {
              if ((await Geolocator().checkGeolocationPermissionStatus()) ==
                  GeolocationStatus.disabled)
                AppSettings.openLocationSettings();
              position = (await ExtendedNavigator.rootNavigator
                  .pushNamed(Routes.mapScreen)) as Position;
              addressCtrler.text = (await Geocoder.local
                      .findAddressesFromCoordinates(
                          Coordinates(position.latitude, position.longitude)))
                  .first
                  .addressLine;
              lat = position?.latitude ?? 0.0;
              lng = position?.longitude ?? 0.0;
            },
          ),
          textEditingController: addressCtrler,
        ),
        SizedBox(height: 30),
        Visibility(
          visible: !isEdit,
          child: Container(
            width: size.width * 0.75,
            height: size.height / 16,
            child: changePassword(),
          ),
        ),
        confirmEditRebuilder()
      ],
    );
  }

  Widget profilePageRebuilder() {
    return WhenRebuilder(
        onIdle: null,
        onWaiting: null,
        onError: null,
        onData: null,
        models: [authRM]);
  }

  final authRM = Injector.getAsReactive<AuthStore>();
  confirmEdit() {
    print('object');
    authRM.setState(
      (state) => state.editProfile(
          Credentials(
            accountNumber: '1',
            address: addressCtrler.text,
            lat: '$lat',
            lng: '$lng',
            email: 'sad',
            name: nameCtrler.text,
            phone: phoneCtrler.text,
          ),
          _image?.path),
      onError: (context, e) {
        print(e);
      },
      onData: (context, e) {
        Toast.show("تم تعديل بيانات حسابك بنجاح", context,
            duration: Toast.LENGTH_LONG);
        setState(() {
          isEdit = false;
        });
        print(e);
      },
    );
  }

  Widget confirmEditWidget() {
    return Visibility(
      visible: isEdit,
      child: Txt(
        'تأكيد',
        gesture: Gestures()..onTap(() => confirmEdit()),
        style: StylesD.mazadBtnStyle.clone()
          ..width(size.width * 0.4)
          ..height(size.height / 16)
          ..fontSize(20),
      ),
    );
  }

  Widget confirmEditRebuilder() {
    return WhenRebuilder(
        onWaiting: () => WaitingWidget(),
        onIdle: () => confirmEditWidget(),
        onError: (e) => confirmEditWidget(),
        onData: (e) => confirmEditWidget(),
        models: [authRM]);
  }

  Widget changePassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(Icons.edit),
        Txt('تغيير كلمة المرور',
            gesture: Gestures()
              ..onTap(() => ExtendedNavigator.rootNavigator
                  .pushNamed(Routes.changePasswordScreen)),
            style: TxtStyle()
              ..fontSize(18)
              ..textColor(ColorsD.main)),
      ],
    );
  }
  // Widget editableTxtFieldWithTitle(
  //     String title, TextEditingController txtCtrler) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Txt(
  //         '$title',
  //         style: TxtStyle()
  //           ..fontSize(18)
  //           ..textColor(ColorsD.main),
  //       ),
  //     ],
  //   );
  // }
}
