import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../constants/aegis_animations.dart';
import '../models/resource_item.dart';
import '../widgets/resource_card.dart';

class ResourceFeedScreen extends StatefulWidget {
  const ResourceFeedScreen({super.key});

  @override
  State<ResourceFeedScreen> createState() => _ResourceFeedScreenState();
}

class _ResourceFeedScreenState extends State<ResourceFeedScreen> {
  int _selectedFilterPill = 0;
  late List<ResourceItem> _items;

  final List<String> _filterPills = ['All', 'Food', 'Medical', 'Water', 'Battery', 'Other'];

  @override
  void initState() {
    super.initState();
    _items = [
      const ResourceItem(id: '1', category: ResourceCategory.food, title: 'Food Pack', detail: '12 available', nodeId: 'SIG-8AF3', hops: 2, timeAgo: '300 m away • 2 hops', type: ResourceType.offered),
      const ResourceItem(id: '2', category: ResourceCategory.medical, title: 'Medicine Kit', detail: '4 available', nodeId: 'SIG-1A9D', hops: 3, timeAgo: '450 m away • 3 hops', type: ResourceType.offered),
      const ResourceItem(id: '3', category: ResourceCategory.water, title: 'Water Bottle', detail: '25 available', nodeId: 'SIG-B2C1', hops: 1, timeAgo: '200 m away • 1 hop', type: ResourceType.offered),
      const ResourceItem(id: '4', category: ResourceCategory.battery, title: 'Power Bank', detail: '6 available', nodeId: 'SIG-C4E1', hops: 2, timeAgo: '150 m away • 2 hops', type: ResourceType.offered),
      const ResourceItem(id: '5', category: ResourceCategory.other, title: 'Blankets', detail: '10 available', nodeId: 'SIG-9E10', hops: 3, timeAgo: '600 m away • 3 hops', type: ResourceType.offered),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                StaggeredFadeIn(index: 0, child: _header()),
                SizedBox(height: 16),
                StaggeredFadeIn(index: 1, child: _filterPillsWidget()),
                SizedBox(height: 20),
                Expanded(child: ListView.builder(itemCount: _items.length, padding: const EdgeInsets.only(bottom: 160), itemBuilder: (_, i) {
                  final item = _items[i];
                  if (_selectedFilterPill > 0) {
                    if (item.category.name.toLowerCase() != _filterPills[_selectedFilterPill].toLowerCase()) return const SizedBox.shrink();
                  }
                  return StaggeredFadeIn(index: i + 2, child: ResourceCard(item: item, actionLabel: 'View', onReplyTap: () {}));
                })),
              ]),
            ),
            Positioned(left: 24, right: 24, bottom: 90, child: StaggeredFadeIn(index: 6, child: _offerBtn())),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Container(width: 3, height: 24, decoration: BoxDecoration(gradient: AegisColors.greenGradient, borderRadius: BorderRadius.circular(2))),
        SizedBox(width: 12),
        Text('Resources', style: AegisStyles.h2),
      ]),
      Row(children: [
        _hdrIcon(Icons.search_rounded), SizedBox(width: 4), _hdrIcon(Icons.tune_rounded),
      ]),
    ]);
  }

  Widget _hdrIcon(IconData icon) => Container(width: 36, height: 36, decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(10), border: Border.all(color: AegisColors.border1, width: 0.5)), child: Icon(icon, color: Colors.white, size: 18));

  Widget _filterPillsWidget() {
    return SizedBox(height: 36, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _filterPills.length, itemBuilder: (_, i) => _pill(i, _filterPills[i])));
  }

  Widget _pill(int idx, String label) {
    final sel = _selectedFilterPill == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterPill = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: sel ? AegisColors.purpleGradient : null,
          color: sel ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sel ? Colors.transparent : AegisColors.border1, width: 1),
          boxShadow: sel ? [BoxShadow(color: AegisColors.violet.withOpacity(0.25), blurRadius: 12, spreadRadius: 1)] : null,
        ),
        child: Center(child: Text(label, style: TextStyle(color: sel ? Colors.white : AegisColors.textSecondary, fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.w500))),
      ),
    );
  }

  Widget _offerBtn() {
    return GestureDetector(
      onTap: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
        builder: (_) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), child: PostResourceBottomSheet(onPost: (newItem) => setState(() => _items.insert(0, newItem))))),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AegisColors.isLight ? AegisColors.neonGreen.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AegisColors.neonGreen.withOpacity(0.3), width: 0.5),
          boxShadow: AegisColors.isLight ? null : [BoxShadow(color: AegisColors.neonGreen.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.add_rounded, color: AegisColors.neonGreen, size: 22),
          SizedBox(width: 8),
          Text('OFFER RESOURCE', style: TextStyle(color: AegisColors.neonGreen, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
        ]),
      ),
    );
  }
}

