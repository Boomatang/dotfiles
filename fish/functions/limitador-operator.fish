function limitador-operator
     
  if test "$argv[1]" = "-w"
      open https://github.com/kuadrant/limitador-operator
      return
  end

  if test "$argv[1]" = "-p"
      open https://github.com/kuadrant/limitador-operator/pulls/Boomatang
      return
  end
   
  cd $HOME/code/github.com/Kuadrant/limitador-operator
    
end
