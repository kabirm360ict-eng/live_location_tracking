import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/core/model/full_address.dart';
import 'package:location_tracking/feature/job_seeker/location/data/model/prediction_list_response_model.dart';
import 'package:location_tracking/feature/job_seeker/location/presentation/bloc/location_bloc.dart';
import 'package:location_tracking/feature/job_seeker/location/presentation/widget/location_search_empty_view.dart';
import 'package:location_tracking/feature/job_seeker/location/presentation/widget/location_search_shimmer.dart';
import 'package:location_tracking/feature/job_seeker/location/presentation/widget/prediction_tile.dart';

// import '../../../../app/route/app_routes.dart';
// import '../../../../core/models/full_address.dart';
// import '../../../../core/widgets/app_show_message.dart';
// import '../../data/models/prediction_list_response_model.dart';
// import '../bloc/location_bloc.dart';
// import '../widgets/location_search_empty_view.dart';
// import '../widgets/location_search_shimmer.dart';
// import '../widgets/prediction_tile.dart';

/// UK & Global Industry Standard Google Places Autocomplete Page.
///
/// Features:
/// - Responsive 350ms debounced live search with micro progress spinner.
/// - Shimmer skeleton placeholder list for smooth 60fps UX.
/// - Quick action pills for "Pick on Map" and "Manual / Custom Address".
/// - Structured [PredictionTile] with bold primary street and subtle locality.
/// - Full exception handling and tactile loading feedback on place selection.
class GoogleAutoCompleteAddressPage extends StatefulWidget {
  const GoogleAutoCompleteAddressPage({
    super.key,
    required this.address,
  });

  /// Optional initial query address.
  final String address;

  @override
  State<GoogleAutoCompleteAddressPage> createState() =>
      _GoogleAutoCompleteAddressPageState();
}

