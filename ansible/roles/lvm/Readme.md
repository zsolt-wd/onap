#  LVM Ansible Role

This role manages CentOS logical volumes.

## Requirements

Volume group `vg_default` and disk `/dev/sdb` must exist and contain enough free space on the physical volume.

## Role Variables

- `lvm_groups` - a dictionary containing volume group, disk and logical volume settings
	- `vgname` - volume group name
	- `disks` - a list of disks and/or partitions available to add to the volue group
	- `lvnames` - a list of logical volume names on the `vgname` volume group
		- `lvname` - name of the logical volume
		- `size` - size of the logical volume by default in megabytes or optionally with one of [bBsSkKmMgGtTpPeE] units; or according to lvcreate(8) 
		- `filesystem` - ext4 or swap
		- `mount` - boolean, mount/unmount the file system
		- `mntp` - mount point of the file system
		- `mopts` - mount options to add to the `/etc/fstab` entry
			- `opts` - mount options (see fstab(5))
			- `dump` - see fstab(5)
			- `passno` - see fstab(5)

## Dependencies

None.

## Example Playbook

```
---
- name: Example for the cas_lvm role
  hosts: centos_nodes
  roles:
    - lvm
```
