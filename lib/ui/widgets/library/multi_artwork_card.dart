import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:namida/class/track.dart';
import 'package:namida/core/extensions.dart';
import 'package:namida/ui/widgets/artwork.dart';

class MultiArtworkCard extends StatelessWidget {
  final List<Track> tracks;
  final String name;
  final int gridCount;
  final String heroTag;
  final void Function()? onTap;
  final void Function()? showMenuFunction;

  const MultiArtworkCard({super.key, required this.tracks, required this.name, required this.gridCount, this.onTap, this.showMenuFunction, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 4.0;
    final double thumnailSize = (Get.width / gridCount) - horizontalPadding * 2;
    final fontSize = (18.0 - (gridCount * 1.7)).multipliedFontScale;

    return GridTile(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: horizontalPadding),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(12.0.multipliedRadius),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Hero(
                  tag: heroTag,
                  child: MultiArtworks(
                    borderRadius: 12.0.multipliedFontScale,
                    heroTag: heroTag,
                    disableHero: true,
                    paths: tracks.map((e) => e.pathToImage).toList(),
                    thumbnailSize: thumnailSize,
                    iconSize: 92.0 - 14 * gridCount,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (name != '')
                          Hero(
                            tag: 'line1_$heroTag',
                            child: Text(
                              name.overflow,
                              style: context.textTheme.displayMedium?.copyWith(fontSize: fontSize),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Hero(
                          tag: 'line2_$heroTag',
                          child: Text(
                            [tracks.displayTrackKeyword, if (tracks.totalDuration != 0) tracks.totalDurationFormatted].join(' - '),
                            style: context.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize * 0.85,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: const Color.fromARGB(40, 120, 120, 120),
                onLongPress: showMenuFunction,
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
