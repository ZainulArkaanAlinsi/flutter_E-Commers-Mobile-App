import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  // Map untuk menyimpan ID produk dan jumlah (quantity) produk tersebut di keranjang.
  final Map<String, int> _items = {};

  // Map untuk menyimpan katalog produk, digunakan untuk mengambil detail produk
  // seperti harga dan nama berdasarkan ID-nya.
  final Map<String, Product> _catalog = {};

  // Mengembalikan map item di keranjang.
  Map<String, int> get items => _items;

  // Menambahkan produk ke keranjang. Jika produk sudah ada,
  // jumlahnya akan bertambah satu.
  void add(Product p) {
    _items.update(p.id, (q) => q + 1, ifAbsent: () => 1);
    _catalog[p.id] = p; // Memastikan produk ada di katalog
    notifyListeners();
  }

  // Menghapus satu item dari produk di keranjang. Jika jumlahnya 1, produk akan dihapus sepenuhnya.
  void removeOne(Product p) {
    // Jika produk tidak ada di keranjang, tidak ada yang perlu dilakukan.
    if (!_items.containsKey(p.id)) return;

    final q = _items[p.id]!;
    if (q <= 1) {
      // Jika jumlahnya 1 atau kurang, hapus produk dari map.
      _items.remove(p.id);
    } else {
      // Kurangi jumlahnya sebanyak satu.
      _items[p.id] = q - 1;
    }
    notifyListeners();
  }

  // Menghapus semua item dari produk tertentu di keranjang.
  void remove(Product p) {
    _items.remove(p.id);
    notifyListeners();
  }

  // Menghitung total harga dari semua produk di keranjang.
  double get total {
    double sum = 0;
    _items.forEach((id, qty) {
      final p = _catalog[id];
      if (p != null) sum += p.price * qty;
    });
    return sum;
  }

  // Mengembalikan daftar produk yang ada di keranjang.
  List<Product> get products =>
      _items.keys.map((id) => _catalog[id]!).toList(growable: false);

  void register(Product p) {}
}
