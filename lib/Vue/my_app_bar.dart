import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSearch;

  const MyAppBar({super.key, required this.onSearch});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Search...',
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onSearch,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => widget.onSearch(_controller.text),
        ),
      ],
    );
  }
}