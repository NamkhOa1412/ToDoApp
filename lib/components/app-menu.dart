import 'package:flutter/material.dart';

Future<String?> showAppMenu({
  required BuildContext context,
  required Offset position,
  required Map<String, String> items,
}) async {
  return await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      MediaQuery.of(context).size.width - position.dx,
      MediaQuery.of(context).size.height - position.dy,
    ),
    items: items.entries
        .map(
          (e) => PopupMenuItem(
            value: e.key,
            child: Text(e.value),
          ),
        )
        .toList(),
  );
}
