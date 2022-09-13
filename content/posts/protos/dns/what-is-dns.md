---
author: "Samy Fodil"
title: "What is DNS?"
date: "2022-09-01"
tags: ["protocol","internet", "dns"]
---

The Domain Name System (DNS) is a distributed database system that translates domain names to numerical Internet Protocol (IP) addresses. And yes again! decentralized before Web 3.0.

DNS is an essential part of Internet infrastructure. A good analogy is to think of it as the phonebook of the Internet. Besides the fact that it makes us humans smarter than we are: "Most of us access information online using domain names", DNS is used for load-balancing, protocol bridging, network discovery, etc.


The Domain Name System is a distributed tree where each leaf, here a domain or sub-domain, is only responsible for updating the information at its level.

A Fully Qualified Domain Name (FQDN), for example, `blog.taubyte.com.`, is a path from the root of the tree to the leaf that provides information about how to access this website.

![life-of-a-dns-query](../images/life-of-a-dns-query.png)


# Hands on
Let's explore what happens under the hood when you're browser tries to connect to this blog:

- On Linux, the `dig` command can help us trace the request from the root:
{{< highlight shell >}}
$ dig +trace blog.taubyte.com
{{< /highlight >}}

- The first request goes to your configured DNS server, which returns the list of root servers it knows.
{{< highlight shell >}}
.			27775	IN	NS	a.root-servers.net.
.			27775	IN	NS	b.root-servers.net.
.			27775	IN	NS	c.root-servers.net.
.			27775	IN	NS	d.root-servers.net.
.			27775	IN	NS	e.root-servers.net.
.			27775	IN	NS	f.root-servers.net.
.			27775	IN	NS	g.root-servers.net.
.			27775	IN	NS	h.root-servers.net.
.			27775	IN	NS	i.root-servers.net.
.			27775	IN	NS	j.root-servers.net.
.			27775	IN	NS	k.root-servers.net.
.			27775	IN	NS	l.root-servers.net.
.			27775	IN	NS	m.root-servers.net.
;; Received 239 bytes from 127.0.0.53#53(127.0.0.53) in 6 ms
{{< /highlight >}}

- `dig`, same as what you're browser, selects one root server and queries it about `com`. The result is a list of servers capable of resolving `com.`
{{< highlight shell >}}
com.			172800	IN	NS	e.gtld-servers.net.
com.			172800	IN	NS	b.gtld-servers.net.
com.			172800	IN	NS	j.gtld-servers.net.
com.			172800	IN	NS	m.gtld-servers.net.
com.			172800	IN	NS	i.gtld-servers.net.
com.			172800	IN	NS	f.gtld-servers.net.
com.			172800	IN	NS	a.gtld-servers.net.
com.			172800	IN	NS	g.gtld-servers.net.
com.			172800	IN	NS	h.gtld-servers.net.
com.			172800	IN	NS	l.gtld-servers.net.
com.			172800	IN	NS	k.gtld-servers.net.
com.			172800	IN	NS	c.gtld-servers.net.
com.			172800	IN	NS	d.gtld-servers.net.
;; Received 1176 bytes from 198.41.0.4#53(a.root-servers.net) in 23 ms
{{< /highlight >}}

- It will do the same with one of those servers asking about `taubyte.com.`, which will return:
{{< highlight shell >}}
taubyte.com.		172800	IN	NS	dns1.registrar-servers.com.
taubyte.com.		172800	IN	NS	dns2.registrar-servers.com.
;; Received 738 bytes from 192.33.14.30#53(b.gtld-servers.net) in 39 ms
{{< /highlight >}}

- You can guess the next move right: ask `dns1.registrar-servers.com` or `dns2.registrar-servers.com` about `blog.taubyte.com`. Result:
{{< highlight shell >}}
blog.taubyte.com.	60	IN	CNAME	nodes.taubyte.com.
nodes.taubyte.com.	60	IN	NS	seer.taubyte.com.
;; Received 111 bytes from 156.154.132.200#53(dns1.registrar-servers.com) in 33 ms
{{< /highlight >}}

- At this point, we know that `blog.taubyte.com` is an alias (CNAME) to `nodes.taubyte.com`. This will call for querying about the latter which will return:
{{< highlight shell >}}
nodes.taubyte.com.	60	IN	A	20.9.66.151
nodes.taubyte.com.	60	IN	A	20.231.58.152
{{< /highlight >}}

# DNS Zone
A DNS sub-tree can be stored in one or multiple databases called zones where each zone represents an authoritative source of truth for a specific sub-tree. In the figure below, the green zone hosts `debian.org`:
![dns-tree](../images/dns-tree.svg)


 A server can host many zones acting either as a master (read/write), a slave (read) or a forwarder. The figure below depicts the common setup.
![dns-server](../images/dns-server.svg)

## DNS Records
DNS (Domain Name System) entries take a human-friendly name, such as store.example.com, and translate it to an IP address. The DNS can quickly be updated with some propagation time, which is the length of time needed to update records across the Internet. There are some DNS Entries you can create. The following DNS Entries can be created or modified from within the DNS Zone Editor.


### A Record

> Returns a 32-bit IPv4 address, most commonly used to map hostnames to an IP address of the host, but it is also used for DNSBLs, storing subnet masks in RFC 1101, etc.

The most common DNS record used. An A record (Address Record) points a domain or subdomain to an IP address.

A blank record (sometimes seen as the ‘@’ record) points your main domain to a server. You can also set subdomains to point to other IP addresses as well. You might also encounter, a wildcard record, shown usually as ‘*’ or ‘*.yourdomain.com,’ which acts as a catch-all record, redirecting every subdomain you haven’t defined elsewhere to an IP address.

The AAAA record is similar to the A record, allowing you to point the domain to an Ipv6 address. More information on IPv6 can be found at [ipv6.com](http://ipv6.com/).




### CNAME

> Alias of one name to another: the DNS lookup will continue by retrying the lookup with the new name.

A CNAME (Canonical Name) points one domain or subdomain to another domain name, allowing you to update one A Record each time you make a change, regardless of how many Host Records need to resolve to that IP address.

It's also possible to point a CNAME to another CNAME. However, doing so is inefficient and can lead to slow load speed and poor user experience.

### MX Entry

> Maps a domain name to a list of message transfer agents for that domain


An MX Entry (Mail Exchanger) directs email to a particular mail server. Like a CNAME, MX Entries must point to a domain and never point directly to an IP address.


### TXT Records

> Originally for arbitrary human-readable text in a DNS record. Since the early 1990s, however, this record more often carries machine-readable data, such as specified by RFC 1464, opportunistic encryption, Sender Policy Framework, DKIM, DMARC, DNS-SD, etc.

A TXT (Text) record was originally intended for human-readable text. These records are dynamic and can be used for several purposes. TXT records are commonly used for Google Verification.

The TXT Value is what the record 'points to,' but these records aren't used to direct any traffic. Instead, they're used to provide needed information to outside sources.


### NS Record
> Delegates a DNS zone to use the given authoritative name servers

A nameserver (NS) record specifies the authoritative DNS server for a domain. In other words, the NS record helps point to where internet applications like a web browser can find the IP address for a domain name. Usually, multiple nameservers are specified for a domain. For example, these could look like ns1.examplehostingprovider.com and ns2.examplehostingprovider.com.

# Online tools
 - [dig](https://www.diggui.com/)
 - [mxtoolbox](https://mxtoolbox.com/)