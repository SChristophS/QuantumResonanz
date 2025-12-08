import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../l10n/app_localizations.dart';
import '../../services/onboarding_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    this.replayMode = false,
    this.onFinished,
  });

  final bool replayMode;
  final VoidCallback? onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final OnboardingService _onboardingService = OnboardingService();
  int _currentIndex = 0;
  bool _requestingPermission = false;
  PermissionStatus? _micStatus;

  @override
  void initState() {
    super.initState();
    _loadPermissionStatus();
  }

  Future<void> _loadPermissionStatus() async {
    final status = await Permission.microphone.status;
    if (mounted) {
      setState(() {
        _micStatus = status;
      });
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _requestingPermission = true;
    });
    final status = await Permission.microphone.request();
    if (mounted) {
      setState(() {
        _micStatus = status;
        _requestingPermission = false;
      });
    }
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    await _onboardingService.markOnboardingCompleted();
    if (widget.onFinished != null) {
      widget.onFinished!.call();
    } else if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _buildPages(l10n);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF050712),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  if (_currentIndex > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => _goToPage((_currentIndex - 1).clamp(0, pages.length - 1)),
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.onboardingTitle,
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _goToPage(pages.length - 1),
                    child: Text(
                      l10n.onboardingSkip,
                      style: const TextStyle(color: Color(0xFF29E0FF)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (context, index) => pages[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == i ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == i
                              ? const Color(0xFF29E0FF)
                              : const Color(0xFF1A1F36),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (_currentIndex > 0)
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF29E0FF),
                              side: const BorderSide(color: Color(0xFF29E0FF)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => _goToPage(_currentIndex - 1),
                            child: Text(l10n.onboardingBack),
                          ),
                        )
                      else
                        const SizedBox(width: 16),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentIndex == pages.length - 1) {
                              _finish();
                            } else {
                              _goToPage(_currentIndex + 1);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF29E0FF),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            _currentIndex == pages.length - 1
                                ? l10n.onboardingStart
                                : l10n.onboardingNext,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPages(AppLocalizations l10n) {
    final theme = Theme.of(context);

    return [
      _OnboardingPage(
        title: l10n.onboardingWelcomeTitle,
        body: l10n.onboardingWelcomeDescription,
        image: 'assets/images/quantumresonanz_hero_silence_scan.png',
      ),
      _OnboardingListPage(
        title: l10n.onboardingHowToUseTitle,
        steps: [
          l10n.onboardingHowToUseStep1,
          l10n.onboardingHowToUseStep2,
          l10n.onboardingHowToUseStep3,
        ],
        image: 'assets/images/quantumresonanz_scan_5s_timeline.png',
      ),
      _PermissionPage(
        title: l10n.onboardingPermissionTitle,
        body: l10n.onboardingPermissionDescription,
        image: 'assets/images/quantumresonanz_icon_tuningfork.png',
        micStatus: _micStatus,
        requesting: _requestingPermission,
        onRequest: _requestPermission,
      ),
      _OnboardingPage(
        title: l10n.onboardingSavingTitle,
        body: l10n.onboardingSavingDescription,
        image: 'assets/images/quantumresonanz_segments_cards.png',
      ),
      _OnboardingPage(
        title: l10n.onboardingGetStartedTitle,
        body: l10n.onboardingGetStartedDescription,
        image: 'assets/images/quantumresonanz_result_dashboard.png',
        footer: Text(
          l10n.onboardingReplayHint,
          style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF9AA1C5)),
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.title,
    required this.body,
    required this.image,
    this.footer,
  });

  final String title;
  final String body;
  final String image;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (footer != null) ...[
            const SizedBox(height: 16),
            footer!,
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _OnboardingListPage extends StatelessWidget {
  const _OnboardingListPage({
    required this.title,
    required this.steps,
    required this.image,
  });

  final String title;
  final List<String> steps;
  final String image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Column(
            children: steps
                .map(
                  (step) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF29E0FF), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            step,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _PermissionPage extends StatelessWidget {
  const _PermissionPage({
    required this.title,
    required this.body,
    required this.image,
    required this.micStatus,
    required this.requesting,
    required this.onRequest,
  });

  final String title;
  final String body;
  final String image;
  final PermissionStatus? micStatus;
  final bool requesting;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusText = _statusText(context, micStatus);
    final statusColor = _statusColor(micStatus);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: const Color(0xFF0C0F1E),
                child: Center(
                  child: Image.asset(image, width: 120, height: 120),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF111427),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Icon(
                  micStatus == PermissionStatus.granted ? Icons.check_circle : Icons.mic,
                  color: statusColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    statusText,
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: requesting ? null : onRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29E0FF),
                    foregroundColor: Colors.black,
                  ),
                  child: requesting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : Text(AppLocalizations.of(context)!.onboardingPermissionButton),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _statusText(BuildContext context, PermissionStatus? status) {
    final l10n = AppLocalizations.of(context)!;
    if (status == null) return l10n.onboardingPermissionUnknown;
    switch (status) {
      case PermissionStatus.granted:
        return l10n.onboardingPermissionGranted;
      case PermissionStatus.denied:
        return l10n.onboardingPermissionDenied;
      case PermissionStatus.permanentlyDenied:
        return l10n.onboardingPermissionPermanentlyDenied;
      case PermissionStatus.restricted:
        return l10n.onboardingPermissionRestricted;
      case PermissionStatus.limited:
        return l10n.onboardingPermissionLimited;
      default:
        return l10n.onboardingPermissionUnknown;
    }
  }

  Color _statusColor(PermissionStatus? status) {
    if (status == PermissionStatus.granted) {
      return const Color(0xFF29E0FF);
    }
    return Colors.amberAccent;
  }
}

