import 'package:flutter/material.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/core/widgets/custom_text_form_field.dart';
// এখানে আপনার custom_text_form_field.dart ফাইলটা ইম্পোর্ট করে নিবেন

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

  void _handleLogin() {
    // এই লাইনে ফর্মের সব ফিল্ড ঠিকঠাক ফিল-আপ করা হয়েছে কি না তা চেক করা হচ্ছে
    if (_formKey.currentState!.validate()) {
      debugPrint("Email: ${_emailController.text}");
      debugPrint("Password: ${_passwordController.text}");
      // TODO: API কল হবে এখানে
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Seeker Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSize.p24),
        child: Form(
          key: _formKey, // ফর্ম-কী অ্যাড করা হলো
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // কাস্টম উ,ইজেট (ইমেইল)
              CustomTextFormField(
                controller: _emailController,
                labelText: 'Email',
                hintText: "Enter your email",
                prefixIcon: Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
            AppSize.gapH16,
              // কাস্টম উইজেট (পাসওয়ার্ড)
              CustomTextFormField(
                controller: _passwordController,
                labelText: 'Password',
                hintText: "Enter your password",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      obscureText1 = !obscureText1;
                    });
                  }, 
                  icon: obscureText1? Icon(Icons.visibility_off): Icon(Icons.visibility)),
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
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSize.p16),
                ),
                child: Text(
                  'Login',
                  style: context.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
