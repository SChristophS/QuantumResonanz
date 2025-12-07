// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'QuantumResonanz';

  @override
  String get appSubtitle => 'Armonizzazione Energetica dello Spazio';

  @override
  String get appDescription =>
      'Cattura le vibrazioni sottili del tuo spazio e crea il tuo profilo di risonanza energetica personale per un\'armonizzazione olistica.';

  @override
  String get appDescriptionLong =>
      'QuantumResonanz ascolta per 10 secondi l\'essenza energetica del tuo spazio. Attraverso l\'analisi meditativa profonda delle energie dello spazio, le vibrazioni disturbanti vengono identificate e trasformate in un modello di risonanza armonizzante. I tuoi dati energetici rimangono completamente protetti e locali sul tuo dispositivo.';

  @override
  String get pathToHarmonization =>
      'Il percorso verso l\'armonizzazione energetica:';

  @override
  String get roomCaptureTitle => 'Cattura Energetica dello Spazio (10 secondi)';

  @override
  String get roomCaptureBody =>
      'Durante questo silenzio profondo, catturiamo le vibrazioni invisibili del tuo spazio. La parola o i disturbi rumorosi interrompono la connessione al livello sottile – per favore mantieni il silenzio completo.';

  @override
  String get decodingTitle => 'Decodifica delle Vibrazioni Energetiche';

  @override
  String get decodingBody =>
      'Ogni frequenza viene riconosciuta e analizzata come una firma energetica unica. I blocchi e le disarmonie vengono identificati e trasformati in un campo di risonanza coerente.';

  @override
  String get synthesisTitle => 'Sintesi e Segnale Contrario';

  @override
  String get synthesisBody =>
      'Dai segmenti emerge un modello di risonanza levigato. Da questo viene generato un \"Segnale Contrario\" che riflette acusticamente il tuo profilo di rumore.';

  @override
  String get startScan => 'Avvia Scansione Energetica';

  @override
  String get savedRooms => 'Archivi Energetici';

  @override
  String get archiveRoom => 'Archivia Spazio Energetico';

  @override
  String get roomNameLabel => 'Nome dello Spazio Energetico';

  @override
  String get roomNameRequired =>
      'Per favore, dai un nome a questo spazio energetico';

  @override
  String get back => 'Indietro';

  @override
  String get archive => 'Archivia';

  @override
  String roomArchivedSuccess(String name) {
    return 'Lo spazio energetico \"$name\" è stato archiviato con successo';
  }

  @override
  String get archiveFailed =>
      'L\'archiviazione energetica non è stata completata';

  @override
  String get recordingInProgress => 'Cattura energetica in corso…';

  @override
  String get recordingInstructions =>
      'Immergiti nel silenzio completo e apriti alle vibrazioni sottili del tuo spazio.';

  @override
  String get vibrationIntensity => 'Intensità di Vibrazione Energetica';

  @override
  String get optimalConnection =>
      'Per una connessione ottimale: Posiziona il dispositivo silenziosamente e centrati interiormente. Ogni movimento disturba la fine connessione energetica.';

  @override
  String get calibrationTitle => 'Calibrazione Base Energetica';

  @override
  String get calibrationBody =>
      'In questa fase, ci connettiamo con le vibrazioni fondamentali del tuo spazio. Prenditi un momento per fare una pausa in modo che possiamo catturare in modo ottimale il tuo campo energetico individuale.';

  @override
  String get baseVibrations => 'Vibrazioni Base Energetiche';

  @override
  String get calibrationNote =>
      'Questa sintonia energetica avviene solo quando necessario. Assicura una connessione precisa alle vibrazioni uniche del tuo spazio personale.';

  @override
  String get connectionInterrupted => 'Connessione Energetica Interrotta';

  @override
  String get connectionInterruptedBody =>
      'La connessione energetica è stata disturbata da vibrazioni disarmoniche. Per favore, riprova e permetti allo spazio di vibrare in completo silenzio meditativo.';

  @override
  String get detectedDisharmony => 'Disarmonia energetica rilevata:';

  @override
  String get energeticRestart => 'Nuovo Inizio Energetico';

  @override
  String get deepAnalysis => 'Analisi Profonda delle Vibrazioni Energetiche…';

  @override
  String get frequencyExtraction =>
      'Le frequenze sottili vengono estratte dalla matrice energetica…';

  @override
  String get calibrateBasis => 'Calibra base energetica';

  @override
  String get exploreResonance => 'Esplora campo di risonanza';

  @override
  String get identifyBlockages => 'Identifica blocchi sottili';

  @override
  String get detectedSignatures => 'Firme Energetiche Rilevate';

  @override
  String signaturesDetected(int count) {
    return 'Dal silenzio meditativo del tuo spazio, $count modelli di risonanza energetica unici sono stati riconosciuti e decodificati.';
  }

  @override
  String energySignature(int number) {
    return 'Firma Energetica $number';
  }

  @override
  String vibrationIntensityValue(String value) {
    return 'Intensità di Vibrazione: $value';
  }

  @override
  String get harmonizationLevel => 'Livello di Armonizzazione';

  @override
  String get generateResonance => 'Genera Frequenza di Risonanza';

  @override
  String get resonanceProfileCreating =>
      'Il tuo profilo di risonanza è in fase di creazione…';

  @override
  String get alchemicalTransformation =>
      'Attraverso la trasformazione alchemica, tutte le firme energetiche vengono fuse in un modello di risonanza armonizzante.';

  @override
  String get signatureTransformation =>
      'Ogni firma energetica rilevata viene trasformata in frequenze di risonanza pure e fusa nel tuo segnale di armonizzazione unico.';

  @override
  String get emergingSignal => 'Segnale di Armonizzazione Emergente';

  @override
  String get decodeImpulses => 'Decodificando impulsi energetici…';

  @override
  String get harmonizeVibrations => 'Armonizzando vibrazioni…';

  @override
  String get resonanceManifestation => 'Manifestazione di risonanza…';

  @override
  String get yourResonanceSignal => 'Il Tuo Segnale di Risonanza';

  @override
  String get playSignalDescription =>
      'Riproduci questo segnale armonizzante per trasformare le energie disarmoniche, rilasciare i blocchi e portare l\'energia del tuo spazio in perfetto equilibrio.';

  @override
  String get activateResonance => 'Attiva Frequenza di Risonanza';

  @override
  String get pauseHarmonization => 'Metti in Pausa l\'Armonizzazione';

  @override
  String get newHarmonization => 'Nuova Armonizzazione';

  @override
  String get settings => 'Impostazioni';

  @override
  String get appInfo => 'Informazioni App';

  @override
  String get version => 'Versione';

  @override
  String get language => 'Lingua';

  @override
  String get legalInfo => 'Informazioni Legali';

  @override
  String get legalNotice => 'Avviso Legale';

  @override
  String get privacyPolicy => 'Informativa sulla Privacy';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get termsOfService => 'Termini di Servizio';

  @override
  String get copyright => 'Copyright';

  @override
  String get rightOfWithdrawal => 'Diritto di Recesso';

  @override
  String get licenses => 'Licenze';

  @override
  String get showOpenSourceLicenses => 'Mostra Licenze Open Source';

  @override
  String get showOpenSourceLicensesDesc =>
      'Mostra tutte le licenze Open Source utilizzate';

  @override
  String get error => 'Errore';

  @override
  String legalInfoError(String error) {
    return 'Le informazioni legali non sono state aperte.\n\n$error';
  }

  @override
  String get ok => 'OK';

  @override
  String get renameRoom => 'Rinomina Spazio Energetico';

  @override
  String get name => 'Nome';

  @override
  String get deleteRoom => 'Elimina Spazio Energetico';

  @override
  String deleteRoomConfirm(String name) {
    return 'Vuoi davvero rimuovere l\'archivio energetico \"$name\" dall\'archiviazione?';
  }

  @override
  String get remove => 'Rimuovi';

  @override
  String get noRoomsArchived => 'Nessuno spazio energetico ancora archiviato';

  @override
  String get noRoomsDescription =>
      'Esegui una scansione energetica e preserva il tuo profilo di risonanza personale per armonizzare i tuoi spazi.';

  @override
  String get changeName => 'Cambia Nome';

  @override
  String get removeFromArchive => 'Rimuovi dall\'Archivio';

  @override
  String get loading => 'Caricamento...';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String couldNotLaunchUrl(String error) {
    return 'Impossibile aprire l\'URL: $error';
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
