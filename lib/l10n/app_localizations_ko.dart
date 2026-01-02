// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'Bio Resonance Scanner';

  @override
  String get appSubtitle => '에너지 공간 조화';

  @override
  String get appDescription =>
      '공간의 미묘한 진동을 포착하고 전체적인 조화를 위한 개인적인 에너지 공명 프로필을 만드세요.';

  @override
  String get appDescriptionLong =>
      'Bio Resonance Scanner는 10초 동안 공간의 에너지 본질을 듣습니다. 공간 에너지의 깊은 명상적 분석을 통해 방해하는 진동이 식별되고 조화로운 공명 패턴으로 변환됩니다. 귀하의 에너지 데이터는 완전히 보호되며 기기에서 로컬로 유지됩니다.';

  @override
  String get pathToHarmonization => '에너지 조화로의 길:';

  @override
  String get roomCaptureTitle => '에너지 공간 캡처 (10초)';

  @override
  String get roomCaptureBody =>
      '이 깊은 침묵 동안 우리는 공간의 보이지 않는 진동을 포착합니다. 말이나 큰 방해는 미묘한 수준과의 연결을 중단합니다 – 완전한 침묵을 유지해 주세요.';

  @override
  String get decodingTitle => '에너지 진동 디코딩';

  @override
  String get decodingBody =>
      '각 주파수는 고유한 에너지 서명으로 인식되고 분석됩니다. 차단과 불조화가 식별되고 일관된 공명 필드로 변환됩니다.';

  @override
  String get synthesisTitle => '합성 및 반대 신호';

  @override
  String get synthesisBody =>
      '세그먼트에서 부드러운 공명 패턴이 나타납니다. 이것으로부터 \"반대 신호\"가 생성되며, 이는 음향적으로 노이즈 프로필을 반영합니다.';

  @override
  String get startScan => '에너지 스캔 시작';

  @override
  String get savedRooms => '에너지 아카이브';

  @override
  String get archiveRoom => '에너지 공간 보관';

  @override
  String get roomNameLabel => '에너지 공간 이름';

  @override
  String get roomNameRequired => '이 에너지 공간에 이름을 지정해 주세요';

  @override
  String get back => '뒤로';

  @override
  String get archive => '보관';

  @override
  String roomArchivedSuccess(String name) {
    return '에너지 공간 \"$name\"이(가) 성공적으로 보관되었습니다';
  }

  @override
  String get archiveFailed => '에너지 보관을 완료할 수 없었습니다';

  @override
  String get recordingInProgress => '에너지 캡처 실행 중…';

  @override
  String get recordingInstructions => '완전한 침묵에 몰입하고 공간의 미묘한 진동에 열어주세요.';

  @override
  String get vibrationIntensity => '에너지 진동 강도';

  @override
  String get optimalConnection =>
      '최적의 연결을 위해: 기기를 조용히 놓고 내적으로 중심을 잡으세요. 모든 움직임이 미세한 에너지 연결을 방해합니다.';

  @override
  String get calibrationTitle => '에너지 기본 보정';

  @override
  String get calibrationBody =>
      '이 단계에서 우리는 공간의 기본 진동과 연결됩니다. 개인적인 에너지 필드를 최적으로 포착할 수 있도록 잠시 멈춰 주세요.';

  @override
  String get baseVibrations => '에너지 기본 진동';

  @override
  String get calibrationNote =>
      '이 에너지 조정은 필요할 때만 발생합니다. 개인 공간의 고유한 진동에 대한 정확한 연결을 보장합니다.';

  @override
  String get connectionInterrupted => '에너지 연결 중단';

  @override
  String get connectionInterruptedBody =>
      '에너지 연결이 불조화 진동에 의해 방해되었습니다. 다시 시도하고 공간이 완전한 명상적 침묵 속에서 진동하도록 허용해 주세요.';

  @override
  String get detectedDisharmony => '감지된 에너지 불조화:';

  @override
  String get energeticRestart => '에너지 새로운 시작';

  @override
  String get deepAnalysis => '에너지 진동 심층 분석…';

  @override
  String get frequencyExtraction => '미묘한 주파수가 에너지 매트릭스에서 추출되고 있습니다…';

  @override
  String get calibrateBasis => '에너지 기본 보정';

  @override
  String get exploreResonance => '공명 필드 탐색';

  @override
  String get identifyBlockages => '미묘한 차단 식별';

  @override
  String get detectedSignatures => '감지된 에너지 서명';

  @override
  String signaturesDetected(int count) {
    return '공간의 명상적 침묵에서 $count개의 고유한 에너지 공명 패턴이 인식되고 디코딩되었습니다.';
  }

  @override
  String energySignature(int number) {
    return '에너지 서명 $number';
  }

  @override
  String vibrationIntensityValue(String value) {
    return '진동 강도: $value';
  }

  @override
  String get harmonizationLevel => '조화 수준';

  @override
  String get generateResonance => '공명 주파수 생성';

  @override
  String get resonanceProfileCreating => '공명 프로필을 생성하는 중…';

  @override
  String get alchemicalTransformation =>
      '연금술적 변환을 통해 모든 에너지 서명이 조화로운 공명 패턴으로 융합됩니다.';

  @override
  String get signatureTransformation =>
      '감지된 각 에너지 서명은 순수한 공명 주파수로 변환되어 고유한 조화 신호로 융합됩니다.';

  @override
  String get emergingSignal => '나타나는 조화 신호';

  @override
  String get decodeImpulses => '에너지 임펄스 디코딩 중…';

  @override
  String get harmonizeVibrations => '진동 조화 중…';

  @override
  String get resonanceManifestation => '공명 현현…';

  @override
  String get yourResonanceSignal => '귀하의 공명 신호';

  @override
  String get playSignalDescription =>
      '이 조화 신호를 재생하여 불조화 에너지를 변환하고, 차단을 해제하며, 공간 에너지를 완벽한 균형으로 가져오세요.';

  @override
  String get activateResonance => '공명 주파수 활성화';

  @override
  String get pauseHarmonization => '조화 일시 중지';

  @override
  String get stopHarmonization => '조화 중지';

  @override
  String get newHarmonization => '새로운 조화';

  @override
  String get onboardingTitle => '온보딩';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingBack => '뒤로';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingStart => '시작';

  @override
  String get onboardingWelcomeTitle => 'Bio Resonance Scanner에 오신 것을 환영합니다';

  @override
  String get onboardingWelcomeDescription =>
      '방의 미세한 진동을 포착하여 개인 맞춤형 조화 공명 프로파일을 만듭니다.';

  @override
  String get onboardingHowToUseTitle => '사용 방법';

  @override
  String get onboardingHowToUseStep1 => '조용한 곳을 찾고 휴대폰을 고정한 뒤 깊게 호흡하세요.';

  @override
  String get onboardingHowToUseStep2 =>
      '10초 스캔을 시작하고 조용히 유지하세요. 공간의 에너지를 앱이 듣도록 합니다.';

  @override
  String get onboardingHowToUseStep3 => '분석 후 조화 공명을 재생하여 균형을 느껴보세요.';

  @override
  String get onboardingPermissionTitle => '마이크 접근';

  @override
  String get onboardingPermissionDescription =>
      '공간의 진동을 감지하려면 마이크 접근이 필요합니다. 최상의 결과를 위해 스캔 중에는 조용히 해주세요.';

  @override
  String get onboardingPermissionButton => '마이크 허용';

  @override
  String get onboardingPermissionGranted => '마이크가 허용되었습니다. 스캔할 준비가 되었습니다.';

  @override
  String get onboardingPermissionDenied => '마이크가 거부되었습니다. 스캔을 활성화하려면 허용해 주세요.';

  @override
  String get onboardingPermissionPermanentlyDenied =>
      '마이크가 영구적으로 거부되었습니다. 스캔하려면 시스템 설정에서 활성화하세요.';

  @override
  String get onboardingPermissionRestricted => '이 기기에서는 마이크 접근이 제한되어 있습니다.';

  @override
  String get onboardingPermissionLimited =>
      '마이크 접근이 제한적입니다. 완전한 접근이 최고의 스캔을 보장합니다.';

  @override
  String get onboardingPermissionUnknown => '마이크 상태를 알 수 없습니다.';

  @override
  String get onboardingSavingTitle => '저장 및 재생';

  @override
  String get onboardingSavingDescription =>
      '공명 결과를 “에너지 공간”으로 보관하고 언제든 재생하여 재조화를 수행하세요.';

  @override
  String get onboardingGetStartedTitle => '준비 완료';

  @override
  String get onboardingGetStartedDescription =>
      '지금 첫 스캔을 시작하세요. 설정에서 언제든 이 온보딩을 다시 볼 수 있습니다.';

  @override
  String get onboardingReplayHint => '팁: 설정에서 언제든 온보딩을 다시 재생할 수 있습니다.';

  @override
  String get showOnboarding => '온보딩 보기';

  @override
  String get showOnboardingDesc => '가이드와 권한 요청을 다시 표시';

  @override
  String get settings => '설정';

  @override
  String get appInfo => '앱 정보';

  @override
  String get version => '버전';

  @override
  String get language => '언어';

  @override
  String get legalInfo => '법적 정보';

  @override
  String get legalNotice => '법적 고지';

  @override
  String get privacyPolicy => '개인정보 보호정책';

  @override
  String get disclaimer => '면책 조항';

  @override
  String get termsOfService => '서비스 약관';

  @override
  String get copyright => '저작권';

  @override
  String get rightOfWithdrawal => '철회권';

  @override
  String get licenses => '라이선스';

  @override
  String get showOpenSourceLicenses => '오픈 소스 라이선스 표시';

  @override
  String get showOpenSourceLicensesDesc => '사용된 모든 오픈 소스 라이선스를 표시합니다';

  @override
  String get error => '오류';

  @override
  String legalInfoError(String error) {
    return '법적 정보를 열 수 없습니다.\n\n$error';
  }

  @override
  String get ok => '확인';

  @override
  String get renameRoom => '에너지 공간 이름 변경';

  @override
  String get name => '이름';

  @override
  String get deleteRoom => '에너지 공간 삭제';

  @override
  String deleteRoomConfirm(String name) {
    return '에너지 아카이브 \"$name\"을(를) 저장소에서 정말로 제거하시겠습니까?';
  }

  @override
  String get remove => '제거';

  @override
  String get noRoomsArchived => '아직 보관된 에너지 공간이 없습니다';

  @override
  String get noRoomsDescription =>
      '에너지 스캔을 수행하고 공간을 조화시키기 위한 개인적인 공명 프로필을 보존하세요.';

  @override
  String get changeName => '이름 변경';

  @override
  String get removeFromArchive => '아카이브에서 제거';

  @override
  String get loading => '로딩 중...';

  @override
  String get unknown => '알 수 없음';

  @override
  String couldNotLaunchUrl(String error) {
    return 'URL을 열 수 없습니다: $error';
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
    return '에너지 서명 $index / $count';
  }

  @override
  String get energyTextLow => '공간 에너지의 부드러운 기본 진동, 조화롭게 흐르는';

  @override
  String get energyTextMedium => '에너지 공명 필드의 활기찬 미묘한 임펄스';

  @override
  String get energyTextHigh => '변환의 힘을 가진 고도로 농축된 에너지 밀도';

  @override
  String get freqTextLow => '차크라 시스템의 접지 깊은 주파수에 뿌리를 둔';

  @override
  String get freqTextMedium => '모든 미묘한 수준을 통한 균형 잡힌 진동';

  @override
  String get freqTextHigh => '영적 개방으로 이끄는 숭고한 고주파 에너지';

  @override
  String get movementTextLow => '명상적으로 균일하고, 오라를 진정시키는';

  @override
  String get movementTextMedium => '부드럽게 맥동하며, 조화로운 일관성으로 차단을 용해하는';

  @override
  String get movementTextHigh => '역동적으로 변환하며, 에너지 구조의 집중적인 정화';

  @override
  String resonanceFrequencyAt(int freqHz) {
    return '공명 주파수 약 $freqHz Hz';
  }
}
