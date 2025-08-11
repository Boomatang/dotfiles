function architecture
    
  if test "$argv[1]" = "-w"
      open https://github.com/kuadrant/architecture
      return
  end

  if test "$argv[1]" = "-p"
      open https://github.com/kuadrant/architecture/pulls/Boomatang
      return
  end
  cd $GRAB_PATH/github.com/Kuadrant/architecture
    
end
