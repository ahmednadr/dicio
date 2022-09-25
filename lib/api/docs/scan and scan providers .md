# scan and scan providers

a class created to scan the local network (wifi) for home-assistant servers.

## Attributes

### ips

list of discovered home-assistant server ips.

---

## Scan provider

the provider (changeNotifierProvider) was created so that we can notify the ui of available ips.

---

## Scan interface

### scanNetwork(int port)

obtains the gateway ip and subnet mask then broadcasts a ping request on the provided port , listens to responds and add the responds’ ips to the ips list.