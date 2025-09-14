import 'package:flutter/material.dart';
import '../models/product.dart';

class OrderProvider with ChangeNotifier {
  // Daftar pesanan yang tidak dapat diubah dari luar kelas.
  final List<Product> _orders = [];

  // Mendapatkan daftar pesanan saat ini. Menggunakan List.unmodifiable
  // untuk mencegah modifikasi langsung dari luar.
  List<Product> get orders => List.unmodifiable(_orders);

  // Mendapatkan total harga dari semua produk dalam pesanan.
  double get totalPrice {
    return _orders.fold(0.0, (sum, product) => sum + product.price);
  }

  // Menambahkan produk ke daftar pesanan dan memberi tahu listener.
  void addOrder(Product p) {
    _orders.add(p);
    notifyListeners();
  }

  // Menghapus produk dari daftar pesanan dan memberi tahu listener.
  void removeOrder(Product p) {
    _orders.remove(p);
    notifyListeners();
  }

  // Menghapus semua pesanan dari daftar dan memberi tahu listener.
  void clear() {
    _orders.clear();
    notifyListeners();
  }
}
