import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaliko/models/power_usage_model.dart';
import 'package:kaliko/models/user_model.dart';
import 'package:kaliko/services/firebase_services.dart';
import 'package:kaliko/utils/date_formatter.dart';
import 'package:kaliko/utils/format_currency.dart';
import 'package:kaliko/widgets/show_dialog.dart';
import 'package:kaliko/widgets/usage_row.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rxdart/rxdart.dart';

class DashboardUserScreen extends StatefulWidget {
  const DashboardUserScreen({
    super.key,
  });

  @override
  State<DashboardUserScreen> createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  late final FirebaseService _firebaseService;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> energyNotifier = ValueNotifier(0.0);
  final ValueNotifier<String> dueDateNotifier = ValueNotifier(
    DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    initializeDateFormatting('id_ID');
  }

  int calculateRemainingDays(String dateStr) {
    if (dateStr.isEmpty) return 0;

    try {
      final dueDate = DateFormat('dd/MM/yyyy').parse(dateStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
      return dueDateOnly.difference(today).inDays;
    } catch (e) {
      return 0;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              return Stack(
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
                              Expanded(
                                child: Row(children: [
                                  Image.asset(
                                    'assets/icons/electric-transparent.png',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      'Hello ${user.fullname}!',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ]),
                              ),
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
                                  itemBuilder: (BuildContext context) => [
                                    // const PopupMenuItem(
                                    //   value: 'About',
                                    //   child: SizedBox(
                                    //     width: 100,
                                    //     child: Row(
                                    //       children: [
                                    //         Icon(Icons.info_outline,
                                    //             size: 20,
                                    //             color: Colors.black54),
                                    //         SizedBox(width: 10),
                                    //         Text('About'),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    PopupMenuItem(
                                      value: 'Logout',
                                      child: const SizedBox(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            Icon(Icons.logout,
                                                size: 20,
                                                color: Colors.black54),
                                            SizedBox(width: 10),
                                            Text('Logout'),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        await FirebaseAuth.instance.signOut();
                                        if (mounted) {
                                          await showCustomDialog(
                                            context: context,
                                            title: 'Berhasil',
                                            content:
                                                'Anda telah berhasil logout',
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
                                      },
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('dd MMM yyyy', 'id_ID')
                                            .format(DateTime.now()),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          ValueListenableBuilder<double>(
                                            valueListenable: energyNotifier,
                                            builder: (context, energy, child) {
                                              return Text(
                                                formatCurrency(1400 * energy),
                                                style: const TextStyle(
                                                  fontSize: 28.0,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xffD65A23),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      ValueListenableBuilder<String>(
                                        valueListenable: dueDateNotifier,
                                        builder: (context, dueDateStr, child) {
                                          final remainingDays =
                                              calculateRemainingDays(
                                                  dueDateStr);
                                          return Text(
                                            '$remainingDays hari',
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                const SizedBox(height: 20.0),
                                StreamBuilder<List<PowerUsageModel>>(
                                    stream: Rx.zip(
                                        [
                                          _firebaseService
                                              .getRoomPowerUsage(user.roomId),
                                          _firebaseService
                                              .getRoomControling(user.roomId)
                                        ],
                                        (List<PowerUsageModel> values) =>
                                            values),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Error loading power usage data');
                                      }

                                      if (!snapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      }

                                      final powerUsage = snapshot.data![0];
                                      final controlling = snapshot.data![1];

                                      final formattedDueDate =
                                          DateFormatter.formatToLocaleDate(
                                              controlling.tanggal);
                                      final formattedStartDate =
                                          DateFormatter.getStartDate(
                                              controlling.tanggal);

                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        energyNotifier.value =
                                            powerUsage.energy;
                                        dueDateNotifier.value =
                                            controlling.tanggal;
                                      });

                                      return Column(
                                        children: [
                                          UsageRow(
                                              label: 'Nama',
                                              value: user.fullname,
                                              gap: 20),
                                          UsageRow(
                                              label: 'No Kamar',
                                              value:
                                                  user.roomId.split('kamar')[1],
                                              gap: 20),
                                          const UsageRow(
                                              label: 'Harga/kWh',
                                              value: 'Rp 1.400,00',
                                              gap: 20),
                                          UsageRow(
                                              label: 'Tegangan',
                                              value:
                                                  "${powerUsage.voltage.toStringAsFixed(2)} V",
                                              gap: 20),
                                          UsageRow(
                                              label: 'Arus',
                                              value:
                                                  "${powerUsage.current.toStringAsFixed(2)} A",
                                              gap: 20),
                                          UsageRow(
                                              label: 'Daya Aktif',
                                              value:
                                                  "${powerUsage.power.toStringAsFixed(2)} W",
                                              gap: 20),
                                          UsageRow(
                                              label: 'Faktor Daya',
                                              value: powerUsage.powerFactor
                                                  .toStringAsFixed(2),
                                              gap: 20),
                                          UsageRow(
                                              label: 'Energi Total',
                                              value:
                                                  '${powerUsage.energy.toStringAsFixed(2)} kWh',
                                              gap: 20),
                                          UsageRow(
                                              label: 'Tanggal Mulai',
                                              value: formattedStartDate,
                                              gap: 20),
                                          UsageRow(
                                              label: 'Jatuh Tempo',
                                              value: formattedDueDate,
                                              gap: 20)
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
