import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationHistoryProvider =
    StateNotifierProvider<NavigationHistoryNotifier, List<Map<String, String>>>(
      (ref) => NavigationHistoryNotifier(),
    );

class NavigationHistoryNotifier
    extends StateNotifier<List<Map<String, String>>> {
  NavigationHistoryNotifier() : super([]);

  /// ✅ **Add new navigation history (max 5 records)**
  void addHistory(String fromAddress, String toAddress) {
    final newHistory = List<Map<String, String>>.from(state); // Copy old state
    if (newHistory.length >= 5) {
      newHistory.removeAt(0); // Keep only last 5
    }
    newHistory.add({"from": fromAddress, "to": toAddress});
    state = newHistory; // ✅ Update state properly
  }

  /// ✅ **Update a specific record (e.g., change destination)**
  void updateHistory(int index, String fromAddress, String toAddress) {
    if (index < 0 || index >= state.length) return; // Prevent invalid index

    final updatedHistory = List<Map<String, String>>.from(state);
    updatedHistory[index] = {"from": fromAddress, "to": toAddress};

    state = updatedHistory; // ✅ Update state
  }

  /// ✅ **Remove a history entry by index**
  void removeHistory(int index) {
    if (index < 0 || index >= state.length) return;

    final updatedHistory = List<Map<String, String>>.from(state);
    updatedHistory.removeAt(index);

    state = updatedHistory; // ✅ Update state
  }
}
