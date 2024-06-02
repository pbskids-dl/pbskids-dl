cd $GITHUB_WORKSPACE
pwd
chmod +x *
mkdir pbskids-dl_deb
cd ./pbskids-dl_deb
mkdir -p usr/bin
cd ./usr/bin
cp $GITHUB_WORKSPACE/pbskids-dl_gui.py .
cp $GITHUB_WORKSPACE/pbskids-dl_gui.py ./pbskids-dl_gui
cd ../../
mkdir DEBIAN
cd ./DEBIAN
cp $GITHUB_WORKSPACE/.debian/control2 ./control
cd $GITHUB_WORKSPACE
dpkg --build ./pbskids-dl_deb
sha256sum pbskids-dl_deb.deb > pbskids-dl.sha256sum
sha512sum pbskids-dl_deb.deb > pbskids-dl.sha512sum