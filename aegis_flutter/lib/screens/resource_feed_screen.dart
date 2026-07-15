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
  int _selectedTab = 0;

  final List<ResourceItem> _items = const [
    ResourceItem(
      id: '1',
      category: ResourceCategory.water,
      title: 'Water',
      detail: '5 bottles available',
      nodeId: 'SIG-8AF3',
      hops: 2,
      timeAgo: '3m ago',
      type: ResourceType.offered,
    ),
    ResourceItem(
      id: '2',
      category: ResourceCategory.food,
      title: 'Food',
      detail: 'Canned food available',
      nodeId: 'SIG-1A9D',
      hops: 3,
      timeAgo: '8m ago',
      type: ResourceType.offered,
    ),
    ResourceItem(
      id: '3',
      category: ResourceCategory.medical,
      title: 'Medical Supplies',
      detail: 'Bandages, Antiseptic',
      nodeId: 'SIG-4D2F',
      hops: 1,
      timeAgo: '10m ago',
      type: ResourceType.offered,
    ),
    ResourceItem(
      id: '4',
      category: ResourceCategory.battery,
      title: 'Battery',
      detail: 'Power bank available',
      nodeId: 'SIG-B2C1',
      hops: 2,
      timeAgo: '15m ago',
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
                        'RESOURCES',
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

                  // 2. Sub-bar Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6.0,
                            height: 6.0,
                            decoration: const BoxDecoration(
                              color: AegisColors.activeGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          const Text(
                            '8 Nodes Online',
                            style: TextStyle(
                              color: AegisColors.textSecondary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.wifi_tethering_rounded,
                            color: AegisColors.textSecondary,
                            size: 13.0,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            '127 Relayed',
                            style: TextStyle(
                              color: AegisColors.textSecondary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  // 3. Tabs Offered / Requested / All
                  Row(
                    children: [
                      _buildTabItem(0, 'Offered'),
                      _buildTabItem(1, 'Requested'),
                      _buildTabItem(2, 'All'),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // 4. Resource Cards Feed List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      padding: const EdgeInsets.only(bottom: 80.0), // Padding to avoid overlap with FAB
                      itemBuilder: (context, index) {
                        return ResourceCard(
                          item: _items[index],
                          onReplyTap: () {},
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Green Centered Add Resource Action Pill Button
            Positioned(
              left: 24.0,
              right: 24.0,
              bottom: 16.0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: AegisColors.activeGreen,
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                        color: AegisColors.activeGreen.withOpacity(0.35),
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
                        color: Colors.white,
                        size: 20.0,
                      ),
                      SizedBox(width: 6.0),
                      Text(
                        'OFFER / REQUEST',
                        style: TextStyle(
                          color: Colors.white,
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

  Widget _buildTabItem(int index, String title) {
    final bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 24.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
                  bottom: BorderSide(
                    color: AegisColors.activeGreen,
                    width: 2.5,
                  ),
                )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AegisColors.textMuted,
            fontSize: 13.0,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
