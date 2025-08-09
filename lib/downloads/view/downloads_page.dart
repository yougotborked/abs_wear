import 'dart:convert';
import 'dart:io';

import 'package:abs_wear/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';

import '../../player/view/player_page.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({
    required this.token,
    required this.serverUrl,
    super.key,
  });

  final String token;
  final String serverUrl;

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  late Future<List<_DownloadItem>> _itemsFuture;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _itemsFuture = _loadItems();
  }

  Future<List<_DownloadItem>> _loadItems() async {
    final directory = await getApplicationDocumentsDirectory();
    final items = <_DownloadItem>[];
    await for (final entity in directory.list()) {
      if (entity is Directory) {
        final metaFile = File('${entity.path}/meta.json');
        if (await metaFile.exists()) {
          final json =
              jsonDecode(await metaFile.readAsString()) as Map<String, dynamic>;
          items.add(
            _DownloadItem(
              id: json['id'] as String,
              title: (json['title'] as String?) ?? json['id'] as String,
            ),
          );
        }
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return RotaryScrollWrapper(
      rotaryScrollbar: RotaryScrollbar(
        width: 2,
        padding: 1,
        hasHapticFeedback: false,
        autoHide: false,
        controller: _pageController,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.downloads),
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder<List<_DownloadItem>>(
          future: _itemsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data ?? [];
            if (data.isEmpty) {
              return Center(child: Text(l10n.noDownloads));
            }
            return ListView.builder(
              controller: _pageController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: Text(
                    item.title,
                    style: theme.textTheme.bodySmall,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerPage(
                          libraryItemId: item.id,
                          serverUrl: widget.serverUrl,
                          token: widget.token,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _DownloadItem {
  const _DownloadItem({required this.id, required this.title});
  final String id;
  final String title;
}
