import 'package:flutter/material.dart';
import 'package:kaliko/widgets/show_dialog.dart';

class RoomDetail extends StatelessWidget {
  final String kamarId;
  final String title;
  final String residentName;

  const RoomDetail({
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
        print('Close button pressed');
      },
      onConfirmPressed: () {
        print('Confirm button pressed');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                          _buildUsageRow('Nama', residentName),
                          _buildUsageRow('No Kamar', '1'),
                          _buildUsageRow('Harga/kWh', 'Rp 1.400,00'),
                          _buildUsageRow('Tegangan', '138'),
                          _buildUsageRow('Arus', '138'),
                          _buildUsageRow('Daya Aktif', '138'),
                          _buildUsageRow('Faktor Daya', '138'),
                          _buildUsageRow('Energi Total', '138'),
                          _buildUsageRow('Start Date', '1 Januari 2025'),
                          _buildUsageRow('End Date', '1 Februari 2025'),
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

  Widget _buildUsageRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15.0,
              color: Color(0xff6C6C6C),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
