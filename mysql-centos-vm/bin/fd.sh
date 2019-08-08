#!/bin/sh

(
echo d # Create a new empty DOS partition table
echo 2 # second disk
echo n # Add a new partition
echo p # Primary partition
echo 2  # disk (Accept default: 2)
echo   # First sector
echo   # Last sector (Accept default: varies)
echo w # Write changes
echo p # Write changes
echo q  #
) | fdisk /dev/sda

