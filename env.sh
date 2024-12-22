#!/bin/bash
trigger_new_install() {
  hash_check=".install-hash-$(basename $(dirname $0))"
  stored_hash=$(cat $hash_check 2> /dev/null || >&2 echo "First install of $0")
  current_hash=$(sha256sum "$0" | awk '{print $1}')
  if [ "$current_hash" != "$stored_hash" ] && [ "$NEW_INSTALL_TRIGGER" != "no" ]; then
    [ ! -z $stored_hash ] && echo "$0 has been modified. Triggering new installation..." && echo "Use 'export NEW_INSTALL_TRIGGER=no' do disable this behavoir"
    \rm -rf $@ || true
    echo "$current_hash" > $hash_check
  fi
}
compute_and_write_hash() {
    local line_number=$(grep -n "$FUNCNAME .*$1.*" "$0" | awk -F: '{print $1}')
    sed -i "${line_number}s/  # SHA256:.*//" "$0"
    sed -i "${line_number}s/.*/&  # SHA256: $(sha256sum "$1" | awk '{print $1}')/" "$0"
}
