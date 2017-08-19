var fs = require('fs');
var jsdom = require('jsdom-no-contextify');

const blfsSourceLink = "http://mirrors-usa.go-parts.com/blfs/8.0/";
//Array of All the pageLinks
console.log("Script Started. Working!");
const blfsUrl = "http://www.linuxfromscratch.org/blfs/view/stable/index.html"; 
function pageLinksPromise() : Promise<any> {
		return new Promise((resolve, reject) => {
				jsdom.env(blfsUrl, (err : Error, win : Window) => {
						if(err) 
								reject(err);
						
						var doc = win.document;
						var temp = Array.from(doc.getElementsByClassName('sect1')).map((e : any) => {
					var anchorelems : any	= Array.from(e.childNodes)[1];
								return anchorelems.href;
						});
						resolve(temp);
				});

		})
}
pageLinksPromise()
		.then((linksArr) => {
				linksArr.forEach((link) => {
						jsdom.env(link, (err : Error, win : Window) => {

								var doc = win.document;
								var arr = Array.from(doc.getElementsByClassName('compact'))[0];						
								var temparr = [];
								if(arr){
										(Array.from(arr.childNodes).every((e : any) => {
												if(e.nodeName === 'LI' && e.childNodes[1].nodeName){
														if(e.childNodes[1].childNodes.length ===3)
														temparr.push(e.childNodes[1].childNodes[1].href);
														return false;
												}				
												else {
														return true;
												}
										}));
										console.log(temparr);
								}

						})
				})
});
