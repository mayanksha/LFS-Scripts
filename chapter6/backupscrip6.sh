#!/bin/bash
		#-------------->>zlib-1.2.11<<--------------
		cd $LFS/sources

		cd zlib-1.2.11

		./configure --prefix=/usr
		make
		make check
		make install
		mv -v /usr/lib/libz.so.* /lib
		ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so

#-------------->>file-5.30<<--------------
cd $LFS/sources

cd file-5.31

./configure --prefix=/usr
make
make check
make install

#-------------->>readline-7.0<<--------------
cd $LFS/sources

cd readline-7.0



sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr    \
		--disable-static \
		--docdir=/usr/share/doc/readline-7.0
make SHLIB_LIBS=-lncurses
make SHLIB_LIBS=-lncurses install
mv -v /usr/lib/lib{readline,history}.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-7.0


#-------------->>m4-1.4.18<<--------------
cd $LFS/sources

cd m4-1.4.18

./configure --prefix=/usr
make
make check
make install

#-------------->>bc-1.07.1<<--------------

cat > bc/fix-libmath_h << "EOF"
#! /bin/bash
sed -e '1   s/^/{"/' \
    -e     's/$/",/' \
    -e '2,$ s/^/"/'  \
    -e   '$ d'       \
    -i libmath.h

sed -e '$ s/$/0}/' \
    -i libmath.h
EOF

ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
ln -sfv libncurses.so.6 /usr/lib/libncurses.so

sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure


#-------------->>binutils-2.27<<--------------
cd $LFS/sources

cd binutils-2.27

expect -c "spawn ls"
mkdir -v build
cd       build
../configure --prefix=/usr       \
		--enable-gold       \
		--enable-ld=default \
		--enable-plugins    \
		--enable-shared     \
		--disable-werror    \
		--with-system-zlib
make tooldir=/usr
make -k check
make tooldir=/usr install

#-------------->>gmp-6.1.2<<--------------
cd $LFS/sources

cd gmp-6.1.2

ABI=32 ./configure ...
./configure --prefix=/usr    \
		--enable-cxx     \
		--disable-static \
		--docdir=/usr/share/doc/gmp-6.1.2
make
make html
make check 2>&1 | tee gmp-check-log
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
make install
make install-html

#-------------->>mpfr-3.1.5<<--------------
cd $LFS/sources

cd mpfr-3.1.5

./configure --prefix=/usr        \
		--disable-static     \
		--enable-thread-safe \
		--docdir=/usr/share/doc/mpfr-3.1.5
make
make html
make check
make install
make install-html

#-------------->>mpc-1.0.3<<--------------
cd $LFS/sources

cd mpc-1.0.3

./configure --prefix=/usr    \
		--disable-static \
		--docdir=/usr/share/doc/mpc-1.0.3
make
make html
make check
make install
make install-html

#-------------->>gcc-6.3.0<<--------------
cd $LFS/sources

cd gcc-6.3.0

case $(uname -m) in
		x86_64)
				sed -e '/m64=/s/lib64/lib/' \
						-i.orig gcc/config/i386/t-linux64
				;;
esac
mkdir -v build
cd       build
SED=sed                               \
		../configure --prefix=/usr            \
		--enable-languages=c,c++ \
		--disable-multilib       \
		--disable-bootstrap      \
		--with-system-zlib
make
ulimit -s 32768
make -k check
../contrib/test_summary
make install
ln -sv ../usr/bin/cpp /lib

ln -sv gcc /usr/bin/cc
install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/6.3.0/liblto_plugin.so \
		/usr/lib/bfd-plugins/
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

grep -B4 '^ /usr/include' dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
rm -v dummy.c a.out dummy.log
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

#-------------->>bzip2-1.0.6<<--------------
cd $LFS/sources

cd bzip2-1.0.6



patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install

cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat

#-------------->>pkg-config-0.29.1<<--------------
cd $LFS/sources

cd pkg-config-0.29.1

./configure --prefix=/usr              \
		--with-internal-glib       \
		--disable-compile-warnings \
		--disable-host-tool        \
		--docdir=/usr/share/doc/pkg-config-0.29.1
make
make check
make install

#-------------->>ncurses-6.0<<--------------
cd $LFS/sources

cd ncurses-6.0

sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
./configure --prefix=/usr           \
		--mandir=/usr/share/man \
		--with-shared           \
		--without-debug         \
		--without-normal        \
		--enable-pc-files       \
		--enable-widec
make
make install
mv -v /usr/lib/libncursesw.so.6* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so
for lib in ncurses form panel menu ; do
		rm -vf                    /usr/lib/lib${lib}.so
		echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
		ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done
rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so
mkdir -v       /usr/share/doc/ncurses-6.0
cp -v -R doc/* /usr/share/doc/ncurses-6.0
make distclean
./configure --prefix=/usr    \
		--with-shared    \
		--without-normal \
		--without-debug  \
		--without-cxx-binding \
		--with-abi-version=5 
make sources libs
cp -av lib/lib*.so.5* /usr/lib

#-------------->>attr-2.4.47<<--------------
cd $LFS/sources

cd attr-2.4.47

sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i -e "/SUBDIRS/s|man[25]||g" man/Makefile
./configure --prefix=/usr \
		--bindir=/bin \
		--disable-static
make
make -j1 tests root-tests
make install install-dev install-lib
chmod -v 755 /usr/lib/libattr.so
mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

		#-------------->>acl-2.2.52<<--------------
		cd $LFS/sources

		cd acl-2.2.52

		sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
		sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test

		sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
				libacl/__acl_to_any_text.c
		./configure --prefix=/usr    \
				--bindir=/bin    \
				--disable-static \
				--libexecdir=/usr/lib
		make

		make install install-dev install-lib
		chmod -v 755 /usr/lib/libacl.so
		mv -v /usr/lib/libacl.so.* /lib
		ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so

#-------------->>libcap-2.25<<--------------
cd $LFS/sources

cd libcap-2.25

sed -i '/install.*STALIBNAME/d' libcap/Makefile
make
make RAISE_SETFCAP=no lib=lib prefix=/usr install
chmod -v 755 /usr/lib/libcap.so

mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so

		#-------------->>sed-4.4<<--------------
		cd $LFS/sources

		cd sed-4.4

		sed -i 's/usr/tools/'       build-aux/help2man
		sed -i 's/panic-tests.sh//' Makefile.in
		./configure --prefix=/usr --bindir=/bin
		make
		make html
		make check
		make install
		install -d -m755           /usr/share/doc/sed-4.4
		install -m644 doc/sed.html /usr/share/doc/sed-4.4

#-------------->>shadow-4.4<<--------------
cd $LFS/sources

cd shadow-4.4



sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
		-e 's@/var/spool/mail@/var/mail@' etc/login.defs

echo '--- src/useradd.c   (old)
+++ src/useradd.c   (new)
@@ -2027,6 +2027,8 @@
is_shadow_grp = sgr_file_present ();
#endif

+       get_defaults ();
+
process_flags (argc, argv);

#ifdef ENABLE_SUBIDS
@@ -2036,8 +2038,6 @@
(!user_id || (user_id <= uid_max && user_id >= uid_min));
#endif                         /* ENABLE_SUBIDS */

