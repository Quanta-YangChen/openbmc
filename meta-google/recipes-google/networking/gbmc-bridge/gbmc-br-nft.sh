#!/bin/bash
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[[ -n ${gbmc_br_nft_lib-} ]] && return

# shellcheck source=meta-google/recipes-google/networking/network-sh/lib.sh
source /usr/share/network/lib.sh || exit

declare -A gbmc_br_nft_pfx=()

gbmc_br_nft_update() {
  printf 'gBMC Bridge input firewall for %s\n' "${!gbmc_br_nft_pfx[*]}" >&2

  local contents=
  contents+='table inet filter {'$'\n'
  contents+='    chain gbmc_br_int_input {'$'\n'
  local pfx
  for pfx in "${!gbmc_br_nft_pfx[@]}"; do
    contents+="        ip6 saddr $pfx accept"$'\n'
  done
  contents+='    }'$'\n'
  contents+='}'$'\n'

  local rfile=/run/nftables/40-gbmc-br-int.rules
  mkdir -p "$(dirname "$rfile")"
  printf '%s' "$contents" >"$rfile"

  # shellcheck disable=SC2015
  systemctl reset-failed nftables && systemctl --no-block reload-or-restart nftables || true
}

gbmc_br_nft_hook() {
  # Match only global IP addresses on the bridge that match the BMC prefix
  # (<mpfx>:fdxx:). So 2002:af4:3480:2248:fd02:6345:3069:9186 would become
  # a 2002:af4:3480:2248:fd00/76 rule.
  # shellcheck disable=SC2154
  if [[ $change == addr && $intf == gbmcbr && $scope == global ]] &&
       [[ $fam == inet6 && $flags != *tentative* ]]; then
    local ip_bytes=()
    if ! ip_to_bytes ip_bytes "$ip"; then
      echo "gBMC Bridge NFT Invalid IP: $ip" >&2
      return 1
    fi
    # Ignore ULAs
    if (( (ip_bytes[0] & 0xfe) == 0xfc )); then
      return 0
    fi

    # We assume the entire machine /64 is allowed, so remove the suffix of the address
    local i
    for (( i=8; i<16; ++i )); do
      ip_bytes["$i"]=0
    done

    # Update the value tracking the number of users for a subnet
    pfx="$(ip_bytes_to_str ip_bytes)/64"
    local old=${gbmc_br_nft_pfx["$pfx"]-0}
    local new
    if [[ $action == add ]]; then
      new=$((old + 1))
    elif [[ $action == del ]]; then
      new=$((old - 1))
    fi
    if (( new <= 0 )); then
      unset 'gbmc_br_nft_pfx["$pfx"]'
    else
      gbmc_br_nft_pfx["$pfx"]=$new
    fi

    if (( old <= 0 && new >= 1 || old >= 1 && new <= 0 )); then
      gbmc_br_nft_update
    fi
  fi
}

GBMC_IP_MONITOR_HOOKS+=(gbmc_br_nft_hook)

gbmc_br_nft_lib=1
