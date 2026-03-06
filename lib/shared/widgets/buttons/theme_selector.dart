import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/core/theme/app_theme_option.dart';
import 'package:usverse/core/theme/theme_scope.dart';

class ThemeButton extends StatelessWidget {
  final AppThemeOption option;
  final AppThemeOption selected;
  final ValueChanged<AppThemeOption> onSelected;

  const ThemeButton({
    super.key,
    required this.option,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = option == selected;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onSelected(option),
        child: Column(
          children: [
            AnimatedContainer(
              height: 100,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.outlineVariant,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(decoration: _previewDecoration(option, colors)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HugeIcon(
                        icon: option == AppThemeOption.light
                            ? HugeIcons.strokeRoundedSun01
                            : option == AppThemeOption.dark
                            ? HugeIcons.strokeRoundedMoon02
                            : HugeIcons.strokeRoundedComputer,
                        color: option == AppThemeOption.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              option.label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? colors.onPrimaryContainer
                    : colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _previewDecoration(AppThemeOption option, ColorScheme colors) {
    if (option == AppThemeOption.light) {
      return const BoxDecoration(color: Colors.white);
    }

    if (option == AppThemeOption.dark) {
      return const BoxDecoration(color: Colors.black);
    }

    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Colors.white, Colors.black, Colors.black],
        stops: [0, 0.5, 0.5, 1],
      ),
    );
  }
}

class ThemeSelectorRow extends StatelessWidget {
  const ThemeSelectorRow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeScope.of(context);

    final current = AppThemeOption.values.firstWhere(
      (e) => e.toThemeMode == controller.mode,
    );

    return Row(
      children: List.generate(AppThemeOption.values.length, (index) {
        final option = AppThemeOption.values[index];

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index != AppThemeOption.values.length - 1 ? 12 : 0,
            ),
            child: ThemeButton(
              option: option,
              selected: current,
              onSelected: (value) {
                controller.setTheme(value.toThemeMode);
              },
            ),
          ),
        );
      }),
    );
  }
}
