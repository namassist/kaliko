import 'package:flutter/material.dart';
import 'package:kaliko/widgets/usage_row.dart';

class DashboardUserScreen extends StatefulWidget {
  const DashboardUserScreen({super.key});

  @override
  State<DashboardUserScreen> createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 380,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff171514),
                  Color(0xffF75320),
                ],
              ),
            ),
          ),
          Positioned(
            top: 25,
            right: 90,
            child: Image.asset(
              'assets/icons/pattern-1.png',
              height: 15,
            ),
          ),
          Positioned(
            top: 45,
            right: 60,
            child: Image.asset(
              'assets/icons/pattern-1.png',
              height: 15,
            ),
          ),
          Positioned(
            top: 290,
            right: 120,
            child: Image.asset(
              'assets/icons/pattern-1.png',
              height: 30,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(children: [
                        Image.asset(
                          'assets/icons/electric-transparent.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Hello Rafael!',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                      PopupMenuTheme(
                        data: const PopupMenuThemeData(
                          color: Colors.white,
                        ),
                        child: PopupMenuButton<String>(
                          offset: const Offset(0, 50),
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 28.0,
                          ),
                          onSelected: (value) {
                            if (value == 'About') {
                              Navigator.pushNamed(context, "/user/profile");
                            } else if (value == 'Logout') {
                              Navigator.pushNamed(context, "/auth/login");
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 'About',
                              child: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        size: 20, color: Colors.black54),
                                    SizedBox(width: 10),
                                    Text('About'),
                                  ],
                                ),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'Logout',
                              child: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    Icon(Icons.logout,
                                        size: 20, color: Colors.black54),
                                    SizedBox(width: 10),
                                    Text('Logout'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Penggunaan  Energi',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 27.0,
                      right: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '17 Dec 2022',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '132',
                                  style: TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xffD65A23)),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'kWh',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '20 hari',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/images/electric-pattern.png',
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: 20.0,
                      bottom: 45.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffF75320),
                        width: 1.0,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
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
                        SizedBox(height: 20.0),
                        Column(
                          children: [
                            UsageRow(
                                label: 'Nama',
                                value: 'Rafael Struick',
                                gap: 20),
                            UsageRow(
                                label: 'No Kamar', value: 'Room 1', gap: 20),
                            UsageRow(
                                label: 'Harga/kWh',
                                value: 'Rp 1.400,00',
                                gap: 20),
                            UsageRow(label: 'Tegangan', value: '138', gap: 20),
                            UsageRow(label: 'Arus', value: '138', gap: 20),
                            UsageRow(
                                label: 'Daya Aktif', value: '138', gap: 20),
                            UsageRow(
                                label: 'Faktor Daya', value: '138', gap: 20),
                            UsageRow(
                                label: 'Energi Total', value: '138', gap: 20),
                            UsageRow(
                                label: 'Tanggal Mulai',
                                value: '1 Januari 2025',
                                gap: 20),
                            UsageRow(
                                label: 'Jatuh Tempo',
                                value: '1 Februari 2025',
                                gap: 20),
                          ],
                        ),
                      ],
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
}
