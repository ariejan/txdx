import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/colors.dart';

class NoFileSelectedWidget extends ConsumerWidget {
  const NoFileSelectedWidget({Key? key}) : super(key: key);

  final theText = '''Thank you for choosing TxDx!
  To get you started, here are a few things you might want to look at:
  
   * [Todo.txt Primer](https://www.txdx.eu/todotxt/)
   * [TxDx Getting Started](https://www.txdx.eu/getting-started/)
   
  We're sure you'll enjoy using TxDx daily. Now, go get things done!
  
  First things first: go to Settings and select your todo.txt file to get started.
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
                data: theText,
                onTapLink: (text, href, title) {
                  if (href!.isNotEmpty) {
                    launch(href);
                  }
                },
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/settings');
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: FaIcon(FontAwesomeIcons.gear, size: 12),
                      ),
                      Text('Go to Settings'),
                    ]
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: TxDxColors.buttonPrimary,
                  ),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}