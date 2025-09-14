import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'purchase_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wish = context.watch<WishlistProvider>().isFav(product);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blueGrey.shade800),
        title: Text(
          product.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade900,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              wish ? Icons.favorite : Icons.favorite_border,
              color: wish ? Colors.redAccent : Colors.blueGrey.shade800,
              size: 28,
            ),
            onPressed: () => context.read<WishlistProvider>().toggle(product),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GAMBAR PRODUK
              Center(
                child: Hero(
                  tag: product.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      height:
                          MediaQuery.of(context).size.width > 600 ? 350 : 250,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // INFORMASI PRODUK
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade900,
                                letterSpacing: 0.4,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(
                            product.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Rp ${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.green.shade700,
                          letterSpacing: 0.6,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // DESKRIPSI PRODUK
              Text(
                'Deskripsi Produk',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.blueGrey.shade700,
                      height: 1.6,
                    ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 40),

              // TOMBOL AKSI
              ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart, size: 22),
                label: const Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                onPressed: () {
                  context.read<CartProvider>().add(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "${product.title} telah ditambahkan ke keranjang 🎉"),
                      backgroundColor: Colors.green.shade600,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 8,
                  minimumSize: const Size.fromHeight(56),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PurchasePage(product: product),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue.shade700, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(
                  "Beli Sekarang",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
