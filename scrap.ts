var fs = require('fs');
var jsdom = require("jsdom-no-contextify");
console.log('Script Started');

var linksArray =  ["http://linuxfromscratch.org/lfs/view/stable/chapter06/linux-headers.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/file.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/binutils.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/gmp.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/mpfr.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/mpc.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/gcc.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/bzip2.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/pkg-config.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/ncurses.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/attr.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/acl.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/libcap.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/sed.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/shadow.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/psmisc.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/iana-etc.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/m4.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/bison.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/flex.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/grep.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/readline.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/bash.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/bc.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/libtool.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/gdbm.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/gperf.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/expat.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/inetutils.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/perl.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/xml-parser.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/intltool.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/autoconf.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/automake.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/xz.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/kmod.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/gettext.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/procps-ng.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/e2fsprogs.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/coreutils.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/diffutils.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/gawk.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/findutils.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/groff.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/grub.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/less.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/gzip.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/iproute2.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/kbd.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/libpipeline.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/make.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/patch.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/sysklogd.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/sysvinit.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/eudev.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/util-linux.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/man-db.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/tar.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/texinfo.html",
"http://linuxfromscratch.org/lfs/view/stable/chapter06/vim.html"];
//var data = fs.readFileSync('./' + , 'utf-8');
for (let link of linksArray){
		var doc = jsdom.env(link.toString(), (err, win : Window) => {
				fs.appendFileSync('./scrip6.sh', `"${link}\n\n`);
				if (err) throw err;
				var nodeList = Array.from(win.document.getElementsByClassName('command'));
				nodeList.forEach((elem) => {
						fs.appendFileSync('./scrip6.sh', (elem.nodeName === 'KBD'? elem.textContent.toString() : '\n') + '\n');
						console.log(elem.nodeName === 'KBD'?elem.textContent : '\n');
				});
		})
}
