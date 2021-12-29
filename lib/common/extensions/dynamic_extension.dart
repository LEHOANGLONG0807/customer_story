import 'package:intl/intl.dart';

extension DynamicExtension on dynamic {
  String get formatCurrencyNoName {
    final locale = 'en';
    final currencyName = '';
    final errorText = '0';
    var formatter = NumberFormat.currency(locale: locale, name: currencyName, decimalDigits: 0, customPattern: "#,##0.00\u00A4");
    switch (this.runtimeType) {
      case num:
      case int:
      case double:
        return formatter.format(this);
      case String:
        var value = double.tryParse(this);
        if (value == null) {
          return errorText;
        }
        return formatter.format(value);
      default:
        return errorText;
    }
  }

  String get formatCurrency {
    final locale = 'en';
    final errorText = '0';

    switch (this.runtimeType) {
      case num:
      case int:
      case double:
        var formatter = NumberFormat.simpleCurrency(
          locale: locale,
          decimalDigits: 0,
        );
        if (this % 1 != 0)
          formatter = NumberFormat.simpleCurrency(
            locale: locale,
            decimalDigits: 2,
          );
        return formatter.format(this);
      case String:
        var value = double.tryParse(this);
        if (value == null) {
          return errorText;
        }
        var formatter = NumberFormat.simpleCurrency(
          locale: locale,
          decimalDigits: 0,
        );
        if (value % 1 != 0)
          formatter = NumberFormat.simpleCurrency(
            locale: locale,
            decimalDigits: 2,
          );
        return formatter.format(value);
      default:
        return errorText;
    }
  }
}
