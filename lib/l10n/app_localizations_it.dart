// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Bio Resonance Scanner';

  @override
  String get appSubtitle => 'Armonizzazione Energetica dello Spazio';

  @override
  String get appDescription =>
      'Cattura le vibrazioni sottili del tuo spazio e crea il tuo profilo di risonanza energetica personale per un\'armonizzazione olistica.';

  @override
  String get appDescriptionLong =>
      'Bio Resonance Scanner ascolta per 10 secondi l\'essenza energetica del tuo spazio. Attraverso l\'analisi meditativa profonda delle energie dello spazio, le vibrazioni disturbanti vengono identificate e trasformate in un modello di risonanza armonizzante. I tuoi dati energetici rimangono completamente protetti e locali sul tuo dispositivo.';

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
  String get stopHarmonization => 'Ferma l\'Armonizzazione';

  @override
  String get newHarmonization => 'Nuova Armonizzazione';

  @override
  String get onboardingTitle => 'Introduzione';

  @override
  String get onboardingSkip => 'Salta';

  @override
  String get onboardingBack => 'Indietro';

  @override
  String get onboardingNext => 'Avanti';

  @override
  String get onboardingStart => 'Inizia';

  @override
  String get onboardingWelcomeTitle => 'Benvenuto in Bio Resonance Scanner';

  @override
  String get onboardingWelcomeDescription =>
      'Cattura le sottili vibrazioni della tua stanza per creare un profilo personale di risonanza armonizzante.';

  @override
  String get onboardingHowToUseTitle => 'Come usare';

  @override
  String get onboardingHowToUseStep1 =>
      'Trova un luogo tranquillo. Appoggia il telefono e respira profondamente.';

  @override
  String get onboardingHowToUseStep2 =>
      'Avvia la scansione di 10 secondi e rimani in silenzio. Lascia che l\'app ascolti l\'energia della stanza.';

  @override
  String get onboardingHowToUseStep3 =>
      'Dopo l\'analisi, riproduci la risonanza armonizzante e senti l\'equilibrio.';

  @override
  String get onboardingPermissionTitle => 'Accesso al microfono';

  @override
  String get onboardingPermissionDescription =>
      'Per percepire le vibrazioni della stanza, l\'app ha bisogno dell\'accesso al microfono. Rimani in silenzio durante la scansione per il miglior risultato.';

  @override
  String get onboardingPermissionButton => 'Consenti microfono';

  @override
  String get onboardingPermissionGranted =>
      'Microfono consentito. Pronto per la scansione.';

  @override
  String get onboardingPermissionDenied =>
      'Microfono negato. Puoi consentirlo per attivare la scansione.';

  @override
  String get onboardingPermissionPermanentlyDenied =>
      'Microfono negato permanentemente. Abilitalo nelle impostazioni di sistema per scansionare.';

  @override
  String get onboardingPermissionRestricted =>
      'L\'accesso al microfono è limitato su questo dispositivo.';

  @override
  String get onboardingPermissionLimited =>
      'L\'accesso al microfono è limitato. L\'accesso completo garantisce le migliori scansioni.';

  @override
  String get onboardingPermissionUnknown => 'Stato del microfono sconosciuto.';

  @override
  String get onboardingSavingTitle => 'Salva e riascolta';

  @override
  String get onboardingSavingDescription =>
      'Archivia i risultati di risonanza come “Stanze di energia” e riproducili quando vuoi riequilibrare.';

  @override
  String get onboardingGetStartedTitle => 'Sei pronto';

  @override
  String get onboardingGetStartedDescription =>
      'Inizia ora la tua prima scansione. Puoi sempre rivedere questa introduzione dalle Impostazioni.';

  @override
  String get onboardingReplayHint =>
      'Suggerimento: puoi rivedere l\'introduzione in qualsiasi momento dalle Impostazioni.';

  @override
  String get showOnboarding => 'Mostra introduzione';

  @override
  String get showOnboardingDesc => 'Ripeti la guida e la richiesta di permessi';

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
    return 'Firma Energetica $index di $count';
  }

  @override
  String get energyTextLow =>
      'vibrazione fondamentale delicata dell\'energia dello spazio, che fluisce armoniosamente';

  @override
  String get energyTextMedium =>
      'impulsi sottili e vivaci nel campo di risonanza energetica';

  @override
  String get energyTextHigh =>
      'densità energetica altamente concentrata con potere trasformativo';

  @override
  String get freqTextLow =>
      'radicato nelle frequenze profonde di radicamento del sistema dei chakra';

  @override
  String get freqTextMedium =>
      'vibrazione equilibrata attraverso tutti i livelli sottili';

  @override
  String get freqTextHigh =>
      'energie ad alta frequenza sublimi che portano all\'apertura spirituale';

  @override
  String get movementTextLow =>
      'meditativamente uniforme, calmante per l\'aura';

  @override
  String get movementTextMedium =>
      'leggermente pulsante, che dissolve i blocchi con coerenza armonica';

  @override
  String get movementTextHigh =>
      'trasformazione dinamica, pulizia intensiva delle strutture energetiche';

  @override
  String resonanceFrequencyAt(int freqHz) {
    return 'Frequenza di risonanza a circa $freqHz Hz';
  }
}
