import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../constants/aegis_animations.dart';

class IdentityScreen extends StatelessWidget {
  const IdentityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: AegisColors.surface0.withOpacity(0.95),
        elevation: 0,
        leading: Container(margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: AegisColors.surface2, shape: BoxShape.circle, border: Border.all(color: AegisColors.border1, width: 0.5)), child: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white, size: 20), onPressed: () => Navigator.of(context).pop())),
        title: Text('My Identity'),
        actions: [Container(margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: AegisColors.surface2, shape: BoxShape.circle, border: Border.all(color: AegisColors.border1, width: 0.5)), child: IconButton(icon: Icon(Icons.edit_outlined, color: Colors.white, size: 20), onPressed: () {}))],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AegisStyles.padAll,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            StaggeredFadeIn(index: 0, child: Container(
              padding: AegisStyles.padCardLg,
decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AegisColors.cardBg, AegisColors.surface2]), borderRadius: BorderRadius.circular(20), border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5), boxShadow: AegisColors.cardShadow),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AegisColors.border1, width: 1.5),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('SIG-8AF3', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), decoration: BoxDecoration(color: AegisColors.neonGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AegisColors.neonGreen.withOpacity(0.3), width: 0.5)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        PulseDot(color: AegisColors.neonGreen, size: 6),
                        SizedBox(width: 6),
                        Text('Active', style: TextStyle(color: AegisColors.neonGreen, fontSize: 11, fontWeight: FontWeight.w700)),
                      ])),
                  ])),
                ]),
                SizedBox(height: 24),
                Text('PUBLIC KEY', style: AegisStyles.overline),
                SizedBox(height: 8),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(12), border: Border.all(color: AegisColors.border1, width: 0.5)),
                    child: Text('7f3a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: AegisColors.textSecondary, height: 1.5)))),
                  SizedBox(width: 10),
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(10), border: Border.all(color: AegisColors.border1, width: 0.5)), child: Icon(Icons.copy_rounded, color: AegisColors.textSecondary, size: 18)),
                ]),
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AegisColors.neonGreen.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AegisColors.neonGreen.withOpacity(0.15), width: 0.5)),
                  child: Row(children: [
                    Icon(Icons.check_circle_outline_rounded, color: AegisColors.neonGreen.withOpacity(0.8), size: 18),
                    SizedBox(width: 12),
                    Text('Generated locally — never sent to any server.', style: TextStyle(color: AegisColors.neonGreen.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w500)),
                  ]),
                ),
              ]),
            )),
            SizedBox(height: 32),
            StaggeredFadeIn(index: 1, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 3, height: 16, decoration: BoxDecoration(gradient: AegisColors.primaryGradient, borderRadius: BorderRadius.circular(2))),
                SizedBox(width: 10),
                Text('SHARE IDENTITY', style: AegisStyles.overline),
              ]),
              SizedBox(height: 16),
              Container(
                padding: AegisStyles.padCardLg, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AegisColors.cardBg, AegisColors.surface2]), borderRadius: BorderRadius.circular(20), border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5), boxShadow: AegisColors.cardShadow),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(width: 110, height: 110, padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))]), child: Icon(Icons.qr_code_2_rounded, color: Colors.black, size: 94)),
                  SizedBox(width: 20),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Scan to connect', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.2)),
                    SizedBox(height: 12),
                    _detail('LAN IP', '192.168.1.105'),
                    SizedBox(height: 8),
                    _detail('SIG-ID', 'SIG-8AF3'),
                  ])),
                ]),
              ),
            ])),
            SizedBox(height: 32),
            StaggeredFadeIn(index: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 3, height: 16, decoration: BoxDecoration(gradient: AegisColors.cyanGradient, borderRadius: BorderRadius.circular(2))),
                SizedBox(width: 10),
                Text('MESH STATISTICS (THIS SESSION)', style: AegisStyles.overline),
              ]),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AegisColors.cardBg, AegisColors.surface2]), borderRadius: BorderRadius.circular(18), border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5), boxShadow: AegisColors.cardShadow),
                child: Column(children: [
                  _stat(Icons.access_time_rounded, 'Session Uptime', '2h 45m'),
                  _divider(),
                  _stat(Icons.sync_alt_rounded, 'Total Relayed', '1,248 packets'),
                  _divider(),
                  _stat(Icons.sensors_rounded, 'Nodes Discovered', '8'),
                  _divider(),
                  _stat(Icons.cancel_presentation_rounded, 'Packets Dropped', '23'),
                ]),
              ),
            ])),
          ]),
        ),
      ),
    );
  }

  Widget _detail(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: AegisColors.textSecondary.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w600)),
      SizedBox(height: 2),
      Text(value, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
    ]);
  }

  Widget _stat(IconData icon, String label, String value) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AegisColors.textSecondary, size: 16)),
        SizedBox(width: 12),
        Text(label, style: TextStyle(color: AegisColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
      ]),
      Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
    ]));
  }

  Widget _divider() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 18), height: 0.5, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.transparent, AegisColors.border1.withOpacity(0.3), Colors.transparent])));
  }
}
