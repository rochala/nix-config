#!/bin/bash

set -e

nix build .#darwinConfigurations.$HOSTNAME.system --experimental-features 'nix-command flakes' --dry-run

nix build .#darwinConfigurations.$HOSTNAME.system --experimental-features 'nix-command flakes' --max-jobs 4

sudo ./result/activate
