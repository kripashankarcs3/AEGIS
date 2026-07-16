import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../constants/aegis_animations.dart';
import '../widgets/sos_banner.dart';
import '../providers/mesh_provider.dart';

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> with TickerProviderStateMixin {
  int _selectedCategory = 0;
  int _selectedPriority = 2;
  late AnimationController _bgPulse;
  late Animation<double> _bgAnim;
  final TextEditingController _detailsController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Medical', 'icon': Icons.medical_services_rounded, 'color': AegisColors.sosRed},
    {'label': 'Fire', 'icon': Icons.local_fire_department_rounded, 'color': AegisColors.orange},
    {'label': 'Water', 'icon': Icons.water_drop_rounded, 'color': AegisColors.electricCyan},
    {'label': 'Trapped', 'icon': Icons.lock_rounded, 'color': AegisColors.amber},
    {'label': 'Other', 'icon': Icons.more_horiz_rounded, 'color': AegisColors.violet},
  ];

  @override
  void initState() {
    super.initState();
    _bgPulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _bgAnim = Tween<double>(begin: 0.3, end: 0.6).animate(CurvedAnimation(parent: _bgPulse, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _bgPulse.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _onHoldComplete() async {
    final handler = ref.read(meshProvider.notifier).sosHandler;
    if (!handler.canSend) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please wait before sending another SOS')),
        );
      }
      return;
    }

    double lat = 0.0, lon = 0.0;
    try {
      final pos = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 3),
      );
      lat = pos.latitude;
      lon = pos.longitude;
    } catch (_) {}

    final message = _detailsController.text.trim();
    if (message.isEmpty) {
      handler.sendSOS(latitude: lat, longitude: lon);
    } else {
      handler.sendSOS(latitude: lat, longitude: lon, message: message);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SOS broadcast sent to mesh network')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _bgAnim,
        builder: (_, __) {
          return Container(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AegisColors.sosRed.withOpacity(_bgAnim.value * 0.04), Colors.transparent])),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  StaggeredFadeIn(index: 0, child: _header()),
                  SizedBox(height: 20),
                  StaggeredFadeIn(index: 1, child: SosBroadcastCard(onHoldComplete: _onHoldComplete)),
                  SizedBox(height: 32),
                  StaggeredFadeIn(index: 2, child: _categorySection()),
                  SizedBox(height: 28),
                  StaggeredFadeIn(index: 3, child: _prioritySection()),
                  SizedBox(height: 20),
                  StaggeredFadeIn(index: 4, child: _detailsSection()),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(gradient: AegisColors.sosGradient, borderRadius: BorderRadius.circular(12), boxShadow: AegisColors.glowRed), child: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22)),
        SizedBox(width: 14),
        Text('SOS', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AegisColors.textPrimary, letterSpacing: -0.5)),
      ]),
      Container(width: 36, height: 36, decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(10), border: Border.all(color: AegisColors.border1, width: 0.5)), child: Icon(Icons.info_outline_rounded, color: AegisColors.textPrimary, size: 18)),
    ]);
  }

  Widget _detailsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 3, height: 16, decoration: BoxDecoration(gradient: AegisColors.sosGradient, borderRadius: BorderRadius.circular(2))),
        SizedBox(width: 10),
        Text('DETAILS (OPTIONAL)', style: AegisStyles.overline),
      ]),
      SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: AegisColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AegisColors.border1, width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: TextField(
          controller: _detailsController,
          maxLines: 3,
          maxLength: 200,
          style: TextStyle(color: AegisColors.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Describe your emergency...',
            hintStyle: TextStyle(color: AegisColors.textMuted, fontSize: 13),
            border: InputBorder.none,
            counterText: '',
            isDense: true,
          ),
        ),
      ),
    ]);
  }

  Widget _categorySection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 3, height: 16, decoration: BoxDecoration(gradient: AegisColors.sosGradient, borderRadius: BorderRadius.circular(2))),
        SizedBox(width: 10),
        Text('SELECT CATEGORY', style: AegisStyles.overline),
      ]),
      SizedBox(height: 20),
      Wrap(
        spacing: 12, runSpacing: 16,
        children: List.generate(_categories.length, (i) => _catBtn(i, _categories[i]['icon'], _categories[i]['label'], _categories[i]['color'])),
      ),
    ]);
  }

  Widget _catBtn(int idx, IconData icon, String label, Color catColor) {
    final sel = _selectedCategory == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = idx),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250), curve: Curves.easeOutCubic,
          width: 58, height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: sel ? catColor : Colors.transparent,
            border: Border.all(color: sel ? catColor : AegisColors.border1, width: sel ? 2 : 1),
            boxShadow: sel ? [BoxShadow(color: catColor.withOpacity(0.3), blurRadius: 16, spreadRadius: 3)] : null,
          ),
          child: Icon(icon, color: sel ? Colors.white : AegisColors.textSecondary, size: 24),
        ),
        SizedBox(height: 8),
        AnimatedDefaultTextStyle(duration: const Duration(milliseconds: 200),
          style: TextStyle(fontSize: 11, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, color: sel ? catColor : AegisColors.textSecondary),
          child: Text(label)),
      ]),
    );
  }

  Widget _prioritySection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 3, height: 16, decoration: BoxDecoration(gradient: LinearGradient(colors: [AegisColors.neonGreen, AegisColors.warning, AegisColors.sosRed]), borderRadius: BorderRadius.circular(2))),
        SizedBox(width: 10),
        Text('PRIORITY LEVEL', style: AegisStyles.overline),
      ]),
      SizedBox(height: 16),
      Row(children: [
        Expanded(child: _prioBtn(0, 'Low', AegisColors.neonGreen)),
        SizedBox(width: 12),
        Expanded(child: _prioBtn(1, 'Medium', AegisColors.warning)),
        SizedBox(width: 12),
        Expanded(child: _prioBtn(2, 'High', AegisColors.sosRed)),
      ]),
    ]);
  }

  Widget _prioBtn(int idx, String label, Color color) {
    final sel = _selectedPriority == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedPriority = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250), curve: Curves.easeOutCubic,
        height: 46,
        decoration: BoxDecoration(
          gradient: sel ? LinearGradient(colors: [color.withOpacity(0.15), color.withOpacity(0.04)]) : null,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: sel ? color : AegisColors.border1, width: sel ? 1.5 : 1),
          boxShadow: sel ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, spreadRadius: 1)] : null,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 16, height: 16,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: sel ? color : AegisColors.textMuted, width: 1.5)),
            child: sel ? Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle))) : null,
          ),
          SizedBox(width: 10),
          AnimatedDefaultTextStyle(duration: const Duration(milliseconds: 200),
            style: TextStyle(color: sel ? color : AegisColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w700),
            child: Text(label)),
        ]),
      ),
    );
  }
}
