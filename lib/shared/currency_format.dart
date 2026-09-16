extension CurrencyFormatting on double {
  String toBRL() => 'R\$ ${toStringAsFixed(2).replaceAll('.', ',')}';
}
