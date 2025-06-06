typedef FormFieldValidator<T> = String? Function(T? value);

FormFieldValidator<T> combinedValidator<T>({
  bool useDefaultValidator = false,
  FormFieldValidator<T>? customValidator,
}) {
  return (T? value) {
    if (useDefaultValidator) {
      if (value == null) {
        return 'Campo não pode ser vazio';
      }
      if (value is String && value.trim().isEmpty) {
        return 'Campo não pode ser vazio';
      }
    }
    if (customValidator != null) {
      return customValidator(value);
    }
    return null;
  };
}
