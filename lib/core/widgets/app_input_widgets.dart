// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:location_tracking/core/constants/app_size.dart';
// export 'app_country_picker_field.dart';

// class AppTextField extends StatelessWidget {
//   const AppTextField({
//     this.textInputAction,
//     required this.hint,
//     required this.label,
//     this.keyboardType,
//     this.controller,
//     super.key,
//     this.onChanged,
//     this.validator,
//     this.obscureText,
//     this.suffix,
//     this.autofocus,
//     this.focusNode,
//     this.readOnly = false,
//     this.maxLines,
//     this.minLines,
//     this.isRequired = true,
//     this.prefixIcon,
//     this.onTap,
//     this.inputFormatters,
//     this.autovalidateMode,
//   });

//   final void Function(String)? onChanged;
//   final String? Function(String?)? validator;
//   final TextInputAction? textInputAction;
//   final TextInputType? keyboardType;
//   final TextEditingController? controller;
//   final AutovalidateMode? autovalidateMode;
//   final bool? obscureText;
//   final Widget? suffix;
//   final String hint;
//   final String? label;
//   final bool? autofocus;
//   final bool readOnly;
//   final FocusNode? focusNode;
//   final int? maxLines;
//   final int? minLines;
//   final bool isRequired;
//   final IconData? prefixIcon;
//   final Function()? onTap;
//   final List<TextInputFormatter>? inputFormatters;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if ((label ?? '').isNotEmpty)
//           Row(
//             children: [
//               Text(
//                 label ?? '',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//               ),
//               if (isRequired == false)
//                 Text(
//                   ' (Optional)',
//                   style: TextStyle(color: theme.hintColor, fontSize: 10),
//                 ),
//             ],
//           ),
//         if ((label ?? '').isNotEmpty) SizedBox(height: 6),
//         TextFormField(
//           inputFormatters: inputFormatters,
//           onTap: onTap,
//           minLines: minLines ?? 1,
//           maxLines: maxLines ?? 1,
//           controller: controller,
//           keyboardType: keyboardType,
//           textInputAction: textInputAction,
//           textCapitalization: TextCapitalization.sentences,
//           focusNode: focusNode,
//           onChanged: onChanged,
//           autofocus: autofocus ?? false,
//           validator: validator,
//           autovalidateMode: autovalidateMode,
//           obscureText: obscureText ?? false,
//           readOnly: readOnly,
//           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//           decoration: InputDecoration(
//             errorMaxLines: 2,
//             prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
//             suffixIcon: suffix,
//             hintText: hint,
//             hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
//             prefixIconColor: Colors.grey.shade600,
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 14,
//             ),
//             filled: true,
//             fillColor: const Color(0xFFF9FAFB),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppSize.radiusMd),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppSize.radiusMd),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppSize.radiusMd),
//               borderSide: BorderSide(
//                 color: theme.colorScheme.primary,
//                 width: 1.8,
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppSize.radiusMd),
//               borderSide: const BorderSide(color: Colors.redAccent),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppSize.radiusMd),
//               borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
//             ),
//           ),
//           onTapOutside: (event) => FocusScope.of(context).unfocus(),
//         ),
//       ],
//     );
//   }
// }

