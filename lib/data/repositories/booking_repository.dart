import 'package:app/domain/models/booking_summary.dart';
import 'package:app/utils/result.dart';

class BookingRepository {
  final List<BookingSummary> _bookings = [
    BookingSummary(
      id: 1,
      name: 'Seoul Forest Walk',
      startDate: DateTime(2026, 4, 10),
      endDate: DateTime(2026, 4, 10),
    ),
    BookingSummary(
      id: 2,
      name: 'Hangang Night Route',
      startDate: DateTime(2026, 4, 12),
      endDate: DateTime(2026, 4, 12),
    ),
  ];

  Future<Result<List<BookingSummary>>> getBookingList() async {
    return Result.ok(List.unmodifiable(_bookings));
  }

  Future<Result<void>> delete(int id) async {
    _bookings.removeWhere((booking) => booking.id == id);
    return const Ok(null);
  }

  Future<Result<void>> updateEndDate(int id, DateTime date) async {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index == -1) {
      return Result.error(Exception('Booking $id not found'));
    }
    _bookings[index] = _bookings[index].copyWith(endDate: date);
    return const Ok(null);
  }
}
