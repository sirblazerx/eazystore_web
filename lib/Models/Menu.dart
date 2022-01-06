import 'package:flutter/material.dart';

class Menu {
  final String MenuId;
  final String Name;
  final double Price;
  final String Desc;
  final String Img;
  final String Category;
  final String StoreId;

  Menu(
      {this.Desc,
      @required this.MenuId,
      this.Name,
      this.Price,
      this.Img,
      this.StoreId,
      this.Category});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      MenuId: json['MenuId'],
      Name: json['Name'],
      Price: json['Price'],
      Desc: json['Desc'],
      Img: json['Img'],
      Category: json['Category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'MenuID': MenuId,
      'Name': Name,
      'Price': Price,
      'Desc': Desc,
      'Img': Img,
      'Category': Category,
    };
  }
}
