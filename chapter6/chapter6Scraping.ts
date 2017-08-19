var fs = require('fs');
var jsdom = require("jsdom-no-contextify");
//console.log('Script Started');

 var tarballData = fs.readFileSync('../tarFolderNames-8.1-rc2.txt', 'utf-8')
 tarballData = tarballData.split(/[\n ]+/);

var tarballPaths = [];
var tarballFolderNames = [];
for(let i = 0; i < tarballData.length - 1; i+=2){
		tarballPaths.push(tarballData[i]);
		tarballFolderNames.push(tarballData[i+1]);
}

var linksArr : string[] =  ["http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/linux-headers.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/file.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/binutils.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/gmp.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/mpfr.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/mpc.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/gcc.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/bzip2.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/pkg-config.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/ncurses.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/attr.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/acl.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/libcap.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/sed.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/shadow.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/psmisc.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/iana-etc.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/m4.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/bison.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/flex.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/grep.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/readline.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/bash.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/bc.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/libtool.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/gdbm.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/gperf.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/expat.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/inetutils.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/perl.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/xml-parser.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/intltool.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/autoconf.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/automake.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/xz.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/kmod.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/gettext.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/procps-ng.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/e2fsprogs.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/coreutils.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/diffutils.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/gawk.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/findutils.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/groff.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/zlib.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/grub.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/less.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/gzip.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/iproute2.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/kbd.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/libpipeline.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/make.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/patch.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/sysklogd.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/sysvinit.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/eudev.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/util-linux.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/man-db.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/tar.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/texinfo.html",
"http://linuxfromscratch.org/lfs/view/8.1-rc2/chapter06/vim.html"];
//var data = fs.readFileSync('./' + , 'utf-8');
var mainArray = [];
for (let i = 0; i < linksArr.length; i+=1){
		var regex = /http:.*chapter06\/(.*)\.html/
		var t = linksArr[i].replace(regex, "$1");
		mainArray.push([
				linksArr[i],
				tarballFolderNames.find((e) => {
						if (e.search(new RegExp(`${t}.*`)) === 0)
								return true;
						else
								return false;
				}),
				tarballPaths.find((e) => {
						if (e.search(new RegExp(`/mnt.*${t}.*`)) === 0)
								return true;
						else
								return false;
				}),

		])
};
mainArray[0][1] = 'linux-4.12.7 ';
mainArray[0][2] = '/mnt/lfs/sources//linux-4.12.7.tar.xz';
		
 
for (let arr of mainArray){
		var doc = jsdom.env((arr[0]), (err : any, win : Window) => {
				fs.appendFileSync('./meScript6.sh', `
						#-------------->>${arr[1]}<<--------------
						cd $LFS/sources\n
						cd ${arr[1]}\n
						`);
				if (err) throw err;
				var nodeList = Array.from(win.document.getElementsByClassName('command'));
				nodeList.forEach((elem) => {
						fs.appendFileSync('./meScript6.sh', (elem.nodeName === 'KBD'? elem.textContent.toString() : '\n') + '\n');
						//console.log(elem.nodeName === 'KBD'?elem.textContent : '\n');
				});
		})
}
