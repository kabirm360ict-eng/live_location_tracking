import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import '../utilities/app_countries.dart';

/// A modern, UK industry-standard Country Picker Form Field and Bottom Sheet Selector.
class AppCountryPickerField extends StatefulWidget {
  const AppCountryPickerField({
    super.key,
    this.label = 'Country',
    this.hint = 'Select country',
    this.controller,
    this.selectedCountry,
    this.onChanged,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.isRequired = true,
    this.enabled = true,
    this.prefixIcon,
  });

  final String? label;
  final String hint;
  final TextEditingController? controller;
  final AppCountry? selectedCountry;
  final ValueChanged<AppCountry>? onChanged;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;
  final bool isRequired;
  final bool enabled;
  final IconData? prefixIcon;

  @override
  State<AppCountryPickerField> createState() => _AppCountryPickerFieldState();
}

class _AppCountryPickerFieldState extends State<AppCountryPickerField> {
  AppCountry? _currentCountry;

  @override
  void initState() {
    super.initState();
    _resolveInitialCountry();
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant AppCountryPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
      _resolveInitialCountry();
    } else if (oldWidget.selectedCountry != widget.selectedCountry) {
      setState(() {
        _currentCountry = widget.selectedCountry;
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.controller != null) {
      final text = widget.controller!.text.trim();
      final found = AppCountries.findByNameOrCode(text);
      if (found != _currentCountry) {
        setState(() {
          _currentCountry = found;
        });
      }
    }
  }

  void _resolveInitialCountry() {
    if (widget.selectedCountry != null) {
      _currentCountry = widget.selectedCountry;
      if (widget.controller != null &&
          widget.controller!.text.trim().isEmpty) {
        widget.controller!.text = widget.selectedCountry!.name;
      }
    } else if (widget.controller != null &&
        widget.controller!.text.trim().isNotEmpty) {
      _currentCountry =
          AppCountries.findByNameOrCode(widget.controller!.text.trim());
    } else {
      // Default to United Kingdom for UK-based apps if not set
      _currentCountry = AppCountries.findByName('United Kingdom');
      if (widget.controller != null &&
          widget.controller!.text.trim().isEmpty &&
          _currentCountry != null) {
        widget.controller!.text = _currentCountry!.name;
      }
    }
  }

  Future<void> _openCountryPicker(FormFieldState<String> state) async {
    if (!widget.enabled) return;
    HapticFeedback.selectionClick();

    final selected = await showModalBottomSheet<AppCountry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) => _AppCountryPickerSheet(
        selectedCountry: _currentCountry,
      ),
    );

