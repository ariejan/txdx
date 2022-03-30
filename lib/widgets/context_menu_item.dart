import 'package:flutter/material.dart';
import 'package:txdx/theme/colors.dart';

class ContextMenuItem extends StatelessWidget
{
  const ContextMenuItem({Key? key, required this.title, this.leading, this.onTap}) : super(key: key);

  final String title;
  final Widget? leading;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      onTap: onTap,
      dense: true,
      leading: leading,
      hoverColor: Theme.of(context).brightness == Brightness.dark
          ? TxDxColors.darkContextHoverColor
          : TxDxColors.lightContextHoverColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

}