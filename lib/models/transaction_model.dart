import 'package:flutter/material.dart';

class Transaction {
  final title;
  final double amount;
  final DateTime date;
  final Icon icon;
  final String category;

  Transaction({this.title,this.date,this.amount,this.category,this.icon});

}