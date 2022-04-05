import 'package:flutter/material.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    Key? key,
    required this.detailName,
    required this.detailValue,
    this.needInfo = false,
    this.info,
    this.additionalDetail,
  }) : super(key: key);

  final String detailName;
  final String? additionalDetail;
  final String detailValue;
  final bool needInfo;
  final String? info;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Wrap(
        children: [
          Text(
            detailName,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          if (needInfo)
            Tooltip(
              message: info,
              triggerMode: TooltipTriggerMode.tap,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.info_outline,
                  size: 12, color: Colors.black54),
            ),
        ],
      ),
      subtitle: additionalDetail != null
          ? Text(
              additionalDetail!,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 10),
            )
          : null,
      trailing: Text(
        detailValue,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
