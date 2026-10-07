import 'package:flutter/material.dart';

class AppSize {
  // -------------------------------------------
  // ১. Padding & Margin Sizes (প্যাডিং ও মার্জিন)
  // -------------------------------------------
  static const double p4 = 4.0;
  static const double p8 = 8.0;   // Small
  static const double p16 = 16.0; // Medium (Standard)
  static const double p24 = 24.0; // Large
  static const double p32 = 32.0; // Extra Large

  // -------------------------------------------
  // ২. Border Radius (বর্ডার রেডিয়াস)
  // -------------------------------------------
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 16.0;
  static const double radiusCircular = 100.0; // পুরোপুরি গোল করার জন্য

  // -------------------------------------------
  // ৩. Icon Sizes (আইকনের সাইজ)
  // -------------------------------------------
  static const double iconSm = 16.0;
  static const double iconMd = 24.0; // ডিফল্ট আইকন সাইজ
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // -------------------------------------------
  // ৪. UI Component Sizes (উইজেটের মাপ)
  // -------------------------------------------
  static const double buttonHeight = 48.0; // স্ট্যান্ডার্ড বাটন হাইট
  static const double inputFieldHeight = 56.0; // টেক্সট ফিল্ডের হাইট

  // -------------------------------------------
  // ৫. Spacing Widgets (সহজে গ্যাপ দেওয়ার জন্য SizedBox)
  // -------------------------------------------
  // এগুলো ব্যবহার করলে আপনাকে বারবার SizedBox(height: 16) লিখতে হবে না।
  // শুধু AppSize.gapH16 কল করলেই হবে!
  static const gapW8 = SizedBox(width: p8);
  static const gapW16 = SizedBox(width: p16);
  
  static const gapH8 = SizedBox(height: p8);
  static const gapH16 = SizedBox(height: p16);
  static const gapH24 = SizedBox(height: p24);
  static const gapH32 = SizedBox(height: p32);
}


// ------------------------------------------------
// AppSize ক্লাস শেষ হওয়ার পর, একদম নিচে এক্সটেনশনটা পেস্ট করে দিন
// ------------------------------------------------
extension TextThemeExtension on BuildContext {
  // Headlines (বড় টাইটেল)
  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge; // 57.0
  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium; // 45.0
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall; // 36.0
  
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge; // 32.0
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium; // 28.0
  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall; // 24.0
  // Titles (অ্যাপবার বা সেকশন হেডিং)
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge; // 22.0
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium; // 16.0 
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall; // 14.0
  // Body (প্যারাগ্রাফ বা সাধারণ লেখা)
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge; // 16.0
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium; // 14.0 
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall; // 12.0
  // Labels (বাটনের টেক্সট)
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge; // 14.0 
  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium; // 12.0
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall; // 11.0
}
