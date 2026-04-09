import 'package:app/data/repositories/booking_repository_provider.dart';
import 'package:app/data/repositories/user_repository_provider.dart';
import 'package:app/ui/home/view_models/home_viewmodel.dart';
import 'package:flutter_riverpod/legacy.dart';

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  return HomeViewModel(
    bookingRepository: ref.watch(bookingRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
});
