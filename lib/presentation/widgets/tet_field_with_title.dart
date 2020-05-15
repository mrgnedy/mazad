import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';

class TetFieldWithTitle extends StatefulWidget {
  final String title;
  final Function validator;
  final TextInputType inputType;
  final Widget icon;
  final bool isEditable;
  final int minLines;
  final bool isVisible;
  final double height;
  final bool isPassword;
  final String hint;
  final String countryCode;
  // final Function iconCallback;
  final TextEditingController textEditingController;

  TetFieldWithTitle(
      {Key key,
      this.title = 'title',
      this.validator,
      this.inputType,
      this.icon,
      this.isEditable = true,
      // this.iconCallback,
      this.isPassword = false,
      this.textEditingController,
      this.minLines,
      this.height = 1.2,
      this.isVisible = true,
      this.hint,
      this.countryCode})
      : super(key: key);

  @override
  _TetFieldWithTitleState createState() => _TetFieldWithTitleState();
}

class _TetFieldWithTitleState extends State<TetFieldWithTitle> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          widget.title == null
              ? Container()
              : Txt(
                  '${widget.title}',
                  style: TxtStyle()
                    ..textColor(ColorsD.main)
                    ..fontSize(18)

                    // ..fontWeight(FontWeight.bold)
                    ..textAlign.right(),
                ),
          textFieldWidget(context),
        ],
      ),
    );
  }

  bool obSecure = true;

  Widget textFieldWidget(context) {
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: size.width * 0.7,
        // height: widget.isEditable? size.height / 12 : null,
        child: TextFormField(
          enabled: widget.isEditable,
          minLines: widget.minLines,
          // key: key,

          obscureText: widget.isPassword ? obSecure : false,
          maxLines: widget.isPassword ? 1 : null,
          controller: widget.textEditingController,
          validator: widget.validator,
          textInputAction: TextInputAction.send,
          keyboardType: widget.inputType,
          textAlign: TextAlign.right,
          cursorColor: ColorsD.main,
          textDirection: TextDirection.ltr,
          // showCursor: false,
          style: TextStyle(
            fontFamily:
                widget.isPassword || widget.inputType == TextInputType.number
                    ? ''
                    : 'bein',
            height: widget.height,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: widget.countryCode != null
                ? Container(
                    width: size.width / 7,
                    child: Txt('${widget.countryCode}',
                        style: TxtStyle()
                          ..textDirection(TextDirection.ltr)
                          ..alignment.centerRight()
                          ..width(size.width / 9)))
                : widget.isPassword
                    ? InkWell(
                        onTap: () {
                          obSecure = !obSecure;
                          setState(() {});
                        },
                        child: Icon(Icons.remove_red_eye))
                    : widget.icon,
            // enabled: false,
            // labelText: hint,
            // labelStyle:
            //     TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
            // alignLabelWithHint: true,
            contentPadding: EdgeInsets.only(right: 10, top: 16, left: 10),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorsD.main, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),

            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
