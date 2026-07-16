import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../services/storage_service.dart';
import 'identity_screen.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _profileImagePath;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  void _loadProfileImage() {
    setState(() {
      _profileImagePath = StorageService.getProfileImagePath();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop();
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (pickedFile == null) return;

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String savedPath = '${appDir.path}/$fileName';

      final File sourceFile = File(pickedFile.path);
      await sourceFile.copy(savedPath);

      await StorageService.setProfileImagePath(savedPath);

      // Clean up previous profile image if it exists
      if (_profileImagePath != null && _profileImagePath != savedPath) {
        try {
          final File oldFile = File(_profileImagePath!);
          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        } catch (_) {
          // Ignore cleanup errors
        }
      }

      setState(() {
        _profileImagePath = savedPath;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile image: $e')),
        );
      }
    }
  }

  Future<void> _removeImage() async {
    Navigator.of(context).pop();
    if (_profileImagePath != null) {
      try {
        final File oldFile = File(_profileImagePath!);
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      } catch (_) {
        // Ignore cleanup errors
      }
    }
    await StorageService.setProfileImagePath(null);
    setState(() {
      _profileImagePath = null;
    });
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AegisColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AegisColors.border2,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 16),
                _buildPickerOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Choose from Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                _buildPickerOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Take a Photo',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                if (_profileImagePath != null)
                  _buildPickerOption(
                    icon: Icons.delete_outline_rounded,
                    label: 'Remove Photo',
                    iconColor: const Color(0xFFFF0030),
                    textColor: const Color(0xFFFF0030),
                    onTap: _removeImage,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AegisColors.textSecondary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: textColor ?? AegisColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'SF Pro Display',
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background, // Deep space black background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: Container(
          margin: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AegisColors.cardBg.withOpacity(0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: AegisColors.border1,
              width: 1.0,
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: AegisColors.textPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: AegisColors.textPrimary,
            fontFamily: 'SF Pro Display',
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 8, bottom: 8),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AegisColors.cardBg.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: AegisColors.border1,
                width: 1.0,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.more_vert_rounded,
                color: AegisColors.textPrimary,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          children: [
            // 1. Centered Avatar with Purple Glow
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glowing rings
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFA855F7).withOpacity(0.25),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  // Inner Purple Avatar Circle / Profile Image
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFA855F7), // Light purple
                          Color(0xFF6B21A8), // Dark purple
                        ],
                      ),
                      border: Border.all(
                        color: AegisColors.border2.withOpacity(0.3),
                        width: 1.5,
                      ),
                      image: _profileImagePath != null
                          ? DecorationImage(
                              image: FileImage(File(_profileImagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _profileImagePath == null
                        ? Center(
                            child: Icon(
                              Icons.person_rounded,
                              color: AegisColors.textPrimary,
                              size: 52,
                            ),
                          )
                        : null,
                  ),
                  // Edit profile image button
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA855F7),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AegisColors.background,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFA855F7).withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: AegisColors.textPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.0),

            // 2. Name & Details Section
            Center(
              child: Column(
                children: [
                  Text(
                    'Kripashankar Yadav',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                      color: AegisColors.textPrimary,
                      fontFamily: 'SF Pro Display',
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'ID: NEXUS_7FA2B3',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AegisColors.textSecondary,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Active Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00FF88),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00FF88),
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.0),

            // 3. Stats Row (Contributions, Tasks, People Helped)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              decoration: BoxDecoration(
                color: AegisColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AegisColors.border1,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  _buildStatColumn('Contributions', '24'),
                  _buildVerticalDivider(),
                  _buildStatColumn('Tasks Joined', '6'),
                  _buildVerticalDivider(),
                  _buildStatColumn('People Helped', '18'),
                ],
              ),
            ),
            SizedBox(height: 24.0),

            // 4. Menu Card list (My Information, Emergency Contacts, Devices, Settings, Help)
            Container(
              decoration: BoxDecoration(
                color: AegisColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AegisColors.border1,
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  _buildMenuRow(
                    icon: Icons.person_outline_rounded,
                    label: 'My Information',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const IdentityScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildMenuRow(
                    icon: Icons.contact_phone_outlined,
                    label: 'Emergency Contacts',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuRow(
                    icon: Icons.sensors_outlined,
                    label: 'Devices & Network',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuRow(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildMenuRow(
                    icon: Icons.info_outline_rounded,
                    label: 'Help & Support',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // 5. Log Out Button (Red outlined card)
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: AegisColors.cardBg.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AegisColors.sosRed.withOpacity(0.25),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: AegisColors.sosRed,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: AegisColors.sosRed,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 120.0), // leave space for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: AegisColors.textSecondary,
              fontFamily: 'SF Pro Display',
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: AegisColors.textPrimary,
              fontFamily: 'SF Pro Display',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1.0,
      height: 36.0,
      color: AegisColors.border1,
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AegisColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AegisColors.border1,
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: AegisColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AegisColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.0,
      color: AegisColors.border1,
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 40,
            offset: const Offset(0, 12),
            spreadRadius: -8,
          ),
          BoxShadow(
            color: const Color(0xFF256DFF).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF09111F).withOpacity(0.92),
                  const Color(0xFF08080E).withOpacity(0.92),
                ],
              ),
              border: Border.all(
                color: AegisColors.border1,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(context, 'Radar', Icons.radar_rounded),
                _buildNavItem(context, 'Chats', Icons.chat_bubble_outline_rounded),
                _buildSosFab(context),
                _buildNavItem(context, 'Resources', Icons.library_books_outlined),
                _buildNavItem(context, 'Map', Icons.map_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AegisColors.textSecondary,
              size: 22,
            ),
            SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: AegisColors.textSecondary,
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSosFab(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF0030), // vibrant red
                  Color(0xFF8B0000), // dark red
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF0030).withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(
                color: AegisColors.border2.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                'SOS',
                style: TextStyle(
                  color: AegisColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
