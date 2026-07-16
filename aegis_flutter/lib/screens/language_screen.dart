import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int _selectedLanguageIndex = 0;

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'sub': 'Default'},
    {'name': 'हिन्दी (Hindi)', 'sub': ''},
    {'name': 'தமிழ் (Tamil)', 'sub': ''},
    {'name': 'తెలుగు (Telugu)', 'sub': ''},
    {'name': 'বাংলা (Bengali)', 'sub': ''},
    {'name': 'मराठी (Marathi)', 'sub': ''},
    {'name': 'ಕನ್ನಡ (Kannada)', 'sub': ''},
    {'name': 'ગુજરાતી (Gujarati)', 'sub': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF090D16),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Language',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                children: [
                  // 1. Center header logo and titles
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 56.0,
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: AegisColors.neonGreen.withOpacity(0.08),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AegisColors.neonGreen.withOpacity(0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.language_rounded,
                              color: AegisColors.neonGreen,
                              size: 28.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Choose App Language',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          'Select your preferred language for\nthe AEGIS interface.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: AegisColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.0),

                  // 2. Languages list card
                  Container(
                    decoration: BoxDecoration(
                      color: AegisColors.cardBg,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: AegisColors.border1, width: 1.0),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _languages.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Color(0xFF1E293B),
                        height: 1.0,
                        thickness: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        final lang = _languages[index];
                        final bool isSelected = _selectedLanguageIndex == index;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedLanguageIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                            child: Row(
                              children: [
                                // Custom green radio selector
                                Container(
                                  width: 16.0,
                                  height: 16.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? AegisColors.neonGreen : AegisColors.textSecondary,
                                      width: isSelected ? 5.0 : 1.5,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 14.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang['name']!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (lang['sub']!.isNotEmpty) ...[
                                        SizedBox(height: 2.0),
                                        Text(
                                          lang['sub']!,
                                          style: TextStyle(
                                            color: AegisColors.textSecondary,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Green wide "Apply Language" Action button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  height: 46.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF047857), // Forest green active color
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF047857).withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Apply Language',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
