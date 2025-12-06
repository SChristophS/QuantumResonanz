import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/language_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = 'Loading...';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
      });
    } catch (e) {
      setState(() {
        _appVersion = 'Unknown';
      });
    }
  }

  Future<void> _openLegalPage(String anchor) async {
    try {
      // Just link to the base page, no anchor fragments
      final baseUrl = 'https://byte-bandits.com/QuantumResonance_legal.html';
      final uri = Uri.parse(baseUrl);
      
      // Try to launch URL - try externalApplication first, fallback to platformDefault
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback: try platformDefault mode
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      } catch (e) {
        // If externalApplication fails, try platformDefault
        try {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        } catch (e2) {
          throw Exception('Could not launch URL: ${e2.toString()}');
        }
      }
    } catch (e) {
      // Fallback: show error dialog
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111427),
        title: const Text(
          'Fehler',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Die rechtlichen Informationen konnten nicht geöffnet werden.\n\n$error',
          style: const TextStyle(color: Color(0xFFB0B5D0)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF29E0FF)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF050712),
      appBar: AppBar(
        title: const Text('Einstellungen'),
        backgroundColor: const Color(0xFF0C0F1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF07091A),
              Color(0xFF050712),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // App Version
            _buildSection(
              context,
              'App-Informationen',
              [
                _buildInfoTile(
                  context,
                  'Version',
                  '$_appVersion+$_buildNumber',
                  Icons.info_outline,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Language Selection
            _buildSection(
              context,
              'Sprache / Language',
              [
                _buildLanguageSelector(context, languageService),
              ],
            ),
            const SizedBox(height: 24),

            // Legal Links
            _buildSection(
              context,
              'Rechtliche Informationen / Legal Information',
              [
                _buildLegalLink(
                  context,
                  'Impressum / Legal Notice',
                  '#impressum',
                  Icons.description,
                ),
                _buildLegalLink(
                  context,
                  'Datenschutzerklärung / Privacy Policy',
                  '#datenschutz',
                  Icons.privacy_tip,
                ),
                _buildLegalLink(
                  context,
                  'Haftungsausschluss / Disclaimer',
                  '#haftungsausschluss',
                  Icons.warning,
                ),
                _buildLegalLink(
                  context,
                  'Allgemeine Geschäftsbedingungen / Terms of Service',
                  '#agb',
                  Icons.gavel,
                ),
                _buildLegalLink(
                  context,
                  'Urheberrecht / Copyright',
                  '#urheberrecht',
                  Icons.copyright,
                ),
                _buildLegalLink(
                  context,
                  'Widerrufsrecht / Right of Withdrawal',
                  '#widerrufsrecht',
                  Icons.undo,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Licenses
            _buildSection(
              context,
              'Lizenzen / Licenses',
              [
                ListTile(
                  leading: const Icon(
                    Icons.code,
                    color: Color(0xFF29E0FF),
                  ),
                  title: const Text(
                    'Open Source Lizenzen anzeigen',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Zeigt alle verwendeten Open Source Lizenzen',
                    style: TextStyle(color: Color(0xFFB0B5D0)),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF29E0FF),
                  ),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'QuantumResonanz',
                      applicationVersion: _appVersion,
                      applicationIcon: Image.asset(
                        'assets/images/quantumresonanz_icon_tuningfork.png',
                        width: 48,
                        height: 48,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF29E0FF),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F1A2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF29E0FF).withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF29E0FF)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          color: Color(0xFFB0B5D0),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    LanguageService languageService,
  ) {
    return ListTile(
      leading: const Icon(
        Icons.language,
        color: Color(0xFF29E0FF),
      ),
      title: const Text(
        'Sprache / Language',
        style: TextStyle(color: Colors.white),
      ),
      trailing: DropdownButton<Locale>(
        value: languageService.locale,
        underline: Container(),
        dropdownColor: const Color(0xFF111427),
        style: const TextStyle(color: Colors.white),
        items: const [
          DropdownMenuItem(
            value: Locale('de'),
            child: Text('Deutsch'),
          ),
          DropdownMenuItem(
            value: Locale('en'),
            child: Text('English'),
          ),
        ],
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            languageService.setLanguage(newLocale);
            HapticFeedback.lightImpact();
          }
        },
      ),
    );
  }

  Widget _buildLegalLink(
    BuildContext context,
    String title,
    String anchor,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF29E0FF)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF29E0FF),
      ),
      onTap: () => _openLegalPage(anchor),
    );
  }
}

