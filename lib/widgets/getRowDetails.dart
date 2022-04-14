import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brahmo/globals/myColors.dart';
import 'package:brahmo/globals/myFonts.dart';
import 'package:brahmo/globals/mySpaces.dart';

Widget getRowDetails(String param, String val){
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyFonts().heading1(param, MyColors.blueLighter),
          Flexible(child: MyFonts().heading1(val, MyColors.gray)),
        ],
      ),
      Divider(),
      MySpaces.vGapInBetween,
    ],
  );
}