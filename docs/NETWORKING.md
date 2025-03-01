# Networking

The networking configuration of this ArchLinux setup follows the usual security principal which states that "what is not explicitly allowed is forbidden".

## Firewall Policies

All the [firewall policies](rootfs/etc/nftables.conf) are set to `drop` by default, which means nothing can come in or out unless stated otherwise.

While both the `input` and `forward` chains can easily be set to `drop` without breaking much, the `output` chain is another kettle of fish.


## Kernel hardening

The `linux-hardened` kernel of ArchLinux has various defaults which harden the network configuration as well.

Here's a non exhaustive list:

- Enable syn flood protection: `net.ipv4.tcp_syncookies`
- Ignore source-routed packets: `net.ipv4.conf.all.accept_source_route`
- Ignore source-routed packets: `net.ipv4.conf.default.accept_source_route`
- Ignore ICMP redirects: `net.ipv4.conf.all.accept_redirects`
- Ignore ICMP redirects: `net.ipv4.conf.default.accept_redirects`
- Ignore ICMP redirects from non-GW hosts: `net.ipv4.conf.all.secure_redirects`
- Ignore ICMP redirects from non-GW hosts: `net.ipv4.conf.default.secure_redirects`
- Don't allow traffic between networks or act as a router: `net.ipv4.ip_forward`
- Don't allow traffic between networks or act as a router: `net.ipv4.conf.all.send_redirects`
- Don't allow traffic between networks or act as a router: `net.ipv4.conf.default.send_redirects`
- Reverse path filtering - IP spoofing protection: `net.ipv4.conf.all.rp_filter`
- Reverse path filtering - IP spoofing protection: `net.ipv4.conf.default.rp_filter`
- Ignore ICMP broadcasts to avoid participating in Smurf attacks: `net.ipv4.icmp_echo_ignore_broadcasts`
- Ignore bad ICMP errors: `net.ipv4.icmp_ignore_bogus_error_responses`
- Log spoofed, source-routed, and redirect packets: `net.ipv4.conf.all.log_martians`
- Log spoofed, source-routed, and redirect packets: `net.ipv4.conf.default.log_martians`

You can query their value using the `sysctl` command, for example:

```
$ sysctl net.ipv4.tcp_syncookies
net.ipv4.tcp_syncookies = 1
```