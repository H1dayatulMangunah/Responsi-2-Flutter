import 'package:flutter/material.dart';
import '../helpers/api_service.dart';
import '../model/inventaris.dart';

class InventarisFormPage extends StatefulWidget {
  final Inventaris? item;

  const InventarisFormPage({super.key, this.item});

  @override
  State<InventarisFormPage> createState() => _InventarisFormPageState();
}

class _InventarisFormPageState extends State<InventarisFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _tanggalController = TextEditingController();

  bool _isSaving = false;
  String? _msg;

  bool get isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final item = widget.item!;
      _namaController.text = item.nama ?? '';
      _hargaController.text = item.harga?.toString() ?? '';
      _jumlahController.text = item.jumlah?.toString() ?? '';
      _tanggalController.text = item.tanggalMasuk ?? '';
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (result != null) {
      _tanggalController.text = result.toIso8601String().substring(0, 10);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _msg = null;
    });

    final nama = _namaController.text;
    final harga = int.tryParse(_hargaController.text) ?? 0;
    final jumlah = int.tryParse(_jumlahController.text) ?? 0;
    final tanggal = _tanggalController.text;

    Map<String, dynamic> res;
    if (isEdit) {
      res = await ApiService.updateInventaris(
          widget.item!.id!, nama, harga, jumlah, tanggal);
    } else {
      res = await ApiService.addInventaris(
          nama, harga, jumlah, tanggal);
    }

    setState(() {
      _msg = res['body']['data'].toString();
      _isSaving = false;
    });

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit
            ? 'Edit Inventaris Unamart'
            : 'Tambah Inventaris Unamart'),
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
                v == null || v.isEmpty ? 'Nama harus diisi' : null,
              ),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Harga (int)'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || v.isEmpty ? 'Harga harus diisi' : null,
              ),
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(labelText: 'Jumlah (int)'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || v.isEmpty ? 'Jumlah harus diisi' : null,
              ),
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Masuk (string)',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ),
                validator: (v) => v == null || v.isEmpty
                    ? 'Tanggal Masuk harus diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              if (_msg != null)
                Text(_msg!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? 'Update' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
