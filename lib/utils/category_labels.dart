import 'package:flutter/material.dart';

String categoryLabel(String raw) {
  switch (raw) {
    case "men's clothing":
      return 'ملابس رجالية';
    case "women's clothing":
      return 'ملابس نسائية';
    case 'jewelery':
      return 'مجوهرات';
    case 'electronics':
      return 'إلكترونيات';
    default:
      return raw;
  }
}

IconData categoryIcon(String raw) {
  switch (raw) {
    case "men's clothing":
      return Icons.man;
    case "women's clothing":
      return Icons.woman;
    case 'jewelery':
      return Icons.diamond;
    case 'electronics':
      return Icons.devices_other;
    default:
      return Icons.category;
  }
}
