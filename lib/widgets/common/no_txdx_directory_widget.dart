import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/utils/file_picker_helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../config/colors.dart';

class NoTxDxDirectoryWidget extends ConsumerWidget {
  const NoTxDxDirectoryWidget({Key? key}) : super(key: key);

  final theTextOne = '''Thank you for choosing TxDx! ❤️
  
  TxDx stores _your_ data on _your_ device in _plain text_. To get started, 
  please select a directory for TxDx to store your data. If you already have
  a todo.txt file, move it to the directory you select.
  ''';

  final theTextTwo = '''That's all you need to do to get started.
  
  If you're eager to get the most out of TxDx and want to learn more about 
  the principles behind the Todo.txt format, feel free to check out these 
  resources:
  
  - [TxDx Getting Started](https://www.txdx.eu/getting-started/)
  - [TxDx Keyboard Shortcuts](https://www.txdx.eu/shortcuts/)
  - [Todo.txt Primer](https://www.txdx.eu/todotxt/)
  
  We're sure you'll enjoy using TxDx daily. Now, go get things done!
  ''';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = Theme.of(context).textTheme.bodyText2?.color;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Image(image: AssetImage('assets/txdx.png'), width: 200,),
            const Text('Welcome to TxDx', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
            Container(
              width: 600,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: MarkdownBody(
                data: theTextOne,
                onTapLink: (text, href, title) {
                  if (href!.isNotEmpty) {
                    launchUrlString(href);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => pickTxDxDirectory(ref),
                    style: ElevatedButton.styleFrom(
                      primary: TxDxColors.prioDefault,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                            child: Icon(
                              Icons.folder_sharp,
                              size: 16,
                              color: textColor,
                            ),
                          ),
                          Text(
                            'Select your TxDx folder',
                            style: TextStyle(
                              fontSize: 16,
                              color: textColor,
                            )
                          ),
                        ]
                      ),
                    ),
                  ),
                ]
              ),
            ),
            Container(
              width: 600,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: MarkdownBody(
                data: theTextTwo,
                onTapLink: (text, href, title) {
                  if (href!.isNotEmpty) {
                    launchUrlString(href);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}