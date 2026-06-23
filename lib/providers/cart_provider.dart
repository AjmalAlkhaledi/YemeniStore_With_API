import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/local_storage.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };
}

class CartProvider extends ChangeNotifier {
  final LocalStorage _storage = LocalStorage();
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  List<CartItem> get itemsList => _items.values.toList();

  int get count => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.values
      .fold(0.0, (sum, item) => sum + item.product.price * item.quantity);

  bool isInCart(int id) => _items.containsKey(id);

  Future<void> loadCart() async {
    final raw = await _storage.loadCart();
    _items.clear();
    for (final entry in raw) {
      final product =
          Product.fromJson(entry['product'] as Map<String, dynamic>);
      final quantity = (entry['quantity'] as num?)?.toInt() ?? 1;
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  void _persist() {
    _storage.saveCart(_items.values.map((item) => item.toJson()).toList());
  }

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
    _persist();
  }

  void increase(int id) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
      notifyListeners();
      _persist();
    }
  }

  void decrease(int id) {
    if (!_items.containsKey(id)) return;
    final item = _items[id]!;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(id);
    }
    notifyListeners();
    _persist();
  }

  void removeFromCart(int id) {
    _items.remove(id);
    notifyListeners();
    _persist();
  }

  Future<void> checkout() async {
    _items.clear();
    notifyListeners();
    await _storage.saveCart([]);
  }

  void clear() {
    _items.clear();
    notifyListeners();
    _persist();
  }
}
