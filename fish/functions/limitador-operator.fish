function limitador-operator
     
  if test "$argv[1]" = "-w"
      open https://github.com/kuadrant/limitador-operator
      return
  end

  if test "$argv[1]" = "-p"
      open https://github.com/kuadrant/limitador-operator/pulls/Boomatang
      return
  end
   
  cd $GRAB_PATH/github.com/Kuadrant/limitador-operator

  if test "$argv[1]" = "-s"
      set_goroot
      return
  end
    
end
