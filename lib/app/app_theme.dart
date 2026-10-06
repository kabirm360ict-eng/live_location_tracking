import 'package:flutter/material.dart';
import 'package:location_tracking/core/constants/app_colors.dart';

class AppTheme {
  // ১. অ্যাপের কালারগুলো (Colors)
  // পুরো অ্যাপে আমরা মেইনলি যেই কালার ব্যবহার করবো, তা এখানে ডিফাইন করে রাখছি। 
  // এতে করে ফিউচারে কালার চেঞ্জ করতে চাইলে শুধু এখানে চেঞ্জ করলেই পুরো অ্যাপে চেঞ্জ হয়ে যাবে।
  // static const Color primaryColor = Colors.blueAccent;
  // static const Color backgroundColor = Colors.white;

  // ২. লাইট থিম (Light Theme)
  // অ্যাপের ডিফল্ট বা লাইট মোডের জন্য এই ThemeData আমরা ব্যবহার করবো।
  static ThemeData get lightTheme {
    return ThemeData(
      // scaffoldBackgroundColor: প্রতিটি স্ক্রিন বা পেজের ব্যাকগ্রাউন্ড কালার কী হবে সেটা ঠিক করে।
      scaffoldBackgroundColor: AppColors.backgroundColor,

      // colorScheme: অ্যাপের মেইন কালার স্কিম। বাটনের কালার, লোডিং আইকন ইত্যাদি এই seedColor থেকে জেনারেট হয়।
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary, // সরাসরি primary color সেট করে দেওয়া হলো
      ),
    );
  }
}