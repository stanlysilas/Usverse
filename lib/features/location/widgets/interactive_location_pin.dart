import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/features/location/widgets/location_info_card.dart';
import 'package:usverse/models/location_model.dart';

class InteractiveLocationPin extends StatefulWidget {
  final String? avatarUrl;
  final UserLocation location;

  const InteractiveLocationPin({
    super.key,
    required this.avatarUrl,
    required this.location,
  });

  @override
  State<InteractiveLocationPin> createState() => _InteractiveLocationPinState();
}

class _InteractiveLocationPinState extends State<InteractiveLocationPin> {
  OverlayEntry? overlay;

  bool hovering = false;

  void showHoverCard() {
    final overlayState = Overlay.of(context);

    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    overlay = OverlayEntry(
      builder: (_) => Positioned(
        left: position.dx - 80,
        top: position.dy - 90,
        child: LocationInfoCard(
          location: widget.location,
          avatarUrl: widget.avatarUrl,
        ),
      ),
    );

    overlayState.insert(overlay!);
  }

  void removeHoverCard() {
    overlay?.remove();
    overlay = null;
  }

  void openBottomSheet() {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(maxWidth: double.infinity),
      builder: (_) => LocationInfoCard(
        location: widget.location,
        avatarUrl: widget.avatarUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTouch = MediaQuery.of(context).size.width < 800;
    final colors = Theme.of(context).colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!isTouch) {
          showHoverCard();
        }
      },

      onExit: (_) {
        removeHoverCard();
      },

      child: GestureDetector(
        onTap: () {
          if (isTouch) {
            openBottomSheet();
          }
        },

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.avatarUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: colors.primaryContainer,
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedUser,
                      color: colors.surface,
                    ),
                  ),
                ),
              ),
            ),

            Container(width: 4, height: 12, color: colors.primaryContainer),
          ],
        ),
      ),
    );
  }
}
