import 'package:flutter/material.dart';
import '../consts.dart';

class HomeScreenAppBar extends AppBar {
  HomeScreenAppBar({
    super.key,
    super.bottom,
    required Function()? onNotificationActionClicked,
  }) : super(
          elevation: 0,
          title: const Text('Flyin'),
          actions: [
            IconButton(
              onPressed: onNotificationActionClicked,
              icon: const Icon(
                Icons.notifications_outlined,
                size: 18,
              ),
            )
          ],
          
        );
}

class SearchBarWithFilter extends PreferredSize {
  SearchBarWithFilter({
    super.key,
    required super.preferredSize,
  }) : super(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      constraints: BoxConstraints.tight(const Size(100, 30)),
                      contentPadding: const EdgeInsets.only(left: 5),
                      fillColor: mainColorScheme.background,
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: 0,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        width: 1,
                        color: mainThemeData.useMaterial3
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        color: mainThemeData.useMaterial3
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
}
