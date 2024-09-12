# FA_Repacker

## General:
This bash script was made possible using an automated [Powershell to Bash converter](https://codingfleet.com/code-converter/powershell/bash/). Small tweaks edited afterwards to make it slightly more compatable.

## Installation:
Follow instructions to get the packer and unpacker from this post (https://github.com/Ryex/Dungeondraft-GoPackager/issues/5) from Ryex's GitHub Page (https://github.com/Ryex/Dungeondraft-GoPackager).

Download `FA_Repacker.sh` from my source files here.

Copy `dungeondraft-pack`, `dungeondraft-unpack`, and `FA_Repacker.sh` to the folder where you have you Forgotten Adventures `dungeondraft_pack` files. This will be referred to as your "FA Directory".

> You want to make sure you have all of your `dungeondraft_pack` files in the same FA Directory and not in sub-folders.

## Usage:

### Repack Assets
Open terminal and navigate to the FA Directory  and run the following command

```
./FA_Repacker.sh [--output <output folder>] [--clean]
```

#### Clean
Remove the original Forgotten Adventures `dungeondraft_pack` files?

#### Output
The path to use when creating the new repacks.

> This defaults to the current directory if ommitted.

### If You Have Issues
Make sure you have enough disk space, you need about 2-3 times the total space of all `dungeondraft_pack` files available during the repacking operations.

### Thanks
Not possible to have this without the packer and unpacker from [Ryex](https://github.com/Ryex/Dungeondraft-GoPackager) and the original PowerShell script of [Chapel Studios](https://github.com/ChapelStudios/FA_Repacker)