// class AppPhoneNumberTextField extends StatelessWidget {
//   const AppPhoneNumberTextField({
//     super.key,
//     required this.hint,
//     required this.label,
//     this.controller,
//     this.initialValue,
//     this.onChanged,
//     this.onSaved,
//     this.validator,
//     this.textInputAction,
//     this.suffix,
//     this.autofocus,
//     this.focusNode,
//     this.readOnly = false,
//     this.enabled = true,
//     this.isRequired = true,
//     this.inputFormatters,
//     this.autovalidateMode = AutovalidateMode.onUserInteraction,
//     this.isMobileOnly = false,
//     this.countrySelectorNavigator =
//         const CountrySelectorNavigator.draggableBottomSheet(
//       initialChildSize: 0.75,
//       minChildSize: 0.45,
//       maxChildSize: 0.95,
//       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       backgroundColor: Colors.white,
//       showDialCode: true,
//       favorites: [
//         IsoCode.GB,
//         IsoCode.US,
//         IsoCode.IE,
//         IsoCode.CA,
//         IsoCode.AU,
//         IsoCode.BD,
//       ],
//       searchAutofocus: false,
//       flagSize: 24,
//       scrollPhysics: BouncingScrollPhysics(),
//       titleStyle: TextStyle(
//         fontSize: 14.5,
//         fontWeight: FontWeight.w600,
//         color: Colors.black87,
//       ),
//       subtitleStyle: TextStyle(
//         fontSize: 13,
//         fontWeight: FontWeight.w700,
//         color: Color(0xFF475569),
//       ),
//       searchBoxDecoration: InputDecoration(
//         hintText: 'Search country or code...',
//         hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
//         prefixIcon: Icon(
//           Icons.search_rounded,
//           color: Color(0xFF64748B),
//           size: 20,
//         ),
//         filled: true,
//         fillColor: Color(0xFFF8FAFC),
//         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//           borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//           borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//           borderSide: BorderSide(color: Color(0xFF0F172A), width: 1.6),
//         ),
//       ),
//     ),
//   });

//   final String hint;
//   final String? label;

//   /// Use PhoneController instead of TextEditingController.
//   final PhoneController? controller;

//   /// Only use this when controller is null.
//   final PhoneNumber? initialValue;

//   final ValueChanged<PhoneNumber>? onChanged;
//   final FormFieldSetter<PhoneNumber>? onSaved;
//   final FormFieldValidator<PhoneNumber>? validator;

//   final TextInputAction? textInputAction;
//   final Widget? suffix;
//   final bool? autofocus;
//   final bool readOnly;
//   final bool enabled;
//   final FocusNode? focusNode;
//   final bool isRequired;
//   final List<TextInputFormatter>? inputFormatters;
//   final AutovalidateMode autovalidateMode;
//   final bool isMobileOnly;
//   final CountrySelectorNavigator countrySelectorNavigator;

//   FormFieldValidator<PhoneNumber>? _defaultValidator(BuildContext context) {
//     final requiredValidator = PhoneValidator.required(
//       context,
//       errorText: 'Phone number is required',
//     );

//     final validValidator = isMobileOnly
//         ? PhoneValidator.validMobile(
//             context,
//             errorText: 'Enter a valid mobile number',
//           )
//         : PhoneValidator.valid(
//             context,
//             errorText: 'Enter a valid phone number',
//           );

//     return (PhoneNumber? value) {
//       final hasNoNumber = value == null || value.nsn.trim().isEmpty;

//       if (!isRequired && hasNoNumber) {
//         return null;
//       }

//       if (isRequired) {
//         final requiredError = requiredValidator(value);
//         if (requiredError != null) return requiredError;
//       }

//       return validValidator(value);
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if ((label ?? '').isNotEmpty)
//           Row(
//             children: [
//               Text(
//                 label ?? '',
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//               ),
//               if (isRequired == false)
//                 Text(
//                   ' (Optional)',
//                   style: TextStyle(color: theme.hintColor, fontSize: 10),
//                 )
//             ],
//           ),
//         if ((label ?? '').isNotEmpty) const SizedBox(height: 6),

