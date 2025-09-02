
import 'package:flutter/material.dart';
class Myroute extends MaterialPageRoute 
{
  Myroute({required super.builder});
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}