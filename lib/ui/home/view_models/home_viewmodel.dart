import 'dart:collection';

import 'package:app/data/repositories/booking_repository.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/domain/models/booking_summary.dart';
import 'package:app/domain/models/user.dart';
import 'package:app/utils/command.dart';
import 'package:app/utils/result.dart';
import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required BookingRepository bookingRepository,
    required UserRepository userRepository,
  }) : _bookingRepository = bookingRepository,
       _userRepository = userRepository {
    // Load required data when this screen is built.
    load = Command0(_load)..execute();
    deleteBooking = Command1(_deleteBooking);
    updateBookingEndDate = Command1(_updateBookingEndDate);
  }

  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;

  late Command0 load;
  late Command1<void, int> deleteBooking;
  late Command1<void, int> updateBookingEndDate;

  User? _user;
  User? get user => _user;

  List<BookingSummary> _bookings = [];

  /// Items in an [UnmodifiableListView] can't be directly modified,
  /// but changes in the source list can be modified. Since _bookings
  /// is private and bookings is not, the view has no way to modify the
  /// list directly.
  UnmodifiableListView<BookingSummary> get bookings => UnmodifiableListView(_bookings);

  Future<Result> _load() async {
    try {
      final userResult = await _userRepository.getUser();
      switch (userResult) {
        case Ok<User>():
          _user = userResult.value;
          debugPrint('Loaded user');
        case Error<User>():
          debugPrint('Failed to load user: ${userResult.error}');
          return userResult;
      }

      final bookingsResult = await _bookingRepository.getBookingList();
      switch (bookingsResult) {
        case Ok<List<BookingSummary>>():
          _bookings = bookingsResult.value;
          debugPrint('Loaded bookings');
        case Error<List<BookingSummary>>():
          debugPrint('Failed to load bookings: ${bookingsResult.error}');
          return bookingsResult;
      }

      return bookingsResult;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteBooking(int id) async {
    try {
      final resultDelete = await _bookingRepository.delete(id);
      switch (resultDelete) {
        case Ok<void>():
          debugPrint('Deleted booking $id');
        case Error<void>():
          debugPrint('Failed to delete booking $id: ${resultDelete.error}');
          return resultDelete;
      }

      final resultLoadBookings = await _bookingRepository.getBookingList();
      switch (resultLoadBookings) {
        case Ok<List<BookingSummary>>():
          _bookings = resultLoadBookings.value;
          debugPrint('Reloaded bookings after delete');
        case Error<List<BookingSummary>>():
          debugPrint('Failed to reload bookings: ${resultLoadBookings.error}');
      }

      return resultLoadBookings;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _updateBookingEndDate(int id) async {
    try {
      final resultUpdate = await _bookingRepository.updateEndDate(id, DateTime.now());
      switch (resultUpdate) {
        case Ok<void>():
          debugPrint('Updated endDate for booking $id');
        case Error<void>():
          debugPrint('Failed to update endDate for booking $id: ${resultUpdate.error}');
          return resultUpdate;
      }

      final resultLoadBookings = await _bookingRepository.getBookingList();
      switch (resultLoadBookings) {
        case Ok<List<BookingSummary>>():
          _bookings = resultLoadBookings.value;
          debugPrint('Reloaded bookings after endDate update');
        case Error<List<BookingSummary>>():
          debugPrint('Failed to reload bookings: ${resultLoadBookings.error}');
      }

      return resultLoadBookings;
    } finally {
      notifyListeners();
    }
  }
}