//         PhoneFormField(
//           controller: controller,
//           initialValue: controller == null
//               ? initialValue ?? const PhoneNumber(isoCode: IsoCode.GB, nsn: '')
//               : null,
//           focusNode: focusNode,
//           autofocus: autofocus ?? false,
//           enabled: enabled,
//           readOnly: readOnly,
//           onChanged: onChanged,
//           onSaved: onSaved,
//           validator: validator ?? _defaultValidator(context),
//           autovalidateMode: autovalidateMode,
//           textInputAction: textInputAction,
//           keyboardType: TextInputType.phone,
//           autofillHints: const [AutofillHints.telephoneNumber],
//           inputFormatters: inputFormatters,
//           shouldLimitLengthByCountry: true,
//           countrySelectorNavigator: countrySelectorNavigator,
//           isCountrySelectionEnabled: true,
//           isCountryButtonPersistent: true,
//           countryButtonStyle: CountryButtonStyle(
//             showDialCode: true,
//             showIsoCode: false,
//             showFlag: true,
//             showDropdownIcon: true,
//             flagSize: 20,
//             padding: const EdgeInsets.only(left: 10, right: 6),
//             textStyle: const TextStyle(
//               fontSize: 14.5,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//             dropdownIconColor: Colors.grey.shade600,
//             borderRadius: BorderRadius.circular(AppSizes.inputRadius),
//           ),
//           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//           cursorColor: theme.colorScheme.primary,
//           decoration: InputDecoration(
//             errorMaxLines: 2,
//             hintText: hint,
//             hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 14,
//             ),
//             filled: true,
//             fillColor: const Color(0xFFF9FAFB),
//             suffixIcon: suffix != null
//                 ? Padding(
//                     padding: const EdgeInsets.only(right: 12.0),
//                     child: suffix,
//                   )
//                 : null,
//             suffixIconConstraints: const BoxConstraints(),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppSizes.inputRadius),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppSizes.inputRadius),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppSizes.inputRadius),
//               borderSide: BorderSide(
//                 color: theme.colorScheme.primary,
//                 width: 1.8,
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppSizes.inputRadius),
//               borderSide: const BorderSide(color: Colors.redAccent),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppSizes.inputRadius),
//               borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
//             ),
//             disabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppSizes.inputRadius),
//               borderSide: BorderSide(color: theme.disabledColor),
//             ),
//           ),
//           onTapOutside: (_) => FocusScope.of(context).unfocus(),
//         ),
//       ],
//     );
//   }
// }

// class SearchTextField extends StatelessWidget {
//   const SearchTextField({
//     this.textInputAction,
//     required this.hintText,
//     this.keyboardType,
//     required this.controller,
//     super.key,
//     this.onChanged,
//     this.validator,
//     this.obscureText,
//     this.suffixIcon,
//     this.autofocus,
//     this.focusNode,
//     this.readOnly = false,
//     this.maxLines,
//   });

//   final void Function(String)? onChanged;
//   final String? Function(String?)? validator;
//   final TextInputAction? textInputAction;
//   final TextInputType? keyboardType;
//   final TextEditingController controller;
//   final bool? obscureText;
//   final Widget? suffixIcon;
//   final String hintText;
//   final bool? autofocus;
//   final bool readOnly;
//   final FocusNode? focusNode;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         hintText: hintText,
//         prefixIcon: const Icon(Icons.search),
//         filled: true,
//         isDense: true,
//         border: OutlineInputBorder(
          
//           borderRadius: BorderRadius.circular(100),
         
//           borderSide: BorderSide.none,
        
//         ),
//       ),
//       onTapOutside: (event) => FocusScope.of(context).unfocus(),
//     );
//   }
// }

// //! TODO! : remove korte hobe
// class ForgotPasswordWidget extends StatelessWidget {
//   const ForgotPasswordWidget({
//     super.key,
//     required this.otpEmailController,
//     this.onTap,
//   });
//   final TextEditingController otpEmailController;
//   final void Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Forgot Password?",
//           style: Theme.of(
//             context,
//           ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//         ),
//         Text(
//           "Provide your registered email with ${AppValues.appName} to reset your password.",
//           style: Theme.of(
//             context,
//           ).textTheme.labelMedium?.copyWith(color: cs.outline),
//         ),
//         SizedBox(height: 16.0),

