var fs = require('fs');
var jsdom = require('jsdom-no-contextify');

const blfsSourceLink = "http://mirrors-usa.go-parts.com/blfs/8.0/";
//Array of All the pageLinks

console.log("Script Started. Working!");

function pageLinksPromise() : Promise<any> {
		return new Promise((resolve, reject) => {
				jsdom.env(blfsSourceLink, (err : Error, win : Window) => {
						if (err){
								console.error(err.stack);
								reject(err);
						} 
						else {
								var	doc = win.document;

								//Converts the returned nodeList to an Array.
								//Other method, particularly for older browser, is to use Array.prototype.slice.call(arr)
								var tableData =	Array.from(doc.querySelectorAll('td'));


								//Converts every element of the tableData array from a NodeList to a new Array
								var tempArr = [];
								tempArr = tableData.map((elem) => Array.from(elem.childNodes));

								//Array of all the pageLinks inside the table (manually remove the first link too which returns to parentDir)
								var pageLinks = [];
								tempArr.map((elem) => {
										if(elem.length === 2)
												pageLinks.push( elem[0].href );
								});
								pageLinks = pageLinks.slice(1,pageLinks.length);
								resolve(pageLinks);
						};
				})
		})
};

function tarLinksFunc(pageLinks : string[]) : void {
		pageLinks.forEach((link) => {
				jsdom.env(link, (err, win : Window) => {
						if (err) throw err;
						else {
								var doc = win.document;
								var tarLinks = [];
								//var rootRegex = \
								//
								var anchorNodesArr =	Array.from(doc.querySelectorAll('td')).map((e) =>	e.childNodes);						
								anchorNodesArr.forEach((e : any) => {
										if(e[0].nodeName === 'A')
												console.log(e[0].href);
								})
						}
				})
		})
}
pageLinksPromise()
		.then((links) => {
				tarLinksFunc(links);
		})
		.catch((err) => {
				throw err;
})

