main() {
  String funcSignature = '(String okok)';
  // String funcSignature =
  //     '(String data, bool isOk, { Map<String, dynamic> json, Key? key, _Location? \$creationLocationd_0dea112b090073317d4, int someOtherParam })';

  // Remove os parênteses do início e do fim
  String cleanedSignature = funcSignature.replaceAll(RegExp(r'^\(|\)$'), '');

  // Remove Key? key e _Location
  cleanedSignature = cleanedSignature.replaceAll(
      RegExp(r'(Key\?\s*key\s*,?\s*|\w*_Location\?.*?(,|(?=\})))'), '');

  // Remove espaços extras e vírgulas no final
  cleanedSignature = cleanedSignature.replaceAll(RegExp(r',\s*$'), '');

  // Se a string final for apenas chaves vazias, remove as chaves também
  cleanedSignature =
      cleanedSignature.trim() == '{}' ? '' : cleanedSignature.trim();
  return;
}
