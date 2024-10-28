import 'package:flutter/material.dart';

class IconPickerDialog extends StatelessWidget {
  final List<IconData> icons;
  final IconData initialIcon;

  const IconPickerDialog({
    super.key,
    required this.icons,
    required this.initialIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select an Icon',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: icons.length,
                itemBuilder: (context, index) {
                  return IconButton(
                    icon: Icon(icons[index]),
                    color: colorScheme.primary,
                    onPressed: () {
                      Navigator.of(context).pop(icons[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<IconData?> showIconPickerDialog({
  required BuildContext context,
  required List<IconData> icons,
  required IconData initialIcon,
}) {
  return showDialog<IconData>(
    context: context,
    builder: (BuildContext context) {
      return IconPickerDialog(
        icons: icons,
        initialIcon: initialIcon,
      );
    },
  );
}