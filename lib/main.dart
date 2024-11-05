import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Transaksi Toko Komputer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TransaksiPage(),
    );
  }
}

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final List<Barang> daftarBarang = [
    Barang(nama: "Monitor LED", harga: 2500000),
    Barang(nama: "Keyboard Mechanical", harga: 800000),
    Barang(nama: "Mouse Gaming", harga: 600000),
    Barang(nama: "Headset", harga: 450000),
  ];

  List<Transaksi> struk = [];
  double totalBayar = 0;

  final List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < daftarBarang.length; i++) {
      controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void resetTransaksi() {
    setState(() {
      for (var controller in controllers) {
        controller.clear();
      }
      struk.clear();
      totalBayar = 0;
    });
  }

  void cetakStruk() {
    setState(() {
      struk.clear();
      totalBayar = 0;

      for (var i = 0; i < daftarBarang.length; i++) {
        var jumlah = int.tryParse(controllers[i].text) ?? 0;
        if (jumlah > 0) {
          var subtotal = daftarBarang[i].harga * jumlah;
          struk.add(
            Transaksi(
              barang: daftarBarang[i],
              jumlah: jumlah,
              subtotal: subtotal,
            ),
          );
          totalBayar += subtotal;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Toko Komputer'),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: daftarBarang.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.computer),
                      title: Text(daftarBarang[index].nama),
                      subtitle: Text(
                        'Rp ${daftarBarang[index].harga.toStringAsFixed(0)}',
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: controllers[index],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            hintText: '0',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: resetTransaksi,
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: cetakStruk,
                  child: const Text('Cetak Struk'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (struk.isNotEmpty) ...[
              const Text(
                'Struk Transaksi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: struk.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text(struk[index].barang.nama),
                      subtitle: Text(
                          '${struk[index].jumlah} x Rp ${struk[index].barang.harga}'),
                      trailing: Text(
                          'Rp ${struk[index].barang.harga * struk[index].jumlah}'),
                    );
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.receipt),
                title: Text('Total Bayar'),
                trailing: Text(
                  'Rp $totalBayar',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Barang {
  final String nama;
  final double harga;

  Barang({required this.nama, required this.harga});
}

class Transaksi {
  final Barang barang;
  final int jumlah;
  final double subtotal;

  Transaksi({
    required this.barang,
    required this.jumlah,
    required this.subtotal,
  });
}
