import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFullScreen = false;
  bool isContextMenuOpen = false;

  final TextEditingController _urlController = TextEditingController();
  String? imageUrl;

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  void _loadImage() {
    String inputUrl = _urlController.text.trim();
    setState(() {
      imageUrl = inputUrl.isNotEmpty ? inputUrl : null;
    });
  }

  void _toggleContextMenu() {
    setState(() {
      isContextMenuOpen = !isContextMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets containerPadding = isFullScreen
        ? EdgeInsets.zero
        : const EdgeInsets.fromLTRB(32, 16, 32, 16);

    Widget scaffold = Scaffold(
      appBar: isFullScreen ? null : AppBar(),
      body: Padding(
        padding: containerPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GestureDetector(
                onDoubleTap: _toggleFullScreen,
                child: isFullScreen
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.zero,
                        ),
                        child: imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.zero,
                                child: Image.network(
                                  imageUrl!,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Text(
                                      'Invalid image URL',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              )
                            : const Center(child: Text('')),
                      )
                    : AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrl!,
                                    fit: BoxFit.fill,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                      child: Text(
                                        'Invalid image URL',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Text(''),
                                ),
                        ),
                      ),
              ),
            ),
            if (!isFullScreen) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        hintText: 'Image URL',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _loadImage,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 64),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleContextMenu,
        child: const Icon(Icons.add),
        highlightElevation: 0,
      ),
    );

    return Stack(
      children: [
        scaffold,
        if (isContextMenuOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isContextMenuOpen = false;
                });
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ),
        if (isContextMenuOpen)
          Positioned(
            right: 16,
            bottom: 80,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      if (!isFullScreen) {
                        _toggleFullScreen();
                      }
                      setState(() {
                        isContextMenuOpen = false;
                      });
                    },
                    child: const Text("Enter Fullscreen"),
                  ),
                  const Divider(height: 1),
                  TextButton(
                    onPressed: () {
                      if (isFullScreen) {
                        _toggleFullScreen();
                      }
                      setState(() {
                        isContextMenuOpen = false;
                      });
                    },
                    child: const Text("Exit Fullscreen"),
                  ),
                ],
              ),
            ),
          ),
        if (isContextMenuOpen)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: _toggleContextMenu,
              child: const Icon(Icons.add),
              highlightElevation: 0,
            ),
          ),
      ],
    );
  }
}
