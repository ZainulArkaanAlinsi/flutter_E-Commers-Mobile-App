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
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar dan Gambar Produk
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.width > 600 ? 500 : 350,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: Icon(
                      wish ? Icons.favorite : Icons.favorite_border,
                      color: wish ? Colors.redAccent : Colors.white,
                      size: 28,
                    ),
                    onPressed: () =>
                        context.read<WishlistProvider>().toggle(product),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: product.id,
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Konten Detail Produk
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk dan Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade900,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Rp ${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w900,
                              color: Colors.green.shade700,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Kategori
                  Chip(
                    label: Text(
                      product.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: Colors.blue.shade700,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Deskripsi Produk
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
                ],
              ),
            ),
          ),
        ],
      ),

      // Tombol Aksi Bawah
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
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
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(
                  "Beli Sekarang",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart, size: 22),
                label: const Text(
                  'Tambah',
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
                      content: Text("${product.title} telah ditambahkan!"),
                      backgroundColor: Colors.green.shade600,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  minimumSize: const Size.fromHeight(56),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
