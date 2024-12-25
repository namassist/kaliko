import 'package:flutter/material.dart';

class SignUpProfileScreen extends StatefulWidget {
  const SignUpProfileScreen({super.key});

  @override
  State<SignUpProfileScreen> createState() => _SignUpProfileScreenState();
}

class _SignUpProfileScreenState extends State<SignUpProfileScreen> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      _dateController.text = picked.toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'assets/icons/kaliko-app.png',
                width: 145,
                height: 145,
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF75320)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF75320)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Asal dari mana',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF75320)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF75320)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF75320)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF75320)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _dateController,
                mouseCursor: SystemMouseCursors.click,
                onTap: () {
                  _selectDate();
                  setState(() {});
                },
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                    labelText: 'Tanggal Masuk',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF75320)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF75320)),
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.calendar_month,
                        size: 16,
                      ),
                    )),
                readOnly: true,
              ),
              const SizedBox(height: 30),
              // Row(
              //   children: [
              //     const Text("02",
              //         style: TextStyle(
              //             fontSize:
              //                 18)), // Replace with TextFormField for user input
              //     Column(
              //       children: [
              //         IconButton(
              //           icon: const Icon(Icons.arrow_drop_up),
              //           onPressed: () {},
              //         ),
              //         IconButton(
              //           icon: const Icon(Icons.arrow_drop_down),
              //           onPressed: () {},
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF75320),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Register',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}