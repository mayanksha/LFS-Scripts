#!/bin/bash
set -r
set -x

cd $LFS/sources
cd tcl8.7.6
cd unix
./configure --prefix=/tools
make
TZ=UTC make test
make install
chmod -v u+w /tools/lib/libtcl8.7.so
make install-private-headers
ln -sv tclsh8.7 /tools/bin/tclsh
cd $LFS/sources
cd expect5.45
cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure
./configure --prefix=/tools       \
            --with-tcl=/tools/lib \
            --with-tclinclude=/tools/include
make
make test
make SCRIPTS="" install
cd $LFS/sources
cd dejagnu-1.6
./configure --prefix=/tools
make install
make check
cd $LFS/sources
cd check-0.11.0
PKG_CONFIG= ./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd ncurses-6.0
sed -i s/mawk// configure
./configure --prefix=/tools \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite
make
make install
cd $LFS/sources
cd bash-4.4
./configure --prefix=/tools --without-bash-malloc
make
make tests
make install
ln -sv bash /tools/bin/sh
cd $LFS/sources
cd bison-3.0.4
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd bzip2-1.0.6
make
make PREFIX=/tools install
cd $LFS/sources
cd coreutils-8.27
./configure --prefix=/tools --enable-install-program=hostname
make
make RUN_EXPENSIVE_TESTS=yes check
make install
cd $LFS/sources
cd diffutils-3.5
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd file-5.31
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd findutils-4.6.0
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd gawk-4.1.4
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd gettext-0.19.8.1
cd gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared
make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext
cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
cd $LFS/sources
cd grep-3.1
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd gzip-1.8
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd m4-1.4.18
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd make-4.2.1
./configure --prefix=/tools --without-guile
make
make check
make install
cd $LFS/sources
cd patch-2.7.5
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd perl-5.26.0
sh Configure -des -Dprefix=/tools -Dlibs=-lm
make
cp -v perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.26.0
cp -Rv lib/* /tools/lib/perl5/5.26.0
cd $LFS/sources
cd sed-4.4
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd tar-1.29
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd texinfo-6.4
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
cd util-linux-2.30.1
./configure --prefix=/tools                \
            --without-python               \
            --disable-makeinstall-chown    \
            --without-systemdsystemunitdir \
            PKG_CONFIG=""
make
make install
cd $LFS/sources
cd xz-5.2.3
./configure --prefix=/tools
make
make check
make install
cd $LFS/sources
