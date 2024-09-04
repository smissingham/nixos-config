# Sean's NixOS Config

I've been loving NixOS so far. Though frustrating as linux always is to find the right drivers that work for a given hardware configuration, NixOS makes that pain a one-time activity by bringing the "Infrastructure-As-Code" approach to my Operating System config. 

I've got some scripts in here that allow me to quickly rebuild my NixOS config after I make alterations, then commit those changes to this repo. You should see this repo build a small commit history as I tweak my config and daily use environment of NixOS.

# Required `env.toml`:

```toml
# DO NOT COMMIT THIS FILE TO PUBLIC REPO

[wifi]
ssid =  ""
password =  ""
```
