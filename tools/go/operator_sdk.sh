switch_opsdk()
{
  cd $GOPATH/src/github.com/operator-framework/operator-sdk && git fetch && git checkout $1 && make install && operator-sdk version && cd -
}