-       get_defaults ();
-
#ifdef ACCT_TOOLS_SETUID
#ifdef USE_PAM
{' | patch -p0 -l
		sed -i 's@DICTPATH.*@DICTPATH\t/lib/cracklib/pw_dict@' etc/login.defs
		sed -i 's/1000/999/' etc/useradd
		sed -i -e '47 d' -e '60,65 d' libmisc/myname.c
		./configure --sysconfdir=/etc --with-group-name-max-length=32
		make
		make install
		mv -v /usr/bin/passwd /bin
		pwconv
		grpconv

		sed -i 's/yes/no/' /etc/default/useradd
		passwd root

#-------------->>psmisc-22.21<<--------------
cd $LFS/sources

cd psmisc-22.21

./configure --prefix=/usr
make
make install

mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin

		#-------------->>iana-etc-2.30<<--------------
		cd $LFS/sources

		cd iana-etc-2.30

		make
		make install

		#-------------->>bison-3.0.4<<--------------
		cd $LFS/sources

		cd bison-3.0.4

		./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4
		make

		make install


#-------------->>flex-2.6.3<<--------------
cd $LFS/sources

cd flex-2.6.3

HELP2MAN=/tools/bin/true \
		./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.3
make
make check
make install

ln -sv flex /usr/bin/lex

		#-------------->>grep-3.0<<--------------
		cd $LFS/sources

		cd grep-3.0

		./configure --prefix=/usr --bindir=/bin
		make
		make check
		make install

		#-------------->>bash-4.4<<--------------
		cd $LFS/sources

		cd bash-4.4

		patch -Np1 -i ../bash-4.4-upstream_fixes-1.patch
		./configure --prefix=/usr                       \
				--docdir=/usr/share/doc/bash-4.4 \
				--without-bash-malloc               \
				--with-installed-readline
		make
		chown -Rv nobody .
		su nobody -s /bin/bash -c "PATH=$PATH make tests"
		make install
		mv -vf /usr/bin/bash /bin

		exec /bin/bash --login +h
		#-------------->>libtool-2.4.6<<--------------
		cd $LFS/sources

		cd libtool-2.4.6

		./configure --prefix=/usr
		make
		make check
		make install

#-------------->>gdbm-1.12<<--------------
cd $LFS/sources

cd gdbm-1.12

./configure --prefix=/usr \
		--disable-static \
		--enable-libgdbm-compat
make
make check
make install

		#-------------->>gperf-3.0.4<<--------------
		cd $LFS/sources

		cd gperf-3.0.4

		./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.0.4
		make
		make -j1 check
		make install

#-------------->>expat-2.2.0<<--------------
cd $LFS/sources

cd expat-2.2.0

./configure --prefix=/usr --disable-static
make
make check
make install
install -v -dm755 /usr/share/doc/expat-2.2.0
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.0


		#-------------->>inetutils-1.9.4<<--------------
		cd $LFS/sources

		cd inetutils-1.9.4

		./configure --prefix=/usr        \
				--localstatedir=/var \
				--disable-logger     \
				--disable-whois      \
				--disable-rcp        \
				--disable-rexec      \
				--disable-rlogin     \
				--disable-rsh        \
				--disable-servers

		make
		make check
		make install
		mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
		mv -v /usr/bin/ifconfig /sbin

		#-------------->>perl-5.24.1<<--------------
		cd $LFS/sources

		cd perl-5.24.1

		echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
		export BUILD_ZLIB=False
		export BUILD_BZIP2=0
		sh Configure -des -Dprefix=/usr                 \
				-Dvendorprefix=/usr           \
				-Dman1dir=/usr/share/man/man1 \
				-Dman3dir=/usr/share/man/man3 \
				-Dpager="/usr/bin/less -isR"  \
				-Duseshrplib

		make
		make -k test
		make install
		unset BUILD_ZLIB BUILD_BZIP2

		#-------------->>intltool-0.51.0<<--------------
		cd $LFS/sources

		cd intltool-0.51.0

		sed -i 's:\\\${:\\\$\\{:' intltool-update.in
		./configure --prefix=/usr
		make
		make check
		make install
		install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO


		#-------------->>autoconf-2.69<<--------------
		cd $LFS/sources

		cd autoconf-2.69

		./configure --prefix=/usr
		make
		make check
		make install

		#-------------->>automake-1.15<<--------------
		cd $LFS/sources

		cd automake-1.15

		sed -i 's:/\\\${:/\\\$\\{:' bin/automake.in
		./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.15
		make
		sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh
		make -j4 check
		make install

		#-------------->>xz-5.2.3<<--------------
		cd $LFS/sources

		cd xz-5.2.3



		./configure --prefix=/usr    \
				--disable-static \
				--docdir=/usr/share/doc/xz-5.2.3
		make
		make check
		make install
		mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
		mv -v /usr/lib/liblzma.so.* /lib
		ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so

		#-------------->>kmod-23<<--------------
		cd $LFS/sources

		cd kmod-23

		./configure --prefix=/usr          \
				--bindir=/bin          \
				--sysconfdir=/etc      \
				--with-rootlibdir=/lib \
				--with-xz              \
				--with-zlib
		make
		make install

		for target in depmod insmod lsmod modinfo modprobe rmmod; do
				ln -sfv ../bin/kmod /sbin/$target
		done

		ln -sfv kmod /bin/lsmod

		#-------------->>gettext-0.19.8.1<<--------------
		cd $LFS/sources

		cd gettext-0.19.8.1

		sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in &&
				sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in
		./configure --prefix=/usr    \
				--disable-static \
				--docdir=/usr/share/doc/gettext-0.19.8.1
		make
		make check
		make install
		chmod -v 0755 /usr/lib/preloadable_libintl.so

		#-------------->>procps-ng-3.3.12<<--------------
		cd $LFS/sources

		cd procps-ng-3.3.12

		./configure --prefix=/usr                            \
				--exec-prefix=                           \
				--libdir=/usr/lib                        \
				--docdir=/usr/share/doc/procps-ng-3.3.12 \
				--disable-static                         \
				--disable-kill

		make
		sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
		make check
		make install
		mv -v /usr/lib/libprocps.so.* /lib
		ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so


#-------------->>linux-4.9.9<<--------------
cd $LFS/sources

cd linux-4.9.9

make mrproper
make INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete

cp -rv dest/include/* /usr/include



		#-------------->>e2fsprogs-1.43.4<<--------------
		cd $LFS/sources

		cd e2fsprogs-1.43.4

		mkdir -v build
		cd build
		LIBS=-L/tools/lib                    \
				CFLAGS=-I/tools/include              \
				PKG_CONFIG_PATH=/tools/lib/pkgconfig \
				../configure --prefix=/usr           \
				--bindir=/bin           \
				--with-root-prefix=""   \
				--enable-elf-shlibs     \
				--disable-libblkid      \
				--disable-libuuid       \
				--disable-uuidd         \
				--disable-fsck

		make
		ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib
		make LD_LIBRARY_PATH=/tools/lib check
		make install
		make install-libs
		chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
		gunzip -v /usr/share/info/libext2fs.info.gz
		install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
		makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
		install -v -m644 doc/com_err.info /usr/share/info
		install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info



		#-------------->>coreutils-8.26<<--------------
		cd $LFS/sources

		cd coreutils-8.26

		patch -Np1 -i ../coreutils-8.26-i18n-1.patch
		sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
		FORCE_UNSAFE_CONFIGURE=1 ./configure \
				--prefix=/usr            \
				--enable-no-install-program=kill,uptime
		FORCE_UNSAFE_CONFIGURE=1 make
		make NON_ROOT_USERNAME=nobody check-root
		echo "dummy:x:1000:nobody" >> /etc/group
		chown -Rv nobody . 
		su nobody -s /bin/bash \
				-c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
		sed -i '/dummy/d' /etc/group
		make install
		mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
		mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
		mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
		mv -v /usr/bin/chroot /usr/sbin
		mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
		sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8

		mv -v /usr/bin/{head,sleep,nice,test,[} /bin



		#-------------->>diffutils-3.5<<--------------
		cd $LFS/sources

		cd diffutils-3.5

		sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in
		./configure --prefix=/usr
		make
		make check
		make install

		#-------------->>gawk-4.1.4<<--------------
		cd $LFS/sources

		cd gawk-4.1.4

		./configure --prefix=/usr
		make
		make check
		make install
		mkdir -v /usr/share/doc/gawk-4.1.4
		cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.1.4

		#-------------->>findutils-4.6.0<<--------------
		cd $LFS/sources

		cd findutils-4.6.0

		sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in
		./configure --prefix=/usr --localstatedir=/var/lib/locate

		make
		make check
		make install

		mv -v /usr/bin/find /bin
		sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb

		#-------------->>groff-1.22.3<<--------------
		cd $LFS/sources

		cd groff-1.22.3

		PAGE=<paper_size> ./configure --prefix=/usr
		make
		make install


		#-------------->>grub-2.02~beta3<<--------------
		cd $LFS/sources

		cd grub-2.02~beta3

		./configure --prefix=/usr          \
				--sbindir=/sbin        \
				--sysconfdir=/etc      \
				--disable-efiemu       \
				--disable-werror
		make
		make install

		#-------------->>less-481<<--------------
		cd $LFS/sources

		cd less-481

		./configure --prefix=/usr --sysconfdir=/etc
		make
		make install


		#-------------->>gzip-1.8<<--------------
		cd $LFS/sources

		cd gzip-1.8

		./configure --prefix=/usr
		make
		make check
		make install
		mv -v /usr/bin/gzip /bin

		#-------------->>iproute2-4.9.0<<--------------
		cd $LFS/sources

		cd iproute2-4.9.0



		sed -i /ARPD/d Makefile
		sed -i 's/arpd.8//' man/man8/Makefile
		rm -v doc/arpd.sgml
		sed -i 's/m_ipt.o//' tc/Makefile
		make
		make DOCDIR=/usr/share/doc/iproute2-4.9.0 install

		#-------------->>kbd-2.0.4<<--------------
		cd $LFS/sources

		cd kbd-2.0.4

		patch -Np1 -i ../kbd-2.0.4-backspace-1.patch

		sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
		sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
		PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock
		make
		make check
		make install
		mkdir -v       /usr/share/doc/kbd-2.0.4
		cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.4

		#-------------->>libpipeline-1.4.1<<--------------
		cd $LFS/sources

		cd libpipeline-1.4.1

		PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr
		make
		make check
		make install

		#-------------->>make-4.2.1<<--------------
		cd $LFS/sources

		cd make-4.2.1

		./configure --prefix=/usr
		make
		make check
		make install

		#-------------->>patch-2.7.5<<--------------
		cd $LFS/sources

		cd patch-2.7.5



		./configure --prefix=/usr
		make
		make check
		make install


		#-------------->>sysklogd-1.5.1<<--------------
		cd $LFS/sources

		cd sysklogd-1.5.1

		sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
		sed -i 's/union wait/int/' syslogd.c
		make
		make BINDIR=/sbin install
		cat > /etc/syslog.conf << "EOF"
		# Begin /etc/syslog.conf

		auth,authpriv.* -/var/log/auth.log
		*.*;auth,authpriv.none -/var/log/sys.log
		daemon.* -/var/log/daemon.log
		kern.* -/var/log/kern.log
		mail.* -/var/log/mail.log
		user.* -/var/log/user.log
		*.emerg *

		# End /etc/syslog.conf
		EOF

		#-------------->>sysvinit<<--------------

		cd $LFS/sources
		cd $LFS/sources/sysvinit-2.88dsf
		patch -Np1 -i ../sysvinit-2.88dsf-consolidated-1.patch
		make -C src
		make -C src install


		#-------------->>eudev-3.2.1<<--------------
		cd $LFS/sources

		cd eudev-3.2.1

		sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl
		sed -i '/keyboard_lookup_key/d' src/udev/udev-builtin-keyboard.c
		cat > config.cache << "EOF"
		HAVE_BLKID=1
		BLKID_LIBS="-lblkid"
		BLKID_CFLAGS="-I/tools/include"
		EOF
		./configure --prefix=/usr           \
				--bindir=/sbin          \
				--sbindir=/sbin         \
				--libdir=/usr/lib       \
				--sysconfdir=/etc       \
				--libexecdir=/lib       \
				--with-rootprefix=      \
				--with-rootlibdir=/lib  \
				--enable-manpages       \
				--disable-static        \
				--config-cache
		LIBRARY_PATH=/tools/lib make
		mkdir -pv /lib/udev/rules.d
		mkdir -pv /etc/udev/rules.d
		make LD_LIBRARY_PATH=/tools/lib check
		make LD_LIBRARY_PATH=/tools/lib install
		tar -xvf ../udev-lfs-20140408.tar.bz2
		make -f udev-lfs-20140408/Makefile.lfs install
		LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update

#-------------->>util-linux-2.29.1<<--------------
cd $LFS/sources

cd util-linux-2.29.1



mkdir -pv /var/lib/hwclock
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
		--docdir=/usr/share/doc/util-linux-2.29.1 \
		--disable-chfn-chsh  \
		--disable-login      \
		--disable-nologin    \
		--disable-su         \
		--disable-setpriv    \
		--disable-runuser    \
		--disable-pylibmount \
		--disable-static     \
		--without-python     \
		--without-systemd    \
		--without-systemdsystemunitdir
make
bash tests/run.sh --srcdir=$PWD --builddir=$PWD
chown -Rv nobody .
su nobody -s /bin/bash -c "PATH=$PATH make -k check"
make install


#-------------->>man-db-2.7.6.1<<--------------
cd $LFS/sources

cd man-db-2.7.6.1

./configure --prefix=/usr                        \
		--docdir=/usr/share/doc/man-db-2.7.6.1 \
		--sysconfdir=/etc                    \
		--disable-setuid                     \
		--enable-cache-owner=bin             \
		--with-browser=/usr/bin/lynx         \
		--with-vgrind=/usr/bin/vgrind        \
		--with-grap=/usr/bin/grap            \
		--with-systemdtmpfilesdir=

make
make check
make install


#-------------->>tar-1.29<<--------------
cd $LFS/sources

cd tar-1.29

FORCE_UNSAFE_CONFIGURE=1  \
		./configure --prefix=/usr \
		--bindir=/bin
make
make check
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.29

#-------------->>texinfo-6.3<<--------------
cd $LFS/sources

cd texinfo-6.3

./configure --prefix=/usr --disable-static
make
make check
make install
make TEXMF=/usr/share/texmf install-tex
pushd /usr/share/info
rm -v dir
for f in *
do install-info $f dir 2>/dev/null
done
popd

		#-------------->>vim80<<--------------
		cd $LFS/sources

		cd vim80

		echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
		./configure --prefix=/usr
		make
		make -j1 test
		make install

		ln -sv vim /usr/bin/vi
		for L in  /usr/share/man/{,*/}man1/vim.1; do
				ln -sv vim.1 $(dirname $L)/vi.1
		done
		ln -sv ../vim/vim80/doc /usr/share/doc/vim-8.0.069

		cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
set mouse=r
syntax on
if (&term == "xterm") || (&term == "putty")
	set background=dark
endif

" End /etc/vimrc
EOF

vim -c ':options'


