import 'package:flutter/material.dart';

import '../lib/InputField.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final InputFieldController controller =
      InputFieldController(checkOnChange: (text) => true);

  @override
  Widget build(Object context) {
    return Scaffold(
      body: Container(
          color: Colors.red,
          child: Center(
            child: InputField(
              controller: controller,
              builder: (context, ctrl, focusNode, status, isValid) {
                return Column(children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Text',
                        style: TextStyle(
                          color: status == InputStatus.FOCUSED
                              ? Colors.red
                              : (status == InputStatus.CHECKED
                                  ? Colors.green
                                  : Colors.transparent),
                        )),
                  ),
                  TextFormField(
                    focusNode: focusNode,
                    controller: ctrl,
                    cursorColor: Colors.red,
                    obscureText: false,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Text',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                          right: 20,
                        ),
                        child: Icon(Icons.access_alarm),
                      ),
                      prefixIconConstraints: BoxConstraints(maxWidth: 40),
                      suffixIcon: Icon(
                        Icons.check,
                        color: status == InputStatus.CHECKED
                            ? Colors.green
                            : Colors.white,
                      ),
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey, width: 1.5)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: status == InputStatus.CHECKED
                                ? Colors.green
                                : Colors.red,
                            width: 1.5),
                      ),
                    ),
                  )
                ]);
              },
            ),
          )),
    );
  }
}
