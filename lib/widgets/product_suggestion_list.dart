import 'package:flutter/material.dart';
import '../models/product_suggestion.dart';

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
          itemCount: suggestions.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final s = suggestions[index];
            return ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: s.source == 'REWE'
                    ? Colors.red.shade100
                    : Colors.blue.shade100,
                child: Text(
                  s.source == 'REWE' ? 'R' : 'D',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              title: Text(s.name),
              subtitle: s.brand != null ? Text(s.brand!) : null,
              onTap: () => onSelect(s),
            );
          },
        ),
      ),
    );
  }
}
