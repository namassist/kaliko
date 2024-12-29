import 'package:flutter/material.dart';
import 'package:kaliko/widgets/usage_row.dart';

class InvoiceAdmin extends StatelessWidget {
  final String kamarId;

  const InvoiceAdmin({
    super.key,
    required this.kamarId,
  });

  @override
  Widget build(BuildContext context) {
    const totalLabelStyle = TextStyle(
      fontSize: 13.0,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    );

    const totalValueStyle = TextStyle(
      fontSize: 20.0,
      color: Color(0xff00A6FF),
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(
              color: Color(0xFF2F3B41),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28.0),
                bottomRight: Radius.circular(28.0),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 130),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 25.0,
                      bottom: 50.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff00A6FF),
                        width: 1.0,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/mini-logo.png',
                                width: 90,
                              ),
                              const Text(
                                'Tagihan Listrik',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Column(
                          children: [
                            const UsageRow(
                                label: 'Tanggal',
                                value: '2025-01-20 16:33:51 WIB',
                                gap: 20),
                            _buildDottedBorder(),
                            const UsageRow(
                                label: 'Jatuh Tempo',
                                value: '1 Februari 2025',
                                gap: 20),
                            const UsageRow(
                                label: 'Nama',
                                value: 'Rafael Struick',
                                gap: 20),
                            const UsageRow(
                                label: 'No Kamar', value: 'Room 1', gap: 20),
                            const UsageRow(
                                label: 'Energi Total', value: '120', gap: 20),
                            const UsageRow(
                                label: '/kWh', value: 'Rp 1.400,00', gap: 20),
                            _buildDottedBorder(),
                            const UsageRow(
                              label: 'Total Bayar',
                              value: 'Rp 200.000,00',
                              labelStyle: totalLabelStyle,
                              valueStyle: totalValueStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00A6FF),
                        padding: const EdgeInsets.symmetric(vertical: 21.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                      ),
                      child: const Text(
                        'Unduh',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedBorder() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: List.generate(
          150 ~/ 3,
          (index) => Expanded(
            child: Container(
              color: index % 2 == 0
                  ? Colors.black.withOpacity(0.3)
                  : Colors.transparent,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}