class PostResourceBottomSheet extends StatefulWidget {
  final ValueChanged<ResourceItem> onPost;
  const PostResourceBottomSheet({super.key, required this.onPost});

  @override
  State<PostResourceBottomSheet> createState() => _PostResourceBottomSheetState();
}

class _PostResourceBottomSheetState extends State<PostResourceBottomSheet> {
  ResourceType _selectedType = ResourceType.offered;
  int _selectedCategoryIndex = 0;
  final TextEditingController _detailsController = TextEditingController();
  int _charCount = 0;

  final List<Map<String, dynamic>> _sheetCategories = [
    {'label': 'Water', 'icon': Icons.local_drink_rounded, 'color': Color(0xFF0088FF), 'cat': ResourceCategory.water},
    {'label': 'Food', 'icon': Icons.restaurant_rounded, 'color': Color(0xFF00FF88), 'cat': ResourceCategory.food},
    {'label': 'Medicine', 'icon': Icons.medical_services_rounded, 'color': Color(0xFFFF0030), 'cat': ResourceCategory.medical},
    {'label': 'Shelter', 'icon': Icons.home_rounded, 'color': Color(0xFFFFB300), 'cat': ResourceCategory.other},
    {'label': 'Tools', 'icon': Icons.build_rounded, 'color': Color(0xFF8B5CF6), 'cat': ResourceCategory.other},
    {'label': 'People', 'icon': Icons.groups_rounded, 'color': Color(0xFF00E5FF), 'cat': ResourceCategory.other},
  ];

