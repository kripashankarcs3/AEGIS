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
  late List<ResourceItem> _items;

  final List<String> _filterPills = const [
    'All',
    'Food',
    'Medical',
    'Water',
    'Battery',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _items = [
      const ResourceItem(
        id: '1',
        category: ResourceCategory.food,
        title: 'Food Pack',
        detail: '12 available',
        nodeId: 'SIG-8AF3',
        hops: 2,
        timeAgo: '300 m away • 2 hops',
        type: ResourceType.offered,
      ),
      const ResourceItem(
        id: '2',
        category: ResourceCategory.medical,
        title: 'Medicine Kit',
        detail: '4 available',
        nodeId: 'SIG-1A9D',
        hops: 3,
        timeAgo: '450 m away • 3 hops',
        type: ResourceType.offered,
      ),
      const ResourceItem(
        id: '3',
        category: ResourceCategory.water,
        title: 'Water Bottle',
        detail: '25 available',
        nodeId: 'SIG-B2C1',
        hops: 1,
        timeAgo: '200 m away • 1 hop',
        type: ResourceType.offered,
      ),
      const ResourceItem(
        id: '4',
        category: ResourceCategory.battery,
        title: 'Power Bank',
        detail: '6 available',
        nodeId: 'SIG-C4E1',
        hops: 2,
        timeAgo: '150 m away • 2 hops',
        type: ResourceType.offered,
      ),
      const ResourceItem(
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
  }

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
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: const Color(0xFF0F131A),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: PostResourceBottomSheet(
                        onPost: (newItem) {
                          setState(() {
                            _items.insert(0, newItem);
                          });
                        },
                      ),
                    ),
                  );
                },
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

  final List<Map<String, dynamic>> _sheetCategories = const [
    {'label': 'Water', 'icon': Icons.local_drink_rounded, 'color': Color(0xFF3B82F6), 'cat': ResourceCategory.water},
    {'label': 'Food', 'icon': Icons.restaurant_rounded, 'color': Color(0xFF10B981), 'cat': ResourceCategory.food},
    {'label': 'Medicine', 'icon': Icons.medical_services_rounded, 'color': Color(0xFFEF4444), 'cat': ResourceCategory.medical},
    {'label': 'Shelter', 'icon': Icons.home_rounded, 'color': Color(0xFFF59E0B), 'cat': ResourceCategory.other},
    {'label': 'Tools', 'icon': Icons.build_rounded, 'color': Color(0xFF8B5CF6), 'cat': ResourceCategory.other},
    {'label': 'People', 'icon': Icons.groups_rounded, 'color': Color(0xFF14B8A6), 'cat': ResourceCategory.other},
  ];

  @override
  void initState() {
    super.initState();
    _detailsController.addListener(() {
      setState(() {
        _charCount = _detailsController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> activeCategory = _sheetCategories[_selectedCategoryIndex];
    final String previewTitle = (_selectedType == ResourceType.offered ? 'Offering ' : 'Requesting ') + activeCategory['label'];
    final String previewDetail = _detailsController.text.isEmpty ? 'e.g., details...' : _detailsController.text;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Color(0xFF0F131A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle indicator & title
          Center(
            child: Container(
              width: 38.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: const Color(0xFF374151),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Post a Resource',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    'Share what you have or need',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AegisColors.textSecondary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1F2937),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded, color: Colors.white, size: 16.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),

          // Offer vs Request selector buttons
          Row(
            children: [
              Expanded(
                child: _buildTypeButton(ResourceType.offered, 'Offer'),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildTypeButton(ResourceType.requested, 'Request'),
              ),
            ],
          ),
          const SizedBox(height: 20.0),

          // Category Grid
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.bold,
              color: AegisColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10.0),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sheetCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (context, index) {
              final cat = _sheetCategories[index];
              final bool isSelected = _selectedCategoryIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? (cat['color'] as Color).withOpacity(0.12) : const Color(0xFF161A22),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isSelected ? (cat['color'] as Color) : const Color(0xFF374151).withOpacity(0.5),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        cat['icon'] as IconData,
                        color: cat['color'] as Color,
                        size: 18.0,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        cat['label'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20.0),

          // Quantity / Details Text Field
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quantity / Details',
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.bold,
                  color: AegisColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '$_charCount/100',
                style: const TextStyle(
                  fontSize: 10.0,
                  color: AegisColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF161A22),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: const Color(0xFF374151), width: 1.0),
            ),
            child: TextField(
              controller: _detailsController,
              maxLength: 100,
              maxLines: 2,
              style: const TextStyle(color: Colors.white, fontSize: 13.0),
              decoration: const InputDecoration(
                hintText: 'e.g., 10 bottles, First aid kit, 2 tents',
                hintStyle: TextStyle(color: AegisColors.textMuted, fontSize: 12.0),
                border: InputBorder.none,
                counterText: '',
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // Preview Card Section
          const Text(
            'Preview',
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.bold,
              color: AegisColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: const Color(0xFF161A22),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: const Color(0xFF374151), width: 1.0),
            ),
            child: Row(
              children: [
                // Category leading indicator bar
                Container(
                  width: 3.5,
                  height: 32.0,
                  decoration: BoxDecoration(
                    color: activeCategory['color'] as Color,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        previewTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Text(
                        previewDetail,
                        style: const TextStyle(
                          color: AegisColors.textSecondary,
                          fontSize: 11.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'To: All',
                          style: TextStyle(
                            color: AegisColors.activeGreen,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Icon(Icons.signal_cellular_alt_rounded, color: AegisColors.activeGreen, size: 13.0),
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    const Text(
                      'Broadcast to network',
                      style: TextStyle(
                        color: AegisColors.textMuted,
                        fontSize: 9.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),

          // BROADCAST RESOURCE Button
          GestureDetector(
            onTap: () {
              final String detailStr = _detailsController.text.isEmpty
                  ? 'e.g., details...'
                  : _detailsController.text;

              final ResourceItem item = ResourceItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                category: activeCategory['cat'] as ResourceCategory,
                title: previewTitle,
                detail: detailStr,
                nodeId: 'SIG-7F3A', // User's ID
                hops: 0,
                timeAgo: 'Just now • Local',
                type: _selectedType,
              );

              widget.onPost(item);
              Navigator.of(context).pop();
            },
            child: Container(
              width: double.infinity,
              height: 48.0,
              decoration: BoxDecoration(
                color: AegisColors.busyPurple,
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                    color: AegisColors.busyPurple.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'BROADCAST RESOURCE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(ResourceType type, String label) {
    final bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        height: 38.0,
        decoration: BoxDecoration(
          color: isSelected ? AegisColors.busyPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: isSelected ? AegisColors.busyPurple : const Color(0xFF374151),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AegisColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
        ),
      ),
    );
  }
}
