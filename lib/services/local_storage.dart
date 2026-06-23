import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class LocalStorage {
  static const String favoritesKey = 'favorites';
  static const String productsCacheKey = 'products_cache';
  static const String cartKey = 'cart';

  Future<void> _setJson(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value));
  }

  Future<dynamic> _getJson(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveFavorites(List<Product> products) =>
      _setJson(favoritesKey, products.map((p) => p.toJson()).toList());

  Future<List<Product>> loadFavorites() async {
    final data = await _getJson(favoritesKey);
    if (data is! List) return [];
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveProductsCache(List<Product> products) =>
      _setJson(productsCacheKey, products.map((p) => p.toJson()).toList());

  Future<List<Product>> loadProductsCache() async {
    final data = await _getJson(productsCacheKey);
    if (data is! List) return [];
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCart(List<Map<String, dynamic>> items) =>
      _setJson(cartKey, items);

  Future<List<Map<String, dynamic>>> loadCart() async {
    final data = await _getJson(cartKey);
    if (data is! List) return [];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
