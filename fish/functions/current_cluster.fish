function current_cluster
  set -l delay 120

  set -l active (set_color magenta)
  set -l inactive (set_color black)
  set -l unknown (set_color yellow)
  set -l normal (set_color normal)

  set -l kubeconfig ~/.kube/config
  set -l prefix ''
  if test -n "$KUBECONFIG"
    set kubeconfig $KUBECONFIG
    set path (string split "/" -- $kubeconfig)
    set prefix $path[-2]/$path[-1]
  end

  if test ! -e $kubeconfig
    return 1
  end

  set -l context (yq '.current-context' $kubeconfig)
  set -l query '.contexts.[] | select(.name == "'$context'") | .context.cluster'
  set -l cluster (yq "$query" $kubeconfig)

  set -l cluster_ping /tmp/cluster_ping.yaml

  command python $DOT_SCRIPTS/cluster_ping.py $kubeconfig $context &

  if test -e $cluster_ping
    set -l base '."'$kubeconfig'"."'$context'"'
    set -l checked_query $base'.checked'
    set -l connected_query $base'.connected'

    set -l checked (yq "$checked_query" $cluster_ping)
    set -l connected (yq "$connected_query" $cluster_ping)

    set -l diff 0
    if test  $checked != "null"
      set -l cs (date -d "$checked" "+%s")
      set -l ts (date +%s)
      set diff (math $ts - $cs)
    end

    set color $unknown
    if test $diff -lt $delay
      set color $inactive
      if test $connected = "true"
        set color $active
      end
    end
  end

  set -l resp $color$cluster$normal
  if test -n $prefix
    set resp $prefix $resp
  end

  echo $resp
end
