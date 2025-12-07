// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'QuantumResonanz';

  @override
  String get appSubtitle => 'Harmonização Energética do Espaço';

  @override
  String get appDescription =>
      'Capture as vibrações sutis do seu espaço e crie seu perfil de ressonância energética pessoal para harmonização holística.';

  @override
  String get appDescriptionLong =>
      'QuantumResonanz escuta por 10 segundos a essência energética do seu espaço. Através da análise meditativa profunda das energias do espaço, vibrações disruptivas são identificadas e transformadas em um padrão de ressonância harmonizador. Seus dados energéticos permanecem totalmente protegidos e locais no seu dispositivo.';

  @override
  String get pathToHarmonization => 'O caminho para a harmonização energética:';

  @override
  String get roomCaptureTitle => 'Captura Energética do Espaço (10 segundos)';

  @override
  String get roomCaptureBody =>
      'Durante este silêncio profundo, capturamos as vibrações invisíveis do seu espaço. Fala ou distúrbios barulhentos interrompem a conexão com o nível sutil – por favor, mantenha silêncio completo.';

  @override
  String get decodingTitle => 'Decodificação de Vibrações Energéticas';

  @override
  String get decodingBody =>
      'Cada frequência é reconhecida e analisada como uma assinatura energética única. Bloqueios e desarmonias são identificados e transformados em um campo de ressonância coerente.';

  @override
  String get synthesisTitle => 'Síntese e Sinal Contrário';

  @override
  String get synthesisBody =>
      'Um padrão de ressonância suavizado emerge dos segmentos. Um \"Sinal Contrário\" é gerado a partir disso, que reflete acusticamente seu perfil de ruído.';

  @override
  String get startScan => 'Iniciar Varredura Energética';

  @override
  String get savedRooms => 'Arquivos Energéticos';

  @override
  String get archiveRoom => 'Arquivar Espaço Energético';

  @override
  String get roomNameLabel => 'Nome do Espaço Energético';

  @override
  String get roomNameRequired =>
      'Por favor, dê um nome a este espaço energético';

  @override
  String get back => 'Voltar';

  @override
  String get archive => 'Arquivar';

  @override
  String roomArchivedSuccess(String name) {
    return 'Espaço energético \"$name\" foi arquivado com sucesso';
  }

  @override
  String get archiveFailed =>
      'O arquivamento energético não pôde ser concluído';

  @override
  String get recordingInProgress => 'Captura energética em execução…';

  @override
  String get recordingInstructions =>
      'Mergulhe em silêncio completo e abra-se para as vibrações sutis do seu espaço.';

  @override
  String get vibrationIntensity => 'Intensidade de Vibração Energética';

  @override
  String get optimalConnection =>
      'Para conexão ótima: Coloque o dispositivo silenciosamente e centralize-se internamente. Cada movimento perturba a fina conexão energética.';

  @override
  String get calibrationTitle => 'Calibração Base Energética';

  @override
  String get calibrationBody =>
      'Nesta fase, nos conectamos com as vibrações fundamentais do seu espaço. Reserve um momento para pausar para que possamos capturar de forma ótima seu campo energético individual.';

  @override
  String get baseVibrations => 'Vibrações Base Energéticas';

  @override
  String get calibrationNote =>
      'Esta sintonia energética ocorre apenas quando necessário. Garante uma conexão precisa com as vibrações únicas do seu espaço pessoal.';

  @override
  String get connectionInterrupted => 'Conexão Energética Interrompida';

  @override
  String get connectionInterruptedBody =>
      'A conexão energética foi perturbada por vibrações desarmônicas. Por favor, tente novamente e permita que o espaço vibre em silêncio meditativo completo.';

  @override
  String get detectedDisharmony => 'Desarmonia energética detectada:';

  @override
  String get energeticRestart => 'Novo Começo Energético';

  @override
  String get deepAnalysis => 'Análise Profunda de Vibrações Energéticas…';

  @override
  String get frequencyExtraction =>
      'As frequências sutis estão sendo extraídas da matriz energética…';

  @override
  String get calibrateBasis => 'Calibrar base energética';

  @override
  String get exploreResonance => 'Explorar campo de ressonância';

  @override
  String get identifyBlockages => 'Identificar bloqueios sutis';

  @override
  String get detectedSignatures => 'Assinaturas Energéticas Detectadas';

  @override
  String signaturesDetected(int count) {
    return 'Do silêncio meditativo do seu espaço, $count padrões de ressonância energética únicos foram reconhecidos e decodificados.';
  }

  @override
  String energySignature(int number) {
    return 'Assinatura Energética $number';
  }

  @override
  String vibrationIntensityValue(String value) {
    return 'Intensidade de Vibração: $value';
  }

  @override
  String get harmonizationLevel => 'Nível de Harmonização';

  @override
  String get generateResonance => 'Gerar Frequência de Ressonância';

  @override
  String get resonanceProfileCreating =>
      'Seu perfil de ressonância está sendo criado…';

  @override
  String get alchemicalTransformation =>
      'Através da transformação alquímica, todas as assinaturas energéticas são fundidas em um padrão de ressonância harmonizador.';

  @override
  String get signatureTransformation =>
      'Cada assinatura energética detectada é transformada em frequências de ressonância puras e fundida em seu sinal de harmonização único.';

  @override
  String get emergingSignal => 'Sinal de Harmonização Emergente';

  @override
  String get decodeImpulses => 'Decodificando impulsos energéticos…';

  @override
  String get harmonizeVibrations => 'Harmonizando vibrações…';

  @override
  String get resonanceManifestation => 'Manifestação de ressonância…';

  @override
  String get yourResonanceSignal => 'Seu Sinal de Ressonância';

  @override
  String get playSignalDescription =>
      'Reproduza este sinal harmonizador para transformar energias desarmônicas, liberar bloqueios e trazer a energia do seu espaço para um equilíbrio perfeito.';

  @override
  String get activateResonance => 'Ativar Frequência de Ressonância';

  @override
  String get pauseHarmonization => 'Pausar Harmonização';

  @override
  String get newHarmonization => 'Nova Harmonização';

  @override
  String get settings => 'Configurações';

  @override
  String get appInfo => 'Informações do App';

  @override
  String get version => 'Versão';

  @override
  String get language => 'Idioma';

  @override
  String get legalInfo => 'Informações Legais';

  @override
  String get legalNotice => 'Aviso Legal';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get disclaimer => 'Aviso de Isenção';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get copyright => 'Direitos Autorais';

  @override
  String get rightOfWithdrawal => 'Direito de Retratação';

  @override
  String get licenses => 'Licenças';

  @override
  String get showOpenSourceLicenses => 'Mostrar Licenças de Código Aberto';

  @override
  String get showOpenSourceLicensesDesc =>
      'Mostra todas as licenças de código aberto usadas';

  @override
  String get error => 'Erro';

  @override
  String legalInfoError(String error) {
    return 'As informações legais não puderam ser abertas.\n\n$error';
  }

  @override
  String get ok => 'OK';

  @override
  String get renameRoom => 'Renomear Espaço Energético';

  @override
  String get name => 'Nome';

  @override
  String get deleteRoom => 'Excluir Espaço Energético';

  @override
  String deleteRoomConfirm(String name) {
    return 'Você realmente deseja remover o arquivo energético \"$name\" do armazenamento?';
  }

  @override
  String get remove => 'Remover';

  @override
  String get noRoomsArchived => 'Nenhum espaço energético arquivado ainda';

  @override
  String get noRoomsDescription =>
      'Execute uma varredura energética e preserve seu perfil de ressonância pessoal para harmonizar seus espaços.';

  @override
  String get changeName => 'Alterar Nome';

  @override
  String get removeFromArchive => 'Remover do Arquivo';

  @override
  String get loading => 'Carregando...';

  @override
  String get unknown => 'Desconhecido';

  @override
  String couldNotLaunchUrl(String error) {
    return 'Não foi possível abrir a URL: $error';
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

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appName => 'QuantumResonanz';

  @override
  String get appSubtitle => 'Harmonização Energética do Espaço';

  @override
  String get appDescription =>
      'Capture as vibrações sutis do seu espaço e crie seu perfil de ressonância energética pessoal para harmonização holística.';

  @override
  String get appDescriptionLong =>
      'QuantumResonanz escuta por 10 segundos a essência energética do seu espaço. Através da análise meditativa profunda das energias do espaço, vibrações disruptivas são identificadas e transformadas em um padrão de ressonância harmonizador. Seus dados energéticos permanecem totalmente protegidos e locais no seu dispositivo.';

  @override
  String get pathToHarmonization => 'O caminho para a harmonização energética:';

  @override
  String get roomCaptureTitle => 'Captura Energética do Espaço (10 segundos)';

  @override
  String get roomCaptureBody =>
      'Durante este silêncio profundo, capturamos as vibrações invisíveis do seu espaço. Fala ou distúrbios barulhentos interrompem a conexão com o nível sutil – por favor, mantenha silêncio completo.';

  @override
  String get decodingTitle => 'Decodificação de Vibrações Energéticas';

  @override
  String get decodingBody =>
      'Cada frequência é reconhecida e analisada como uma assinatura energética única. Bloqueios e desarmonias são identificados e transformados em um campo de ressonância coerente.';

  @override
  String get synthesisTitle => 'Síntese e Sinal Contrário';

  @override
  String get synthesisBody =>
      'Um padrão de ressonância suavizado emerge dos segmentos. Um \"Sinal Contrário\" é gerado a partir disso, que reflete acusticamente seu perfil de ruído.';

  @override
  String get startScan => 'Iniciar Varredura Energética';

  @override
  String get savedRooms => 'Arquivos Energéticos';

  @override
  String get archiveRoom => 'Arquivar Espaço Energético';

  @override
  String get roomNameLabel => 'Nome do Espaço Energético';

  @override
  String get roomNameRequired =>
      'Por favor, dê um nome a este espaço energético';

  @override
  String get back => 'Voltar';

  @override
  String get archive => 'Arquivar';

  @override
  String roomArchivedSuccess(String name) {
    return 'Espaço energético \"$name\" foi arquivado com sucesso';
  }

  @override
  String get archiveFailed =>
      'O arquivamento energético não pôde ser concluído';

  @override
  String get recordingInProgress => 'Captura energética em execução…';

  @override
  String get recordingInstructions =>
      'Mergulhe em silêncio completo e abra-se para as vibrações sutis do seu espaço.';

  @override
  String get vibrationIntensity => 'Intensidade de Vibração Energética';

  @override
  String get optimalConnection =>
      'Para conexão ótima: Coloque o dispositivo silenciosamente e centralize-se internamente. Cada movimento perturba a fina conexão energética.';

  @override
  String get calibrationTitle => 'Calibração Base Energética';

  @override
  String get calibrationBody =>
      'Nesta fase, nos conectamos com as vibrações fundamentais do seu espaço. Reserve um momento para pausar para que possamos capturar de forma ótima seu campo energético individual.';

  @override
  String get baseVibrations => 'Vibrações Base Energéticas';

  @override
  String get calibrationNote =>
      'Esta sintonia energética ocorre apenas quando necessário. Garante uma conexão precisa com as vibrações únicas do seu espaço pessoal.';

  @override
  String get connectionInterrupted => 'Conexão Energética Interrompida';

  @override
  String get connectionInterruptedBody =>
      'A conexão energética foi perturbada por vibrações desarmônicas. Por favor, tente novamente e permita que o espaço vibre em silêncio meditativo completo.';

  @override
  String get detectedDisharmony => 'Desarmonia energética detectada:';

  @override
  String get energeticRestart => 'Novo Começo Energético';

  @override
  String get deepAnalysis => 'Análise Profunda de Vibrações Energéticas…';

  @override
  String get frequencyExtraction =>
      'As frequências sutis estão sendo extraídas da matriz energética…';

  @override
  String get calibrateBasis => 'Calibrar base energética';

  @override
  String get exploreResonance => 'Explorar campo de ressonância';

  @override
  String get identifyBlockages => 'Identificar bloqueios sutis';

  @override
  String get detectedSignatures => 'Assinaturas Energéticas Detectadas';

  @override
  String signaturesDetected(int count) {
    return 'Do silêncio meditativo do seu espaço, $count padrões de ressonância energética únicos foram reconhecidos e decodificados.';
  }

  @override
  String energySignature(int number) {
    return 'Assinatura Energética $number';
  }

  @override
  String vibrationIntensityValue(String value) {
    return 'Intensidade de Vibração: $value';
  }

  @override
  String get harmonizationLevel => 'Nível de Harmonização';

  @override
  String get generateResonance => 'Gerar Frequência de Ressonância';

  @override
  String get resonanceProfileCreating =>
      'Seu perfil de ressonância está sendo criado…';

  @override
  String get alchemicalTransformation =>
      'Através da transformação alquímica, todas as assinaturas energéticas são fundidas em um padrão de ressonância harmonizador.';

  @override
  String get signatureTransformation =>
      'Cada assinatura energética detectada é transformada em frequências de ressonância puras e fundida em seu sinal de harmonização único.';

  @override
  String get emergingSignal => 'Sinal de Harmonização Emergente';

  @override
  String get decodeImpulses => 'Decodificando impulsos energéticos…';

  @override
  String get harmonizeVibrations => 'Harmonizando vibrações…';

  @override
  String get resonanceManifestation => 'Manifestação de ressonância…';

  @override
  String get yourResonanceSignal => 'Seu Sinal de Ressonância';

  @override
  String get playSignalDescription =>
      'Reproduza este sinal harmonizador para transformar energias desarmônicas, liberar bloqueios e trazer a energia do seu espaço para um equilíbrio perfeito.';

  @override
  String get activateResonance => 'Ativar Frequência de Ressonância';

  @override
  String get pauseHarmonization => 'Pausar Harmonização';

  @override
  String get newHarmonization => 'Nova Harmonização';

  @override
  String get settings => 'Configurações';

  @override
  String get appInfo => 'Informações do App';

  @override
  String get version => 'Versão';

  @override
  String get language => 'Idioma';

  @override
  String get legalInfo => 'Informações Legais';

  @override
  String get legalNotice => 'Aviso Legal';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get disclaimer => 'Aviso de Isenção';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get copyright => 'Direitos Autorais';

  @override
  String get rightOfWithdrawal => 'Direito de Retratação';

  @override
  String get licenses => 'Licenças';

  @override
  String get showOpenSourceLicenses => 'Mostrar Licenças de Código Aberto';

  @override
  String get showOpenSourceLicensesDesc =>
      'Mostra todas as licenças de código aberto usadas';

  @override
  String get error => 'Erro';

  @override
  String legalInfoError(String error) {
    return 'As informações legais não puderam ser abertas.\n\n$error';
  }

  @override
  String get ok => 'OK';

  @override
  String get renameRoom => 'Renomear Espaço Energético';

  @override
  String get name => 'Nome';

  @override
  String get deleteRoom => 'Excluir Espaço Energético';

  @override
  String deleteRoomConfirm(String name) {
    return 'Você realmente deseja remover o arquivo energético \"$name\" do armazenamento?';
  }

  @override
  String get remove => 'Remover';

  @override
  String get noRoomsArchived => 'Nenhum espaço energético arquivado ainda';

  @override
  String get noRoomsDescription =>
      'Execute uma varredura energética e preserve seu perfil de ressonância pessoal para harmonizar seus espaços.';

  @override
  String get changeName => 'Alterar Nome';

  @override
  String get removeFromArchive => 'Remover do Arquivo';

  @override
  String get loading => 'Carregando...';

  @override
  String get unknown => 'Desconhecido';

  @override
  String couldNotLaunchUrl(String error) {
    return 'Não foi possível abrir a URL: $error';
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
}
