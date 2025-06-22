import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final itemsListProvider =
    AsyncNotifierProvider<ItemsListNotifier, List<Map<String, dynamic>>>(
      ItemsListNotifier.new,
    );

class ItemsListNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<Map<String, dynamic>>> build() async {
    return _fetchItems();
  }

  Future<List<Map<String, dynamic>>> _fetchItems() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('items')
        .select('*, category_id(name)')
        .eq('uploaded_by', user.id);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncLoading();
    try {
      await supabase.from('items').delete().eq('id', id);
      final updatedItems = await _fetchItems();
      state = AsyncData(updatedItems);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final items = await _fetchItems();
      state = AsyncData(items);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> filterByCategory(String? categoryId) async {
    try {
      state = const AsyncLoading();
      final supabase = Supabase.instance.client;

      var query = supabase
          .from('items')
          .select('*, category_id (name)')
          .eq('uploaded_by', supabase.auth.currentUser!.id);

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      final result = await query;
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