//         AppTextField(
//           label: 'Your email address',
//           hint: 'ex. m360ict@gmail.com',
//           controller: otpEmailController,
//         ),
//         SizedBox(height: 16.0 * 2),

//         SizedBox(
//           width: double.maxFinite,
//           child: OutlinedButton(onPressed: onTap, child: Text("Send OTP")),
//         ),
//       ],
//     );
//   }
// }

// //for app sheet input
// class AppSheetInput<T> extends FormField<T> {
//   final List<T> items;
//   final T? selectedItem;
//   final String Function(T) getLabel;
//   final String hint;
//   final String label;
//   final bool isSearchable;
//   final double? height;
//   final IconData? prefixIcon;

//   AppSheetInput({
//     super.key,
//     required this.items,
//     this.height,
//     required this.selectedItem,
//     super.initialValue,
//     required this.getLabel,
//     required void Function(T?) onChanged,
//     this.isSearchable = false,
//     required this.hint,
//     required this.label,
//     this.prefixIcon,
//     super.validator,
//     bool autovalidateMode = false,
//   }) : super(
//          autovalidateMode: autovalidateMode
//              ? AutovalidateMode.onUserInteraction
//              : AutovalidateMode.disabled,
//          builder: (FormFieldState<T> state) {
//            return _AppSheetContent<T>(
//              label: label,
//              items: items,
//              selectedItem: selectedItem,
//              getLabel: getLabel,
//              onChanged: (T? value) {
//                state.didChange(value);
//                onChanged(value);
//              },
//              hint: hint,
//              //  icon: icon,
//              isSearchable: isSearchable,
//              errorText: state.errorText,
//              state: state,
//              prefixIcon: prefixIcon,
//            );
//          },
//        );
// }

// class _AppSheetContent<T> extends StatefulWidget {
//   final List<T> items;
//   final T? selectedItem;
//   final String Function(T) getLabel;
//   final void Function(T?) onChanged;
//   final String hint;
//   final String label;
//   final bool isSearchable;
//   final String? errorText;
//   final FormFieldState<T> state;
//   final IconData? prefixIcon;

//   const _AppSheetContent({
//     required this.items,
//     required this.selectedItem,
//     required this.getLabel,
//     required this.onChanged,
//     required this.hint,
//     required this.label,
//     required this.isSearchable,
//     required this.errorText,
//     required this.state,
//     this.prefixIcon,
//   });

//   @override
//   State<_AppSheetContent<T>> createState() => _AppSheetContentState<T>();
// }

// class _AppSheetContentState<T> extends State<_AppSheetContent<T>> {
//   final TextEditingController _searchController = TextEditingController();
//   List<T> _filteredItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _filteredItems = widget.items;
//   }

//   @override
//   void didUpdateWidget(covariant _AppSheetContent<T> oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.items != widget.items) {
//       setState(() {
//         _filteredItems = widget.items;
//       });
//     }
//   }

//   void _showDropdown() {
//     AppBottomSheets.showModal(
//       context,
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
//           child: StatefulBuilder(
//                 builder: (BuildContext context, StateSetter setModalState) {
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       // Header
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 16.0),
//                         child: Center(
//                           child: Text(
//                             "Select ${widget.label}",
//                             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                   fontWeight: FontWeight.w800,
//                                   color: const Color(0xFF0F172A),
//                                   letterSpacing: -0.5,
//                                 ),
//                           ),
//                         ),
//                       ),
//                       if (widget.isSearchable) ...[
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 12.0),
//                           child: TextField(
//                             controller: _searchController,
//                             decoration: InputDecoration(
//                               fillColor: const Color(0xFFF8FAFC),
//                               filled: true,
//                               prefixIcon: const Icon(
//                                 Icons.search,
//                                 color: Color(0xFF64748B),
//                                 size: 20,
//                               ),
//                               hintText: "Search ${widget.label}...",
//                               hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                     color: const Color(0xFF94A3B8),
//                                   ),
//                               isDense: true,
//                               contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide.none,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             onChanged: (value) {
//                               setModalState(() {
//                                 _filteredItems = widget.items
//                                     .where(
//                                       (item) => widget
//                                           .getLabel(item)
//                                           .toLowerCase()
//                                           .contains(value.toLowerCase()),
//                                     )
//                                     .toList();
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                       _buildListView(),
//                       const SizedBox(height: 16),
//                     ],
//                   );
//                 },
//               ),
//         ),
//       ),
//     ).then((_) {
//       _searchController.clear();
//       setState(() {
//         _filteredItems = widget.items;
//       });
//     });
//   }

