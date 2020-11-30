extension StringExtension on String {
  get stringToName {
    if (this != null) {
      if (this.length > 0) {
        return this[0].toUpperCase() + this.substring(1);
      } else {
        return this;
      }
    } else
      return this;
  }

  get removeZeroInNumber {
    if (this != null) {
      if (this.length > 0) {
        if (this[0] == "0") {
          return this.substring(1);
        } else {
          return this;
        }
      } else {
        return this;
      }
    } else
      return this;
  }
}
