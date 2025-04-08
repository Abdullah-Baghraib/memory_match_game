import 'package:flutter/material.dart';

class appName extends StatelessWidget 
{
  const appName({
    super.key,
    required this.screenSize,
  });

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Text('Memory Match Game',style: TextStyle(  fontSize: screenSize.width * 0.06,  fontWeight: FontWeight.bold,  color: Colors.white,),);
  }
}