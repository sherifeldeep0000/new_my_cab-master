import 'package:my_cab/constance/constance.dart' as constance;

class AppLocalizations {
  static String of(String text, {String ignoreLanguageCode: 'en'}) {
    String myLocale = constance.locale;
    // if (myLocale.languageCode != '' &&
    //     myLocale.languageCode != 'en' &&
    //     (myLocale.languageCode == 'fr' || myLocale.languageCode == 'ar') &&
    //     ignoreLanguageCode != myLocale.languageCode) {
    if (constance.allTextData != null && constance.allTextData.allText.length > 0) {
      var newtext = '';
      int index = constance.allTextData.allText.indexWhere((note) => note.textId == text);
      if (index != -1) {
        if (myLocale == 'fr') {
          newtext = constance.allTextData.allText[index].fr;
        } else if (myLocale == 'ar') {
          newtext = constance.allTextData.allText[index].ar;
        } else if (myLocale == 'en') {
          newtext = constance.allTextData.allText[index].en;
        } else if (myLocale == 'ja') {
          newtext = constance.allTextData.allText[index].ja;
        }
        if (newtext != '') {
          return newtext;
        } else {
          return text;
        }
      } else {
        return text;
      }
    } else {
      return text;
    }
  }
}