class _GoogleAutoCompleteAddressPageState
    extends State<GoogleAutoCompleteAddressPage> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  List<PredictionListResponseModel> _items = [];
  Timer? _debounce;
  String? _selectedPlaceId;
  String? _errorMessage;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    final initialQuery = widget.address.replaceAll('#', '').trim();
    _controller = TextEditingController(text: initialQuery);
    _focusNode = FocusNode();

    if (initialQuery.isNotEmpty) {
      context.read<LocationBloc>().add(
            GetSuggestionListEvent(input: initialQuery),
          );
      _isSearching = true;
    }

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    _debounce?.cancel();

    final query = val.trim();
    if (query.isEmpty) {
      setState(() {
        _items = [];
        _errorMessage = null;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        context.read<LocationBloc>().add(
              GetSuggestionListEvent(input: query),
            );
      }
    });
  }

  Future<void> _openCustomAddressPage() async {
    final result =
        await Navigator.pushNamed(context, AppRoutes.customAddressPage);
    if (result != null && result is FullAddress && mounted) {
      Navigator.pop(context, result);
    }
  }

  void _onPredictionTapped(PredictionListResponseModel prediction) {
    FocusScope.of(context).unfocus();
    final placeId = '${prediction.placeId}';
    setState(() => _selectedPlaceId = placeId);

    context.read<LocationBloc>().add(
          GetPlaceDetailsEvent(
            placeId: placeId,
            description: prediction.description ?? '',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(primaryColor),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: _onLocationState,
        builder: (context, state) {
          final isLoadingSuggestions =
              state is LocationSuggestionsLoadingState;
          final isFetchingDetails =
              state is LocationPlaceDetailsLoadingState;

          return Column(
            children: [
              // ── SEARCH BAR & SHORTCUT CHIPS ──
              _buildSearchSection(
                primaryColor: primaryColor,
                isLoading: isLoadingSuggestions,
              ),

              const Divider(height: 1, color: Color(0xFFF3F4F6)),

              // ── SUGGESTIONS LIST / STATES ──
              Expanded(
                child: Stack(
                  children: [
                    _buildContent(
                      state: state,
                      primaryColor: primaryColor,
                      isLoadingSuggestions: isLoadingSuggestions,
                    ),

                    // Loading overlay when fetching selected place coordinates
                    if (isFetchingDetails)
                      _buildPlaceDetailsLoadingOverlay(primaryColor),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Color primaryColor) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200, width: 1.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 16,
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Find Location',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              fontFamily: 'Libertinus Sans',
            ),
          ),
          Text(
            'Search places, streets, or postcodes',
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection({
    required Color primaryColor,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search Input Box
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Libertinus Sans',
              ),
              decoration: InputDecoration(
                hintText: 'Enter street, city, or postcode...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: primaryColor,
                  size: 22,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading || _isSearching)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        splashRadius: 18,
                        icon: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: Colors.black54,
                          ),
                        ),
                        onPressed: () {
                          _controller.clear();
                          _onSearchChanged('');
                        },
                      ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          const SizedBox(height: 10),

          // Shortcut Pills (Quick location actions)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Set Pin on Map Pill
                _buildActionChip(
                  icon: Icons.map_outlined,
                  label: 'Pick on Map',
                  primaryColor: primaryColor,
                  onTap: () => Navigator.pop(context),
                ),

                const SizedBox(width: 8),

                // Manual Custom Address Pill
                _buildActionChip(
                  icon: Icons.edit_note_rounded,
                  label: 'Custom Address',
                  primaryColor: primaryColor,
                  onTap: _openCustomAddressPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: primaryColor),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required LocationState state,
    required Color primaryColor,
    required bool isLoadingSuggestions,
  }) {
    final query = _controller.text.trim();

    // 1. Loading suggestions state when items list is empty
    if (isLoadingSuggestions && _items.isEmpty) {
      return const LocationSearchShimmer(itemCount: 6);
    }

    // 2. Error state
    if (_errorMessage != null && _errorMessage!.isNotEmpty) {
      return LocationSearchEmptyView(
        query: query,
        errorMessage: _errorMessage,
        onRetry: () => _onSearchChanged(query),
        onPickOnMap: () => Navigator.pop(context),
        onCustomAddress: _openCustomAddressPage,
      );
    }

    // 3. Initial Empty State (before typing)
    if (query.isEmpty) {
      return LocationSearchEmptyView(
        query: '',
        onPickOnMap: () => Navigator.pop(context),
        onCustomAddress: _openCustomAddressPage,
      );
    }

    // 4. No Results Found State
    if (_items.isEmpty) {
      return LocationSearchEmptyView(
        query: query,
        onPickOnMap: () => Navigator.pop(context),
        onCustomAddress: _openCustomAddressPage,
      );
    }

    // 5. Populated Suggestions List
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: _items.length,
      separatorBuilder: (_, __) => Divider(
        color: Colors.grey.shade100,
        height: 1,
        indent: 70,
        endIndent: 16,
      ),
      itemBuilder: (context, index) {
        final prediction = _items[index];
        final isTileLoading =
            _selectedPlaceId != null && '${prediction.placeId}' == _selectedPlaceId;

        return PredictionTile(
          prediction: prediction,
          isLoading: isTileLoading,
          onTap: () => _onPredictionTapped(prediction),
        );
      },
    );
  }

  /// Glassmorphic loading overlay when place coordinates are being resolved
  Widget _buildPlaceDetailsLoadingOverlay(Color primaryColor) {
    return Container(
      color: Colors.black.withValues(alpha: 0.15),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'Fetching location details...',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _onLocationState(BuildContext context, LocationState state) {
    if (state is LocationSuggestionsSuccessState) {
      setState(() {
        _items = state.suggestions;
        _isSearching = false;
        _errorMessage = null;
      });
    } else if (state is LocationSuggestionsFailureState) {
      setState(() {
        _isSearching = false;
        _errorMessage = state.message;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    } else if (state is LocationPlaceDetailsSuccessState) {
      setState(() => _selectedPlaceId = null);
      Navigator.of(context).pop(state.placeDetails);
    } else if (state is LocationPlaceDetailsFailureState) {
      setState(() => _selectedPlaceId = null);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }
}
