import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaliko/models/user_model.dart';
import 'package:kaliko/services/firebase_services.dart';
import 'package:kaliko/services/notification_services.dart';
import 'package:kaliko/widgets/room_card.dart';
import 'package:kaliko/widgets/show_dialog.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  late final FirebaseService _firebaseService;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    await NotificationService.clearUserSession();

    if (mounted) {
      await showCustomDialog(
        context: context,
        title: 'Berhasil',
        content: 'Anda telah berhasil logout',
        showCloseButton: false,
        confirmButtonText: 'OK',
        onConfirmPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/auth/sign_in',
            (route) => false,
          );
        },
      );
    }
  }

  void _endTenancy(
      BuildContext context, UserModel user, VoidCallback onSuccess) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hentikan Sewa'),
        content: Text(
            'Anda yakin ingin menghentikan sewa untuk ${user.fullname}? Data pengguna akan dihapus secara permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:
                const Text('Ya, Hentikan', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await _firebaseService.deleteUser(user.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Sewa untuk ${user.fullname} telah dihentikan.')),
          );
        }
        onSuccess();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghentikan sewa: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<UserModel?>(
        future: _firebaseService.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/auth/sign-in');
            });
            return const SizedBox.shrink();
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
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
                              Text(
                                'Hello ${user.fullname}!',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 16.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 17.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                        child: FutureBuilder<List<UserModel>>(
                          future: FirebaseService().getAllUsers(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No users found'));
                            } else {
                              final users = snapshot.data!;
                              return GridView.builder(
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
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  final user = users[index];
                                  return RoomCard(
                                    id: user.id,
                                    roomId: user.roomId,
                                    name: user.fullname,
                                    user: user,
                                    onDelete: () {
                                      _endTenancy(context, user, () {
                                        setState(() {});
                                      });
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
