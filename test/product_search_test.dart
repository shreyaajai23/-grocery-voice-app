import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_voice_app/services/dm_product_service.dart';
import 'package:grocery_voice_app/services/product_search_service.dart';
import 'package:grocery_voice_app/services/rewe_product_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DmProductService', () {
    test('matches by product name substring, case-insensitively', () async {
      final service = DmProductService();
      final results = await service.search('milch');
      expect(results, isNotEmpty);
      expect(
        results.every((r) => r.name.toLowerCase().contains('milch')),
        isTrue,
      );
      expect(results.every((r) => r.source == 'DM'), isTrue);
    });

    test('matches by brand', () async {
      final service = DmProductService();
      final results = await service.search('dmbio');
      expect(results, isNotEmpty);
    });

    test('returns nothing for an empty query', () async {
      final service = DmProductService();
      final results = await service.search('');
      expect(results, isEmpty);
    });

    test('returns nothing for a query matching no products', () async {
      final service = DmProductService();
      final results = await service.search('zzzznotarealproductzzzz');
      expect(results, isEmpty);
    });
  });

  group('ReweProductService', () {
    test('never throws and returns an empty list (best-effort, no live API)', () async {
      final service = ReweProductService();
      final results = await service.search('Milch');
      expect(results, isEmpty);
    });
  });

  group('ProductSearchService', () {
    test('still returns DM results when REWE yields nothing', () async {
      final service = ProductSearchService();
      final results = await service.search('Milch');
      expect(results, isNotEmpty);
      expect(results.every((r) => r.source == 'DM'), isTrue);
    });
  });
}
