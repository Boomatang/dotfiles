function _current_cluster_ping

  set -l tmp 'false|'(date +%H:%M:%S)
  kubectl version -o yaml &>/dev/null

  if test $status -eq 0 
    set tmp 'true|'(date +%H:%M:%S)
  end

  set -g FISH_USER_cluster_ping $tmp
end
