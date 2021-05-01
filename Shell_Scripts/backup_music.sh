#!/bin/bash
# Backup files to other hard drive
# Running this script with sudo will treat $HOME as the root's home
# Don't try to backup to other drive if one or more of the drives is not mounted (will up root directory otherwise)
# Modified from https://stackoverflow.com/a/27370
if df | grep -q '/media/matt/Linux$' && df | grep -q '/media/matt/Backup$'; then
	echo "Found mountpoint"
	ntfs_music='/media/matt/Backup/Music (Backup)/'
	ext4_music='/media/matt/Linux/Music_Backup/'
	rsync -rav -progress "${ntfs_music}" "${ext4_music}" >> ~/.backup_music.log
	date -u >> ~/.backup_music.log
	echo -e "\n" >> ~/.backup_music.log
	# Write the paths to albums that do not contain album art with the name "Album" to files (unsorted and then sorted by path name)
	# Modified from https://askubuntu.com/a/196966
	find "${ntfs_music}" -mindepth 3 -maxdepth 3 -type d '!' -exec sh -c 'ls -1 "{}"|egrep -i -q "^[Aa]lbum\.(jpe?g|png)$"' ';' -print > ~/.Directories_Without_Album_Cover_File.txt; sort ~/.Directories_Without_Album_Cover_File.txt > ~/.Directories_Without_Album_Cover_File_Sorted.txt
	echo -e "\n" >> ~/.Directories_Without_Album_Cover_File.txt
	echo -e "\n" >> ~/.Directories_Without_Album_Cover_File_Sorted.txt
	date -u >> ~/.Directories_Without_Album_Cover_File.txt
	date -u >> ~/.Directories_Without_Album_Cover_File_Sorted.txt

	cp ~/.backup_music.log "${ntfs_music}"
	cp ~/.Directories_Without_Album_Cover_File.txt "${ntfs_music}"
	cp ~/.Directories_Without_Album_Cover_File_Sorted.txt "${ntfs_music}"
else
	echo "Not mounted. Did not backup"
	exit -1
fi
