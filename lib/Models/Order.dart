import 'package:flutter/material.dart';

class Order {
  final String OrderID;
  final String StoreId;
  final String Details;
  final double Price;
  final DateTime Time;

  Order(
      {this.OrderID,
        this.StoreId,
        this.Details,
        this.Price,
        this.Time,
      });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      OrderID: json['OrderID'],
      StoreId: json['StoreId'],
      Details: json['Details'],
      Price: json['Price'],
      Time: json['Time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'OrderID': OrderID,
      'StoreId': StoreId,
      'Details': Details,
      'Price': Price,
      'Time': Time,
    };
  }
}
