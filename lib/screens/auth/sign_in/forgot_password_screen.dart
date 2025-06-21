import 'package:flutter/material.dart';
import 'package:kaliko/config/themes/color_palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _isLoading = false;
  String? _feedbackMessage;

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _feedbackMessage = null;
    });
    try {
      // Cek ke Firestore apakah email terdaftar
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _email)
          .limit(1)
          .get();
      if (query.docs.isEmpty) {
        setState(() {
          _feedbackMessage = 'Email tidak terdaftar.';
        });
      } else {
        // Kirim reset password
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        setState(() {
          _feedbackMessage = 'Link reset password telah dikirim ke email.';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _feedbackMessage = _getErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        _feedbackMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email tidak terdaftar.';
      case 'invalid-email':
        return 'Email tidak valid.';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundColor,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: ColorPalette.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  'assets/icons/kaliko-app.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 30),
                Text(
                  'Enter your email to receive a password reset link.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ColorPalette.textSecondaryColor,
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => _email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorPalette.primaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorPalette.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleForgotPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      textStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : const Text('Send Reset Link'),
                  ),
                ),
                if (_feedbackMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    _feedbackMessage!,
                    style: const TextStyle(
                      color: ColorPalette.primaryColor,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
