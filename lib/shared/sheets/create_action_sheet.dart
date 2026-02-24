import 'package:flutter/material.dart';
import 'package:usverse/models/create_action_item.dart';
import 'package:usverse/shared/widgets/usverse_list_tile.dart';

class CreateActionSheet extends StatelessWidget {
  final List<CreateActionItem> items;

  const CreateActionSheet({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create ✨',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return UsverseListTile(
                  leading: item.leading,
                  title: item.title,
                  subtitle: item.subtitle,
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    item.onTap();
                  },
                  extended: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
