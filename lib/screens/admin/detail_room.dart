import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kaliko/models/power_usage_model.dart';
import 'package:kaliko/models/user_model.dart';
import 'package:kaliko/services/firebase_services.dart';
import 'package:kaliko/utils/date_formatter.dart';
import 'package:kaliko/utils/format_currency.dart';
import 'package:kaliko/widgets/show_dialog.dart';
import 'package:kaliko/widgets/usage_row.dart';
import 'package:rxdart/rxdart.dart'; // Untuk StreamZip

class DetailRoomAdminScreen extends StatefulWidget {
  final UserModel user;

  const DetailRoomAdminScreen({super.key, required this.user});

  @override
  State<DetailRoomAdminScreen> createState() => _DetailRoomAdminScreenState();
}

class _DetailRoomAdminScreenState extends State<DetailRoomAdminScreen> {
  late final FirebaseService _firebaseService;
  final ValueNotifier<double> energyNotifier = ValueNotifier(0.0);
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    initializeDateFormatting('id_ID');
  }

  void _showDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      title: 'Pemberitahuan',
      content: 'Apakah benar melakukan pembayaran?',
      showCloseButton: true,
      closeButtonText: 'Batal',
      confirmButtonText: 'Iya',
      onConfirmPressed: () async {
        String jam = DateTime.now().hour.toString();

        DateTime nextMonth = DateTime.now().add(const Duration(days: 30));
        String tanggal = "${nextMonth.day.toString().padLeft(2, '0')}/"
            "${(nextMonth.month).toString().padLeft(2, '0')}/"
            "${nextMonth.year}";

        final streamData = await Rx.zip([
          _firebaseService.getRoomPowerUsage(widget.user.roomId),
          _firebaseService.getRoomControling(widget.user.roomId)
        ], (List<PowerUsageModel> values) => values).first;

        final powerUsage = streamData[0];
        final controlling = streamData[1];
        final formattedDueDate =
            DateFormatter.formatToLocaleDate(controlling.tanggal);

        try {
          await _firebaseService.updateDeviceControl(
              widget.user.roomId, jam, tanggal);
          await _firebaseService.resetDeviceMonitoring(widget.user.roomId);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.electric_bolt,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Listrik telah menyala',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xffF75320),
            ),
          );

          await Future.delayed(const Duration(seconds: 1));

          if (context.mounted) {
            Navigator.of(context).pop();
            Navigator.pushNamed(
              context,
              '/admin/invoice',
              arguments: {
                'kamarId': widget.user.id,
                'dueDate': formattedDueDate,
                'fullname': widget.user.fullname,
                'roomId': widget.user.roomId,
                'energy': powerUsage.energy,
              },
            );
          }
        } catch (e) {
          debugPrint('Proses gagal: $e');
          Navigator.of(context).pop();
        }
      },
    );
  }

  void _showEditPriceDialog(BuildContext context, String currentPrice) {
    _priceController.text = currentPrice;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Harga/kWh'),
          content: TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Harga per kWh',
              prefixText: 'Rp ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final newPrice = double.tryParse(_priceController.text);
                  await _firebaseService.updatePrice(
                      widget.user.roomId, newPrice!);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harga berhasil diperbarui'),
                      ),
                    );
                  }
                  setState(() {});
                } catch (e) {
                  debugPrint('Update price failed: $e');
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal memperbarui harga'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
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
        child: StreamBuilder<List<PowerUsageModel>>(
            stream: Rx.zip([
              _firebaseService.getRoomPowerUsage(widget.user.roomId),
              _firebaseService.getRoomControling(widget.user.roomId)
            ], (List<PowerUsageModel> values) => values),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error loading power usage data');
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final powerUsage = snapshot.data![0];
              final controlling = snapshot.data![1];

              final formattedDueDate =
                  DateFormatter.formatToLocaleDate(controlling.tanggal);
              final formattedStartDate =
                  DateFormatter.getStartDate(controlling.tanggal);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                energyNotifier.value = powerUsage.energy;
              });

              return Column(
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
                                  ValueListenableBuilder<double>(
                                    valueListenable: energyNotifier,
                                    builder: (context, energy, child) {
                                      return Text(
                                        formatCurrency(
                                            controlling.price * energy),
                                        style: const TextStyle(
                                          fontSize: 36.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
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
                                  value: widget.user.fullname,
                                  gap: 20,
                                ),
                                UsageRow(
                                  label: 'No Kamar',
                                  value: widget.user.roomId.split('kamar')[1],
                                  gap: 20,
                                ),
                                UsageRow(
                                  label: 'Harga/kWh',
                                  value: 'Rp ${controlling.price}',
                                  gap: 20,
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit, size: 16),
                                    onPressed: () => _showEditPriceDialog(
                                        context, controlling.price.toString()),
                                  ),
                                ),
                                UsageRow(
                                  label: 'Tegangan',
                                  value:
                                      "${powerUsage.voltage.toStringAsFixed(2)} V",
                                  gap: 20,
                                ),
                                UsageRow(
                                  label: 'Arus',
                                  value:
                                      "${powerUsage.current.toStringAsFixed(2)} A",
                                  gap: 20,
                                ),
                                UsageRow(
                                  label: 'Daya Aktif',
                                  value:
                                      "${powerUsage.power.toStringAsFixed(2)} W",
                                  gap: 20,
                                ),
                                UsageRow(
                                  label: 'Faktor Daya',
                                  value:
                                      powerUsage.powerFactor.toStringAsFixed(2),
                                  gap: 20,
                                ),
                                UsageRow(
                                  label: 'Energi Total',
                                  value:
                                      '${powerUsage.energy.toStringAsFixed(2)} kWh',
                                  gap: 20,
                                ),
                                UsageRow(
                                  label: 'Tanggal Mulai',
                                  value: formattedStartDate,
                                  gap: 20,
                                ),
                                UsageRow(
                                  label: 'Jatuh Tempo',
                                  value: formattedDueDate,
                                  gap: 20,
                                )
                              ],
                            ),
                            const SizedBox(height: 24.0),
                            ElevatedButton(
                              onPressed: () => _showDialog(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff00A6FF),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
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
              );
            }),
      ),
    );
  }
}
