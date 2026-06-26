import 'package:flutter/material.dart';

@immutable
class LifeArea {

  final String id;

  final String name;

  final IconData icon;

  final Color color;

  final int order;

  final bool isArchived;

  const LifeArea({

    required this.id,

    required this.name,

    required this.icon,

    required this.color,

    this.order = 0,

    this.isArchived = false,
  });

  LifeArea copyWith({

    String? id,

    String? name,

    IconData? icon,

    Color? color,

    int? order,

    bool? isArchived,

  }) {

    return LifeArea(

      id: id ?? this.id,

      name: name ?? this.name,

      icon: icon ?? this.icon,

      color: color ?? this.color,

      order: order ?? this.order,

      isArchived: isArchived ?? this.isArchived,
    );
  }
}
