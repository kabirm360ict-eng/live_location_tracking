import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking/core/constants/app_urls.dart';
import 'package:location_tracking/feature/job_seeker/location/presentation/service/places_service.dart';

class LocationSearchResult {
  final LatLng coordinates;
  final String title;
  final String? subtitle;

  LocationSearchResult({
    required this.coordinates,
    required this.title,
    this.subtitle,
  });
}

class LocationSearchModal extends StatefulWidget {
  const LocationSearchModal({super.key});

  static Future<LocationSearchResult?> show(BuildContext context) {
    return showModalBottomSheet<LocationSearchResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LocationSearchModal(),
    );
  }

  @override
  State<LocationSearchModal> createState() => _LocationSearchModalState();
}

class _LocationSearchModalState extends State<LocationSearchModal> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _debounce;
  late final PlacesService _placesService;

  @override
  void initState() {
    super.initState();
    _placesService = PlacesService(AppUrls.placeApi);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
        _errorMessage = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        if (AppUrls.placeApi.isNotEmpty) {
          final results = await _placesService.getSuggestions(query.trim());
          if (mounted) {
            setState(() {
              _suggestions = results;
              _isLoading = false;
            });
          }
        } else {
          // Fallback to geocoding if place API key is empty
          await _fallbackGeocodeSearch(query.trim());
        }
      } catch (e) {
        // Fallback to geocoding package
        await _fallbackGeocodeSearch(query.trim());
      }
    });
  }

  Future<void> _fallbackGeocodeSearch(String query) async {
    try {
      final locations = await Geocoding().locationFromAddress(query);
      if (mounted) {
        setState(() {
          _suggestions = locations.take(5).map((loc) {
            return {
              "description": query,
              "place_id": null,
              "lat": loc.latitude,
              "lng": loc.longitude,
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _isLoading = false;
          _errorMessage = 'No results found for "$query"';
        });
      }
    }
  }

  Future<void> _onSelectSuggestion(Map<String, dynamic> item) async {
    setState(() => _isLoading = true);

    try {
      final placeId = item['place_id'] as String?;
      final description = item['description'] as String? ?? 'Destination';

      if (placeId != null && placeId.isNotEmpty) {
        final details = await _placesService.getPlaceDetails(placeId);
        if (details.latitude != null && details.longitude != null) {
          if (mounted) {
            Navigator.pop(
              context,
              LocationSearchResult(
                coordinates: LatLng(details.latitude!, details.longitude!),
                title: description,
                subtitle: [details.city, details.country]
                    .where((e) => e != null && e.isNotEmpty)
                    .join(', '),
              ),
            );
          }
          return;
        }
      }

      // If lat/lng was pre-stored
      if (item['lat'] != null && item['lng'] != null) {
        if (mounted) {
          Navigator.pop(
            context,
            LocationSearchResult(
              coordinates: LatLng(item['lat'] as double, item['lng'] as double),
              title: description,
            ),
          );
        }
        return;
      }

      // Try geocoding the description
      final locations = await Geocoding().locationFromAddress(description);
      if (locations.isNotEmpty && mounted) {
        Navigator.pop(
          context,
          LocationSearchResult(
            coordinates: LatLng(
              locations.first.latitude,
              locations.first.longitude,
            ),
            title: description,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load location details: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Title & close
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  'Search Destination',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // Search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _onSearchChanged(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter place, city or address...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.location_off_outlined,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else if (_suggestions.isEmpty &&
              _searchController.text.trim().isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 60,
                      color: Colors.blue.shade200,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Type any location to see suggestions',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _suggestions.length,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey.shade200, height: 1),
                itemBuilder: (context, index) {
                  final item = _suggestions[index];
                  final desc = item['description'] as String? ?? '';
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      desc,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () => _onSelectSuggestion(item),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
