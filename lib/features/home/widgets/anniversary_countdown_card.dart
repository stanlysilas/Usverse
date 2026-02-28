import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/core/utils/date_functions.dart';
import 'package:usverse/models/countdown_model.dart';
import 'package:usverse/models/relationship_model.dart';
import 'package:usverse/shared/widgets/countdown_box.dart';

class AnniversaryCountdownCard extends StatefulWidget {
  final Relationship relationship;
  const AnniversaryCountdownCard({super.key, required this.relationship});

  @override
  State<AnniversaryCountdownCard> createState() =>
      _AnniversaryCountdownCardState();
}

class _AnniversaryCountdownCardState extends State<AnniversaryCountdownCard> {
  late DateTime nextAnniversary;
  late String years;
  late Timer timer;
  late ConfettiController confettiController;
  bool hasCelebrated = false;
  Duration remaining = Duration.zero;

  @override
  void initState() {
    super.initState();

    nextAnniversary = DateFunctions().getNextAnniversary(
      widget.relationship.anniversaryDate,
    );
    years = DateFunctions().yearsUntilNextAnniversary(
      widget.relationship.anniversaryDate,
    );

    updateCountdown();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => updateCountdown(),
    );

    confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );

    checkAndCelebrate();
  }

  void updateCountdown() {
    final newRemaining = DateFunctions().timeUntil(nextAnniversary);

    if (!hasCelebrated && newRemaining.inSeconds <= 0) {
      hasCelebrated = true;
      confettiController.play();
    }

    setState(() {
      remaining = newRemaining;
    });
  }

  Future<void> checkAndCelebrate() async {
    if (!DateFunctions().isAnniversaryToday(
      widget.relationship.anniversaryDate,
    )) {
      return;
    }
    confettiController.play();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parts = splitDuration(remaining);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedCalendar01,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      'Anniversary Countdown ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const Divider(),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CountdownBox(value: parts.days, label: "Days"),
                    ),
                    Expanded(
                      child: CountdownBox(value: parts.hours, label: "Hours"),
                    ),
                    Expanded(
                      child: CountdownBox(
                        value: parts.minutes,
                        label: "Minutes",
                      ),
                    ),
                    Expanded(
                      child: CountdownBox(
                        value: parts.seconds,
                        label: "Seconds",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                DateFunctions().isAnniversaryToday(
                      widget.relationship.anniversaryDate,
                    )
                    ? Text(
                        'Happy Anniversary to ${widget.relationship.relationshipName} ❤️',
                      )
                    : Text(years, style: TextStyle(fontSize: 16)),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        ConfettiWidget(
          confettiController: confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          emissionFrequency: 0.05,
          numberOfParticles: 25,
          gravity: 0.2,
        ),
      ],
    );
  }
}
