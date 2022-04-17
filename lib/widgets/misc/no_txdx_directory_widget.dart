import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/utils/file_picker_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/colors.dart';

class NoTxDxDirectoryWidget extends ConsumerWidget {
  const NoTxDxDirectoryWidget({Key? key}) : super(key: key);

  final theTextOne = '''Thank you for choosing TxDx!
  
  TxDx stores _your_ data on _your_ device. To get started, please select a 
  directory for TxDx to store your data.
  
  _If you are migrating from a previous version, please read or [FAQ on upgrading
  to 1.0.13](https://www.txdx.eu/support)_.
  ''';

  final theTextTwo = '''After that you may want to take a look at the following
  resources to learn more about the principles behind TxDx:
   
   * [Todo.txt Primer](https://www.txdx.eu/todotxt/)
   * [TxDx Getting Started](https://www.txdx.eu/getting-started/)
   
  We're sure you'll enjoy using TxDx daily. Now, go get things done!
  ''';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Image(image: AssetImage('assets/txdx.png'), width: 200,),
            const Text('Welcome to TxDx', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: MarkdownBody(
                data: theTextOne,
                onTapLink: (text, href, title) {
                  if (href!.isNotEmpty) {
                    launch(href);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => pickTxDxDirectory(ref),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                            child: FaIcon(FontAwesomeIcons.folderOpen, size: 16),
                          ),
                          Text(
                            'Select TxDx folder',
                            style: TextStyle(
                              fontSize: 16,
                            )
                          ),
                        ]
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: TxDxColors.buttonPrimary,
                    ),
                  ),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: MarkdownBody(
                data: theTextTwo,
                onTapLink: (text, href, title) {
                  if (href!.isNotEmpty) {
                    launch(href);
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