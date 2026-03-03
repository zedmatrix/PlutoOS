# Pluto OS
Pluto - Arm64 Musl From Scratch - sysv - zbuild

# Create Partition
`fdisk /dev/sdX`

# Format and Mounting
```
source environment.sh
cd stage_0-filesystem-setup
source 01_mount-create-directories.sh
```
> only if basic partition layout of
> SWAP + ROOT or
> UEFI + SWAP + ROOT
