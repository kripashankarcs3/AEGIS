import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../models/resource_item.dart';
import '../widgets/resource_card.dart';

class ResourceFeedScreen extends StatefulWidget {
  const ResourceFeedScreen({super.key});

  @override
  State<ResourceFeedScreen> createState() => _ResourceFeedScreenState();
}

class _ResourceFeedScreenState extends State<ResourceFeedScreen> {
  int _selectedFilterPill = 0;

  final List<String> _filterPills = const [
    'All',
    'Food',
    'Medical',
    'Water',
    'Battery',
    'Other',
  ];

  final List<ResourceItem> _items = const [
    ResourceItem(
      id: '1',
      category: ResourceCategory.food,
      title: 'Food Pack',
      detail: '12 available',
      nodeId: 'SIG-8AF3',
      hops: 2,
      timeAgo: '300 m away • 2 hops',
      type: ResourceType.offered,
    ),
    ResourceItem(
      id: '2',
      category: ResourceCategory.medical,
      title: 'Medicine Kit',
      detail: '4 available',
      nodeId: 'SIG-1A9D',
      hops: 3,
      timeAgo: '450 m away • 3 hops',
      type: ResourceType.offered,
    ),
    ResourceItem(
      id: '3',
      category: ResourceCategory.water,
      title: 'Water Bottle',
      detail: '25 available',
      nodeId: 'SIG-B2C1',
      hops: 1,
      timeAgo: '200 m away • 1 hop',
      type: ResourceType.offered,
    ),
    ResourceItem(
      id: '4',
      category: ResourceCategory.battery,
      title: 'Power Bank',
      detail: '6 available',
      nodeId: 'SIG-C4E1',
      hops: 2,
      timeAgo: '150 m away • 2 hops',
      type: ResourceType.offered,
    ),
    ResourceItem(
      id: '5',
      category: ResourceCategory.other,
      title: 'Blankets',
      detail: '10 available',
      nodeId: 'SIG-9E10',
      hops: 3,
      timeAgo: '600 m away • 3 hops',
      type: ResourceType.offered,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Header Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Resources',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search_rounded, color: Colors.white, size: 22.0),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 22.0),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),

                  // 2. Horizontally Scrolling Filter Pills
                  SizedBox(
                    height: 34.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filterPills.length,
                      itemBuilder: (context, index) {
                        return _buildFilterPillItem(index, _filterPills[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // 3. Resource Cards Feed List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      padding: const EdgeInsets.only(bottom: 80.0), // space for bottom FAB button
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        // Optional: Filter items based on selected pill
                        if (_selectedFilterPill > 0) {
                          final String categoryName = item.category.name.toLowerCase();
                          final String pillName = _filterPills[_selectedFilterPill].toLowerCase();
                          if (categoryName != pillName) {
                            return const SizedBox.shrink();
                          }
                        }

                        return ResourceCard(
                          item: item,
                          actionLabel: 'View',
                          onReplyTap: () {},
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Green Centered Add Resource Action Pill Button (+ OFFER RESOURCE)
            Positioned(
              left: 24.0,
              right: 24.0,
              bottom: 16.0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF042F1A).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(22.0),
                    border: Border.all(
                      color: AegisColors.activeGreen.withOpacity(0.4),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AegisColors.activeGreen.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add_rounded,
                        color: AegisColors.activeGreen,
                        size: 20.0,
                      ),
                      SizedBox(width: 6.0),
                      Text(
                        'OFFER RESOURCE',
                        style: TextStyle(
                          color: AegisColors.activeGreen,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPillItem(int index, String label) {
    final bool isSelected = _selectedFilterPill == index;
    final Color bgColor = isSelected ? AegisColors.busyPurple : Colors.transparent;
    final Color strokeColor = isSelected ? AegisColors.busyPurple : const Color(0xFF1E293B);
    final Color textColor = isSelected ? Colors.white : AegisColors.textSecondary;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterPill = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: strokeColor, width: 1.0),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
