import 'dart:js_interop';

import 'package:flutter/material.dart';

class Bugiganga {
  snacks(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  InputDecoration textFormFieldDecoration(
      {String? label, IconData? icon, Widget? sufix}) {
    return InputDecoration(
      labelStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.blue,
      ),
      labelText: label,
      prefixIcon: icon.isNull
          ? null
          : Icon(
              icon,
              color: Colors.blue,
            ),
      suffixIcon: sufix,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}

extension EmailValidator on String {
  bool get isNotEmail {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
