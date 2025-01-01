import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaliko/models/user_model.dart';
import 'package:kaliko/services/firebase_services.dart';
import 'package:kaliko/utils/validation_rules.dart';
import 'package:kaliko/widgets/show_dialog.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;
  String _email = '';
  String _password = '';

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final userCredential = await _firebaseService.signIn(_email, _password);

        if (!mounted) return;

        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final user = UserModel(
            id: userCredential.user!.uid,
            email: userData['email'],
            fullname: userData['fullname'],
            origin: userData['origin'],
            phone: userData['phone'],
            startDate: (userData['startDate'] as Timestamp).toDate(),
            roomId: userData['roomId'],
            roleId: userData['roleId'],
            createdAt: (userData['createdAt'] as Timestamp).toDate(),
            updatedAt: (userData['updatedAt'] as Timestamp).toDate(),
          );

          if (user.roleId == 'admin') {
            Navigator.pushReplacementNamed(
              context,
              '/admin/dashboard',
              arguments: user,
            );
          } else {
            Navigator.pushReplacementNamed(
              context,
              '/user/dashboard',
              arguments: user,
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        await showCustomDialog(
          context: context,
          title: 'Error',
          content: _getErrorMessage(e.code),
          showCloseButton: false,
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email tidak terdaftar';
      case 'wrong-password':
        return 'Password salah';
      case 'invalid-email':
        return 'Email tidak valid';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi';
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
                  width: 175,
                  height: 175,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  onChanged: (value) => _email = value,
                  validator: (value) =>
                      ValidationUtils.validateMinLength(value, 5, 'Email'),
                  decoration: const InputDecoration(
                    labelText: 'Alamat Email',
                    labelStyle: TextStyle(color: Colors.black54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF75320)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF75320)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: _obscureText,
                  onChanged: (value) => _password = value,
                  validator: (value) =>
                      ValidationUtils.validateMinLength(value, 6, 'Password'),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF75320)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF75320)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignIn,
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
                    child: _isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? ',
                        style: TextStyle(color: Colors.black)),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/auth/sign-up');
                        },
                        child: const Text('Sign Up',
                            style: TextStyle(color: Color(0xFFF75320)))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
