class Inventaris {
  int? id;
  String? nama;
  int? harga;
  int? jumlah;
  String? tanggalMasuk;

  Inventaris({this.id, this.nama, this.harga, this.jumlah, this.tanggalMasuk});

  factory Inventaris.fromJson(Map<String, dynamic> obj) {
    return Inventaris(
      id: int.parse(obj['id'].toString()),
      nama: obj['nama'],
      harga: int.parse(obj['harga'].toString()),
      jumlah: int.parse(obj['jumlah'].toString()),
      tanggalMasuk: obj['tanggal_masuk'],
    );
  }
}
