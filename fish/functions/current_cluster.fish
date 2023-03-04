function current_cluster
  set -l active (set_color green)
  set -l inactive (set_color black)
  set -l unknown (set_color yellow)
  set -l normal (set_color normal)

  set -l context (yq '.current-context' ~/.kube/config)
  set -l query '.contexts.[] | select(.name == "'$context'") | .context.cluster'
  set -l cluster (yq "$query" ~/.kube/config)

  set -l query '.clusters.[] | select(.name == "'$cluster'") | .cluster.server'
  set -l server (yq "$query" ~/.kube/config)

  _current_cluster_ping &

  set env (string split "|" -- $FISH_USER_cluster_ping)

  set -l color $inactive
  if test $env[1] = "true"
    set  color $active
  end

  echo $color$cluster$normal
end
