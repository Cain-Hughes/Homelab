# Jellyfin

Jellyfin presents the media library and serves playback to browsers, TVs, and other clients. It runs on the Docker host with configuration under `/docker/jellyfin/config` and media mounted at `/data`.

- LAN endpoint: `http://10.10.20.5:8096`
- HTTPS: handled by NPM; documentation uses `watch.example.com`
- Server version checked September 28, 2026: **12.1.0**
- [Compose example](Jellyfin.yaml): LinuxServer image, UID/GID 1000, persistent configuration, `unless-stopped` restart policy

## GPU available, acceleration not yet enabled

The host contains an NVIDIA Quadro P2000. The container uses the NVIDIA runtime, and `nvidia-smi` inside Jellyfin successfully identifies the card.

However, live settings were verified as:

```text
HardwareAccelerationType: none
EnableHardwareEncoding: true
```

The checkbox does not activate acceleration when the selected method is None. Recent logs used `libx264` with native H.264 decoding. Those sessions were software video transcodes despite the GPU being available.

Enabling NVIDIA NVENC/NVDEC and testing supported codecs is **deferred to a maintenance window**. The Compose file makes the GPU available; it does not set Jellyfin's acceleration method. No GPU or playback settings were changed during this documentation update.

During that work, check the generated FFmpeg command, encoder name, GPU encoder/decoder activity, and actual playback. A “Transcoding” label or visible GPU does not prove hardware encoding. Reference: [Jellyfin NVIDIA guide](https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/nvidia/).

## Why a file transcodes

The client must support the container, video, audio, subtitles, and requested bitrate. One investigated session required unsupported-audio conversion and video bitrate reduction. The dashboard's output format is not necessarily the source file's format.

Distinguish direct play, remuxing, audio-only conversion, and video re-encoding. Check the session reasons and FFmpeg log before changing profiles or acquiring a replacement. A lower client quality limit can trigger video transcoding even when the video codec is supported.

## Metadata and artwork

Sonarr and Radarr export local NFO metadata and artwork through their Kodi (XBMC) / Emby metadata consumers. Sonarr provides series/episode metadata and series/season/episode images; Radarr writes `movie.nfo` and movie artwork.

A targeted missing-artwork repair confirmed Jellyfin picked up the generated identification and images. The case involved a title that had not matched correctly. Online metadata/image providers were configured; an obsolete configuration field must not be used as proof they were disabled.

These exports help future imports and refreshed items. They do not replace video files or guarantee that every existing unmatched item has been repaired. Prefer targeted identification/refresh when that resolves the issue.

## Continue Watching and Next Up

Continue Watching can contain several partially watched episodes from one series. It differs from Next Up, although some clients merge the rows. Older resume positions can remain after moving ahead in a show.

The desired behavior is one most-recently-played unfinished episode per series while preserving older progress. A third-party [Continue Watching Deduplicator](https://github.com/SloMR/jellyfin-plugin-dedupe-continue-watching) was researched but **not installed**. Its published compatibility target needs verification against this server release. Back up the database/configuration and preserve a rollback path before testing.

## Statistics and recovery

[Streamystats](Streamystats.md) collects playback through Jellyfin's API. It does not require Playback Reporting for live collection, and its new database does not contain a complete pre-installation viewing history.

Back up Jellyfin configuration and its database consistently, using a supported backup mechanism or with Jellyfin stopped. Container recreation is not a backup. NFS media needs its own backup plan; see [operations](../Operations/README.md).
