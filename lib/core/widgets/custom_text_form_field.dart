import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_tracking/core/constants/app_size.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller; // অপশনাল রাখাও যায়
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon; // IconData এর বদলে Widget, যাতে IconButton দেওয়া যায়
  final Widget? suffixIcon; 
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    this.controller, // Required না করে অপশনাল করলাম
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false, // ডিফল্ট false
    this.readOnly = false,    // ডিফল্ট false
    this.maxLines = 1,        // ডিফল্ট 1
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSize.radiusMd)),
        ),
        // ফোকাস করলে বর্ডারের কালার কেমন হবে ইত্যাদি থিম থেকে নিবে বা এখানে সেট করা যায়
      ),
    );
  }
}
