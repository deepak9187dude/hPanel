
var xmlHttp, pgurl, dObj, xmlHttp2, pgurl2, dObj2
	function GetXmlHttpObject(handler){ 
		var objXmlHttp=null
		if (navigator.userAgent.indexOf("Opera")>=0){
			alert("This example doesn't work in Opera") 
			return 
		}
		if (navigator.userAgent.indexOf("MSIE")>=0){ 
			var strName="Msxml2.XMLHTTP"
			if (navigator.appVersion.indexOf("MSIE 5.5")>=0){
				strName="Microsoft.XMLHTTP"
			}//if 
			try{ 
				objXmlHttp=new ActiveXObject(strName)
				objXmlHttp.onreadystatechange=handler 
				return objXmlHttp
			} 
			catch(e){ 
				alert("Error. Scripting for ActiveX might be disabled") 
				return 
			} 
		}//if 
		if (navigator.userAgent.indexOf("Mozilla")>=0){
			objXmlHttp=new XMLHttpRequest()
			objXmlHttp.onload=handler
			objXmlHttp.onerror=handler 
			return objXmlHttp
		}
    } 
	
	//var dObj;
	function funshowchild(pg1,sval,divObj,pg2)		
	{ 
		//alert('aa'+divObj);
		if (pg2 == null)
			pg2 = '';
		else
			pgurl = pg2;

		dObj =  document.getElementById(divObj);

		url = pg1+"&id="+sval+"&ajaxshow=1";	

		xmlHttp=GetXmlHttpObject(childChanged) 		
		//alert(url);
		xmlHttp.open("GET", url , true)
		dObj.innerHTML="<br><img src='/images/loading_ani2.gif'>";			
		xmlHttp.send(null) 
    }

	//var dObj;
	function funpostchild(pg1,sval,divObj,pg2,frm)		
	{ 
		//alert('aa'+divObj);
		
		if (pg2 == null)
			pg2 = '';
		else
			pgurl = pg2;

		dObj =  document.getElementById(divObj);

		url = pg1+"&id="+sval+"&ajaxshow=1";	
		xmlHttp=GetXmlHttpObject(childChanged) 
		xmlHttp.open("POST", url , true) 
		xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
		var postReq = "";
		var frmObj = document.frmserver;
		for(i=0;i<frmObj.elements.length;i++) {
		
			if(frmObj.elements[i].checked) {
				postReq += frmObj.elements[i].name;
				postReq += "=";
				postReq += frmObj.elements[i].value;
				postReq += "&";
			}
			if(frmObj.elements[i].type == "hidden") {
				postReq += frmObj.elements[i].name;
				postReq += "=";
				postReq += frmObj.elements[i].value;
				postReq += "&";
			}
		}
		
		dObj.innerHTML="<br><img src='asset/images/loading_ani2.gif'>";
		xmlHttp.send(postReq) 
		return true;
    }
	
	//var dObj;
	function funshow(pg1,sval,divObj,pg2)		
	{ 
		//alert('aa'+divObj);
		if (pg2 == null)
			pg2 = '';
		else
			pgurl = pg2;

		dObj =  document.getElementById(divObj);

		url = pg1+"&id="+sval+"&ajaxshow=1";	

		//alert(url); 	
		xmlHttp=GetXmlHttpObject(childChanged) 		
		//alert(url);
		xmlHttp.open("GET", url , true) 		
		dObj.innerHTML="<img src='asset/images/loader24x24.gif'>";
		xmlHttp.send(null) 
    }
	
	function funshow2(pg1,sval,divObj,pg2)		
	{ 
		//alert('aa'+divObj+sval);
		if (pg2 == null)
			pg2 = '';
		else
			pgurl2 = pg2;

		dObj2 =  document.getElementById(divObj);

		url = pg1+"&id="+sval+"&ajaxshow=1";	

		//alert(url); 	
		xmlHttp2=GetXmlHttpObject(childChanged2) 		
		//alert(url);
		xmlHttp2.open("GET", url , true) 		
		dObj2.innerHTML="<img src='asset/images/loader24x24.gif'>";
		xmlHttp2.send(null) 
    }
	
	function childChanged2()
	{ 

       if (xmlHttp2.readyState==4 || xmlHttp2.readyState=="complete")
	   { 
	  
	   		if(xmlHttp2.responseText == ' ') 
			{
				location.href = pgurl2
			}
			
			dObj2.innerHTML=xmlHttp2.responseText
       }//if 
    }
	
	function childChanged()
	{ 

       if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete")
	   { 
	  
	   		if(xmlHttp.responseText == ' ') 
			{
				location.href = pgurl
			}
			
			dObj.innerHTML=xmlHttp.responseText
       }//if 
    }

	function get(frm, pg1, div, pg2) 
	{
		
		var str = ' ';
		for(var i=0;i<frm.elements.length;i++)
		  { 
			 var e = frm.elements[i];
			 var f=1;
			 f=0;
			 str += "&"+e.name+"="+e.value;
		  }				 
		funshowchild(pg1, str, div, pg2);
	}
	
	function getVmDetails(frm, pg1, div, pg2) 
	{
	//Function used to send the request for vm creation process. 	
		var str = ' ';
		for(var i=0;i<frm.elements.length;i++)
		  { 
			 var e = frm.elements[i];
			 var f=1;
			 f=0;
			 str += "&"+e.name+"="+e.value;
		  }
		 if(frm.resolver.checked == false) {
		    str += "&txtresolver="+"false";
		 } else {
		 	str += "&txtresolver="+"true"; 
		 }
		funshowchild(pg1, str, div, pg2);
	}
	
	
	function funshowos(pg1,sval,divObj,pg2)		
	{ 
		document.getElementById('ordernow').style.display = 'none';	
		//alert('aa'+divObj+sval);
		if (pg2 == null)
			pg2 = '';
		else
			pgurl2 = pg2;

		dObj2 =  document.getElementById(divObj);

		url = pg1+"&id="+sval+"&ajaxshow=1";	

		//alert(url); 	
		xmlHttp2=GetXmlHttpObject(childChanged2) 		
		//alert(url);
		xmlHttp2.open("GET", url , true) 		
		dObj2.innerHTML="<img src='asset/images/loader24x24.gif'>";
		xmlHttp2.send(null) 
    }
	
	function funloadList(pg1,sval,divObj,pg2)		
	{ 
		//document.getElementById('ordernow').style.display = 'none';	
		//alert('aa'+divObj+sval);
		if (pg2 == null)
			pg2 = '';
		else
			pgurl2 = pg2;

		dObj2 =  document.getElementById(divObj);

		url = pg1+"&id="+sval+"&ajaxshow=1";	

		//alert(url); 	
		xmlHttp2=GetXmlHttpObject(childChanged2) 		
		//alert(url);
		xmlHttp2.open("GET", url , true) 		
		dObj2.innerHTML="<img src='asset/images/loader24x24.gif'>";
		xmlHttp2.send(null) 
    }
	function funshowordernow(pg1,sval,divObj,pg2, planid, billingperiod)		
	{ 
		 
		if (pg2 == null)
			pg2 = '';
		else
			pgurl2 = pg2;

		dObj2 =  document.getElementById(divObj);

		url = pg1+"&id="+planid+"&period="+billingperiod+"&tid="+sval+"&ajaxshow=1";
		
		selbox = document.getElementById('cmbtemplate');
	 
		if(selbox.value != '') {
			 
			document.getElementById('ordernow').style.display = 'block';	
		}	
		else {
			document.getElementById('ordernow').style.display = 'none';			
		}
		 
		xmlHttp2=GetXmlHttpObject(childChanged2) 		
		//alert(url);
		xmlHttp2.open("GET", url , true) 		
		dObj2.innerHTML="<img src='asset/images/loader24x24.gif'>";
		xmlHttp2.send(null) 
    }
