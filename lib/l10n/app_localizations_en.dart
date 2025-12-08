// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Bio Resonance Scanner';

  @override
  String get appSubtitle => 'Energetic Room Harmonization';

  @override
  String get appDescription =>
      'Capture the subtle vibrations of your room and create your personal energetic resonance profile for holistic harmonization.';

  @override
  String get appDescriptionLong =>
      'Bio Resonance Scanner listens for 10 seconds into the energetic essence of your room. Through deep meditative analysis of room energies, disruptive vibrations are identified and transformed into a harmonizing resonance pattern. Your energetic data remains fully protected and local on your device.';

  @override
  String get pathToHarmonization => 'The path to energetic harmonization:';

  @override
  String get roomCaptureTitle => 'Energetic Room Capture (10 seconds)';

  @override
  String get roomCaptureBody =>
      'During this deep silence, we capture the invisible vibrations of your room. Speech or loud disturbances interrupt the connection to the subtle level – please maintain complete silence.';

  @override
  String get decodingTitle => 'Decoding Energy Vibrations';

  @override
  String get decodingBody =>
      'Each frequency is recognized and analyzed as a unique energetic signature. Blockages and disharmonies are identified and transformed into a coherent resonance field.';

  @override
  String get synthesisTitle => 'Synthesis & Counter-Signal';

  @override
  String get synthesisBody =>
      'A smoothed resonance pattern emerges from the segments. A \"Counter Signal\" is generated from this, which acoustically reflects your noise profile.';

  @override
  String get startScan => 'Start Energetic Scan';

  @override
  String get savedRooms => 'Energetic Archives';

  @override
  String get archiveRoom => 'Archive Energy Room';

  @override
  String get roomNameLabel => 'Name of the Energy Room';

  @override
  String get roomNameRequired => 'Please give this energy room a name';

  @override
  String get back => 'Back';

  @override
  String get archive => 'Archive';

  @override
  String roomArchivedSuccess(String name) {
    return 'Energy room \"$name\" has been successfully archived';
  }

  @override
  String get archiveFailed => 'The energetic archiving could not be completed';

  @override
  String get recordingInProgress => 'Energetic capture running…';

  @override
  String get recordingInstructions =>
      'Immerse yourself in complete silence and open yourself to the subtle vibrations of your room.';

  @override
  String get vibrationIntensity => 'Energetic Vibration Intensity';

  @override
  String get optimalConnection =>
      'For optimal connection: Place the device quietly and center yourself inwardly. Every movement disturbs the fine energetic connection.';

  @override
  String get calibrationTitle => 'Energetic Base Calibration';

  @override
  String get calibrationBody =>
      'In this phase, we connect with the fundamental vibrations of your room. Take a moment to pause so we can optimally capture your individual energetic field.';

  @override
  String get baseVibrations => 'Energetic Base Vibrations';

  @override
  String get calibrationNote =>
      'This energetic tuning only occurs when needed. It ensures a precise connection to the unique vibrations of your personal room.';

  @override
  String get connectionInterrupted => 'Energetic Connection Interrupted';

  @override
  String get connectionInterruptedBody =>
      'The energetic connection was disturbed by disharmonic vibrations. Please try again and allow the room to vibrate in complete meditative silence.';

  @override
  String get detectedDisharmony => 'Detected energetic disharmony:';

  @override
  String get energeticRestart => 'Energetic New Beginning';

  @override
  String get deepAnalysis => 'Deep Analysis of Energy Vibrations…';

  @override
  String get frequencyExtraction =>
      'The subtle frequencies are being extracted from the energetic matrix…';

  @override
  String get calibrateBasis => 'Calibrate energetic basis';

  @override
  String get exploreResonance => 'Explore resonance field';

  @override
  String get identifyBlockages => 'Identify subtle blockages';

  @override
  String get detectedSignatures => 'Detected Energy Signatures';

  @override
  String signaturesDetected(int count) {
    return 'From the meditative silence of your room, $count unique energetic resonance patterns were recognized and decoded.';
  }

  @override
  String energySignature(int number) {
    return 'Energy Signature $number';
  }

  @override
  String vibrationIntensityValue(String value) {
    return 'Vibration Intensity: $value';
  }

  @override
  String get harmonizationLevel => 'Harmonization Level';

  @override
  String get generateResonance => 'Generate Resonance Frequency';

  @override
  String get resonanceProfileCreating =>
      'Your resonance profile is being created…';

  @override
  String get alchemicalTransformation =>
      'Through alchemical transformation, all energy signatures are merged into a harmonizing resonance pattern.';

  @override
  String get signatureTransformation =>
      'Each detected energy signature is transformed into pure resonance frequencies and merged into your unique harmonization signal.';

  @override
  String get emergingSignal => 'Emerging Harmonization Signal';

  @override
  String get decodeImpulses => 'Decoding energetic impulses…';

  @override
  String get harmonizeVibrations => 'Harmonizing vibrations…';

  @override
  String get resonanceManifestation => 'Resonance manifestation…';

  @override
  String get yourResonanceSignal => 'Your Resonance Signal';

  @override
  String get playSignalDescription =>
      'Play this harmonizing signal to transform disharmonic energies, release blockages, and bring your room energy into perfect balance.';

  @override
  String get activateResonance => 'Activate Resonance Frequency';

  @override
  String get pauseHarmonization => 'Pause Harmonization';

  @override
  String get newHarmonization => 'New Harmonization';

  @override
  String get onboardingTitle => 'Onboarding';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Start';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Bio Resonance Scanner';

  @override
  String get onboardingWelcomeDescription =>
      'Capture the subtle vibrations of your room to create a personal harmonizing resonance profile.';

  @override
  String get onboardingHowToUseTitle => 'How to use';

  @override
  String get onboardingHowToUseStep1 =>
      'Find a quiet spot. Place your phone still and take a deep breath.';

  @override
  String get onboardingHowToUseStep2 =>
      'Start the 10-second scan and stay silent. Let the app listen to your room’s energy.';

  @override
  String get onboardingHowToUseStep3 =>
      'After analysis, play the harmonizing resonance and feel the balance.';

  @override
  String get onboardingPermissionTitle => 'Microphone access';

  @override
  String get onboardingPermissionDescription =>
      'To sense the room’s vibrations, the app needs microphone access. Stay silent during the scan for the clearest result.';

  @override
  String get onboardingPermissionButton => 'Allow microphone';

  @override
  String get onboardingPermissionGranted =>
      'Microphone granted. You’re ready to scan.';

  @override
  String get onboardingPermissionDenied =>
      'Microphone denied. You can allow it to enable scanning.';

  @override
  String get onboardingPermissionPermanentlyDenied =>
      'Microphone denied permanently. Please enable it in system settings to scan.';

  @override
  String get onboardingPermissionRestricted =>
      'Microphone access is restricted on this device.';

  @override
  String get onboardingPermissionLimited =>
      'Microphone access is limited. Full access ensures best scans.';

  @override
  String get onboardingPermissionUnknown => 'Microphone status unknown.';

  @override
  String get onboardingSavingTitle => 'Save and revisit';

  @override
  String get onboardingSavingDescription =>
      'Archive your resonance results as “Energy Rooms” and replay them whenever you want to re-harmonize.';

  @override
  String get onboardingGetStartedTitle => 'You’re ready';

  @override
  String get onboardingGetStartedDescription =>
      'Begin your first scan now. You can always replay this onboarding from Settings.';

  @override
  String get onboardingReplayHint =>
      'Tip: You can replay the onboarding anytime via Settings.';

  @override
  String get showOnboarding => 'Show onboarding';

  @override
  String get showOnboardingDesc =>
      'Replay the guided introduction and permission request';

  @override
  String get settings => 'Settings';

  @override
  String get appInfo => 'App Information';

  @override
  String get version => 'Version';

  @override
  String get language => 'Language';

  @override
  String get legalInfo => 'Legal Information';

  @override
  String get legalNotice => 'Legal Notice';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get copyright => 'Copyright';

  @override
  String get rightOfWithdrawal => 'Right of Withdrawal';

  @override
  String get licenses => 'Licenses';

  @override
  String get showOpenSourceLicenses => 'Show Open Source Licenses';

  @override
  String get showOpenSourceLicensesDesc =>
      'Shows all used Open Source licenses';

  @override
  String get error => 'Error';

  @override
  String legalInfoError(String error) {
    return 'The legal information could not be opened.\n\n$error';
  }

  @override
  String get ok => 'OK';

  @override
  String get renameRoom => 'Rename Energy Room';

  @override
  String get name => 'Name';

  @override
  String get deleteRoom => 'Delete Energy Room';

  @override
  String deleteRoomConfirm(String name) {
    return 'Do you really want to remove the energetic archive \"$name\" from storage?';
  }

  @override
  String get remove => 'Remove';

  @override
  String get noRoomsArchived => 'No energy rooms archived yet';

  @override
  String get noRoomsDescription =>
      'Perform an energetic scan and preserve your personal resonance profile for harmonizing your rooms.';

  @override
  String get changeName => 'Change Name';

  @override
  String get removeFromArchive => 'Remove from Archive';

  @override
  String get loading => 'Loading...';

  @override
  String get unknown => 'Unknown';

  @override
  String couldNotLaunchUrl(String error) {
    return 'Could not launch URL: $error';
  }

  @override
  String get languageDeutsch => 'Deutsch';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '中文 (简体)';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageFrench => 'Français';

  @override
  String get languagePortuguese => 'Português (Brasil)';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageRussian => 'Русский';

  @override
  String energySignatureOf(int index, int count) {
    return 'Energy Signature $index of $count';
  }

  @override
  String get energyTextLow =>
      'gentle fundamental vibration of room energy, harmoniously flowing';

  @override
  String get energyTextMedium =>
      'lively subtle impulses in the energetic resonance field';

  @override
  String get energyTextHigh =>
      'highly concentrated energy density with transformative power';

  @override
  String get freqTextLow =>
      'rooted in the grounding deep frequencies of the chakra system';

  @override
  String get freqTextMedium => 'balanced vibration through all subtle levels';

  @override
  String get freqTextHigh =>
      'sublime high-frequency energies leading to spiritual opening';

  @override
  String get movementTextLow => 'meditatively uniform, calming for the aura';

  @override
  String get movementTextMedium =>
      'gently pulsating, dissolving blockages with harmonic coherence';

  @override
  String get movementTextHigh =>
      'dynamically transforming, intensive cleansing of energy structures';

  @override
  String resonanceFrequencyAt(int freqHz) {
    return 'Resonance frequency at approximately $freqHz Hz';
  }
}
