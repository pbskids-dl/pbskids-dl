cd $GITHUB_WORKSPACE
pwd
chmod +x *
mkdir pbskids-dl_deb
cd ./pbskids-dl_deb
mkdir -p usr/bin
cd ./usr/bin
cp $GITHUB_WORKSPACE/pbskids-dl.py ./pbskids-dl
cp $GITHUB_WORKSPACE/pbskids-dl.sh .
cp $GITHUB_WORKSPACE/pbskids-dl.py .
chmod +x *
cd ../../
mkdir DEBIAN
cd ./DEBIAN
cp $GITHUB_WORKSPACE/.debian/control_c ./control
cd $GITHUB_WORKSPACE
dpkg --build ./pbskids-dl_deb