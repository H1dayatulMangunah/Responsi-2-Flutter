import 'package:flutter/material.dart';
import '../helpers/api_service.dart';
import '../model/registrasi.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordKonfirmasiController = TextEditingController();

  bool _isLoading = false;
  String? _msg;

  void _doRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _msg = null;
    });

    final result = await ApiService.registrasi(
      _namaController.text,
      _emailController.text,
      _passwordController.text,
    );

    final registrasi = Registrasi.fromJson(result['body']);

    setState(() {
      _msg = registrasi.data;
      _isLoading = false;
    });

    if (registrasi.status == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(registrasi.data ?? 'Registrasi Berhasil')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Unamart'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) =>
                v == null || v.length < 3 ? 'Nama minimal 3 karakter' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Email harus diisi' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) =>
                v == null || v.length < 6 ? 'Password minimal 6 karakter' : null,
              ),
              TextFormField(
                controller: _passwordKonfirmasiController,
                decoration:
                const InputDecoration(labelText: 'Konfirmasi Password'),
                obscureText: true,
                validator: (v) => v != _passwordController.text
                    ? 'Konfirmasi password tidak sama'
                    : null,
              ),
              const SizedBox(height: 16),
              if (_msg != null)
                Text(_msg!,
                    style: TextStyle(
                        color: _msg!.contains('Berhasil')
                            ? Colors.green
                            : Colors.red)),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _doRegister,
                child: const Text('Registrasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
