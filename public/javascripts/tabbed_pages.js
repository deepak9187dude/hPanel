/* ================================================================ 
This copyright notice must be untouched at all times.

The original version of this script and the associated (x)html
is available at http://www.stunicholls.com/various/tabbed_pages.html
Copyright (c) 2005-2007 Stu Nicholls. All rights reserved.
This script and the associated (x)html may be modified in any 
way to fit your requirements.
=================================================================== */


onload = function() {


	var e, i = 0;
	var post = querySt("tab");
	try{
	 
	while (e = document.getElementById('gallery').getElementsByTagName ('DIV') [i++]) {
		if (e.className == 'ondiv' || e.className == 'offdiv') {
			
			e.onclick = function () {
				var getEls = document.getElementsByTagName('DIV');
				for (var z=0; z<getEls.length; z++) {
					getEls[z].className=getEls[z].className.replace('show', 'hide');
					getEls[z].className=getEls[z].className.replace('ondiv', 'offdiv');
				}
				this.className = 'ondiv';
				var max1 = this.getAttribute('title');
				document.getElementById(max1).className = "show";
			}
			
			if(e.getAttribute('title') == post) {
				var max2 = e.getAttribute('title');
				document.getElementById(max2).className = "show";
				document.getElementById(max2+"tab").className = "ondiv";
			}
			else
			if (post != '')
			{
				var max2 = e.getAttribute('title');		
				document.getElementById(max2).className = "hide";
				document.getElementById(max2+"tab").className = "offdiv";				
			}
		}
	}
	}
	catch(exception)
	{}
}

function querySt(ji) {
	hu = window.location.search.substring(1);
	gy = hu.split("&");
	for (i=0;i<gy.length;i++) {
		ft = gy[i].split("=");
		if (ft[0] == ji) {
			return ft[1];
		}
	}
	return 0;
}