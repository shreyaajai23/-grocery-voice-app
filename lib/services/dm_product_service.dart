import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product_suggestion.dart';

/// Searches a curated local catalog of common DM products (bundled as a JSON
/// asset). DM has no working public/unofficial product-search API, so this
/// local list stands in for live data. Extend assets/dm_products.json to add
/// more items.
class DmProductService {
  List<ProductSuggestion>? _catalog;

  Future<List<ProductSuggestion>> _loadCatalog() async {
    if (_catalog != null) return _catalog!;
    final raw = await rootBundle.loadString('assets/dm_products.json');
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    _catalog = data
        .map(
          (e) => ProductSuggestion(
            name: e['name'] as String,
            brand: e['brand'] as String?,
            source: 'DM',
          ),
        )
        .toList();
    return _catalog!;
  }

  Future<List<ProductSuggestion>> search(String query, {int limit = 8}) async {
    if (query.trim().isEmpty) return [];
    final catalog = await _loadCatalog();
    final needle = query.toLowerCase();
    return catalog
        .where(
          (p) =>
              p.name.toLowerCase().contains(needle) ||
              (p.brand?.toLowerCase().contains(needle) ?? false),
        )
        .take(limit)
        .toList();
  }
}
