// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'QuantumResonanz';

  @override
  String get appSubtitle => 'エネルギールーム調和';

  @override
  String get appDescription =>
      'お部屋の微細な振動を捉え、全体的な調和のための個人的なエネルギーの共鳴プロファイルを作成します。';

  @override
  String get appDescriptionLong =>
      'QuantumResonanzは10秒間、お部屋のエネルギーの本質に耳を傾けます。ルームエネルギーの深い瞑想的分析を通じて、破壊的な振動が識別され、調和的な共鳴パターンに変換されます。お客様のエネルギーデータは完全に保護され、デバイス上にローカルに保存されます。';

  @override
  String get pathToHarmonization => 'エネルギーの調和への道：';

  @override
  String get roomCaptureTitle => 'エネルギールームキャプチャ（10秒）';

  @override
  String get roomCaptureBody =>
      'この深い静寂の中で、お部屋の見えない振動を捉えます。音声や大きな妨害は微細なレベルへの接続を中断します—完全な静寂を保ってください。';

  @override
  String get decodingTitle => 'エネルギー振動のデコード';

  @override
  String get decodingBody =>
      '各周波数は、独自のエネルギーの署名として認識され、分析されます。ブロックと不調和が識別され、一貫した共鳴フィールドに変換されます。';

  @override
  String get synthesisTitle => '合成とカウンターシグナル';

  @override
  String get synthesisBody =>
      'セグメントから滑らかな共鳴パターンが現れます。これから「カウンターシグナル」が生成され、音響的にノイズプロファイルを反映します。';

  @override
  String get startScan => 'エネルギースキャンを開始';

  @override
  String get savedRooms => 'エネルギーアーカイブ';

  @override
  String get archiveRoom => 'エネルギールームをアーカイブ';

  @override
  String get roomNameLabel => 'エネルギールームの名前';

  @override
  String get roomNameRequired => 'このエネルギールームに名前を付けてください';

  @override
  String get back => '戻る';

  @override
  String get archive => 'アーカイブ';

  @override
  String roomArchivedSuccess(String name) {
    return 'エネルギールーム「$name」が正常にアーカイブされました';
  }

  @override
  String get archiveFailed => 'エネルギーのアーカイブを完了できませんでした';

  @override
  String get recordingInProgress => 'エネルギーキャプチャ実行中…';

  @override
  String get recordingInstructions => '完全な静寂に浸り、お部屋の微細な振動に開いてください。';

  @override
  String get vibrationIntensity => 'エネルギー振動強度';

  @override
  String get optimalConnection =>
      '最適な接続のために：デバイスを静かに置き、内側に集中してください。すべての動きが微細なエネルギーの接続を妨げます。';

  @override
  String get calibrationTitle => 'エネルギーベースキャリブレーション';

  @override
  String get calibrationBody =>
      'この段階では、お部屋の基本的な振動と接続します。個人的なエネルギーフィールドを最適に捉えるために、少しの間、一時停止してください。';

  @override
  String get baseVibrations => 'エネルギーベース振動';

  @override
  String get calibrationNote =>
      'このエネルギーの調整は、必要な場合にのみ発生します。お客様の個人的なルームの独特な振動への正確な接続を保証します。';

  @override
  String get connectionInterrupted => 'エネルギーの接続が中断されました';

  @override
  String get connectionInterruptedBody =>
      'エネルギーの接続が不調和な振動によって妨害されました。もう一度お試しください。ルームが完全な瞑想的静寂の中で振動することを許可してください。';

  @override
  String get detectedDisharmony => '検出されたエネルギーの不調和：';

  @override
  String get energeticRestart => 'エネルギーの新しい始まり';

  @override
  String get deepAnalysis => 'エネルギー振動の深い分析…';

  @override
  String get frequencyExtraction => '微細な周波数がエネルギーマトリックスから抽出されています…';

  @override
  String get calibrateBasis => 'エネルギーベースをキャリブレート';

  @override
  String get exploreResonance => '共鳴フィールドを探索';

  @override
  String get identifyBlockages => '微細なブロックを識別';

  @override
  String get detectedSignatures => '検出されたエネルギー署名';

  @override
  String signaturesDetected(int count) {
    return 'お部屋の瞑想的静寂から、$count個の独自のエネルギーの共鳴パターンが認識され、デコードされました。';
  }

  @override
  String energySignature(int number) {
    return 'エネルギー署名 $number';
  }

  @override
  String vibrationIntensityValue(String value) {
    return '振動強度：$value';
  }

  @override
  String get harmonizationLevel => '調和レベル';

  @override
  String get generateResonance => '共鳴周波数を生成';

  @override
  String get resonanceProfileCreating => '共鳴プロファイルを作成中…';

  @override
  String get alchemicalTransformation =>
      '錬金術的変換を通じて、すべてのエネルギー署名が調和的な共鳴パターンに融合されます。';

  @override
  String get signatureTransformation =>
      '検出された各エネルギー署名は、純粋な共鳴周波数に変換され、お客様の独自の調和シグナルに融合されます。';

  @override
  String get emergingSignal => '出現する調和シグナル';

  @override
  String get decodeImpulses => 'エネルギーのインパルスをデコード中…';

  @override
  String get harmonizeVibrations => '振動を調和中…';

  @override
  String get resonanceManifestation => '共鳴の現れ…';

  @override
  String get yourResonanceSignal => 'お客様の共鳴シグナル';

  @override
  String get playSignalDescription =>
      'この調和シグナルを再生して、不調和なエネルギーを変換し、ブロックを解放し、お部屋のエネルギーを完璧なバランスに導きます。';

  @override
  String get activateResonance => '共鳴周波数をアクティブ化';

  @override
  String get pauseHarmonization => '調和を一時停止';

  @override
  String get newHarmonization => '新しい調和';

  @override
  String get settings => '設定';

  @override
  String get appInfo => 'アプリ情報';

  @override
  String get version => 'バージョン';

  @override
  String get language => '言語';

  @override
  String get legalInfo => '法的情報';

  @override
  String get legalNotice => '法的通知';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get disclaimer => '免責事項';

  @override
  String get termsOfService => '利用規約';

  @override
  String get copyright => '著作権';

  @override
  String get rightOfWithdrawal => '撤回権';

  @override
  String get licenses => 'ライセンス';

  @override
  String get showOpenSourceLicenses => 'オープンソースライセンスを表示';

  @override
  String get showOpenSourceLicensesDesc => '使用されているすべてのオープンソースライセンスを表示します';

  @override
  String get error => 'エラー';

  @override
  String legalInfoError(String error) {
    return '法的情報を開くことができませんでした。\n\n$error';
  }

  @override
  String get ok => 'OK';

  @override
  String get renameRoom => 'エネルギールームの名前を変更';

  @override
  String get name => '名前';

  @override
  String get deleteRoom => 'エネルギールームを削除';

  @override
  String deleteRoomConfirm(String name) {
    return 'エネルギーのアーカイブ「$name」をストレージから本当に削除しますか？';
  }

  @override
  String get remove => '削除';

  @override
  String get noRoomsArchived => 'まだエネルギールームがアーカイブされていません';

  @override
  String get noRoomsDescription =>
      'エネルギースキャンを実行し、お部屋を調和させるための個人的な共鳴プロファイルを保存してください。';

  @override
  String get changeName => '名前を変更';

  @override
  String get removeFromArchive => 'アーカイブから削除';

  @override
  String get loading => '読み込み中...';

  @override
  String get unknown => '不明';

  @override
  String couldNotLaunchUrl(String error) {
    return 'URLを開くことができませんでした：$error';
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
