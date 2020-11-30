class AllTextData {
  List<AllText> allText;

  AllTextData({this.allText});

  AllTextData.fromJson(Map<String, dynamic> json) {
    if (json['allText'] != null) {
      allText = new List<AllText>();
      json['allText'].forEach((v) {
        allText.add(new AllText.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allText != null) {
      data['allText'] = this.allText.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllText {
  String textId = '';
  String fr = '';
  String ar = '';
  String en = '';
  String ja = '';

  AllText({this.textId = '', this.fr = '', this.en = '', this.ar = '', this.ja = ""});

  AllText.fromJson(Map<String, dynamic> json) {
    textId = json['textId'] ?? '';
    if (json['languageTextList'] != null) {
      json['languageTextList'].forEach((text) {
        if (text["fr"] != null) {
          fr = text["fr"] ?? textId;
        }
        if (text["ar"] != null) {
          ar = text["ar"] ?? textId;
        }
        if (text["en"] != null) {
          en = text["en"] ?? textId;
        }
        if (text["ja"] != null) {
          ja = text["ja"] ?? textId;
        }
      });
      if (fr == '') {
        fr = textId;
      }
      if (ar == '') {
        ar = textId;
      }
      if (en == '') {
        en = textId;
      }
      if (ja == '') {
        ja = textId;
      }
    } else {
      fr = textId;
      ar = textId;
      en = textId;
      ja = textId;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['textId'] = this.textId;
    data['fr'] = this.fr;
    data['ar'] = this.ar;
    data['en'] = this.en;
    data['ja'] = this.ja;
    return data;
  }
}
