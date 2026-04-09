import 'package:app/domain/models/booking_summary.dart';
import 'package:app/ui/core/ui/shared_widgets.dart';
import 'package:app/ui/home/providers/home_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel.load,
          builder: (context, child) {
            if (viewModel.load.running) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.load.error) {
              return ErrorIndicator(
                title: '홈 화면을 불러오는 중 오류가 발생했습니다.',
                label: '다시 시도',
                onPressed: viewModel.load.execute,
              );
            }

            // The command has completed without error.
            // Return the main view widget.
            return child!;
          },
          // child는 load 상태와 무관하게 빌드되며,
          // viewModel 변경 시에만 재빌드됩니다.
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        viewModel.user?.name ?? '',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: viewModel.bookings.length,
                    itemBuilder: (_, index) => _BookingItem(
                      key: ValueKey(viewModel.bookings[index].id),
                      booking: viewModel.bookings[index],
                      onDismissed: (_) =>
                          viewModel.deleteBooking.execute(viewModel.bookings[index].id),
                      onUpdateEndDate: (_) =>
                          viewModel.updateBookingEndDate.execute(viewModel.bookings[index].id),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BookingItem extends StatelessWidget {
  const _BookingItem({
    super.key,
    required this.booking,
    required this.onDismissed,
    required this.onUpdateEndDate,
  });

  final BookingSummary booking;
  final DismissDirectionCallback onDismissed;
  final DismissDirectionCallback onUpdateEndDate;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(booking.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // 오른쪽 스와이프는 항목 삭제 없이 endDate만 업데이트
          onUpdateEndDate(direction);
          return false;
        }
        return true;
      },
      onDismissed: onDismissed,
      // 오른쪽 스와이프: endDate를 현재 시간으로 업데이트
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        color: Colors.green,
        child: const Icon(Icons.check, color: Colors.white),
      ),
      // 왼쪽 스와이프: 삭제
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: Text(booking.name),
        subtitle: Text('${booking.startDate} ~ ${booking.endDate}'),
      ),
    );
  }
}
