import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('zh'),
    Locale('zh', 'CN')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'QuantumResonanz'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Energetic Room Harmonization'**
  String get appSubtitle;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Capture the subtle vibrations of your room and create your personal energetic resonance profile for holistic harmonization.'**
  String get appDescription;

  /// No description provided for @appDescriptionLong.
  ///
  /// In en, this message translates to:
  /// **'QuantumResonanz listens for 10 seconds into the energetic essence of your room. Through deep meditative analysis of room energies, disruptive vibrations are identified and transformed into a harmonizing resonance pattern. Your energetic data remains fully protected and local on your device.'**
  String get appDescriptionLong;

  /// No description provided for @pathToHarmonization.
  ///
  /// In en, this message translates to:
  /// **'The path to energetic harmonization:'**
  String get pathToHarmonization;

  /// No description provided for @roomCaptureTitle.
  ///
  /// In en, this message translates to:
  /// **'Energetic Room Capture (10 seconds)'**
  String get roomCaptureTitle;

  /// No description provided for @roomCaptureBody.
  ///
  /// In en, this message translates to:
  /// **'During this deep silence, we capture the invisible vibrations of your room. Speech or loud disturbances interrupt the connection to the subtle level – please maintain complete silence.'**
  String get roomCaptureBody;

  /// No description provided for @decodingTitle.
  ///
  /// In en, this message translates to:
  /// **'Decoding Energy Vibrations'**
  String get decodingTitle;

  /// No description provided for @decodingBody.
  ///
  /// In en, this message translates to:
  /// **'Each frequency is recognized and analyzed as a unique energetic signature. Blockages and disharmonies are identified and transformed into a coherent resonance field.'**
  String get decodingBody;

  /// No description provided for @synthesisTitle.
  ///
  /// In en, this message translates to:
  /// **'Synthesis & Counter-Signal'**
  String get synthesisTitle;

  /// No description provided for @synthesisBody.
  ///
  /// In en, this message translates to:
  /// **'A smoothed resonance pattern emerges from the segments. A \"Counter Signal\" is generated from this, which acoustically reflects your noise profile.'**
  String get synthesisBody;

  /// No description provided for @startScan.
  ///
  /// In en, this message translates to:
  /// **'Start Energetic Scan'**
  String get startScan;

  /// No description provided for @savedRooms.
  ///
  /// In en, this message translates to:
  /// **'Energetic Archives'**
  String get savedRooms;

  /// No description provided for @archiveRoom.
  ///
  /// In en, this message translates to:
  /// **'Archive Energy Room'**
  String get archiveRoom;

  /// No description provided for @roomNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name of the Energy Room'**
  String get roomNameLabel;

  /// No description provided for @roomNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please give this energy room a name'**
  String get roomNameRequired;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @roomArchivedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Energy room \"{name}\" has been successfully archived'**
  String roomArchivedSuccess(String name);

  /// No description provided for @archiveFailed.
  ///
  /// In en, this message translates to:
  /// **'The energetic archiving could not be completed'**
  String get archiveFailed;

  /// No description provided for @recordingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Energetic capture running…'**
  String get recordingInProgress;

  /// No description provided for @recordingInstructions.
  ///
  /// In en, this message translates to:
  /// **'Immerse yourself in complete silence and open yourself to the subtle vibrations of your room.'**
  String get recordingInstructions;

  /// No description provided for @vibrationIntensity.
  ///
  /// In en, this message translates to:
  /// **'Energetic Vibration Intensity'**
  String get vibrationIntensity;

  /// No description provided for @optimalConnection.
  ///
  /// In en, this message translates to:
  /// **'For optimal connection: Place the device quietly and center yourself inwardly. Every movement disturbs the fine energetic connection.'**
  String get optimalConnection;

  /// No description provided for @calibrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Energetic Base Calibration'**
  String get calibrationTitle;

  /// No description provided for @calibrationBody.
  ///
  /// In en, this message translates to:
  /// **'In this phase, we connect with the fundamental vibrations of your room. Take a moment to pause so we can optimally capture your individual energetic field.'**
  String get calibrationBody;

  /// No description provided for @baseVibrations.
  ///
  /// In en, this message translates to:
  /// **'Energetic Base Vibrations'**
  String get baseVibrations;

  /// No description provided for @calibrationNote.
  ///
  /// In en, this message translates to:
  /// **'This energetic tuning only occurs when needed. It ensures a precise connection to the unique vibrations of your personal room.'**
  String get calibrationNote;

  /// No description provided for @connectionInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Energetic Connection Interrupted'**
  String get connectionInterrupted;

  /// No description provided for @connectionInterruptedBody.
  ///
  /// In en, this message translates to:
  /// **'The energetic connection was disturbed by disharmonic vibrations. Please try again and allow the room to vibrate in complete meditative silence.'**
  String get connectionInterruptedBody;

  /// No description provided for @detectedDisharmony.
  ///
  /// In en, this message translates to:
  /// **'Detected energetic disharmony:'**
  String get detectedDisharmony;

  /// No description provided for @energeticRestart.
  ///
  /// In en, this message translates to:
  /// **'Energetic New Beginning'**
  String get energeticRestart;

  /// No description provided for @deepAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Deep Analysis of Energy Vibrations…'**
  String get deepAnalysis;

  /// No description provided for @frequencyExtraction.
  ///
  /// In en, this message translates to:
  /// **'The subtle frequencies are being extracted from the energetic matrix…'**
  String get frequencyExtraction;

  /// No description provided for @calibrateBasis.
  ///
  /// In en, this message translates to:
  /// **'Calibrate energetic basis'**
  String get calibrateBasis;

  /// No description provided for @exploreResonance.
  ///
  /// In en, this message translates to:
  /// **'Explore resonance field'**
  String get exploreResonance;

  /// No description provided for @identifyBlockages.
  ///
  /// In en, this message translates to:
  /// **'Identify subtle blockages'**
  String get identifyBlockages;

  /// No description provided for @detectedSignatures.
  ///
  /// In en, this message translates to:
  /// **'Detected Energy Signatures'**
  String get detectedSignatures;

  /// No description provided for @signaturesDetected.
  ///
  /// In en, this message translates to:
  /// **'From the meditative silence of your room, {count} unique energetic resonance patterns were recognized and decoded.'**
  String signaturesDetected(int count);

  /// No description provided for @energySignature.
  ///
  /// In en, this message translates to:
  /// **'Energy Signature {number}'**
  String energySignature(int number);

  /// No description provided for @vibrationIntensityValue.
  ///
  /// In en, this message translates to:
  /// **'Vibration Intensity: {value}'**
  String vibrationIntensityValue(String value);

  /// No description provided for @harmonizationLevel.
  ///
  /// In en, this message translates to:
  /// **'Harmonization Level'**
  String get harmonizationLevel;

  /// No description provided for @generateResonance.
  ///
  /// In en, this message translates to:
  /// **'Generate Resonance Frequency'**
  String get generateResonance;

  /// No description provided for @resonanceProfileCreating.
  ///
  /// In en, this message translates to:
  /// **'Your resonance profile is being created…'**
  String get resonanceProfileCreating;

  /// No description provided for @alchemicalTransformation.
  ///
  /// In en, this message translates to:
  /// **'Through alchemical transformation, all energy signatures are merged into a harmonizing resonance pattern.'**
  String get alchemicalTransformation;

  /// No description provided for @signatureTransformation.
  ///
  /// In en, this message translates to:
  /// **'Each detected energy signature is transformed into pure resonance frequencies and merged into your unique harmonization signal.'**
  String get signatureTransformation;

  /// No description provided for @emergingSignal.
  ///
  /// In en, this message translates to:
  /// **'Emerging Harmonization Signal'**
  String get emergingSignal;

  /// No description provided for @decodeImpulses.
  ///
  /// In en, this message translates to:
  /// **'Decoding energetic impulses…'**
  String get decodeImpulses;

  /// No description provided for @harmonizeVibrations.
  ///
  /// In en, this message translates to:
  /// **'Harmonizing vibrations…'**
  String get harmonizeVibrations;

  /// No description provided for @resonanceManifestation.
  ///
  /// In en, this message translates to:
  /// **'Resonance manifestation…'**
  String get resonanceManifestation;

  /// No description provided for @yourResonanceSignal.
  ///
  /// In en, this message translates to:
  /// **'Your Resonance Signal'**
  String get yourResonanceSignal;

  /// No description provided for @playSignalDescription.
  ///
  /// In en, this message translates to:
  /// **'Play this harmonizing signal to transform disharmonic energies, release blockages, and bring your room energy into perfect balance.'**
  String get playSignalDescription;

  /// No description provided for @activateResonance.
  ///
  /// In en, this message translates to:
  /// **'Activate Resonance Frequency'**
  String get activateResonance;

  /// No description provided for @pauseHarmonization.
  ///
  /// In en, this message translates to:
  /// **'Pause Harmonization'**
  String get pauseHarmonization;

  /// No description provided for @newHarmonization.
  ///
  /// In en, this message translates to:
  /// **'New Harmonization'**
  String get newHarmonization;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInfo;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @legalInfo.
  ///
  /// In en, this message translates to:
  /// **'Legal Information'**
  String get legalInfo;

  /// No description provided for @legalNotice.
  ///
  /// In en, this message translates to:
  /// **'Legal Notice'**
  String get legalNotice;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'Copyright'**
  String get copyright;

  /// No description provided for @rightOfWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Right of Withdrawal'**
  String get rightOfWithdrawal;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @showOpenSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Show Open Source Licenses'**
  String get showOpenSourceLicenses;

  /// No description provided for @showOpenSourceLicensesDesc.
  ///
  /// In en, this message translates to:
  /// **'Shows all used Open Source licenses'**
  String get showOpenSourceLicensesDesc;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @legalInfoError.
  ///
  /// In en, this message translates to:
  /// **'The legal information could not be opened.\n\n{error}'**
  String legalInfoError(String error);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @renameRoom.
  ///
  /// In en, this message translates to:
  /// **'Rename Energy Room'**
  String get renameRoom;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @deleteRoom.
  ///
  /// In en, this message translates to:
  /// **'Delete Energy Room'**
  String get deleteRoom;

  /// No description provided for @deleteRoomConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to remove the energetic archive \"{name}\" from storage?'**
  String deleteRoomConfirm(String name);

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @noRoomsArchived.
  ///
  /// In en, this message translates to:
  /// **'No energy rooms archived yet'**
  String get noRoomsArchived;

  /// No description provided for @noRoomsDescription.
  ///
  /// In en, this message translates to:
  /// **'Perform an energetic scan and preserve your personal resonance profile for harmonizing your rooms.'**
  String get noRoomsDescription;

  /// No description provided for @changeName.
  ///
  /// In en, this message translates to:
  /// **'Change Name'**
  String get changeName;

  /// No description provided for @removeFromArchive.
  ///
  /// In en, this message translates to:
  /// **'Remove from Archive'**
  String get removeFromArchive;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @couldNotLaunchUrl.
  ///
  /// In en, this message translates to:
  /// **'Could not launch URL: {error}'**
  String couldNotLaunchUrl(String error);

  /// No description provided for @languageDeutsch.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageDeutsch;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'中文 (简体)'**
  String get languageChinese;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português (Brasil)'**
  String get languagePortuguese;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// No description provided for @languageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @energySignatureOf.
  ///
  /// In en, this message translates to:
  /// **'Energy Signature {index} of {count}'**
  String energySignatureOf(int index, int count);

  /// No description provided for @energyTextLow.
  ///
  /// In en, this message translates to:
  /// **'gentle fundamental vibration of room energy, harmoniously flowing'**
  String get energyTextLow;

  /// No description provided for @energyTextMedium.
  ///
  /// In en, this message translates to:
  /// **'lively subtle impulses in the energetic resonance field'**
  String get energyTextMedium;

  /// No description provided for @energyTextHigh.
  ///
  /// In en, this message translates to:
  /// **'highly concentrated energy density with transformative power'**
  String get energyTextHigh;

  /// No description provided for @freqTextLow.
  ///
  /// In en, this message translates to:
  /// **'rooted in the grounding deep frequencies of the chakra system'**
  String get freqTextLow;

  /// No description provided for @freqTextMedium.
  ///
  /// In en, this message translates to:
  /// **'balanced vibration through all subtle levels'**
  String get freqTextMedium;

  /// No description provided for @freqTextHigh.
  ///
  /// In en, this message translates to:
  /// **'sublime high-frequency energies leading to spiritual opening'**
  String get freqTextHigh;

  /// No description provided for @movementTextLow.
  ///
  /// In en, this message translates to:
  /// **'meditatively uniform, calming for the aura'**
  String get movementTextLow;

  /// No description provided for @movementTextMedium.
  ///
  /// In en, this message translates to:
  /// **'gently pulsating, dissolving blockages with harmonic coherence'**
  String get movementTextMedium;

  /// No description provided for @movementTextHigh.
  ///
  /// In en, this message translates to:
  /// **'dynamically transforming, intensive cleansing of energy structures'**
  String get movementTextHigh;

  /// No description provided for @resonanceFrequencyAt.
  ///
  /// In en, this message translates to:
  /// **'Resonance frequency at approximately {freqHz} Hz'**
  String resonanceFrequencyAt(int freqHz);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'ja',
        'ko',
        'pt',
        'ru',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
