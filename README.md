# ArchLinux Hardened - Installation 

This is an ArchLinux setup focused on desktop security, featuring the latest software!

Besides security, we also use the most advanced software available, including:

* **Btrfs:** Copy-on-write filesystem with snapshot support.
* **Wayland:** Because X11 is old, slow, and insecure.
* **NFTables:** Firewalling without that annoying iptables syntax.

This setup is *hardened*, so you'll need some Linux knowledge. Not for beginners!

## Highlights

**Physical tampering hardening:**

* Secure boot without Microsoft's keys.
* Direct booting with [unified kernel images](https://wiki.archlinux.org/title/Unified_kernel_image), no GRUB.
* Full disk encryption with LUKS 2.

**Exploit protection:**

* GrapheneOS' hardened kernel.
* Kernel's lockdown mode set to "integrity".
* Firejail + AppArmor (see [FIREJAIL.md](docs/FIREJAIL.md) for explanation).

**Network hardening:**

* Strict firewall rules (drop everything by default, see [NETWORKING.md](docs/NETWORKING.md)).
* Reverse Path Filtering set to strict.
* ICMP redirects disabled.
* Strong network security within the kernel.

**System monitoring:**

* Auditd notifications via desktop notifications.
* Many systemd services for system management.
* Firewall block notifications.

**System resilience:**

* LTS kernel fallback from the BIOS.
* Automated encrypted backups to a remote server (manual setup required!).
* Automated encrypted backups to an external USB drive (manual setup required!).

Extensive use of desktop notifications for monitoring! If something goes wrong, I want to know immediately.


pacman -Sy git
git clone https://github.com/rroethof/archlinux-install.git
cd archlinux-install
./install.sh
