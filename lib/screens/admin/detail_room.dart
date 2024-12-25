import 'package:flutter/material.dart';
import 'package:kaliko/widgets/show_dialog.dart';
import 'package:kaliko/widgets/usage_row.dart';

class DetailRoomAdminScreen extends StatelessWidget {
  final String kamarId;
  final String title;
  final String residentName;

  const DetailRoomAdminScreen({
    super.key,
    required this.kamarId,
    required this.title,
    required this.residentName,
  });

  void _showDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      title: 'Action Required',
      content: 'Do you want to proceed with the action?',
      closeButtonText: 'Batal',
      confirmButtonText: 'Iya',
      onClosePressed: () {
        debugPrint('Close button pressed');
      },
      onConfirmPressed: () {
        Navigator.pushNamed(
          context,
          '/admin/invoice',
          arguments: {
            'kamarId': kamarId,
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/electric.png',
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Info Tagihan",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 30, bottom: 16, left: 24, right: 24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xff88D5FF),
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                              color: const Color(0xff00A6FF), width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tagihan Pembayaran',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black87),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Rp 200.000,00',
                              style: TextStyle(
                                fontSize: 36.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '20 hari',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                Image.asset(
                                  'assets/images/mini-logo.png',
                                  width: 80,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        children: [
                          UsageRow(
                            label: 'Nama',
                            value: residentName,
                          ),
                          const UsageRow(label: 'No Kamar', value: '1'),
                          const UsageRow(
                              label: 'Harga/kWh', value: 'Rp 1.400,00'),
                          const UsageRow(label: 'Tegangan', value: '138'),
                          const UsageRow(label: 'Arus', value: '138'),
                          const UsageRow(label: 'Daya Aktif', value: '138'),
                          const UsageRow(label: 'Faktor Daya', value: '138'),
                          const UsageRow(label: 'Energi Total', value: '138'),
                          const UsageRow(
                              label: 'Start Date', value: '1 Januari 2025'),
                          const UsageRow(
                              label: 'End Date', value: '1 Februari 2025'),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () => _showDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00A6FF),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                        ),
                        child: const Text(
                          'Bayar',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
