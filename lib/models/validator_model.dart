class ValidatorModel {
  String? validateName(String? value) {
    if (value!.length < 5)
      return 'Name field is required';
    else
      return '';
  }

  String validateVille(String value) {
    if (value.isEmpty)
      return 'veuillez entrez une ville svp';
    else
      return '';
  }

  String? validateNumber(String? value) {
    String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value!))
      return 'Phone number is wrong or empty';
    else
      return '';
  }

  String? validatePassword(String? value) {
    if (value!.length < 6)
      return 'Le mot de passe trop court';
    else
      return '';
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp? regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return 'Entrez une adresse email valide';
    else
      return '';
  }
}
