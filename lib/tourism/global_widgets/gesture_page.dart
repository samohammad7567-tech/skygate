import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GesturePage extends StatelessWidget {
  final Widget? gestureChild;

  const GesturePage({super.key, this.gestureChild});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        FocusScope.of(context).unfocus();
      },
      child: gestureChild,
    );
  }
}
