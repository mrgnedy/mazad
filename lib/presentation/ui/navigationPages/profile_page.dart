import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/register_model.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/tet_field_with_title.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:toast/toast.dart';

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
    nameCtrler = TextEditingController(text: 'عبده');
    phoneCtrler = TextEditingController(text: '01011121314');
    accountCtrler = TextEditingController(text: '461469347891203');
    addressCtrler =
        TextEditingController(text: 'ميدان كفر مية وانت ازيك بجااا');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => setState(() => isEdit = !isEdit))
              ],
            ),
            preferredSize: Size.fromHeight(size.height / 12)),
        body: Center(
          child: SingleChildScrollView(child: profileWidget()),
        ),
      ),
    );
  }

  // getProfileData() {
  //   authRM.setState((state) => state.getProfile());
  // }

  Widget profileWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () async {
            _image = await StylesD.getProfilePicture(context);
            setState(() {});
          },
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
                        : AssetImage('assets/icons/logo.png'),
                    fit: BoxFit.cover)),
          ),
        ),
        SizedBox(height: 30),
        TetFieldWithTitle(
          title: 'اسم المستخدم',
          isEditable: isEdit,
          textEditingController: nameCtrler,
        ),
        TetFieldWithTitle(
          title: 'رفم الجوال',
          isEditable: isEdit,
          textEditingController: phoneCtrler,
        ),
        TetFieldWithTitle(
          title: 'رقم الحساب',
          isEditable: isEdit,
          textEditingController: accountCtrler,
        ),
        TetFieldWithTitle(
          title: 'العنوان',
          isEditable: isEdit,
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
            accountNumber: 'accountCtrler.text',
            address: addressCtrler.text,
            lat: '0.0',
            lng: '0.0',
            email: 'sad',
            name: nameCtrler.text,
            phone: phoneCtrler.text,
          ),
          _image.path),
      onError: (context, e) {
        print(e);
      },
      onData: (context, e) {
        Toast.show("تم تعديل بيانات حسابك بنجاح", context,
            duration: Toast.LENGTH_LONG);
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
            gesture: Gestures()..onTap(()=>ExtendedNavigator.rootNavigator.pushNamed(Routes.changePasswordScreen)),
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
