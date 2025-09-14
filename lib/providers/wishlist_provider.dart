import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  // Set untuk menyimpan ID produk yang ada di wishlist,
  // menjadikannya sangat cepat untuk memeriksa apakah suatu item adalah favorit.
  final Set<String> _ids = {};

  // Map untuk menyimpan katalog produk, dengan ID produk sebagai kuncinya.
  // Ini memungkinkan kita untuk mengambil detail produk dengan cepat.
  final Map<String, Product> _catalog = {};

  // Memeriksa apakah suatu produk ada di wishlist berdasarkan ID-nya.
  bool isFav(Product p) => _ids.contains(p.id);

  // Menambahkan produk ke wishlist.
  void add(Product p) {
    _ids.add(p.id);
    _catalog[p.id] = p;
    notifyListeners();
  }

  // Menghapus produk dari wishlist.
  void remove(Product p) {
    _ids.remove(p.id);
    _catalog.remove(p.id);
    notifyListeners();
  }

  // Mengubah status favorit produk, menambahkan jika belum ada
  // dan menghapus jika sudah ada.
  void toggle(Product p) {
    if (isFav(p)) {
      remove(p);
    } else {
      add(p);
    }
  }

  // Mengembalikan daftar produk yang ada di wishlist.
  // Properti 'growable: false' memastikan daftar tidak dapat dimodifikasi.
  List<Product> get items =>
      _ids.map((id) => _catalog[id]!).toList(growable: false);
}
