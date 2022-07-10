# Luna Multiplayer (Kerbal Space Program Multiplayer MOD) in Docker optimized for Unraid
This container will download and run Luna Multiplayer for Kerbal Space Program (KSP).

Luna Multiplayer is a mod to enable Multiplayer for Kerbal Space Program, you can find more information here: [Click](https://github.com/LunaMultiplayer/LunaMultiplayer)

**ATTENTION:** Please also don't forget that you have to install the mod for your Client too: [Click](https://github.com/LunaMultiplayer/LunaMultiplayer/releases)
You can get detailed instructions on how to do that on the Wiki: [Click](https://github.com/LunaMultiplayer/LunaMultiplayer/wiki)

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for gamefiles | /lunamultiplayer |
| LMP_V | Enter the prefered version (valid options are 'latest' and 'nightly' both without quotes). | latest | 
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| DATA_PERM | Data permissions | 770 |
| UMASK | Umask for files | 0000 |

## Run example
```
docker run --name KerbalSpaceProgram-LMP -d \
	-p 8800:8800/udp \
	--env 'LMP_V=latest' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'DATA_PERM=770' \
	--env 'UMASK=0000' \
	--volume /path/to/lunarmultiplayer:/lunarmultiplayer \
	ich777/lunamultiplayer-ksp
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/
