// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Product> get _products => const [
        Product(
          id: 'p1',
          title: 'Jaket Stylish',
          price: 1500000,
          image: 'assets/jaket.jpg',
          category: 'Fashion',
          description:
              'Jaket stylish dan nyaman yang sempurna untuk setiap kesempatan, dengan desain modern dan bahan berkualitas.',
        ),
        Product(
          id: 'p2',
          title: 'Samsung Galaxy S24 Ultra',
          price: 18000000,
          image: 'assets/s24ultra.jpg',
          category: 'Electronics',
          description:
              'Smartphone Samsung S24 Ultra, canggih dan ramping, sempurna untuk penggunaan sehari-hari dan fotografi.',
        ),
        Product(
          id: 'p3',
          title: 'Sofa Keluarga Modern',
          price: 2500000,
          image: 'assets/kursi.jpg',
          category: 'Furniture',
          description:
              'Sofa keluarga yang dirancang untuk kenyamanan maksimal dan gaya, cocok untuk ruang tamu Anda.',
        ),
        Product(
          id: 'p4',
          title: 'Nike Jordan High',
          price: 3000000,
          image: 'assets/nikejordan.jpg',
          category: 'Sneakers',
          description:
              'Sneaker mutakhir dari Nike, menampilkan desain stylish dan bantalan canggih untuk kenyamanan maksimal.',
        ),
        Product(
          id: 'p5',
          title: 'Kaos Red Bull',
          price: 2500000,
          image: 'assets/bajuredbull.jpg',
          category: 'Fashion',
          description:
              'Kaos trendi dan nyaman dari Red Bull, cocok untuk pemakaian kasual dan aktivitas olahraga.',
        ),
        Product(
          id: 'p6',
          title: 'Jam Tangan Rolex Submariner',
          price: 35000000,
          image: 'assets/rolex.jpg',
          category: 'Watches',
          description:
              'Jam tangan mewah dan ikonik dari Rolex, menampilkan desain abadi dan rekayasa presisi.',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    for (final p in _products) {
      cart.register(p);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeaderWidget(),
              const SizedBox(height: 20),
              const _SearchInput(),
              const SizedBox(height: 28),
              const _PromoBanner(),
              const SizedBox(height: 36),
              Text(
                'Kategori Populer',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                      letterSpacing: 0.5,
                    ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _Cat(icon: Icons.phone_iphone, label: 'Ponsel'),
                    _Cat(icon: Icons.computer, label: 'Laptop'),
                    _Cat(icon: Icons.watch, label: 'Jam Tangan'),
                    _Cat(icon: Icons.chair, label: 'Furnitur'),
                    _Cat(icon: Icons.shopping_bag, label: 'Fashion'),
                    _Cat(icon: Icons.checkroom, label: 'Kaos'),
                  ],
                ),
              ),
              const SizedBox(height: 38),
              Text(
                'Produk Rekomendasi',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                      letterSpacing: 0.5,
                    ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 700 ? 3 : 2;
                  return GridView.builder(
                    itemCount: _products.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (c, i) {
                      final p = _products[i];
                      final fav = c.watch<WishlistProvider>().isFav(p);
                      return _ProductCardCustom(
                        product: p,
                        isFavorite: fav,
                        onFavToggle: () => c.read<WishlistProvider>().toggle(p),
                        onAddToCart: () => c.read<CartProvider>().add(p),
                        onOpen: () => Navigator.push(
                          c,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: p),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, Pembeli!',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.blueGrey.shade700,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Apa yang kamu cari hari ini?',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade900,
                    letterSpacing: 0.6,
                  ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_outlined),
          tooltip: 'Pemberitahuan',
          iconSize: 30,
          color: Colors.blueGrey.shade800,
          splashRadius: 26,
        ),
      ],
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Cari produk...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = constraints.maxWidth > 400 ? 28.0 : 22.0;
        final horizontalPadding = constraints.maxWidth > 400 ? 28.0 : 20.0;
        return Container(
          height: 190,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade300.withOpacity(0.45),
                blurRadius: 16,
                offset: const Offset(0, 10),
              )
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 32,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Diskon Kilat 30%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Berakhir dalam 04:32:11',
                      style: TextStyle(
                        fontSize: fontSize * 0.65,
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 7,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shadowColor: Colors.orangeAccent.shade200,
                ),
                onPressed: () {},
                child: const Text(
                  'Belanja Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.9,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Cat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Cat({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 22),
      child: Container(
        width: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 12,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade50,
              child: Icon(icon, size: 32, color: Colors.blue.shade600),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.blueGrey.shade900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCardCustom extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavToggle;
  final VoidCallback onAddToCart;
  final VoidCallback onOpen;
  const _ProductCardCustom({
    required this.product,
    required this.isFavorite,
    required this.onFavToggle,
    required this.onAddToCart,
    required this.onOpen,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24),
      elevation: 9,
      shadowColor: Colors.grey.shade400,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onOpen,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Hero(
                      tag: product.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          product.image,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 14,
                      child: GestureDetector(
                        onTap: onFavToggle,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white70,
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.redAccent : Colors.grey,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                  letterSpacing: 0.4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Rp ${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                label: const Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: onAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size.fromHeight(42),
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
