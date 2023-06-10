import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _showClearButton = ValueNotifier<bool>(false);

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        _showClearButton.value = false;
      } else {
        _showClearButton.value = true;
      }
    });
    super.initState();
  }

  void _clear() {
    _controller.clear();
    context.read<SearchProvider>().searchValue = "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: 0,
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          context.read<SearchProvider>().searchValue = value;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.withOpacity(0.2),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: ValueListenableBuilder(
            valueListenable: _showClearButton,
            builder: (context, value, child) {
              return value
                  ? IconButton(
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: _clear,
                    )
                  : const SizedBox();
            },
          ),
          hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
              ),
          labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
              ),
              counterStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
              ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Theme.of(context).canvasColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Theme.of(context).canvasColor),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        ),
      ),
    );
  }
}