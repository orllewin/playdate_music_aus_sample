# Drum

## Creating New Patches

Add custom patches to `/Disk/Data/orllewin.playdate.drum/UserPatches`. Custom patches must be in their own directory and include a `config.json` file. The `samples` array contains sample objects (see below), the array size must equal `columns` x `rows`.

```json
{
"label": "Default Demo Patch",
"columns": 4,
"rows": 2,
"samples": [
		...
	]
}
```

Example sample object:

```json
{
	"title": "011",
	"path": "/Samples/Loops/100/Bonus Beat 08 (100BPM)",
	"type": "sample",
	"mode": "hit",
	"image": "/Images/down",
	"key": "down",
	"volume": 0.75,
	"pitch": 1
}
```

* `title`: String. Not truncated so keep it short
* `path`: String, path tot he sample within the .pda directory
* `type`: String: see below. files are streamed from disk. Use sample for anything but long audio files. 
* `mode`: String, the initial mode, can be one of `hit`, `play`, `loop` - see below for specs for each
* `image`: String _optional_ - path to an image in the .pda directory
* `key`: String _optional_ - one of `left`, `right`, `up`, `down`, `a`, `b`
* `volume`: Float _optional_ - 0.0 to 1.0, default is 1.0
* `pitch`: Float _optional_ - playback rate in range 0.0 to 1.0, default is 1.0

## Type

* `empty` - make the ui cell a spacer/placeholder, can still have text and/or an image
* `sample` - stored in memory so use for drum hits and short loops
* `file` - audio streamed from disk, use for longer files and background music
* `transition` - plays a file while loading in new player, see below

## Mode

* `play` - plays once, a second tap while playing stops, good for longer samples
* `hit` - plays once, a second tap while playing restarts, good for drum hits
* `loop` - loops forever, a second tap should stop playback

## Transition

A transition is a special type that allows you to build up a full set with different sample sets/patches. When triggered an optional sample can be played once while the ui for the new patch is loaded, any other playing samples are stopped immediately:

```json
{
	"title": "011",
	"path": "/UserPatches/set1/interlude",
	"type": "transition",
	"image": "/UserPatch/set1/transition_image",
	"next": "/UserPatches/set2/
}
```

## Image Asset Attribution

[thenounproject.com/coquet_adrien/](https://thenounproject.com/coquet_adrien/)

jellyfish.png, frequency.png, sine.png, rain_cloud.png, snow_cloud.png, censored.png, heartbeat.png, bomb.png, recycle.png, octopus.png, snail.png, happy_jellyfish1.png, happy_jellyfish2.png, coronavirus.png, joking.png, tease.png, laugh.png, concentrate.png, pirate.png, grasshopper.png, creature.png

## Sample Attribution

The vast majority of audio samples come from MusicRadar: [musicradar.com/news/tech/free-music-samples-royalty-free-loops-hits-and-multis-to-download](https://www.musicradar.com/news/tech/free-music-samples-royalty-free-loops-hits-and-multis-to-download)