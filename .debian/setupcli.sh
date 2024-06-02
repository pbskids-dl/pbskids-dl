cd $GITHUB_WORKSPACE
pwd
chmod +x *
mkdir pbskids-dl_deb
cd ./pbskids-dl_deb
mkdir -p opt/pbskids-dl
cd ./opt/pbskids-dl
cp $GITHUB_WORKSPACE/pbskids-dl.py .
pyinstaller pbskids-dl.py
chmod +x ./dist/pbskids-dl/pbskids-dl
cd ../..
mkdir -p usr/bin
cd ./usr/bin
ln -s /opt/pbskids-dl/dist/pbskids-dl/pbskids-dl pbskids-dl
cp $GITHUB_WORKSPACE/pbskids-dl.sh .
cd ../../
mkdir DEBIAN
cd ./DEBIAN
cp $GITHUB_WORKSPACE/.debian/control .
cd $GITHUB_WORKSPACE
dpkg --build ./pbskids-dl_deb