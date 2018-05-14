
ifndef EP
$(error episode number is not defined. e.g. EP=08MAY18)
endif

# SERIES SPECIFIC CONSTANTS
SERIES := momokuro
NAME := $(SERIES).$(EP)

# DIRECTORIES
OUT_DIR := ./out/$(NAME)
SUBS_DIR := ./subs/$(EP)
VIDEO_DIR := ~/incoming/$(SERIES)
TORRENT_DIR := ./torrent

# INPUTS
MP4 := $(VIDEO_DIR)/$(NAME).mp4
SRT_EN := $(SUBS_DIR)/$(NAME).en_us.srt
SRT_JP := $(SUBS_DIR)/$(NAME).ja_jp.srt
ASS_EN := $(SUBS_DIR)/$(NAME).en_us.ass

# OUTPUTS
MKV := $(OUT_DIR)/$(NAME).mkv
#TORRENT := $(TORRENT_DIR)/$(OUTNAME).torrent
#TRACKER := http://nyaa.tracker.wf:7777/announce

# tools
FFMPEG := ffmpeg
CTORRENT := ctorrent
MIXTAPE := uploadtomixtape.sh
YOUTUBEDL := youtube-dl

# default rule (build mkv with japanese and engrish softsubs)
all: $(MKV)

# TODO: convert input video to ideal youtube settings
# TODO: upload to youtube as private video
# TODO: download autosubs from youtube when available

$(MKV): $(MP4) $(SRT_JP) $(ASS_EN)
	mkdir -p "$(@D)"
	$(FFMPEG) -i $(MP4) -i $(ASS_EN) -i $(SRT_JP) \
	-map 0:v -map 0:a -map 1 -map 2 \
	-metadata:s:s:0 language=eng -metadata:s:s:1 language=jpn "$@"

torrent: $(TORRENT)

$(TORRENT): $(INCOMING)/$(MKV_FILE)
	mkdir -p $(TORRENT_DIR)
	$(CTORRENT) -t -u "$(TRACKER)" -s "$@" "$<"


