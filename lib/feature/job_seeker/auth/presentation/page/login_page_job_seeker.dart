import 'package:flutter/material.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/core/widgets/custom_text_form_field.dart';
import 'package:location_tracking/feature/job_seeker/auth/data/models/login_request_model_job.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/bloc/auth_job_bloc.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/page/job_seeker_home_page.dart';

class LoginPageJobSeeker extends StatefulWidget {
  const LoginPageJobSeeker({super.key});

  @override
  State<LoginPageJobSeeker> createState() => _LoginPageJobSeekerState();
}

class _LoginPageJobSeekerState extends State<LoginPageJobSeeker> {
  // ফর্ম ভ্যালিডেশন করার জন্য GlobalKey
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
      context.read<AuthJobBloc>().add(
        LoginEventJob(
          LoginRequestJobModel(
            email: _emailController.text,
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
        title: const Text('Job Seeker Login'),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthJobBloc, AuthJobState>(
        listener: (context, state) {
          if (state is LoginSuccessStateJob) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Successful!')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const JobSeekerHomePage(),
              ),
            );
          } else if (state is LoginFailedStateJob) {
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
                      if (value == null || value.isEmpty) {
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
                    onPressed: state is LoginLoadingStateJob
                        ? null
                        : () => _handleLogin(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSize.p16),
                    ),
                    child: state is LoginLoadingStateJob
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
