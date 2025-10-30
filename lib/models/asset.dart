import 'package:flutter/material.dart';

class Asset {
  final int id;
  final String name;
  final AssetStatus status;

  Asset({
    required this.id,
    required this.name,
    required this.status,
  });
}

enum AssetStatus {
  available,
  disable,
  pending,
  borrowed,
}

extension AssetStatusExtension on AssetStatus {
  String get label {
    switch (this) {
      case AssetStatus.available:
        return 'Available';
      case AssetStatus.disable:
        return 'Disable';
      case AssetStatus.pending:
        return 'Pending';
      case AssetStatus.borrowed:
        return 'Borrowed';
    }
  }

  Color get color {
    switch (this) {
      case AssetStatus.available:
        return const Color(0xFF22C55E);
      case AssetStatus.disable:
        return const Color(0xFFEF4444);
      case AssetStatus.pending:
        return const Color(0xFFFBBF24);
      case AssetStatus.borrowed:
        return const Color(0xFF3B82F6);
    }
  }
}
