import 'package:flutter/material.dart';

class ApiKeyModel {
  final String id;
  final String name;
  final String apiKey;
  final DateTime createdAt;
  final DateTimeRange expiryDate;

  const ApiKeyModel({
    required this.id,
    required this.name,
    required this.apiKey,
    required this.createdAt,
    required this.expiryDate,
  });
}
