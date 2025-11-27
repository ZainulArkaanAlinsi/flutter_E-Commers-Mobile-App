import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, int> _items = {};
  final Map<String, Product> _catalog = {};

  Map<String, int> get items => _items;

  // Method untuk register product ke catalog
  void register(Product p) {
    _catalog[p.id] = p;
  }

  void add(Product p) {
    _items.update(p.id, (q) => q + 1, ifAbsent: () => 1);
    _catalog[p.id] = p; // Memastikan produk ada di katalog
    notifyListeners();
  }

  void removeOne(Product p) {
    if (!_items.containsKey(p.id)) return;

    final q = _items[p.id]!;
    if (q <= 1) {
      _items.remove(p.id);
    } else {
      _items[p.id] = q - 1;
    }
    notifyListeners();
  }

  void remove(Product p) {
    _items.remove(p.id);
    notifyListeners();
  }

  double get total {
    double sum = 0;
    _items.forEach((id, qty) {
      final p = _catalog[id];
      if (p != null) sum += p.price * qty;
    });
    return sum;
  }

  List<Product> get products =>
      // ignore: unnecessary_null_comparison
      _items.keys.map((id) => _catalog[id]!).where((p) => p != null).toList();

  int get itemCount => _items.values.fold(0, (sum, qty) => sum + qty);
}
