import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/models/user_model.dart';
import 'package:usverse/models/usverse_navigation_items.dart';
import 'package:usverse/services/firebase/user_profile_service.dart';
import 'package:usverse/shared/widgets/buttons/usverse_icon_button.dart';
import 'package:usverse/shared/widgets/dialogs/usverse_feature_dialog.dart';
import 'package:usverse/shared/widgets/usverse_list_tile.dart';

class UsverseSidebar extends StatefulWidget {
  final int selectedIndex;
  final List<UsverseNavigationItem> items;
  final ValueChanged<int> onItemSelected;

  const UsverseSidebar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  @override
  State<UsverseSidebar> createState() => _UsverseSidebarState();
}

class _UsverseSidebarState extends State<UsverseSidebar> {
  final auth = FirebaseAuth.instance.currentUser!;
  bool extended = true;
  final profileService = UserProfileService();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOutCubic,
      width: extended ? 260 : 72,
      decoration: BoxDecoration(
        color: colors.surfaceContainer.withAlpha(100),
        border: Border(
          right: BorderSide(color: colors.outlineVariant, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 2.0,
              ),
              child: Row(
                mainAxisAlignment: extended
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: UsverseIconButton(
                      onTap: () {
                        setState(() => extended = !extended);
                      },
                      icon: HugeIcons.strokeRoundedSidebarLeft,
                      message: extended ? 'Close sidebar' : 'Open sidebar',
                      mouseCursor: extended
                          ? SystemMouseCursors.resizeLeft
                          : SystemMouseCursors.resizeRight,
                    ),
                  ),

                  if (extended)
                    Flexible(
                      child: ClipRect(
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOutCubic,
                          alignment: Alignment.centerLeft,
                          widthFactor: extended ? 1 : 0,
                          child: SvgPicture.asset(
                            'assets/logos/usverse_logo.svg',
                            width: 100,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.onSurface,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (extended) const Spacer(),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(widget.items.length, (index) {
                    final item = widget.items[index];

                    return UsverseListTile(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      leading: HugeIcon(
                        icon: item.icon,
                        color: index == widget.selectedIndex
                            ? colors.onPrimaryContainer
                            : null,
                      ),
                      title: item.label,
                      selected: widget.selectedIndex == index,
                      onTap: () => widget.onItemSelected(index),
                      extended: extended,
                      selectedColor: colors.primaryContainer.withAlpha(80),
                    );
                  }),
                ),
              ),
            ),

            StreamBuilder<UserModel?>(
              stream: profileService.watchUser(auth.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final user = snapshot.data;

                return UsverseListTile(
                  margin: EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: user!.photoUrl!,
                      scale: 3,
                      placeholder: (_, _) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (_, _, _) =>
                          const HugeIcon(icon: HugeIcons.strokeRoundedUser),
                    ),
                  ),
                  title: user.displayName,
                  subtitle: user.email,
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => UsverseFeatureDialog(
                      image: CachedNetworkImage(
                        imageUrl: user.photoUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (_, _, _) =>
                            const HugeIcon(icon: HugeIcons.strokeRoundedUser),
                      ),
                      title: user.displayName,
                      description: user.email,
                      cancelText: 'Close',
                    ),
                  ),
                  selected: false,
                  extended: extended,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
