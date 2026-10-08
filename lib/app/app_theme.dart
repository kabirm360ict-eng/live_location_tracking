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
  static ThemeData lightTheme = ThemeData(
      // scaffoldBackgroundColor: প্রতিটি স্ক্রিন বা পেজের ব্যাকগ্রাউন্ড কালার কী হবে সেটা ঠিক করে।
      scaffoldBackgroundColor: Colors.white,

      // colorScheme: অ্যাপের মেইন কালার স্কিম। বাটনের কালার, লোডিং আইকন ইত্যাদি এই seedColor থেকে জেনারেট হয়।
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: AppColors.primary,
        primary: AppColors.primary, // সরাসরি primary color সেট করে দেওয়া হলো
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),

      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
      ),

      extensions: const [
        CustomThemeExtension(
          successColor: Colors.green, // লাইট মোডের জন্য সবুজ
          warningColor: Colors.orange, // লাইট মোডের জন্য কমলা
        ),
      ],
      
    );
  

    // ৩. ডার্ক থিম (Dark Theme)
  static ThemeData get darkTheme {
    return ThemeData(
      // ডার্ক মোডের জন্য পুরো অ্যাপের ব্যাকগ্রাউন্ড কালার 
      scaffoldBackgroundColor: AppColors.backgroundColor, // অথবা আপনার AppColors থেকে কোনো ডার্ক কালার

      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark, // ফ্লাটারকে বলে দিচ্ছি এটা ডার্ক থিম
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.backgroundColor,
        onSurface: Colors.white,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),

      // ডার্ক মোডে কাস্টম কালারগুলো কেমন হবে, সেটা এখানে বলে দিচ্ছি
      extensions: const [
        CustomThemeExtension(
          successColor: Colors.lightGreenAccent, // ডার্ক মোডে সবুজটা একটু হালকা/উজ্জ্বল হলে ভালো লাগে
          warningColor: Colors.deepOrangeAccent, // ডার্ক মোডের কমলা
        ),
      ],
    );
  }

}