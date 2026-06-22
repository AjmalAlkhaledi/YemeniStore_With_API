import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/local_storage.dart';

class FavoritesProvider extends ChangeNotifier {
  final LocalStorage _storage = LocalStorage();
  List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool isFavorite(int id) => _items.any((p) => p.id == id);

  Future<void> loadFavorites() async {
    _items = await _storage.loadFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    if (isFavorite(product.id)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
    await _storage.saveFavorites(_items);
  }

  Future<void> removeFavorite(int id) async {
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
    await _storage.saveFavorites(_items);
  }
}
