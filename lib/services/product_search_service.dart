import '../models/product_suggestion.dart';
import 'dm_product_service.dart';
import 'rewe_product_service.dart';

/// Combines DM (local catalog) and REWE (best-effort live) suggestions.
/// REWE failures never block DM results from showing.
class ProductSearchService {
  final DmProductService _dm = DmProductService();
  final ReweProductService _rewe = ReweProductService();

  Future<List<ProductSuggestion>> search(String query) async {
    final results = await Future.wait([
      _dm.search(query),
      _rewe.search(query),
    ]);
    final dmResults = results[0];
    final reweResults = results[1];
    return [...reweResults, ...dmResults];
  }
}
