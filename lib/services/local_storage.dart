import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class LocalStorage {
  static const String favoritesFile = 'favorites.json';
  static const String productsCacheFile = 'products_cache.json';

  Future<File> _file(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$name');
  }

  Future<void> saveFavorites(List<Product> products) async {
    try {
      final file = await _file(favoritesFile);
      final data = jsonEncode(products.map((p) => p.toJson()).toList());
      await file.writeAsString(data);
    } catch (_) {}
  }

  Future<List<Product>> loadFavorites() async {
    try {
      final file = await _file(favoritesFile);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      if (content.isEmpty) return [];
      final List<dynamic> list = jsonDecode(content) as List<dynamic>;
      return list
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveProductsCache(List<Product> products) async {
    try {
      final file = await _file(productsCacheFile);
      final data = jsonEncode(products.map((p) => p.toJson()).toList());
      await file.writeAsString(data);
    } catch (_) {}
  }

  Future<List<Product>> loadProductsCache() async {
    try {
      final file = await _file(productsCacheFile);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      if (content.isEmpty) return [];
      final List<dynamic> list = jsonDecode(content) as List<dynamic>;
      return list
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
