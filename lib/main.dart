import 'file:///E:/AndroidStudioprojs/bustracker/lib/ui/google_map.dart';
import 'package:bustracker/util/theme.dart';
import 'package:flutter/material.dart';

final ThemeData _AppTheme = CustomAppTheme().data;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _AppTheme,
      home: MyMap(),
    );
  }
}


