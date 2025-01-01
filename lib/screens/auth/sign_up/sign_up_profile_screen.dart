import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaliko/models/user_model.dart';
import 'package:kaliko/services/firebase_services.dart';
import 'package:kaliko/utils/validation_rules.dart';
import 'package:kaliko/widgets/show_dialog.dart';

class SignUpProfileScreen extends StatefulWidget {
  final String email;
  final String password;

  const SignUpProfileScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<SignUpProfileScreen> createState() => _SignUpProfileScreenState();
}

class _SignUpProfileScreenState extends State<SignUpProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _dateController = TextEditingController();

  String _fullname = '';
  String _origin = '';
  String _phone = '';
  bool _isLoading = false;

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

  Future<void> _handleSignUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (userCredential.user != null) {
          final userModel = UserModel(
            id: userCredential.user!.uid,
            email: email,
            fullname: _fullname,
            origin: _origin,
            phone: _phone,
            startDate: DateTime.parse(_dateController.text),
            roomId: '',
            roleId: 'user',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _firebaseService.createUser(userModel);

          if (mounted) {
            await showCustomDialog(
              context: context,
              title: 'Success',
              content: 'Registrasi berhasil!',
              confirmButtonText: 'OK',
              showCloseButton: false,
              onConfirmPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/auth/sign-in',
                  (route) => false,
                );
              },
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'Password terlalu lemah';
            break;
          case 'email-already-in-use':
            errorMessage = 'Email sudah terdaftar';
            break;
          case 'invalid-email':
            errorMessage = 'Email tidak valid';
            break;
          default:
            errorMessage = 'Terjadi kesalahan: ${e.message}';
        }

        if (mounted) {
          await showCustomDialog(
            context: context,
            title: 'Error',
            content: errorMessage,
            showCloseButton: false,
            closeButtonText: 'OK',
          );
        }
      } catch (e) {
        if (mounted) {
          await showCustomDialog(
            context: context,
            title: 'Error',
            content: 'Terjadi kesalahan: $e',
            showCloseButton: false,
            closeButtonText: 'OK',
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
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
                  onChanged: (value) => _fullname = value,
                  validator: (value) => ValidationUtils.validateMinLength(
                      value, 4, 'Nama Lengkap'),
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
                  onChanged: (value) => _origin = value,
                  validator: (value) =>
                      ValidationUtils.validateMinLength(value, 4, 'Asal'),
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
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => _phone = value,
                  validator: ValidationUtils.validatePhone,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _dateController,
                  mouseCursor: SystemMouseCursors.click,
                  onTap: _selectDate,
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
                        color: Color(0xFFF75320),
                      ),
                    ),
                  ),
                  readOnly: true,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Tanggal Masuk tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        _handleSignUp(widget.email, widget.password),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF75320),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : const Text('Register'),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
