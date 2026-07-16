import 'package:flutter/material.dart';

import '../models/resource_item.dart';
import '../widgets/resource_card.dart';

class ResourceFeedScreen extends StatefulWidget {
  const ResourceFeedScreen({super.key});

  @override
  State<ResourceFeedScreen> createState() => _ResourceFeedScreenState();
}

class _ResourceFeedScreenState extends State<ResourceFeedScreen> {
  int _selectedFilter = 0;

  final _filters = const [
    'All',
    'Food',
    'Medical',
    'Water',
    'Battery',
    'Other'
  ];
  late final List<ResourceItem> _items = [
    const ResourceItem(
        id: '1',
        category: ResourceCategory.food,
        title: 'Food Pack',
        detail: '12 available',
        nodeId: 'SIG-8AF3',
        hops: 2,
        timeAgo: 'Just now',
        type: ResourceType.offered),
    const ResourceItem(
        id: '2',
        category: ResourceCategory.medical,
        title: 'Medicine Kit',
        detail: '4 available',
        nodeId: 'SIG-1A9D',
        hops: 3,
        timeAgo: '10 min ago',
        type: ResourceType.offered),
    const ResourceItem(
        id: '3',
        category: ResourceCategory.water,
        title: 'Water Bottle',
        detail: '25 available',
        nodeId: 'SIG-B2C1',
        hops: 1,
        timeAgo: '15 min ago',
        type: ResourceType.offered),
    const ResourceItem(
        id: '4',
        category: ResourceCategory.battery,
        title: 'Power Bank',
        detail: '6 available',
        nodeId: 'SIG-C4E1',
        hops: 2,
        timeAgo: '20 min ago',
        type: ResourceType.offered),
    const ResourceItem(
        id: '5',
        category: ResourceCategory.other,
        title: 'Blankets',
        detail: '10 available',
        nodeId: 'SIG-9E10',
        hops: 3,
        timeAgo: '25 min ago',
        type: ResourceType.offered),
  ];

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF2563EB);
  static const _green = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: _header(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _filtersRow(),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 92),
                itemCount: _filteredItems.length,
                itemBuilder: (_, index) => ResourceCard(
                    item: _filteredItems[index],
                    actionLabel: 'View',
                    onReplyTap: () {}),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Offer Resource',
            style: TextStyle(fontWeight: FontWeight.w800)),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<ResourceItem> get _filteredItems {
    if (_selectedFilter == 0) return _items;
    return _items
        .where((item) =>
            item.category.name.toLowerCase() ==
            _filters[_selectedFilter].toLowerCase())
        .toList();
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Resources',
            style: TextStyle(
                color: _ink, fontSize: 24, fontWeight: FontWeight.w900)),
        Row(
          children: [
            _iconButton(Icons.search_rounded),
            const SizedBox(width: 8),
            _iconButton(Icons.tune_rounded),
          ],
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: Icon(icon, color: _ink, size: 18),
    );
  }

  Widget _filtersRow() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (_, index) {
          final selected = _selectedFilter == index;
          return Padding(
            padding:
                EdgeInsets.only(right: index == _filters.length - 1 ? 0 : 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFEFF6FF)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                      color: selected ? const Color(0xFFBFDBFE) : _line),
                ),
                child: Text(
                  _filters[index],
                  style: TextStyle(
                      color: selected ? _blue : _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
