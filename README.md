# FA_Repacker

## Installation:
Download `dungeondraft-pack.exe` and `dungeondraft-unpack.exe` from [Ryex's GitHub Page](https://github.com/Ryex/Dungeondraft-GoPackager/releases).

Download `FA_Repack.ps1` from my source files here.

Copy `dungeondraft-pack.exe`, `dungeondraft-unpack.exe`, and `FA_Repack.ps1` to the folder where you have you Forgotten Adventures `dungeondraft_pack` files. This will be referred to as your "FA Directory".

> You want to make sure you have all of your `dungeondraft_pack` files in the same FA Directory and not in sub-folders.

## Usage:

### Repack Assets
Open powershell and navigate to the FA Directory  and run the following command

```
./FA_Repacker.ps1 [-Output <output folder>] [-Clean]
```

#### Clean
Remove the original Forgotten Adventures `dungeondraft_pack` files?

#### Output
The path to use when creating the new repacks.

> This defaults to the current directory if ommitted.

### If You Have Issues
Make sure you have enough disk space, you need about 2-3 times the total space of all `dungeondraft_pack` files available during the repacking operations.
