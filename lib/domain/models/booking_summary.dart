/// A lightweight summary of a booking used for list display.
class BookingSummary {
  const BookingSummary({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  BookingSummary copyWith({int? id, String? name, DateTime? startDate, DateTime? endDate}) {
    return BookingSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
