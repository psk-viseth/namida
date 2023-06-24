import 'package:flutter/material.dart';

import 'package:namida/class/playlist.dart';
import 'package:namida/class/queue.dart';
import 'package:namida/class/track.dart';
import 'package:namida/controller/navigator_controller.dart';
import 'package:namida/controller/playlist_controller.dart';
import 'package:namida/controller/settings_controller.dart';
import 'package:namida/core/constants.dart';
import 'package:namida/core/enums.dart';
import 'package:namida/core/extensions.dart';
import 'package:namida/core/namida_converter_ext.dart';
import 'package:namida/core/translations/strings.dart';
import 'package:namida/ui/dialogs/general_popup_dialog.dart';
import 'package:namida/ui/widgets/custom_widgets.dart';

class NamidaDialogs {
  static NamidaDialogs get inst => _instance;
  static final NamidaDialogs _instance = NamidaDialogs._internal();
  NamidaDialogs._internal();

  Future<void> showTrackDialog(
    Track track, {
    Widget? leading,
    Playlist? playlist,
    int? index,
    bool comingFromQueue = false,
    bool isFromPlayerQueue = false,
    bool errorPlayingTrack = false,
  }) async {
    await showGeneralPopupDialog(
      [track],
      track.originalArtist,
      track.title.overflow,
      QueueSource.selectedTracks,
      thirdLineText: track.album.overflow,
      forceSquared: SettingsController.inst.forceSquaredTrackThumbnail.value,
      isTrackInPlaylist: playlist != null,
      playlist: playlist,
      index: index,
      comingFromQueue: comingFromQueue,
      useTrackTileCacheHeight: true,
      isFromPlayerQueue: isFromPlayerQueue,
      errorPlayingTrack: errorPlayingTrack,
    );
  }

  Future<void> showAlbumDialog(String albumName) async {
    final tracks = albumName.getAlbumTracks();
    final artists = tracks.map((e) => e.artistsList).expand((list) => list).toSet();
    await showGeneralPopupDialog(
      tracks,
      tracks.album.overflow,
      "${tracks.displayTrackKeyword} & ${artists.length.displayArtistKeyword}",
      QueueSource.album,
      thirdLineText: artists.join(', ').overflow,
      forceSquared: shouldAlbumBeSquared,
      forceSingleArtwork: true,
      heroTag: 'album_$albumName',
      albumToAddFrom: tracks.album,
    );
  }

  Future<void> showArtistDialog(String name) async {
    final tracks = name.getArtistTracks();
    final albums = tracks.map((e) => e.album).toList();
    await showGeneralPopupDialog(
      tracks,
      name.overflow,
      "${tracks.displayTrackKeyword} & ${albums.length.displayAlbumKeyword}",
      QueueSource.artist,
      thirdLineText: albums.toSet().take(5).join(', ').overflow,
      forceSquared: true,
      forceSingleArtwork: true,
      heroTag: 'artist_$name',
      isCircle: true,
      artistToAddFrom: name,
    );
  }

  Future<void> showGenreDialog(String name) async {
    final tracks = name.getGenresTracks();
    await showGeneralPopupDialog(
      tracks,
      name,
      [tracks.displayTrackKeyword, tracks.totalDurationFormatted].join(' - '),
      QueueSource.genre,
      extractColor: false,
      heroTag: 'genre_$name',
    );
  }

  Future<void> showPlaylistDialog(Playlist playlist) async {
    if (playlist.tracks.isEmpty) {
      NamidaNavigator.inst.navigateDialog(
        CustomBlurryDialog(
          title: Language.inst.WARNING,
          bodyText: '${Language.inst.DELETE_PLAYLIST}: "${playlist.name}"?',
          actions: [
            const CancelButton(),
            ElevatedButton(
              onPressed: () {
                PlaylistController.inst.removePlaylist(playlist);
                NamidaNavigator.inst.closeDialog();
              },
              child: Text(Language.inst.DELETE.toUpperCase()),
            )
          ],
        ),
      );
      return;
    }
    await showGeneralPopupDialog(
      playlist.tracks.map((e) => e.track).toList(),
      playlist.name.translatePlaylistName(),
      [playlist.tracks.map((e) => e.track).toList().displayTrackKeyword, playlist.creationDate.dateFormatted].join(' • '),
      playlist.toQueueSource(),
      thirdLineText: playlist.moods.join(', ').overflow,
      playlist: playlist,
      extractColor: false,
      heroTag: 'playlist_${playlist.name}',
    );
  }

  Future<void> showQueueDialog(Queue queue) async {
    await showGeneralPopupDialog(
      queue.tracks,
      queue.date.dateFormatted,
      queue.date.clockFormatted,
      QueueSource.queuePage,
      thirdLineText: [
        queue.tracks.displayTrackKeyword,
        queue.tracks.totalDurationFormatted,
      ].join(' - '),
      extractColor: false,
      queue: queue,
      forceSquared: true,
      heroTag: 'queue_${queue.date}',
    );
  }
}
