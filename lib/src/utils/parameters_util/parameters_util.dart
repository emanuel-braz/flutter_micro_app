class ParametersUtil {
  static String getParametersAsString(dynamic parameters) {
    if (parameters == null) return '';

    if (parameters is String) return parameters;

    String parametersAsString = parameters.runtimeType.toString();

    if (parametersAsString.contains(' => ')) {
      parametersAsString = parametersAsString.split(' => ').first;
    }

    // Remove os parênteses do início e do fim
    String cleanedSignature =
        parametersAsString.replaceAll(RegExp(r'^\(|\)$'), '');

    // Remove Key? key e _Location
    cleanedSignature = cleanedSignature.replaceAll(
        RegExp(r'(Key\?\s*key\s*,?\s*|\w*_Location\?.*?(,|(?=\})))'), '');

    cleanedSignature = cleanedSignature.trim().replaceAll('{}', '');

    // Remove espaços extras e vírgulas no final
    cleanedSignature = cleanedSignature.replaceAll(RegExp(r',\s*$'), '');

    // se existir virgula ou espaço antes ou depois de uma chave, remove
    cleanedSignature =
        cleanedSignature.replaceAll(RegExp(r',\s*}'), '}').trim();
    cleanedSignature =
        cleanedSignature.replaceAll(RegExp(r'{\s*,'), '{').trim();

    // Se a string final for apenas chaves vazias, remove as chaves também
    cleanedSignature =
        cleanedSignature.trim() == '{}' ? '' : cleanedSignature.trim();

    return cleanedSignature;
  }
}
