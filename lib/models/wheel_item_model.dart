import 'package:flutter/material.dart';

class WheelItem {
  WheelItem({
    required this.imgpath,
    required this.bgColor,
  });

  String imgpath;
  Color bgColor;

  factory WheelItem.fromJson(Map<String, dynamic> json) => WheelItem(
        imgpath: json["imgpath"] ?? "",
        bgColor: json["bgColor"] ?? Colors.transparent,
      );

  Map<String, dynamic> toJson() => {
        "imgpath": imgpath,
        "bgColor": bgColor,
      };
}
