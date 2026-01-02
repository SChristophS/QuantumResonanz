// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Bio Resonance Scanner';

  @override
  String get appSubtitle => 'Энергетическая Гармонизация Пространства';

  @override
  String get appDescription =>
      'Захватите тонкие вибрации вашего пространства и создайте свой личный профиль энергетического резонанса для целостной гармонизации.';

  @override
  String get appDescriptionLong =>
      'Bio Resonance Scanner слушает в течение 10 секунд энергетическую сущность вашего пространства. Через глубокий медитативный анализ энергий пространства разрушительные вибрации идентифицируются и преобразуются в гармонизирующий резонансный паттерн. Ваши энергетические данные остаются полностью защищенными и локальными на вашем устройстве.';

  @override
  String get pathToHarmonization => 'Путь к энергетической гармонизации:';

  @override
  String get roomCaptureTitle =>
      'Энергетический Захват Пространства (10 секунд)';

  @override
  String get roomCaptureBody =>
      'В течение этой глубокой тишины мы захватываем невидимые вибрации вашего пространства. Речь или громкие помехи прерывают связь с тонким уровнем – пожалуйста, поддерживайте полную тишину.';

  @override
  String get decodingTitle => 'Декодирование Энергетических Вибраций';

  @override
  String get decodingBody =>
      'Каждая частота распознается и анализируется как уникальная энергетическая подпись. Блокировки и дисгармонии идентифицируются и преобразуются в связное резонансное поле.';

  @override
  String get synthesisTitle => 'Синтез и Контрсигнал';

  @override
  String get synthesisBody =>
      'Из сегментов возникает сглаженный резонансный паттерн. Из этого генерируется \"Контрсигнал\", который акустически отражает ваш профиль шума.';

  @override
  String get startScan => 'Начать Энергетическое Сканирование';

  @override
  String get savedRooms => 'Энергетические Архивы';

  @override
  String get archiveRoom => 'Архивировать Энергетическое Пространство';

  @override
  String get roomNameLabel => 'Название Энергетического Пространства';

  @override
  String get roomNameRequired =>
      'Пожалуйста, дайте этому энергетическому пространству имя';

  @override
  String get back => 'Назад';

  @override
  String get archive => 'Архивировать';

  @override
  String roomArchivedSuccess(String name) {
    return 'Энергетическое пространство \"$name\" успешно заархивировано';
  }

  @override
  String get archiveFailed =>
      'Энергетическое архивирование не могло быть завершено';

  @override
  String get recordingInProgress => 'Энергетический захват выполняется…';

  @override
  String get recordingInstructions =>
      'Погрузитесь в полную тишину и откройтесь тонким вибрациям вашего пространства.';

  @override
  String get vibrationIntensity => 'Интенсивность Энергетической Вибрации';

  @override
  String get optimalConnection =>
      'Для оптимального соединения: Тихо поместите устройство и центрируйтесь внутренне. Каждое движение нарушает тонкое энергетическое соединение.';

  @override
  String get calibrationTitle => 'Энергетическая Базовая Калибровка';

  @override
  String get calibrationBody =>
      'На этом этапе мы соединяемся с фундаментальными вибрациями вашего пространства. Сделайте паузу на мгновение, чтобы мы могли оптимально захватить ваше индивидуальное энергетическое поле.';

  @override
  String get baseVibrations => 'Энергетические Базовые Вибрации';

  @override
  String get calibrationNote =>
      'Эта энергетическая настройка происходит только при необходимости. Она обеспечивает точное соединение с уникальными вибрациями вашего личного пространства.';

  @override
  String get connectionInterrupted => 'Энергетическое Соединение Прервано';

  @override
  String get connectionInterruptedBody =>
      'Энергетическое соединение было нарушено дисгармоничными вибрациями. Пожалуйста, попробуйте снова и позвольте пространству вибрировать в полной медитативной тишине.';

  @override
  String get detectedDisharmony => 'Обнаружена энергетическая дисгармония:';

  @override
  String get energeticRestart => 'Энергетическое Новое Начало';

  @override
  String get deepAnalysis => 'Глубокий Анализ Энергетических Вибраций…';

  @override
  String get frequencyExtraction =>
      'Тонкие частоты извлекаются из энергетической матрицы…';

  @override
  String get calibrateBasis => 'Калибровать энергетическую основу';

  @override
  String get exploreResonance => 'Исследовать резонансное поле';

  @override
  String get identifyBlockages => 'Идентифицировать тонкие блокировки';

  @override
  String get detectedSignatures => 'Обнаруженные Энергетические Подписи';

  @override
  String signaturesDetected(int count) {
    return 'Из медитативной тишины вашего пространства было распознано и декодировано $count уникальных энергетических резонансных паттернов.';
  }

  @override
  String energySignature(int number) {
    return 'Энергетическая Подпись $number';
  }

  @override
  String vibrationIntensityValue(String value) {
    return 'Интенсивность Вибрации: $value';
  }

  @override
  String get harmonizationLevel => 'Уровень Гармонизации';

  @override
  String get generateResonance => 'Генерировать Резонансную Частоту';

  @override
  String get resonanceProfileCreating => 'Ваш резонансный профиль создается…';

  @override
  String get alchemicalTransformation =>
      'Через алхимическое преобразование все энергетические подписи сливаются в гармонизирующий резонансный паттерн.';

  @override
  String get signatureTransformation =>
      'Каждая обнаруженная энергетическая подпись преобразуется в чистые резонансные частоты и сливается в ваш уникальный сигнал гармонизации.';

  @override
  String get emergingSignal => 'Появляющийся Сигнал Гармонизации';

  @override
  String get decodeImpulses => 'Декодирование энергетических импульсов…';

  @override
  String get harmonizeVibrations => 'Гармонизация вибраций…';

  @override
  String get resonanceManifestation => 'Проявление резонанса…';

  @override
  String get yourResonanceSignal => 'Ваш Резонансный Сигнал';

  @override
  String get playSignalDescription =>
      'Воспроизведите этот гармонизирующий сигнал, чтобы преобразовать дисгармоничные энергии, освободить блокировки и привести энергию вашего пространства в идеальный баланс.';

  @override
  String get activateResonance => 'Активировать Резонансную Частоту';

  @override
  String get pauseHarmonization => 'Приостановить Гармонизацию';

  @override
  String get stopHarmonization => 'Остановить Гармонизацию';

  @override
  String get newHarmonization => 'Новая Гармонизация';

  @override
  String get onboardingTitle => 'Онбординг';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingBack => 'Назад';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingStart => 'Начать';

  @override
  String get onboardingWelcomeTitle =>
      'Добро пожаловать в Bio Resonance Scanner';

  @override
  String get onboardingWelcomeDescription =>
      'Улавливайте тонкие вибрации вашего пространства, создавая персональный гармонизирующий резонансный профиль.';

  @override
  String get onboardingHowToUseTitle => 'Как использовать';

  @override
  String get onboardingHowToUseStep1 =>
      'Найдите тихое место. Положите телефон неподвижно и глубоко вдохните.';

  @override
  String get onboardingHowToUseStep2 =>
      'Запустите 10-секундное сканирование и сохраняйте тишину. Позвольте приложению услышать энергию комнаты.';

  @override
  String get onboardingHowToUseStep3 =>
      'После анализа воспроизведите гармонизирующий резонанс и почувствуйте баланс.';

  @override
  String get onboardingPermissionTitle => 'Доступ к микрофону';

  @override
  String get onboardingPermissionDescription =>
      'Чтобы уловить вибрации пространства, приложению нужен доступ к микрофону. Во время сканирования соблюдайте тишину для наилучшего результата.';

  @override
  String get onboardingPermissionButton => 'Разрешить микрофон';

  @override
  String get onboardingPermissionGranted =>
      'Микрофон разрешен. Готовы к сканированию.';

  @override
  String get onboardingPermissionDenied =>
      'Микрофон отклонен. Разрешите его, чтобы включить сканирование.';

  @override
  String get onboardingPermissionPermanentlyDenied =>
      'Микрофон отклонен навсегда. Включите его в настройках системы для сканирования.';

  @override
  String get onboardingPermissionRestricted =>
      'Доступ к микрофону ограничен на этом устройстве.';

  @override
  String get onboardingPermissionLimited =>
      'Доступ к микрофону ограничен. Полный доступ обеспечивает лучшие сканы.';

  @override
  String get onboardingPermissionUnknown => 'Статус микрофона неизвестен.';

  @override
  String get onboardingSavingTitle => 'Сохранение и повтор';

  @override
  String get onboardingSavingDescription =>
      'Архивируйте результаты резонанса как «Энергетические комнаты» и воспроизводите их, когда захотите восстановить гармонию.';

  @override
  String get onboardingGetStartedTitle => 'Все готово';

  @override
  String get onboardingGetStartedDescription =>
      'Начните первое сканирование сейчас. Вы всегда можете повторно просмотреть онбординг в Настройках.';

  @override
  String get onboardingReplayHint =>
      'Совет: вы можете повторно запустить онбординг в любой момент через Настройки.';

  @override
  String get showOnboarding => 'Показать онбординг';

  @override
  String get showOnboardingDesc => 'Повторить руководство и запрос разрешений';

  @override
  String get settings => 'Настройки';

  @override
  String get appInfo => 'Информация о Приложении';

  @override
  String get version => 'Версия';

  @override
  String get language => 'Язык';

  @override
  String get legalInfo => 'Юридическая Информация';

  @override
  String get legalNotice => 'Юридическое Уведомление';

  @override
  String get privacyPolicy => 'Политика Конфиденциальности';

  @override
  String get disclaimer => 'Отказ от Ответственности';

  @override
  String get termsOfService => 'Условия Использования';

  @override
  String get copyright => 'Авторское Право';

  @override
  String get rightOfWithdrawal => 'Право на Отзыв';

  @override
  String get licenses => 'Лицензии';

  @override
  String get showOpenSourceLicenses =>
      'Показать Лицензии с Открытым Исходным Кодом';

  @override
  String get showOpenSourceLicensesDesc =>
      'Показывает все используемые лицензии с открытым исходным кодом';

  @override
  String get error => 'Ошибка';

  @override
  String legalInfoError(String error) {
    return 'Юридическая информация не могла быть открыта.\n\n$error';
  }

  @override
  String get ok => 'OK';

  @override
  String get renameRoom => 'Переименовать Энергетическое Пространство';

  @override
  String get name => 'Имя';

  @override
  String get deleteRoom => 'Удалить Энергетическое Пространство';

  @override
  String deleteRoomConfirm(String name) {
    return 'Вы действительно хотите удалить энергетический архив \"$name\" из хранилища?';
  }

  @override
  String get remove => 'Удалить';

  @override
  String get noRoomsArchived =>
      'Пока нет заархивированных энергетических пространств';

  @override
  String get noRoomsDescription =>
      'Выполните энергетическое сканирование и сохраните свой личный резонансный профиль для гармонизации ваших пространств.';

  @override
  String get changeName => 'Изменить Имя';

  @override
  String get removeFromArchive => 'Удалить из Архива';

  @override
  String get loading => 'Загрузка...';

  @override
  String get unknown => 'Неизвестно';

  @override
  String couldNotLaunchUrl(String error) {
    return 'Не удалось открыть URL: $error';
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
    return 'Энергетическая Подпись $index из $count';
  }

  @override
  String get energyTextLow =>
      'нежная фундаментальная вибрация энергии пространства, гармонично текущая';

  @override
  String get energyTextMedium =>
      'живые тонкие импульсы в энергетическом резонансном поле';

  @override
  String get energyTextHigh =>
      'высоко концентрированная плотность энергии с преобразующей силой';

  @override
  String get freqTextLow =>
      'укорененная в заземляющих глубоких частотах системы чакр';

  @override
  String get freqTextMedium =>
      'сбалансированная вибрация через все тонкие уровни';

  @override
  String get freqTextHigh =>
      'возвышенные высокочастотные энергии, ведущие к духовному открытию';

  @override
  String get movementTextLow =>
      'медитативно равномерная, успокаивающая для ауры';

  @override
  String get movementTextMedium =>
      'мягко пульсирующая, растворяющая блокировки с гармоничной согласованностью';

  @override
  String get movementTextHigh =>
      'динамически преобразующаяся, интенсивное очищение энергетических структур';

  @override
  String resonanceFrequencyAt(int freqHz) {
    return 'Резонансная частота приблизительно $freqHz Гц';
  }
}
