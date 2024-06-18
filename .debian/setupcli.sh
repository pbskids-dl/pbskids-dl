if [ -n "$GITHUB_WORKSPACE" ]; then
  echo "Github actions detected."
else
  echo "Non-github actions detected."
  export GITHUB_WORKSPACE=($PWD)
fi
cd $GITHUB_WORKSPACE
pwd
chmod +x *
mkdir pbskids-dl_deb
cd ./pbskids-dl_deb
mkdir -p usr/bin
cd ./usr/bin
cp $GITHUB_WORKSPACE/pbskids-dl.py .
ln -s ./pbskids-dl.py ./pbskids-dl
chmod +x *
cd ../../
mkdir DEBIAN
cd ./DEBIAN
cp $GITHUB_WORKSPACE/.debian/control ./control
cd $GITHUB_WORKSPACE
dpkg --build ./pbskids-dl_deb
sha256sum pbskids-dl_deb.deb > pbskids-dl.sha256sum
