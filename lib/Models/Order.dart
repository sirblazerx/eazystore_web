import 'package:flutter/material.dart';

class Order {
  final String OrderID;
  final String MenuId;
  final String Name;
  final String ClientName;
  final double Price;
  final int Quantity;

  Order(
      {this.OrderID,
      this.MenuId,
      this.Name,
      this.ClientName,
      this.Price,
      this.Quantity});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      OrderID: json['OrderID'],
      MenuId: json['MenuId'],
      Name: json['Name'],
      ClientName: json['ClientName'],
      Price: json['Price'],
      Quantity: json['Quantitiy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'OrderID': OrderID,
      'MenuId': MenuId,
      'Name': Name,
      'ClientName': ClientName,
      'Price': Price,
      'Quantity': Quantity,
    };
  }
}
