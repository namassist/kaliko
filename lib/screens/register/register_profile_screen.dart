import 'package:flutter/material.dart';

class RegisterProfileScreen extends StatefulWidget {
  const RegisterProfileScreen({super.key});

  @override
  State<RegisterProfileScreen> createState() => _RegisterProfileScreenState();
}

class _RegisterProfileScreenState extends State<RegisterProfileScreen> {
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
                mouseCursor: SystemMouseCursors.click,
                onTap: () {
                  // widget.onTap();
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
                  ),
                ),
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
