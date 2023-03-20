String? validateRequiredField(String? value) {
  if (value != null && value.isNotEmpty) return null;
  return "Esse campo é obrigatório";
}
