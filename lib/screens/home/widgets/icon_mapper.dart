import 'package:flutter/material.dart';

IconData getIcon(String category) {
  final name = category.toLowerCase();

  if (name.contains('grocery')) return Icons.local_grocery_store;

  if (name.contains('electronic')) return Icons.devices;

  if (name.contains('fashion')) return Icons.checkroom;

  if (name.contains('beauty') || name.contains('personal'))
    return Icons.spa;

  if (name.contains('home') || name.contains('kitchen'))
    return Icons.kitchen;

  if (name.contains('appliance'))
    return Icons.electrical_services;

  if (name.contains('mobile') || name.contains('tablet'))
    return Icons.smartphone;

  if (name.contains('computer') || name.contains('laptop') || name.contains('accessories'))
    return Icons.computer;

  if (name.contains('tv') || name.contains('entertainment'))
    return Icons.tv;

  if (name.contains('sports') || name.contains('outdoor'))
    return Icons.sports_soccer;

  if (name.contains('automotive'))
    return Icons.directions_car;

  if (name.contains('toys') || name.contains('baby'))
    return Icons.toys;

  if (name.contains('books') || name.contains('media'))
    return Icons.menu_book;

  if (name.contains('health') || name.contains('wellness'))
    return Icons.health_and_safety;

  if (name.contains('pet'))
    return Icons.pets;

  if (name.contains('office') || name.contains('stationery'))
    return Icons.work;

  if (name.contains('jewellery'))
    return Icons.diamond;

  if (name.contains('footwear'))
    return Icons.hiking;

  if (name.contains('bags') || name.contains('luggage'))
    return Icons.work_outline;

  return Icons.category;
}