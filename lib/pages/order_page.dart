import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../models/product.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final List<Product> orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: orders.isEmpty
          ? const Center(child: Text('No orders yet'))
          : ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final p = orders[i];
                return ListTile(
                  leading: Image.asset(p.image, width: 56, fit: BoxFit.contain),
                  title: Text(p.title),
                  subtitle: Text('Rp ${p.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => orderProvider.removeOrder(p),
                  ),
                );
              },
            ),
    );
  }
}
