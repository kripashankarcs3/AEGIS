import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class StatusHistoryScreen extends StatefulWidget {
  const StatusHistoryScreen({super.key});

  @override
  State<StatusHistoryScreen> createState() => _StatusHistoryScreenState();
}

class _StatusHistoryScreenState extends State<StatusHistoryScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF090D16),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Status & History',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded, color: Colors.white, size: 22.0),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. My Status Header Card
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AegisColors.cardBg,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: AegisColors.border1, width: 1.0),
                ),
                child: Row(
                  children: [
                    // Green Shield avatar
                    Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF064E3B),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.verified_user_rounded,
                          color: AegisColors.neonGreen,
                          size: 22.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    // Status texts
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'My Status',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            'I am safe and available.',
                            style: TextStyle(
                              color: AegisColors.textSecondary,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            'Updated just now',
                            style: TextStyle(
                              color: AegisColors.textMuted,
                              fontSize: 9.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Edit pencil icon
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18.0),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // 2. Tabs Row
              Row(
                children: [
                  _buildTabItem(0, 'Activity'),
                  _buildTabItem(1, 'Beacons'),
                  _buildTabItem(2, 'History'),
                ],
              ),
              const SizedBox(height: 16.0),

              // 3. Recent Activity list
              const Text(
                'RECENT ACTIVITY',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: AegisColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: ListView(
                  children: [
                    _buildActivityTile(
                      color: AegisColors.neonGreen,
                      nodeId: 'SIG-8AF3',
                      status: 'Online',
                      statusColor: AegisColors.neonGreen,
                      time: 'Just now',
                      hops: '2 hops',
                    ),
                    _buildDivider(),
                    _buildActivityTile(
                      color: AegisColors.neonGreen,
                      nodeId: 'SIG-C4E1',
                      status: 'Online',
                      statusColor: AegisColors.neonGreen,
                      time: '1 min ago',
                      hops: '1 hop',
                    ),
                    _buildDivider(),
                    _buildActivityTile(
                      color: AegisColors.sosRed,
                      nodeId: 'SIG-B2C1',
                      status: 'Relay',
                      statusColor: AegisColors.sosRed,
                      time: '2 min ago',
                      hops: '2 hops',
                    ),
                    _buildDivider(),
                    _buildActivityTile(
                      color: AegisColors.sosRed,
                      nodeId: 'SIG-1D9A',
                      status: 'SOS',
                      statusColor: AegisColors.sosRed,
                      time: '5 min ago',
                      hops: '3 hops',
                    ),
                    _buildDivider(),
                    _buildActivityTile(
                      color: AegisColors.textMuted,
                      nodeId: 'SIG-9E10',
                      status: 'Offline',
                      statusColor: AegisColors.textMuted,
                      time: '10 min ago',
                      hops: '—',
                    ),
                  ],
                ),
              ),

              // 4. View Full History bottom button
              Container(
                width: double.infinity,
                height: 44.0,
                decoration: BoxDecoration(
                  color: AegisColors.violet.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: AegisColors.violet, width: 1.0),
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(6.0),
                  child: const Center(
                    child: Text(
                      'View Full History',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                    color: AegisColors.neonGreen,
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

  Widget _buildActivityTile({
    required Color color,
    required String nodeId,
    required String status,
    required Color statusColor,
    required String time,
    required String hops,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      child: Row(
        children: [
          // Cube/Node colored circle avatar
          Container(
            width: 34.0,
            height: 34.0,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sensors_rounded,
              color: color,
              size: 16.0,
            ),
          ),
          const SizedBox(width: 14.0),

          // Node ID & Status Text
          Expanded(
            child: Row(
              children: [
                Text(
                  nodeId,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14.0),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),

          // Timestamp & hops detail
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 10.0,
                  color: AegisColors.textMuted,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                hops,
                style: const TextStyle(
                  fontSize: 10.0,
                  color: AegisColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF1E293B),
      height: 1.0,
      thickness: 0.5,
    );
  }
}
