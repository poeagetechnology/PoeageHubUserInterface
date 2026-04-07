import 'package:flutter/material.dart';

IconData getIcon(String name) {
  switch (name) {
    case 'local_grocery_store':
      return Icons.local_grocery_store;
    case 'devices':
      return Icons.devices;
    case 'checkroom':
      return Icons.checkroom;
    case 'spa':
      return Icons.spa;
    case 'kitchen':
      return Icons.kitchen;
    case 'electrical_services':
      return Icons.electrical_services;
    case 'smartphone':
      return Icons.smartphone;
    case 'computer':
      return Icons.computer;
    case 'tv':
      return Icons.tv;
    case 'sports_soccer':
      return Icons.sports_soccer;
    case 'directions_car':
      return Icons.directions_car;
    case 'toys':
      return Icons.toys;
    case 'menu_book':
      return Icons.menu_book;
    case 'health_and_safety':
      return Icons.health_and_safety;
    case 'pets':
      return Icons.pets;
    case 'edit':
      return Icons.edit;
    case 'diamond':
      return Icons.diamond;
    case 'hiking':
      return Icons.hiking;
    case 'work':
      return Icons.work;
    default:
      return Icons.category;
  }
}