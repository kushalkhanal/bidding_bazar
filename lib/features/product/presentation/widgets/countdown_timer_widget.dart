import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class CountdownTimerWidget extends StatelessWidget {
  final DateTime endTime;
  const CountdownTimerWidget({super.key, required this.endTime});

  @override
  Widget build(BuildContext context) {
    final int endTimeMs = endTime.millisecondsSinceEpoch;

    return CountdownTimer(
      endTime: endTimeMs,
      widgetBuilder: (_, time) {
        if (time == null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red),
            ),
            child: const Center(
              child: Text(
                'Auction Has Ended',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTimeCard(time.days, 'Days', context),
            _buildTimeCard(time.hours, 'Hours', context),
            _buildTimeCard(time.min, 'Mins', context),
            _buildTimeCard(time.sec, 'Secs', context),
          ],
        );
      },
    );
  }

  Widget _buildTimeCard(int? time, String label, BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3))
          ),
          child: Text(
            '${time ?? 0}'.padLeft(2, '0'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}