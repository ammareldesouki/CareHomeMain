import 'package:carehome/features/psw/application/presentation/manager/psw_application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../psw/offer/domain/entities/offer_entity.dart';
import '../../../psw/offer/presentation/manager/offers_bloc.dart';
import '../../../psw/offer/presentation/pages/offer_details.dart';
import '../widgets/offer_card_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late PageController _pageController;
  GoogleMapController? _mapController;

  // null = still locating, non-null = ready
  LatLng? _myPosition;
  bool _locationDenied = false;

  // Markers cached in state — survive tab switches
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _locate();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _locate() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() => _locationDenied = true);
        return;
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        setState(() => _locationDenied = true);
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final me = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _myPosition = me;
        _markers['__me__'] = Marker(
          markerId: const MarkerId('__me__'),
          position: me,
          infoWindow: const InfoWindow(title: 'You'),
        );
      });
    } catch (_) {
      // Use a default position so the map still renders
      setState(() => _myPosition = const LatLng(0, 0));
    }
  }

  void _addOfferMarker(OfferDetailEntity detail, int index) {
    if (_markers.containsKey(detail.id)) {
      // Already exists — just move camera
      _animateTo(LatLng(detail.latitude, detail.longitude));
      return;
    }
    final pos = LatLng(detail.latitude, detail.longitude);
    setState(() {
      _markers[detail.id] = Marker(
        markerId: MarkerId(detail.id),
        position: pos,
        infoWindow: InfoWindow(title: detail.title),
        onTap: () =>
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
        ),
      );
    });
    _animateTo(pos);
  }

  void _animateTo(LatLng pos) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 15));
  }

  void _openSheet(BuildContext ctx, String offerId, int index) {
    // Dispatch detail fetch BEFORE opening sheet
    ctx.read<OffersBloc>().add(FetchOfferDetailEvent(offerId));

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: ctx.read<OffersBloc>()),
              BlocProvider.value(value: ctx.read<PswApplicationBloc>()),
            ],
            child: const OfferDetailSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // ── Location denied ────────────────────────────────────────────────────
    if (_locationDenied) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_off, size: 56, color: Colors.grey),
              SizedBox(height: 12),
              Text('Location permission denied.\nPlease enable it in settings.',
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    // ── Still locating ─────────────────────────────────────────────────────
    if (_myPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // ── Map ready ─────────────────────────────────────────────────────────
    return BlocBuilder<OffersBloc, OffersState>(
      // CRITICAL: rebuild ONLY when the offer list changes, NEVER on detail
      buildWhen: (prev, curr) =>
      prev.offers != curr.offers ||
          prev.listLoading != curr.listLoading,
      builder: (context, state) {
        final offers = state.offers;

        return Stack(
          children: [
            // ── Google Map ───────────────────────────────────────────────
            GoogleMap(
              initialCameraPosition:
              CameraPosition(target: _myPosition!, zoom: 14),
              markers: Set.of(_markers.values),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (c) => _mapController = c,
            ),

            // ── Cards carousel ───────────────────────────────────────────
            if (offers.isNotEmpty)
              Positioned(
                bottom: 40, // above bottom nav
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 140,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: offers.length,
                    onPageChanged: (index) {
                      final offer = offers[index];
                      final marker = _markers[offer.id];
                      if (marker != null) {
                        _animateTo(marker.position);
                      } else {
                        // Need lat/lng — fetch detail to get it
                        context
                            .read<OffersBloc>()
                            .add(FetchOfferDetailEvent(offer.id));
                      }
                    },
                    itemBuilder: (ctx, index) {
                      final offer = offers[index];
                      return BlocListener<OffersBloc, OffersState>(
                        // Only fire when THIS offer's detail arrives
                        listenWhen: (prev, curr) =>
                        curr.detail?.id == offer.id &&
                            curr.detail != prev.detail,
                        listener: (_, s) {
                          if (s.detail != null) {
                            _addOfferMarker(s.detail!, index);
                          }
                        },
                        child: OfferCardMap(
                          title: offer.title,
                          subtitle: offer.address,
                          hourlyRate: offer.hourlyRate,
                          onTap: () => _openSheet(ctx, offer.id, index),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // ── Empty ────────────────────────────────────────────────────
            if (offers.isEmpty && !state.listLoading)
              Positioned(
                bottom: 10,
                left: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(blurRadius: 8, color: Colors.black12)
                    ],
                  ),
                  child: const Text('No offers available nearby',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)),
                ),
              ),

            // ── Loading spinner (refresh) ────────────────────────────────
            if (state.listLoading)
              const Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}