  @override void initState() { super.initState(); _detailsController.addListener(() => setState(() => _charCount = _detailsController.text.length)); }
  @override void dispose() { _detailsController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ac = _sheetCategories[_selectedCategoryIndex];
    final previewTitle = (_selectedType == ResourceType.offered ? 'Offering ' : 'Requesting ') + ac['label'];
    final previewDetail = _detailsController.text.isEmpty ? 'e.g., details...' : _detailsController.text;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF141428), Color(0xFF0E0E1E)]), borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: AegisColors.textDim, borderRadius: BorderRadius.circular(3)))),
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Post a Resource', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3)),
            SizedBox(height: 4),
            Text('Share what you have or need', style: TextStyle(fontSize: 12, color: AegisColors.textSecondary.withOpacity(0.8))),
          ]),
          GestureDetector(onTap: () => Navigator.of(context).pop(), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AegisColors.border1, shape: BoxShape.circle), child: Icon(Icons.close_rounded, color: Colors.white, size: 18))),
        ]),
        SizedBox(height: 24),
        Row(children: [
          Expanded(child: _typeBtn(ResourceType.offered, 'Offer')),
          SizedBox(width: 12),
          Expanded(child: _typeBtn(ResourceType.requested, 'Request')),
        ]),
        SizedBox(height: 24),
        Text('CATEGORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AegisColors.textMuted.withOpacity(0.8), letterSpacing: 1.0)),
        SizedBox(height: 12),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: _sheetCategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6),
          itemBuilder: (_, i) {
            final cat = _sheetCategories[i];
            final sel = _selectedCategoryIndex == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategoryIndex = i),
              child: AnimatedContainer(duration: const Duration(milliseconds: 200), curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: sel ? LinearGradient(colors: [(cat['color'] as Color).withOpacity(0.15), (cat['color'] as Color).withOpacity(0.05)]) : null,
                  color: sel ? null : AegisColors.surface2,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: sel ? (cat['color'] as Color).withOpacity(0.5) : AegisColors.border1, width: sel ? 1.5 : 0.5),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 20),
                  SizedBox(height: 6),
                  Text(cat['label'] as String, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ])),
            );
          }),
        SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AegisColors.textMuted.withOpacity(0.8), letterSpacing: 1.0)),
          Text('$_charCount/100', style: TextStyle(fontSize: 10, color: AegisColors.textMuted.withOpacity(0.6))),
        ]),
        SizedBox(height: 10),
        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(14), border: Border.all(color: AegisColors.border1, width: 0.5)),
          child: TextField(controller: _detailsController, maxLength: 100, maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 14), decoration: InputDecoration(hintText: 'e.g., 10 bottles, First aid kit, 2 tents', hintStyle: TextStyle(color: AegisColors.textMuted, fontSize: 13), border: InputBorder.none, counterText: '', isDense: true))),
        SizedBox(height: 24),
        Row(children: [
          Container(width: 3, height: 16, decoration: BoxDecoration(gradient: AegisColors.primaryGradient, borderRadius: BorderRadius.circular(2))),
          SizedBox(width: 10),
          Text('PREVIEW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AegisColors.textMuted.withOpacity(0.8), letterSpacing: 1.0)),
        ]),
        SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(16), border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5)),
          child: Row(children: [
            Container(width: 4, height: 40, decoration: BoxDecoration(color: ac['color'] as Color, borderRadius: BorderRadius.circular(2))),
            SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(previewTitle, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text(previewDetail, style: TextStyle(color: AegisColors.textSecondary, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Text('To: All', style: TextStyle(color: AegisColors.neonGreen.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w700)),
                SizedBox(width: 4),
                Icon(Icons.signal_cellular_alt_rounded, color: AegisColors.neonGreen.withOpacity(0.8), size: 14),
              ]),
              SizedBox(height: 4),
              Text('Broadcast to network', style: TextStyle(color: AegisColors.textMuted.withOpacity(0.6), fontSize: 9)),
            ]),
          ]),
        ),
        SizedBox(height: 28),
        GestureDetector(
          onTap: () {
            final detailStr = _detailsController.text.isEmpty ? 'e.g., details...' : _detailsController.text;
            widget.onPost(ResourceItem(id: DateTime.now().millisecondsSinceEpoch.toString(), category: ac['cat'] as ResourceCategory, title: previewTitle, detail: detailStr, nodeId: 'SIG-7F3A', hops: 0, timeAgo: 'Just now • Local', type: _selectedType));
            Navigator.of(context).pop();
          },
          child: Container(width: double.infinity, height: 52, decoration: BoxDecoration(gradient: AegisColors.purpleGradient, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: AegisColors.violet.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))]),
            child: Center(child: Text('BROADCAST RESOURCE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.5)))),
        ),
      ]),
    );
  }

  Widget _typeBtn(ResourceType type, String label) {
    final sel = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200), curve: Curves.easeOutCubic, height: 44,
        decoration: BoxDecoration(gradient: sel ? AegisColors.purpleGradient : null, color: sel ? null : Colors.transparent, borderRadius: BorderRadius.circular(12), border: Border.all(color: sel ? Colors.transparent : AegisColors.border1, width: 1), boxShadow: sel ? [BoxShadow(color: AegisColors.violet.withOpacity(0.2), blurRadius: 12, spreadRadius: 1)] : null),
        child: Center(child: Text(label, style: TextStyle(color: sel ? Colors.white : AegisColors.textSecondary, fontWeight: FontWeight.w700, fontSize: 14))),
      ),
    );
  }
}
