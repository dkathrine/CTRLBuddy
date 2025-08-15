class Validator {
  //username validator
  String? validateUsername(value) {
    if (value == null || value.isEmpty) {
      return "Bitte einen Username eingeben";
    }
    if (value.length > 16) {
      return "Maximal 16 Zeichen erlaubt";
    }
    final usernameCheck = RegExp(r'^[A-Za-z0-9_]+$');
    if (!usernameCheck.hasMatch(value)) {
      return "Nur Buchstaben, Zahlen und Unterstriche erlaubt";
    }
    return null;
  }

  //email validator
  String? validateEmail(value) {
    if (value == null || value.isEmpty) {
      return "Bitte eine E-Mail-Adresse eingeben";
    }
    final emailCheck = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailCheck.hasMatch(value)) {
      return "Bitte gebe eine gültige E-Mail-Adresse ein";
    }
    return null;
  }

  //password validator
  String? validatePassword(value) {
    if (value == null || value.isEmpty) {
      return "Bitte gib ein Password ein";
    }
    if (value.length < 8) {
      return "Muss mindestens 8 Zeichen lang sein";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Muss mindestens einen Großbuchstaben enthalten";
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return "Muss mindestens eine Zahl enthalten";
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Muss mindestens ein Sonderzeichen enthalten";
    }
    return null;
  }
}
