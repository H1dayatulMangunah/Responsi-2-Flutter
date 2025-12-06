import 'package:flutter/material.dart';
import '../helpers/api_service.dart';
import '../model/inventaris.dart';
import 'inventaris_form_page.dart';
import 'login_page.dart';

class InventarisListPage extends StatefulWidget {
  const InventarisListPage({super.key});

  @override
  State<InventarisListPage> createState() => _InventarisListPageState();
}

class _InventarisListPageState extends State<InventarisListPage> {
  late Future<List<Inventaris>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = ApiService.getInventaris().then((list) =>
        list.map((e) => Inventaris.fromJson(e as Map<String, dynamic>)).toList());
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  Future<void> _deleteItem(int id) async {
    final res = await ApiService.deleteInventaris(id);
    final msg = res['body']['data'].toString();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Hapus: $msg')));
    setState(_reload);
  }

  Future<void> _goToForm({Inventaris? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InventarisFormPage(item: item),
      ),
    );
    if (result == true) {
      setState(_reload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Komputer Unamart'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: FutureBuilder<List<Inventaris>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('Belum ada data inventaris'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                child: ListTile(
                  title: Text(item.nama ?? '-'),
                  subtitle: Text(
                    'Harga: ${item.harga} | Jumlah: ${item.jumlah}\n'
                        'Tanggal Masuk: ${item.tanggalMasuk}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _goToForm(item: item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteItem(item.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
