import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

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
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('ta'),
    Locale('te')
  ];

  /// No description provided for @yourAiLegalCompanion.
  ///
  /// In en, this message translates to:
  /// **'Your AI Legal Companion'**
  String get yourAiLegalCompanion;

  /// No description provided for @understandYourRights.
  ///
  /// In en, this message translates to:
  /// **'Understand Your Rights'**
  String get understandYourRights;

  /// No description provided for @understandRightsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get simple and accessible explanations of Indian laws and legal rights.'**
  String get understandRightsDesc;

  /// No description provided for @askJurixbot.
  ///
  /// In en, this message translates to:
  /// **'Ask JuriXBot'**
  String get askJurixbot;

  /// No description provided for @askJurixbotDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask legal questions in your preferred language and get clear explanations.'**
  String get askJurixbotDesc;

  /// No description provided for @legalHelpSimple.
  ///
  /// In en, this message translates to:
  /// **'Legal Help, Made Simple'**
  String get legalHelpSimple;

  /// No description provided for @legalHelpSimpleDesc.
  ///
  /// In en, this message translates to:
  /// **'Search laws, understand documents, draft complaints and explore your rights.'**
  String get legalHelpSimpleDesc;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @selectLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language for JuriXBot'**
  String get selectLanguageDescription;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navDrafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get navDrafts;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello 👋'**
  String get hello;

  /// No description provided for @howCanWeHelpToday.
  ///
  /// In en, this message translates to:
  /// **'How can we help you today?'**
  String get howCanWeHelpToday;

  /// No description provided for @howCanWeHelpHero.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get howCanWeHelpHero;

  /// No description provided for @describeLegalProblem.
  ///
  /// In en, this message translates to:
  /// **'Describe your legal problem in your own words.'**
  String get describeLegalProblem;

  /// No description provided for @tellUsWhatHappened.
  ///
  /// In en, this message translates to:
  /// **'Tell us what happened...'**
  String get tellUsWhatHappened;

  /// No description provided for @quickHelp.
  ///
  /// In en, this message translates to:
  /// **'Quick Help'**
  String get quickHelp;

  /// No description provided for @askJurixbotAction.
  ///
  /// In en, this message translates to:
  /// **'Ask JuriXBot'**
  String get askJurixbotAction;

  /// No description provided for @analyzeDocument.
  ///
  /// In en, this message translates to:
  /// **'Analyze Document'**
  String get analyzeDocument;

  /// No description provided for @makeComplaint.
  ///
  /// In en, this message translates to:
  /// **'Make Complaint'**
  String get makeComplaint;

  /// No description provided for @knowRights.
  ///
  /// In en, this message translates to:
  /// **'Know Rights'**
  String get knowRights;

  /// No description provided for @exploreLegalHelp.
  ///
  /// In en, this message translates to:
  /// **'Explore Legal Help'**
  String get exploreLegalHelp;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All →'**
  String get seeAll;

  /// No description provided for @latestLegalUpdate.
  ///
  /// In en, this message translates to:
  /// **'Latest Legal Update'**
  String get latestLegalUpdate;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All →'**
  String get viewAll;

  /// No description provided for @legalHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'⚖ Legal Help'**
  String get legalHelpTitle;

  /// No description provided for @legalHelpDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask questions, search laws and understand legal procedures.'**
  String get legalHelpDesc;

  /// No description provided for @searchLaws.
  ///
  /// In en, this message translates to:
  /// **'Search Laws'**
  String get searchLaws;

  /// No description provided for @whatShouldIDo.
  ///
  /// In en, this message translates to:
  /// **'What Should I Do?'**
  String get whatShouldIDo;

  /// No description provided for @legalDictionary.
  ///
  /// In en, this message translates to:
  /// **'Legal Dictionary'**
  String get legalDictionary;

  /// No description provided for @rightsAndProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'🛡 Rights & Protection'**
  String get rightsAndProtectionTitle;

  /// No description provided for @rightsAndProtectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Understand your rights as a citizen, worker, or consumer.'**
  String get rightsAndProtectionDesc;

  /// No description provided for @womensRights.
  ///
  /// In en, this message translates to:
  /// **'Women\'s Rights'**
  String get womensRights;

  /// No description provided for @consumerRights.
  ///
  /// In en, this message translates to:
  /// **'Consumer Rights'**
  String get consumerRights;

  /// No description provided for @propertyRights.
  ///
  /// In en, this message translates to:
  /// **'Property Rights'**
  String get propertyRights;

  /// No description provided for @govAndWelfareTitle.
  ///
  /// In en, this message translates to:
  /// **'🏛 Government & Welfare'**
  String get govAndWelfareTitle;

  /// No description provided for @govAndWelfareDesc.
  ///
  /// In en, this message translates to:
  /// **'Find schemes, pensions, and government support.'**
  String get govAndWelfareDesc;

  /// No description provided for @schemeFinder.
  ///
  /// In en, this message translates to:
  /// **'Scheme Finder'**
  String get schemeFinder;

  /// No description provided for @farmerSchemes.
  ///
  /// In en, this message translates to:
  /// **'Farmer Schemes'**
  String get farmerSchemes;

  /// No description provided for @publicServices.
  ///
  /// In en, this message translates to:
  /// **'Public Services'**
  String get publicServices;

  /// No description provided for @documentsAndComplaintsTitle.
  ///
  /// In en, this message translates to:
  /// **'📄 Documents & Complaints'**
  String get documentsAndComplaintsTitle;

  /// No description provided for @documentsAndComplaintsDesc.
  ///
  /// In en, this message translates to:
  /// **'Analyze legal documents and create formal complaints.'**
  String get documentsAndComplaintsDesc;

  /// No description provided for @explainNotice.
  ///
  /// In en, this message translates to:
  /// **'Explain Notice'**
  String get explainNotice;

  /// No description provided for @draftComplaint.
  ///
  /// In en, this message translates to:
  /// **'Draft Complaint'**
  String get draftComplaint;

  /// No description provided for @findLegalHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'👩‍⚖ Find Legal Help'**
  String get findLegalHelpTitle;

  /// No description provided for @findLegalHelpDesc.
  ///
  /// In en, this message translates to:
  /// **'Locate free legal aid and emergency contacts.'**
  String get findLegalHelpDesc;

  /// No description provided for @findLegalAid.
  ///
  /// In en, this message translates to:
  /// **'Find Legal Aid'**
  String get findLegalAid;

  /// No description provided for @emergencyHelp.
  ///
  /// In en, this message translates to:
  /// **'Emergency Help'**
  String get emergencyHelp;

  /// No description provided for @whatAreYouLookingFor.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for?'**
  String get whatAreYouLookingFor;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @aboutJurixbot.
  ///
  /// In en, this message translates to:
  /// **'About JuriXBot'**
  String get aboutJurixbot;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'JuriXBot provides general legal information and AI-assisted guidance. It is not a substitute for advice from a qualified advocate or legal professional.'**
  String get aboutDescription;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @howCanIHelpQueries.
  ///
  /// In en, this message translates to:
  /// **'How can I help with your legal queries?'**
  String get howCanIHelpQueries;

  /// No description provided for @jurixbotIsTyping.
  ///
  /// In en, this message translates to:
  /// **'JuriXBot is typing...'**
  String get jurixbotIsTyping;

  /// No description provided for @askLegalQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Ask a legal question...'**
  String get askLegalQuestionHint;

  /// No description provided for @newLawBadge.
  ///
  /// In en, this message translates to:
  /// **'NEW LAW'**
  String get newLawBadge;

  /// No description provided for @bnsTakesEffect.
  ///
  /// In en, this message translates to:
  /// **'Bharatiya Nyaya Sanhita (BNS) takes effect'**
  String get bnsTakesEffect;

  /// No description provided for @bnsDescription.
  ///
  /// In en, this message translates to:
  /// **'The new criminal laws replacing the IPC have officially come into effect across India.'**
  String get bnsDescription;
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
        'bn',
        'en',
        'hi',
        'kn',
        'ml',
        'mr',
        'ta',
        'te'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
