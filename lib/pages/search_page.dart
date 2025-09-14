import 'package:flutter/material.dart';

// Dummy cart & wishlist global
// Disarankan untuk menggunakan Provider atau bloc untuk manajemen state yang lebih baik.
List<Map<String, dynamic>> cart = [];
List<Map<String, dynamic>> wishlist = [];

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Map<String, dynamic>> _products = [
    {
      "id": 1,
      "name": "Jaket Stylish",
      "price": 1500000,
      "image": "assets/jaket.jpg",
      "desc":
          "Jaket stylish dan fungsional untuk segala musim. Desain modern dengan bahan berkualitas tinggi yang nyaman dipakai sepanjang hari."
    },
    {
      "id": 2,
      "name": "Samsung Galaxy S24 Ultra",
      "price": 18000000,
      "image": "assets/s24ultra.png",
      "desc":
          "Ponsel pintar dengan performa terdepan dan kamera super jernih. Abadikan momen terbaik Anda dengan teknologi mutakhir."
    },
    {
      "id": 3,
      "name": "Sofa Keluarga Modern",
      "price": 2500000,
      "image": "assets/sofa.png",
      "desc":
          "Sofa empuk dan nyaman, cocok untuk bersantai bersama keluarga. Desain minimalis yang mempercantik ruang tamu Anda."
    },
    {
      "id": 4,
      "name": "Nike Jordan High",
      "price": 3000000,
      "image": "assets/nikejordan.jpg",
      "desc":
          "Sepatu ikonik yang tak lekang oleh waktu. Dibuat dengan material premium untuk kenyamanan maksimal dan gaya yang tak tertandingi."
    },
    {
      "id": 5,
      "name": "Kaos Red Bull Racing",
      "price": 250000,
      "image": "assets/bajuredbull.jpg",
      "desc":
          "Kaos kasual dengan logo tim balap Red Bull. Sempurna untuk penggemar balapan dan gaya sporty."
    },
    {
      "id": 6,
      "name": "Jam Tangan Rolex Submariner",
      "price": 35000000,
      "image": "assets/rolex.jpg",
      "desc":
          "Jam tangan mewah yang melambangkan keanggunan dan kesuksesan. Tahan air dan dibuat dengan presisi tertinggi."
    },
  ];

  String query = "";

  @override
  Widget build(BuildContext context) {
    final results = _products
        .where((p) => p["name"].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Cari Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty && query.isNotEmpty
                ? Center(
                    child: Text(
                      'Tidak ada hasil untuk "$query"',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount:
                        query.isEmpty ? _products.length : results.length,
                    itemBuilder: (context, index) {
                      final product =
                          query.isEmpty ? _products[index] : results[index];
                      bool isWishlisted = wishlist.contains(product);

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(product: product),
                            ),
                          ).then((_) {
                            setState(() {
                              // Rebuild the page after returning from detail page to update wishlist icon
                            });
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Card(
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Hero(
                                      tag: product["id"],
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                        child: Image.asset(
                                          product["image"],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product["name"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Rp ${product["price"].toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.deepPurple.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: Icon(
                                    isWishlisted
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isWishlisted
                                        ? Colors.red
                                        : Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (isWishlisted) {
                                        wishlist.remove(product);
                                      } else {
                                        wishlist.add(product);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  void _addToCart() {
    if (!cart.contains(widget.product)) {
      cart.add(widget.product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("${widget.product["name"]} ditambahkan ke keranjang!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("${widget.product["name"]} sudah ada di keranjang.")),
      );
    }
  }

  void _toggleWishlist() {
    setState(() {
      if (wishlist.contains(widget.product)) {
        wishlist.remove(widget.product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("${widget.product["name"]} dihapus dari wishlist!")),
        );
      } else {
        wishlist.add(widget.product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("${widget.product["name"]} ditambahkan ke wishlist!")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isFav = wishlist.contains(widget.product);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          Hero(
            tag: widget.product["id"],
            child: Image.asset(
              widget.product["image"],
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product["name"],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${widget.product["price"].toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product["desc"] ?? "Deskripsi tidak tersedia.",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _addToCart,
                        icon: const Icon(Icons.shopping_cart,
                            color: Colors.white),
                        label: const Text(
                          "Tambah ke Keranjang",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleWishlist,
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PurchasePage(product: widget.product),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Beli Sekarang",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy PurchasePage
class PurchasePage extends StatelessWidget {
  final Map<String, dynamic> product;
  const PurchasePage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pembelian ${product["name"]}")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Anda akan membeli ${product["name"]} dengan harga Rp ${product["price"]}.",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
