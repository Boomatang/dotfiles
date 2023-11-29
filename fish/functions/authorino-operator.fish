
function authorino-operator
     
  if test "$argv[1]" = "-w"
      open https://github.com/kuadrant/authorino-operator
      return
  end

  if test "$argv[1]" = "-p"
      open https://github.com/kuadrant/authorino-operator/pulls/Boomatang
      return
  end
   
  cd $HOME/code/github.com/Kuadrant/authorino-operator
    
end
