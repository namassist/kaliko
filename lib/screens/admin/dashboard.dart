import 'package:flutter/material.dart';
import 'package:kaliko/widgets/room_card.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    Navigator.pushNamed(context, '/user/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/splash-logo-dark.png',
                      width: 120,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 28.0,
                      ),
                      onPressed: _handleLogout,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 17.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A6FF),
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello Admin!',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 17.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Cek kondisi listrik kamar dan\npastikan tetap menyala',
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Image.asset(
                                  'assets/icons/electric.png',
                                  width: 60,
                                  height: 60,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: 0.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 32.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final roomData = [
                          {
                            'id': 1,
                            'title': 'Kamar 1',
                            'subtitle': 'Abdul Saleh'
                          },
                          {
                            'id': 2,
                            'title': 'Kamar 2',
                            'subtitle': 'Budi Santoso'
                          },
                          {
                            'id': 3,
                            'title': 'Kamar 3',
                            'subtitle': 'Citra Dewi'
                          },
                          {
                            'id': 4,
                            'title': 'Kamar 4',
                            'subtitle': 'Doni Prasetyo'
                          },
                        ];
                        return RoomCard(
                          kamarId: roomData[index]['id']!.toString(),
                          title: roomData[index]['title']!.toString(),
                          subtitle: roomData[index]['subtitle']!.toString(),
                        );
                      },
                    ),
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