    if (selected != null) {
      setState(() {
        _currentCountry = selected;
      });
      if (widget.controller != null) {
        widget.controller!.text = selected.name;
      }
      state.didChange(selected.name);
      widget.onChanged?.call(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<String>(
      initialValue: _currentCountry?.name ?? widget.controller?.text,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator ??
          (val) {
            if (widget.isRequired && (val == null || val.trim().isEmpty)) {
              return 'Please select a country';
            }
            return null;
          },
      builder: (FormFieldState<String> state) {
        final hasError = state.hasError;
        final isSelected = _currentCountry != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            if ((widget.label ?? '').isNotEmpty) ...[
              Row(
                children: [
                  Text(
                    widget.label!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  if (!widget.isRequired)
                    Text(
                      ' (Optional)',
                      style: TextStyle(
                        color: theme.hintColor,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
            ],

            // Input Container
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.enabled ? () => _openCountryPicker(state) : null,
                borderRadius: BorderRadius.circular(AppSize.radiusMd),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: widget.enabled
                        ? const Color(0xFFF9FAFB)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(AppSize.radiusMd),
                    border: Border.all(
                      color: hasError
                          ? Colors.redAccent
                          : isSelected
                              ? Colors.grey.shade300
                              : Colors.grey.shade300,
                      width: hasError ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Flag / Prefix Icon
                      if (isSelected) ...[
                        Container(
                          width: 34,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _currentCountry!.flagEmoji,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ] else ...[
                        Icon(
                          widget.prefixIcon ?? Icons.public_outlined,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 10),
                      ],

                      // Country Name Text
                      Expanded(
                        child: Text(
                          isSelected ? _currentCountry!.name : widget.hint,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? Colors.black87
                                : Colors.grey.shade400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // ISO Code Pill Badge (when selected)
                      if (isSelected) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.5,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _currentCountry!.code,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],

                      // Dropdown Icon
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade600,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Error Text
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// UK INDUSTRY STANDARD COUNTRY PICKER BOTTOM SHEET
// ============================================================================

class _AppCountryPickerSheet extends StatefulWidget {
  const _AppCountryPickerSheet({
    this.selectedCountry,
  });

  final AppCountry? selectedCountry;

  @override
  State<_AppCountryPickerSheet> createState() => _AppCountryPickerSheetState();
}

class _AppCountryPickerSheetState extends State<_AppCountryPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<AppCountry> _filteredList = AppCountries.all;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredList = AppCountries.all;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      _searchQuery = query;
      _filteredList = AppCountries.search(query);
    });
  }

  void _onSelect(AppCountry country) {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop(country);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final sheetHeight = MediaQuery.of(context).size.height * 0.88;

    return Container(
      height: sheetHeight,
      margin: EdgeInsets.only(bottom: keyboardHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Country",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Choose your country of residence or nationality",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Close button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _searchQuery.isNotEmpty
                      ? primaryColor.withValues(alpha: 0.5)
                      : Colors.transparent,
                  width: 1.2,
                ),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: "Search country by name or code...",
                  hintStyle: TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey.shade500,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.cancel_rounded,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Content List
          Expanded(
            child: _filteredList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: _calculateItemCount(),
                    itemBuilder: (context, index) {
                      // If search is active, directly render filtered countries
                      if (_searchQuery.isNotEmpty) {
                        return _buildCountryTile(_filteredList[index]);
                      }

                      // When search is empty:
                      // Index 0: Recommended Section Header
                      if (index == 0) {
                        return _buildSectionHeader(
                          title: "RECOMMENDED / POPULAR",
                          icon: Icons.star_rounded,
                          iconColor: const Color(0xFFEAB308),
                        );
                      }

                      // Index 1..popular.length: Popular country cards
                      final popularCount = AppCountries.popular.length;
                      if (index <= popularCount) {
                        final country = AppCountries.popular[index - 1];
                        return _buildPopularCard(country);
                      }

                      // Index popularCount + 1: All Countries Header
                      if (index == popularCount + 1) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 4),
                          child: _buildSectionHeader(
                            title: "ALL COUNTRIES",
                            countBadge: "${AppCountries.all.length}",
                          ),
                        );
                      }

                      // Index >= popularCount + 2: All countries list
                      final countryIndex = index - (popularCount + 2);
                      return _buildCountryTile(AppCountries.all[countryIndex]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  int _calculateItemCount() {
    if (_searchQuery.isNotEmpty) {
      return _filteredList.length;
    }
    // 1 (popular header) + popular.length + 1 (all countries header) + all.length
    return 1 + AppCountries.popular.length + 1 + AppCountries.all.length;
  }

  Widget _buildSectionHeader({
    required String title,
    IconData? icon,
    Color? iconColor,
    String? countBadge,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: iconColor ?? Colors.grey.shade600),
            const SizedBox(width: 6),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade600,
              letterSpacing: 0.8,
            ),
          ),
          if (countBadge != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                countBadge,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPopularCard(AppCountry country) {
    final isSelected = widget.selectedCountry?.code == country.code;
    final isUk = country.code == 'GB';
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3.5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onSelect(country),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor.withValues(alpha: 0.09)
                  : isUk
                      ? const Color(0xFFF8FAFC)
                      : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? primaryColor
                    : isUk
                        ? primaryColor.withValues(alpha: 0.35)
                        : Colors.grey.shade200,
                width: isSelected || isUk ? 1.3 : 1.0,
              ),
            ),
            child: Row(
              children: [
                // Flag Container
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    country.flagEmoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 12),

                // Name & Tag
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          country.name,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: isSelected || isUk
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUk) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Default",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Code Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    country.code,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Selection Checkmark
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: primaryColor,
                    size: 20,
                  )
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryTile(AppCountry country) {
    final isSelected = widget.selectedCountry?.code == country.code;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onSelect(country),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Flag Container
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  country.flagEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),

              // Country Name
              Expanded(
                child: Text(
                  country.name,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Country Code
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.5,
                  vertical: 2.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  country.code,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              // Checkmark if selected
              if (isSelected) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle_rounded,
                  color: primaryColor,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 28,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "No country found",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "No results matching '$_searchQuery'. Try checking for typos or searching by 2-letter ISO code.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade600,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () => _searchController.clear(),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text("Clear search"),
            ),
          ],
        ),
      ),
    );
  }
}
