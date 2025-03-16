import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mappingapp/api/riverpod/chate_data/chat_provider.dart';
import 'package:mappingapp/api/riverpod/history_data/history_data.dart';
import 'package:mappingapp/api/riverpod/map_data/map_provider.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(navigationHistoryProvider);
    ref.watch(locationProvider);
    ref.watch(markerProvider);
    ref.watch(routeProvider);
    ref.watch(cameraPositionProvider);
    ref.watch(mapControllerProvider);
    ref.watch(destinationProvider);
    ref.watch(chatMessagesProvider);
    return Container();
  }
}
