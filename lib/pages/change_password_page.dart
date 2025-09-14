import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // Metode untuk membuat dekorasi input yang konsisten
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.deepPurple),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.grey.shade600),
    );
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Logika untuk mengganti kata sandi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kata sandi berhasil diubah!"),
          backgroundColor: Colors.deepPurple,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Ganti Kata Sandi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _oldPassController,
                decoration:
                    _inputDecoration("Kata Sandi Lama", Icons.lock_outline),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? "Masukkan kata sandi lama" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPassController,
                decoration:
                    _inputDecoration("Kata Sandi Baru", Icons.lock_open),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan kata sandi baru";
                  }
                  if (value.length < 6) {
                    return "Minimal 6 karakter";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPassController,
                decoration:
                    _inputDecoration("Konfirmasi Kata Sandi", Icons.lock),
                obscureText: true,
                validator: (value) {
                  if (value != _newPassController.text) {
                    return "Kata sandi tidak cocok";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "Ubah Kata Sandi",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
