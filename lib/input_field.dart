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

  void requestValidation() {
    if (_checkOnChange != null) {
      _performValidation();
    }
  }

  void _performValidation() {
    setValidity(_checkOnChange(text));
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
          widget.controller._performValidation();
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
  }
}
