# audioRemux
There are some scripts used for remux multi mono audio files to one multi-track audiofile

# Use FFMPEG for media processing core

# Usage:
  remux_2.sh/remux_4.sh: These script is for multi-track recorder running at mono mode, which means every take has its own folder. Every folder has some file. For example recording 2 channel will get 2 mono files in one folder.
  Command: bash remux_2.sh mainPathofFolders
  the mainPath is the path that contans each take folders: mainPath/20190410-001.pjt/1.wav
  OutputFile will at the mainpanth/remux
  
  mix20.sh/mix51.sh: These script is for mux multi-track audio files to ONE AC3 codec audio file. For example mux 6 mono files (5.1 mono track) to one ac3 codec files.
  Command: bash mix51.sh inputL inputR inputC inputLFE inputLs inputRs
  OutputFile will at the same path
  
  mix20_auto.sh/mix51_auto.sh: These are the smarter version of mix20/mix51. You can just drop a file path that has 6 mpno files and it will automatically recorgnized channel by reading the LASTWORD of the fileName. For example the folder ./xxx_51mono/ has 6 files named xxx_L.wav xxx_R.wav xxx_C.wav xxx_LFE.wav xxx_Ls.wav xxx_Rs.wav
  you juse use the command: ./mix51_auto.sh ./xxx_51mono/
  
