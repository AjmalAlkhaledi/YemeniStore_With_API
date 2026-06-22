import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/local_storage.dart';

class ProductsProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final LocalStorage _storage = LocalStorage();

  List<Product> _products = [];
  bool _isLoading = false;
  bool _isOffline = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get error => _error;

  List<String> get categories =>
      _products.map((p) => p.category).toSet().toList();

  List<Product> byCategory(String category) =>
      _products.where((p) => p.category == category).toList();

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.fetchProducts();
      _products = data;
      _isOffline = false;
      await _storage.saveProductsCache(data);
    } catch (e) {
      final cached = await _storage.loadProductsCache();
      if (cached.isNotEmpty) {
        _products = cached;
        _isOffline = true;
      } else {
        _error = 'تعذّر تحميل المنتجات. تحقق من اتصال الإنترنت.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
