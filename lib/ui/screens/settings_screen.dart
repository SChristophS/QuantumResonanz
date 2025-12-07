import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../services/language_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';
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
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(() {
          final errorL10n = AppLocalizations.of(context);
          _appVersion = errorL10n?.unknown ?? '';
        });
      }
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
          final l10n = AppLocalizations.of(context);
          final errorMsg = l10n?.couldNotLaunchUrl(e2.toString()) ?? 'Could not launch URL: ${e2.toString()}';
          throw Exception(errorMsg);
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111427),
        title: Text(
          l10n.error,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l10n.legalInfoError(error),
          style: const TextStyle(color: Color(0xFFB0B5D0)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.ok,
              style: const TextStyle(color: Color(0xFF29E0FF)),
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF050712),
      appBar: AppBar(
        title: Text(l10n.settings),
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
              l10n.appInfo,
              [
                _buildInfoTile(
                  context,
                  l10n.version,
                  _appVersion.isEmpty 
                    ? l10n.loading 
                    : '$_appVersion+$_buildNumber',
                  Icons.info_outline,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Language Selection
            _buildSection(
              context,
              l10n.language,
              [
                _buildLanguageSelector(context, languageService),
              ],
            ),
            const SizedBox(height: 24),

            // Legal Links
            _buildSection(
              context,
              l10n.legalInfo,
              [
                _buildLegalLink(
                  context,
                  l10n.legalNotice,
                  '#impressum',
                  Icons.description,
                ),
                _buildLegalLink(
                  context,
                  l10n.privacyPolicy,
                  '#datenschutz',
                  Icons.privacy_tip,
                ),
                _buildLegalLink(
                  context,
                  l10n.disclaimer,
                  '#haftungsausschluss',
                  Icons.warning,
                ),
                _buildLegalLink(
                  context,
                  l10n.termsOfService,
                  '#agb',
                  Icons.gavel,
                ),
                _buildLegalLink(
                  context,
                  l10n.copyright,
                  '#urheberrecht',
                  Icons.copyright,
                ),
                _buildLegalLink(
                  context,
                  l10n.rightOfWithdrawal,
                  '#widerrufsrecht',
                  Icons.undo,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Licenses
            _buildSection(
              context,
              l10n.licenses,
              [
                ListTile(
                  leading: const Icon(
                    Icons.code,
                    color: Color(0xFF29E0FF),
                  ),
                  title: Text(
                    l10n.showOpenSourceLicenses,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    l10n.showOpenSourceLicensesDesc,
                    style: const TextStyle(color: Color(0xFFB0B5D0)),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF29E0FF),
                  ),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: AppLocalizations.of(context)!.appName,
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
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(
        Icons.language,
        color: Color(0xFF29E0FF),
      ),
      title: Text(
        l10n.language,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: DropdownButton<Locale>(
        value: languageService.locale,
        underline: Container(),
        dropdownColor: const Color(0xFF111427),
        style: const TextStyle(color: Colors.white),
        items: [
          DropdownMenuItem(
            value: const Locale('de'),
            child: Text(l10n.languageDeutsch),
          ),
          DropdownMenuItem(
            value: const Locale('en'),
            child: Text(l10n.languageEnglish),
          ),
          DropdownMenuItem(
            value: const Locale('zh', 'CN'),
            child: Text(l10n.languageChinese),
          ),
          DropdownMenuItem(
            value: const Locale('es'),
            child: Text(l10n.languageSpanish),
          ),
          DropdownMenuItem(
            value: const Locale('ja'),
            child: Text(l10n.languageJapanese),
          ),
          DropdownMenuItem(
            value: const Locale('fr'),
            child: Text(l10n.languageFrench),
          ),
          DropdownMenuItem(
            value: const Locale('pt', 'BR'),
            child: Text(l10n.languagePortuguese),
          ),
          DropdownMenuItem(
            value: const Locale('ko'),
            child: Text(l10n.languageKorean),
          ),
          DropdownMenuItem(
            value: const Locale('it'),
            child: Text(l10n.languageItalian),
          ),
          DropdownMenuItem(
            value: const Locale('ru'),
            child: Text(l10n.languageRussian),
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

