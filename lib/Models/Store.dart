import 'package:flutter/material.dart';

class Store {
  final String StoreId;
  final String StoreName;
  final String Owner;
  final String StoreLocation;
  final Image Img;
  final String Uid;

  Store(
      {this.StoreLocation,
      this.Uid,
      @required this.StoreId,
      this.StoreName,
      this.Owner,
      this.Img});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      StoreId: json['StoreId'],
      Uid: json['Uid'],
      StoreName: json['Name'],
      Owner: json['Owner'],
      StoreLocation: json['StoreLocation'],
      Img: json['Img'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'StoreID': StoreId,
      'Uid': Uid,
      'Name': StoreName,
      'Owner': Owner,
      'StoreLocation': StoreLocation,
      'Img': Img,
    };
  }
}
