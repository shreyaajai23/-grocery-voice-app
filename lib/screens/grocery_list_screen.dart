import 'package:flutter/material.dart';
import '../models/grocery_item.dart';
import '../models/product_suggestion.dart';
import '../services/product_search_service.dart';
import '../widgets/voice_input_button.dart';
import '../widgets/product_suggestion_list.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final List<GroceryItem> _items = [];
  final ProductSearchService _productSearch = ProductSearchService();
  final TextEditingController _textController = TextEditingController();

  List<ProductSuggestion> _suggestions = [];
  String _pendingText = '';

  Future<void> _updateSuggestions(String text) async {
    setState(() => _pendingText = text);
    if (text.trim().isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    final results = await _productSearch.search(text);
    if (mounted) setState(() => _suggestions = results);
  }

  void _addItem({required String name, String? brand, String? source}) {
    setState(() {
      _items.insert(
        0,
        GroceryItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: name,
          brand: brand,
          source: source,
          createdAt: DateTime.now(),
        ),
      );
      _suggestions = [];
      _pendingText = '';
      _textController.clear();
    });
  }

  void _toggleChecked(GroceryItem item) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == item.id);
      _items[index] = item.copyWith(isChecked: !item.isChecked);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() => _items.removeWhere((i) => i.id == item.id));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          VoiceInputButton(
            idleHint: 'Tap to speak a grocery item',
            onFinalResult: (text) => _updateSuggestions(text),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Or type an item…',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _updateSuggestions,
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) _addItem(name: text.trim());
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_pendingText.trim().isNotEmpty) {
                    _addItem(name: _pendingText.trim());
                  }
                },
              ),
            ],
          ),
          if (_suggestions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ProductSuggestionList(
                suggestions: _suggestions,
                onSelect: (s) =>
                    _addItem(name: s.name, brand: s.brand, source: s.source),
              ),
            ),
          const SizedBox(height: 12),
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('Your grocery list is empty.'))
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return CheckboxListTile(
                        value: item.isChecked,
                        onChanged: (_) => _toggleChecked(item),
                        title: Text(
                          item.name,
                          style: item.isChecked
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                )
                              : null,
                        ),
                        subtitle: item.brand != null
                            ? Text('${item.brand} · ${item.source ?? ''}')
                            : null,
                        secondary: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeItem(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
