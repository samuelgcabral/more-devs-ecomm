import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/shared/app_colors.dart';

// Dropdown de marcas da categoria. A opção null representa "Todas as Marcas".
class BrandFilter extends StatelessWidget {
  const BrandFilter({
    super.key,
    required this.brands,
    required this.selectedBrand,
    required this.onChanged,
  });

  final List<String> brands;
  final String? selectedBrand;
  final ValueChanged<String?> onChanged;

  static const String allBrandsLabel = 'Todas as Marcas';

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.grey100),
    );

    return DropdownButtonFormField<String?>(
      // A key muda junto com a seleção para o campo refletir resets feitos
      // pelo controller (ex.: ao carregar outra categoria).
      key: ValueKey(selectedBrand),
      initialValue: selectedBrand,
      isExpanded: true,
      decoration: InputDecoration(
        border: border,
        enabledBorder: border,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      items: [
        const DropdownMenuItem<String?>(child: Text(allBrandsLabel)),
        for (final brand in brands)
          DropdownMenuItem<String?>(
            value: brand,
            child: Text(brand, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: brands.isEmpty ? null : onChanged,
    );
  }
}
