library input_field;

import 'package:flutter/material.dart';

enum InputStatus { FOCUSED, UNFOCUSED, CHECKED }

typedef bool CheckOnChange(String text);
typedef Widget Builder(BuildContext context, TextEditingController controller,
    FocusNode focusNode, InputStatus status, bool isValid);

class InputFieldController {
  CheckOnChange _checkOnChange;
  final TextEditingController _controller = TextEditingController();

  final FocusNode focusNode = FocusNode();
  InputStatus status = InputStatus.UNFOCUSED;
  bool isValid = false;

  InputFieldController({CheckOnChange checkOnChange}) {
    this._checkOnChange = checkOnChange;
  }

  void addListener(void Function() listener) {
    _controller.addListener(listener);
  }

  void setValidity(bool value) {
    isValid = value;
    if (value) {
      status = InputStatus.CHECKED;
    } else {
      if (focusNode.hasPrimaryFocus) {
        status = InputStatus.FOCUSED;
      } else {
        status = InputStatus.UNFOCUSED;
      }
    }
  }

  String get text {
    return _controller.text;
  }

  bool get hasPrimaryFocus {
    return focusNode.hasPrimaryFocus;
  }

  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) {
    focusNode.unfocus(disposition: disposition);
  }

  void dispose() {
    _controller.dispose();
  }
}

class InputField extends StatefulWidget {
  final InputFieldController controller;
  final Builder builder;

  InputField({Key key, @required this.controller, @required this.builder})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.focusNode.addListener(() {
      setState(() {
        if (widget.controller.focusNode.hasPrimaryFocus) {
          if (widget.controller.isValid) {
            widget.controller.status = InputStatus.CHECKED;
          } else {
            widget.controller.status = InputStatus.FOCUSED;
          }
        } else {
          widget.controller.status = InputStatus.UNFOCUSED;
        }
      });
    });
    if (widget.controller._checkOnChange != null) {
      widget.controller.addListener(() {
        setState(() {
          widget.controller.setValidity(
              widget.controller._checkOnChange(widget.controller.text));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context,
        widget.controller._controller,
        widget.controller.focusNode,
        widget.controller.status,
        widget.controller.isValid);
    /*return Column(children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(context.tr(widget.label),
            style: LibraTypography.small(
              weight: FontWeight.w400,
              color: widget.controller.status == InputStatus.FOCUSED
                  ? LibraColors.secondary
                  : (widget.controller.status == InputStatus.CHECKED
                      ? LibraColors.primary
                      : LibraColors.white.withOpacity(0)),
            )),
      ),
      TextFormField(
        focusNode: widget.controller.focusNode,
        controller: widget.controller._controller,
        cursorColor: LibraColors.secondary,
        obscureText: widget.isSecureText,
        obscuringCharacter: '*',
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 18),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: widget.label != null ? context.tr(widget.label) : '',
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              right: 20,
            ),
            child: widget.icon,
          ),
          prefixIconConstraints: BoxConstraints(maxWidth: 40),
          suffixIcon: Icon(
            Icons.check,
            color: widget.controller.status == InputStatus.CHECKED
                ? LibraColors.primary
                : LibraColors.white,
          ),
          labelStyle: TextStyle(color: getLabelColor()),
          border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: LibraColors.darkGreyVariant, width: 1.5)),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: widget.controller.status == InputStatus.CHECKED
                    ? LibraColors.primary
                    : LibraColors.secondary,
                width: 1.5),
          ),
        ),
      )
    ]);*/
  }
}
