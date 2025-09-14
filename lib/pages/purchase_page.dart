import 'package:flutter/material.dart';
import '../models/product.dart';
import 'order_page.dart'; // pastikan import OrderPage

// Dummy global order list (kalau belum pakai Provider)
List<Map<String, dynamic>> orders = [];

class PurchasePage extends StatefulWidget {
  final Product product;
  const PurchasePage({super.key, required this.product});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.product.price * quantity;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Checkout",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Produk Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(widget.product.image,
                        height: 80, width: 80, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("\$${widget.product.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.blueGrey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quantity selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Quantity",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() => quantity--);
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Colors.blueGrey),
                    ),
                    Text(quantity.toString(),
                        style: const TextStyle(fontSize: 18)),
                    IconButton(
                      onPressed: () => setState(() => quantity++),
                      icon: const Icon(Icons.add_circle_outline,
                          color: Colors.lightBlue),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Total Harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  "\$${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent),
                ),
              ],
            ),
            const Spacer(),

            // Tombol konfirmasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: Colors.lightBlue,
                ),
                onPressed: () {
                  // Tambahkan ke order global
                  orders.add({
                    "product": widget.product,
                    "quantity": quantity,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("You bought ${widget.product.title} x$quantity ✅"),
                    backgroundColor: Colors.green,
                  ));

                  // Route ke OrderPage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderPage()),
                  );
                },
                child: const Text(
                  "Confirm Purchase",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
