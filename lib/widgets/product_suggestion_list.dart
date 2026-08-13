import 'package:flutter/material.dart';
import '../models/product_suggestion.dart';
import '../theme.dart';

class ProductSuggestionList extends StatelessWidget {
  final List<ProductSuggestion> suggestions;
  final void Function(ProductSuggestion suggestion) onSelect;

  const ProductSuggestionList({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 240),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: suggestions.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            color: PantryTalkTheme.terracotta.withValues(alpha: 0.08),
          ),
          itemBuilder: (context, index) {
            final s = suggestions[index];
            final isRewe = s.source == 'REWE';
            return ListTile(
              dense: true,
              title: Text(s.name),
              subtitle: s.brand != null ? Text(s.brand!) : null,
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: isRewe
                      ? PantryTalkTheme.peach
                      : PantryTalkTheme.sagePale,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  s.source,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isRewe
                        ? PantryTalkTheme.terracottaDark
                        : const Color(0xFF25381F),
                  ),
                ),
              ),
              onTap: () => onSelect(s),
            );
          },
        ),
      ),
    );
  }
}
