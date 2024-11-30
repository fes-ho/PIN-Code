import 'package:flutter/material.dart';
import 'package:frontend/src/features/time_tracking/presentation/time_tracking_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeTrackingWidget extends StatelessWidget {
  const TimeTrackingWidget({
    super.key,
    required this.viewModel,
  });

  final TimeTrackingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  viewModel.hasEstimatedDuration ? 'Timer' : 'Stopwatch',
                  style: GoogleFonts.quicksand(
                    color: colorScheme.onTertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<int>(
                stream: viewModel.durationStream,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Text(
                        viewModel.formatDuration(snapshot.data ?? 0),
                        style: GoogleFonts.quicksand(
                          color: colorScheme.onSurface,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: (!viewModel.isTracking || viewModel.isPaused) ? viewModel.startTracking : null,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Start'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: viewModel.isTracking ? () => viewModel.pauseTracking.execute() : null,
                            icon: const Icon(Icons.pause),
                            label: const Text('Pause'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.secondary,
                              foregroundColor: colorScheme.onSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: (snapshot.data ?? 0) > 0 ? () => viewModel.stopTracking.execute() : null,
                            icon: const Icon(Icons.stop),
                            label: const Text('Stop'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.onError,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
} 