//   Widget _buildListView() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//       ),
//       child: ListView.separated(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: _filteredItems.length,
//         separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
//         itemBuilder: (context, index) {
//           final item = _filteredItems[index];
//           final isSelected = widget.selectedItem == item;
//           return InkWell(
//             onTap: () {
//               widget.onChanged(item);
//               Navigator.pop(context);
//               _searchController.clear();
//               setState(() {
//                 _filteredItems = widget.items;
//               });
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       widget.getLabel(item),
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: isSelected ? Theme.of(context).colorScheme.primary : const Color(0xFF334155),
//                         fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   if (isSelected)
//                     Icon(
//                       Icons.check_circle,
//                       color: Theme.of(context).colorScheme.primary,
//                       size: 20,
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         AppTextField(
//           onTap: _showDropdown,
//           suffix: Icon(Icons.arrow_drop_down, color: Colors.grey),
//           prefixIcon: widget.prefixIcon,
//           hint: widget.hint,
//           label: widget.label,
//           readOnly: true,
//           controller: TextEditingController(
//             text: widget.selectedItem != null
//                 ? widget.getLabel(widget.selectedItem as T)
//                 : '',
//           ),
//         ),
//         if (widget.errorText != null)
//           Padding(
//             padding: const EdgeInsets.only(left: 16, top: 4),
//             child: Text(
//               widget.errorText!,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.error,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// Future<DateTimeRange?> appDateRangePicker(
//   BuildContext context, {
//   DateTime? firstDate,
//   DateTime? lastDate,
//   DateTimeRange? initialDateRange,
// }) async {
//   final now = DateTime.now();
//   firstDate ??= now.subtract(const Duration(days: 360 * 90));
//   lastDate ??= now.add(const Duration(days: 365 * 20));

//   // Provide a default initial range if not set
//   initialDateRange ??= DateTimeRange(
//     start: now,
//     end: now.add(const Duration(days: 7)),
//   );

//   // Adjust initialDateRange to stay within bounds
//   if (initialDateRange.start.isBefore(firstDate)) {
//     initialDateRange = DateTimeRange(
//       start: firstDate,
//       end: firstDate.add(const Duration(days: 7)),
//     );
//   } else if (initialDateRange.end.isAfter(lastDate)) {
//     initialDateRange = DateTimeRange(
//       start: lastDate.subtract(const Duration(days: 7)),
//       end: lastDate,
//     );
//   }

//   final pickedRange = await showDateRangePicker(
//     context: context,
//     firstDate: firstDate,
//     lastDate: lastDate,
//     initialDateRange: initialDateRange,
//   );

//   // Only return if user selects a range; otherwise null
//   return pickedRange;
// }

// Future<DateTimeRange?> pickDateRange(BuildContext context) async {
//   final DateTime now = DateTime.now();
//   final DateTimeRange? picked = await showDateRangePicker(
//     context: context,
//     firstDate: DateTime(now.year - 5),
//     lastDate: DateTime(now.year + 5),
//     initialDateRange: DateTimeRange(
//       start: now,
//       end: now.add(const Duration(days: 7)),
//     ),
//     builder: (context, child) {
//       return child!;
//     },
//   );

//   return picked;
// }


