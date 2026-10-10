import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/core/widgets/custom_text_form_field.dart';
import '../../data/model/login_request_hotelier_model.dart';
import '../bloc/hotelier_auth_bloc.dart';

class HotelierLoginPage extends StatefulWidget {
  const HotelierLoginPage({super.key});

  @override
  State<HotelierLoginPage> createState() => _HotelierLoginPageState();
}

class _HotelierLoginPageState extends State<HotelierLoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText1 = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      debugPrint("Email: ${_emailController.text}");
      debugPrint("Password: ${_passwordController.text}");
      context.read<HotelierAuthBloc>().add(
        HotelierLoginEvent(
          LoginRequestHotelierModel(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotelier Login'),
        centerTitle: true,
      ),
      body: BlocConsumer<HotelierAuthBloc, HotelierAuthState>(
        listener: (context, state) {
          if (state is HotelierLoginSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Successful!')),
            );
            Navigator.pushReplacementNamed(context, AppRoutes.hotelierHome);
          } else if (state is HotelierSendOtpSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP sent for 2FA verification')),
            );
          } else if (state is HotelierLoginFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(AppSize.p24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: "Enter your email",
                    prefixIcon: const Icon(Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  AppSize.gapH16,
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: "Enter your password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText1 = !obscureText1;
                        });
                      },
                      icon: obscureText1
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                    obscureText: obscureText1,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  AppSize.gapH32,
                  ElevatedButton(
                    onPressed: state is HotelierLoginLoadingState
                        ? null
                        : () => _handleLogin(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSize.p16,
                      ),
                    ),
                    child: state is HotelierLoginLoadingState
                        ? const CircularProgressIndicator()
                        : Text(
                            'Login',
                            style: context.titleMedium,
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
