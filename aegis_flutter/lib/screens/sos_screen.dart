import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../widgets/sos_banner.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  int _selectedCategory = 0; // Default to Medical
  int _selectedPriority = 2; // Default to High (High is selected red in mockup 9)

  final List<Map<String, dynamic>> _categories = const [
    {'label': 'Medical', 'icon': Icons.add_rounded, 'color': AegisColors.sosRed},
    {'label': 'Fire', 'icon': Icons.local_fire_department_rounded, 'color': AegisColors.warningOrange},
    {'label': 'Food', 'icon': Icons.restaurant_rounded, 'color': Colors.white},
    {'label': 'Flood', 'icon': Icons.waves_rounded, 'color': AegisColors.primaryBlue},
    {'label': 'Other', 'icon': Icons.more_horiz_rounded, 'color': Colors.white},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Header Bar (Back arrow, Title "SOS", Info icon)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22.0),
                          onPressed: () {},
                        ),
                        const Text(
                          'SOS',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 22.0),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // 2. Central emergency countdown card
                const SosBroadcastCard(countdownText: '05:00'),
                const SizedBox(height: 24.0),

                // 3. Select Category Section
                const Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_categories.length, (index) {
                    final item = _categories[index];
                    return _buildCategoryButton(
                      index,
                      item['icon'] as IconData,
                      item['label'] as String,
                      item['color'] as Color,
                    );
                  }),
                ),
                const SizedBox(height: 24.0),

                // 4. Priority Level Section
                const Text(
                  'Priority Level',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPriorityButton(0, 'Low', AegisColors.activeGreen),
                    _buildPriorityButton(1, 'Medium', AegisColors.warningOrange),
                    _buildPriorityButton(2, 'High', AegisColors.sosRed),
                  ],
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(int index, IconData icon, String label, Color categoryColor) {
    final bool isSelected = _selectedCategory == index;
    final Color activeColor = isSelected ? AegisColors.sosRed : const Color(0xFF1E293B);
    final Color contentColor = isSelected ? AegisColors.sosRed : AegisColors.textSecondary;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: activeColor, width: 1.5),
              color: isSelected ? AegisColors.sosRed.withOpacity(0.08) : Colors.transparent,
            ),
            child: Center(
              child: Icon(
                icon,
                color: contentColor,
                size: 20.0,
              ),
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityButton(int index, String label, Color priorityColor) {
    final bool isSelected = _selectedPriority == index;
    final Color strokeColor = isSelected ? priorityColor : const Color(0xFF1E293B);
    final Color textColor = isSelected ? priorityColor : AegisColors.textSecondary;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPriority = index;
          });
        },
        child: Container(
          margin: EdgeInsets.only(
            left: index == 0 ? 0.0 : 6.0,
            right: index == 2 ? 0.0 : 6.0,
          ),
          height: 38.0,
          decoration: BoxDecoration(
            color: isSelected ? priorityColor.withOpacity(0.06) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: strokeColor, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular radio outline/indicator
              Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: strokeColor, width: 1.0),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 6.0,
                          height: 6.0,
                          decoration: BoxDecoration(
                            color: priorityColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8.0),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
