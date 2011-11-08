function selectall(state, frm, chkid){
		for (i = 0; i < frm.length; i++) {
			if(frm[i].name == chkid)
				frm[i].checked = state ;
		}
}

function confTerminate( msg){
	 var val= chk_confirm(msg, 'request');
		   if(val==false)
		   {
		   	  
		   	 return false;
		   }	 
		   else
		     return true;
}

function isChecked(frm, chkid, msg){
		var flag=0;
		for (i = 0; i < frm.length; i++) {
		if(frm[i].checked == true)
			flag++;
			//alert(frm[i].checked);
			//return false;
		}
		
		if(flag>0)
		{
		   document.getElementById('err').innerHTML = "";
		   var val= chk_confirm(msg, 'request');
		   if(val==false)
		   {
		   	 document.getElementById('err').innerHTML = "";
		   	 return false;
		   }	 
		   else
		     return true;	 		
		   //alert(val);
		   
		}   
		else
		{
			document.getElementById('err').innerHTML = "Please select termination request";
		   return false; 
		}    
}


function isCheckedTermination(frm, chkid, msg){
		var flag=0;
		for (i = 0; i < frm.length; i++) {
		if(frm[i].checked == true)
			flag++;
			//alert(frm[i].checked);
			//return false;
		}
		
		if(flag>0)
		{
		   document.getElementById('err').innerHTML = "";
		   if( document.getElementById('termination_1').value=="")
		   {
		   	      document.getElementById('spanterm').innerHTML = "should not be blank";
				  return false;
		   } 
		   else
		   document.getElementById('spanterm').innerHTML = "";
		   
		   var val= chk_confirm(msg, 'subscription');
		   if(val==false)
		   {
		   	 document.getElementById('err').innerHTML = "";
		   	 return false;
		   }	 
		   else
		     return true;	 		
		   //alert(val);
		   
		}   
		else
		{
			document.getElementById('err').innerHTML = "Please select termination request";
		   return false; 
		}    
}


function showerror(divid,msg)
{	
	if(divid!=""){
		document.getElementById(divid).innerHTML=msg;	
	}
}

function chkdel(frm, msg, val)
{
	var errors="";

  for(var i=0;i<frm.elements.length;i++)
  { 
     var e = frm.elements[i];
     var f=1;
	 if (e.name == "chkdel[]")
	 {
        if(e.checked == true)
		{
	 		f=0;
			if(document.MM_returnValue=chk_confirm(msg, val)==false) return false;
			else true;
			//frm.submit();
			break;
		}
     }
  }
  if(f==1)
  	{
		errors="true";
		if (errors) alert("Please select the checkbox");
		return false;
		
	}

}

function chk_confirm(msg, val)
{ 
	 var errors="";
	 var temp;
	 temp=confirm("Are you sure you want to "+msg+" the "+val+"(s)?");
	 if(temp==false)
	 {
		return temp;
	 }
}

function chk_confirmToRebuild(msg, val) { 		
	 var errors="";
	 var temp;	 	 
	 if(document.frmvmcr.confirmrebuild.checked == false) {
		alert("Please confirm the rebuild process with selected OS Template");
		return false;
	} else {
		temp = confirm("Are you sure you want to "+msg+" the "+val+"(s)?");
		if(temp==false)	 {
			return temp;
	 	}
		
	}
	return true;
}

function chk_vm_confirm(msg, val, status)
{ 
	 var errors="";
	 var temp;
	 var action = msg;
	 if(status == 'Running' && action != 'Backup') {
		 alert("Please Stop the VM to "+msg);
		 return false;
	 }
	 else if(status != 'Stopped' && action != 'Backup') { 
		alert("Please Stop the VM to "+msg);
		return false;
	 }	
	 else {
		 temp=confirm("Are you sure you want to "+msg+" the "+val+"(s)?");
		 if(temp==false)
		 {
			return temp;
		 } 
	 }
}
function chk_vm_reboot(msg, val, status)
{ 
	 var errors="";
	 var temp;
	 if(status != 'Running') {
		 alert("Please make sure VM is Running to "+msg);
		 return false;
	 }	 	
	 else {
		 temp=confirm("Are you sure you want to "+msg+" the "+val+"(s)?");
		 if(temp==false)
		 {
			return temp;
		 } 
	 }
}

function chk_vm_shutdown(msg, val, status)
{ 
	 var errors="";
	 var temp;
	 if(status == 'Paused') {
		 alert("Please Unpause the VM to Shutdown.");
		 return false;
	 }
	 else {
		 temp=confirm("Are you sure you want to "+msg+" the "+val+"(s)?");
		 if(temp==false)
		 {
			return temp;
		 }
	 }
}

function window_open(url){
	window.open(url,"","toolbar=0,location=0,resizable=1,scrollbars=yes,width=440,height=450");
	return 0;
}

function window_printopen(url){
	window.open(url,"","toolbar=0,location=0,left=10,resizable=1,scrollbars=auto,width=640,height=550");
	return 0;
}

function AddAcc( id , name , frm) { 
	  
	window.parent.opener.document.getElementById('txtId').value=id;
	window.parent.opener.document.getElementById('txtName').value=name;
	window.close();
}

function AddServernodes( id , name , frm) {//alert(frm);
	var cselect = parent.opener.document.getElementById('frmhr').cmbserver;
	var cselectsel = parent.opener.document.getElementById('frmhr').cmbserversel;
	//alert(parent.opener.document.getElementById('frmhr').rdoption[1].checked);
	//alert(parent.opener.document.getElementById('frmhr').rdoption[2].checked);
	
	if(parent.opener.document.getElementById('frmhr').rdoption[1].checked == true)
	{
	if(cselect.type=='hidden' || cselect.type=='text') {
		//parent.opener.document.getElementById(frm).hw_name.value=name;
			cselect.value=id;
			window.close();
	} else { 
			var alreadySelected=false;
			for(i=0;i<cselect.length;i++) {
					if (cselect.options[i].value == id) alreadySelected=true;
			};
			if(!alreadySelected) {
					if (document.all) {
							var opt=parent.opener.document.createElement("OPTION");
							opt.text=name;
							opt.value=id;
							cselect.add(opt);
					} else {
							cselect.options[cselect.length] = new Option(name,id);
					}
					cselect[cselect.length-1].selected=true;
			}
	};
	}
	
	if(parent.opener.document.getElementById('frmhr').rdoption[2].checked == true)
	{
	if(cselectsel.type=='hidden' || cselectsel.type=='text') {
		//parent.opener.document.getElementById(frm).hw_name.value=name;
			cselectsel.value=id;
			window.close();
	} else { 
			var alreadySelected=false;
			for(i=0;i<cselectsel.length;i++) {
					if (cselectsel.options[i].value == id) alreadySelected=true;
			};
			if(!alreadySelected) {
					if (document.all) {
							var opt1=parent.opener.document.createElement("OPTION");
							opt1.text=name;
							opt1.value=id;
							cselectsel.add(opt1);
					} else {
							cselectsel.options[cselectsel.length] = new Option(name,id);
					}
					cselectsel[cselectsel.length-1].selected=true;
			}
	};
	}
	window.close();
	//return 0;
}


function selectAllNodes(listid) {
	var cselect;
	//cselect = document.getElementById(listid); 
	
	if(document.getElementById('frmhr').rdoption[1].checked == true)
	{
		cselect = document.getElementById('cmbserver'); 
		for(var i=0;i<cselect.length;i++) {
		cselect.options[i].selected = true;
	}
		}
	else if(document.getElementById('frmhr').rdoption[2].checked == true)
		{cselect =  document.getElementById('cmbserversel'); 
		for(var i=0;i<cselect.length;i++) {
		cselect.options[i].selected = true;
			}
		
		}
		
	
	
}

function AddServer( id , name , frm) {
	var cselect = parent.opener.document.getElementById(frm).cmbserver;
	if(cselect.type=='hidden' || cselect.type=='text') {
		//parent.opener.document.getElementById(frm).hw_name.value=name;
			cselect.value=id;
			window.close();
	} else {
			var alreadySelected=false;
			for(i=0;i<cselect.length;i++) {
					if (cselect.options[i].value == id) alreadySelected=true;
			};
			if(!alreadySelected) {
					if (document.all) {
							var opt=parent.opener.document.createElement("OPTION");
							opt.text=name;
							opt.value=id;
							cselect.add(opt);
					} else {
							cselect.options[cselect.length] = new Option(name,id);
					}
					cselect[cselect.length-1].selected=true;
			}
	};
	return 0;
}

function server_list_remove(v_ObjectName)
{
	var cselect;
    cselect = document.getElementById(v_ObjectName);
    if(!cselect) alert("vidget "+v_ObjectName+" not found :(");
	for(i=cselect.length-1;i>=0;i--) {
		var oOption = cselect[i];
		if (oOption.selected) {
			cselect[i] = null;
		}			
	}
	return 0;
}

function showSearch(part) {
	var pp = document.getElementById(part);
	var img = part+ "_img";
	var prefix = "";
	var msg;
	var search_bar_text = part+ "_text";
	var curr_domain = document.domain;

	if(pp.style.display=='none') {
		pp.style.display = 'block';
		document.images[img].src = "asset/images/search_hide.png";
		msg = prefix + "Hide Search";
		setCookie(part, 1, "", "/", curr_domain, "");

	} else {
		pp.style.display = 'none';
		document.images[img].src = "asset/images/search_show.png";
		msg = prefix + "Show Search";
		setCookie(part, 0, "", "/", curr_domain, "");
	}
	lyrdoc = document.getElementById(search_bar_text);
	if (lyrdoc && lyrdoc.innerHTML) lyrdoc.innerHTML = msg;
	return true;
}

function selectAll(listid) {
	var cselect;
	cselect = document.getElementById(listid);
	for(var i=0;i<cselect.length;i++) {
		cselect.options[i].selected = true;
	}
	
}


function selectAllNodes(listid) {
	var cselect;
	//cselect = document.getElementById(listid); 
	
	if(document.getElementById('frmhr').rdoption[1].checked == true)
	{
		cselect = document.getElementById('cmbserver'); 
		for(var i=0;i<cselect.length;i++) {
		cselect.options[i].selected = true;
	}
		}
	else if(document.getElementById('frmhr').rdoption[2].checked == true)
		{cselect =  document.getElementById('cmbserversel'); 
		for(var i=0;i<cselect.length;i++) {
		cselect.options[i].selected = true;
			}
		
		}
		
	
	
}


function AddItem(listid, chk)
{	
	var flag=0;
	Text = "Automatic";
	Value = 0;
	  
	// Create an Option object        
    var opt = document.createElement("option");

	var x = document.getElementById(listid);
	var len = x.length;
	var chkopt = document.getElementById(chk);	
	 
    if(chkopt.checked) {
		// Add an Option object to Drop Down/List Box
		if(x.options[len-1].value != 0 || len==1) {
			x.options.add(opt);
			// Assign text and value to Option object
			opt.text = Text;
			opt.value = Value;
			x.options[len].selected = true;
		}
		else   x.options[len-1].selected = true;
	}
	else {
		 x.options[0].selected = true;
		 x.remove(len-1);
	}
}

function frm_submit(frm, act) {
	frm.action = act;
	frm.submit();
}
function funcShow(val1, val2)
{
 
  document.getElementById(val1).style.display = "none";
  document.getElementById(val2).style.display = "block";
}
function funcHide(val1, val2)
{
	
  document.getElementById(val1).style.display = "block";
  document.getElementById(val2).style.display = "none";
}


function ToggleContact(val1, val2)
{
	if(document.getElementById(val1).style.display=='block')
	{
		var BrowserName = "";
		BrowserName = navigator.appName;
		if(BrowserName=="Netscape")
		{
			document.getElementById(val1).style.display='none';
			document.getElementById(val2).style.display='block';
			 
		}
		else
		{
			document.getElementById(val1).style.display='block';
			document.getElementById(val2).style.display='none';
		}
	}
	else
	{
		document.getElementById(val1).style.display='block';
		document.getElementById(val2).style.display='none';
	}
}



function chkEnable()
{	

  if((document.getElementById('chkenable').checked == true ))
  {
	  
	document.getElementById('chkoverusage').disabled=false;
	document.getElementById('chktraffic').disabled=false;
  }
  
  if((document.getElementById('chkenable').checked == true ) && (document.getElementById('chktraffic').checked == true ))
  {
	  
	document.getElementById('txtAdditional_').disabled=false;
	document.getElementById('txtUpgrade').disabled=false;
	document.getElementById('cmbUnits1').disabled=false;
	document.getElementById('txtCombine_1').disabled=false;
	
	document.getElementById('txtCombineMax').disabled=false;
	
	document.getElementById('txtIncoming').disabled=true;
	
	document.getElementById('txtIncomingMax').disabled=true;
	
	document.getElementById('txtOutgoing').disabled=true;
	
	document.getElementById('txtOutgoingMax').disabled=true;

  }
  else
  {
	if((document.getElementById('chkenable').checked == true ) && (document.getElementById('chktraffic').checked == false ))
  	{
		document.getElementById('txtAdditional').disabled=false;
		document.getElementById('txtUpgrade').disabled=false;
		document.getElementById('cmbUnits1').disabled=false;
		document.getElementById('txtCombine_1').disabled=true;
		
		document.getElementById('txtCombineMax').disabled=true;
		
		document.getElementById('txtIncoming').disabled=false;
		
		document.getElementById('txtIncomingMax').disabled=false;
		
		document.getElementById('txtOutgoing').disabled=false;
		
		document.getElementById('txtOutgoingMax').disabled=false;

  	}
	else
	{
	  document.getElementById('txtCombine_1').disabled=true;

	document.getElementById('txtCombineMax').disabled=true;

	document.getElementById('txtIncoming').disabled=true;

	document.getElementById('txtIncomingMax').disabled=true;

	document.getElementById('txtOutgoing').disabled=true;

	document.getElementById('txtOutgoingMax').disabled=true;
	document.getElementById('txtAdditional').disabled=true;
	document.getElementById('txtUpgrade').disabled=true;
	document.getElementById('cmbUnits1').disabled=true;
	}

  }
}

function AddchkEnable()
{	

  if((document.getElementById('chkenable').checked == true ))
  {
	   
	document.getElementById('chkoverusage').disabled=false;
	document.getElementById('chktraffic').disabled=false;
  }
  else
  {
	  	document.getElementById('chkoverusage').disabled=true;
		document.getElementById('chktraffic').disabled=true;
  }
  
  if((document.getElementById('chkenable').checked == true ) && (document.getElementById('chktraffic').checked == true ))
  {
	  	document.getElementById('txtCombine').innerHTML = "";
		document.getElementById('txtCombineMax').innerHTML = "";
	  
	document.getElementById('txtAdditional_1').disabled=false;
	document.getElementById('txtUpgrade_1').disabled=false;
	document.getElementById('cmbUnits1').disabled=false;
	document.getElementById('txtCombine_1').disabled=false;
	
	document.getElementById('txtCombineMax_1').disabled=false;
	
	document.getElementById('txtIncoming_1').disabled=true;
	
	document.getElementById('txtIncomingMax_1').disabled=true;
	
	document.getElementById('txtOutgoing_1').disabled=true;
	
	document.getElementById('txtOutgoingMax_1').disabled=true;

  }
  else
  {
	if((document.getElementById('chkenable').checked == true ) && (document.getElementById('chktraffic').checked == false ))
  	{
		document.getElementById('txtCombine').innerHTML = "";
		document.getElementById('txtCombineMax').innerHTML = "";
	  
		document.getElementById('txtAdditional_1').disabled=false;
		document.getElementById('txtUpgrade_1').disabled=false;
		document.getElementById('cmbUnits1').disabled=false;
		document.getElementById('txtCombine_1').disabled=true;
		
		document.getElementById('txtCombineMax_1').disabled=true;
		
		document.getElementById('txtIncoming_1').disabled=false;
		
		document.getElementById('txtIncomingMax_1').disabled=false;
		
		document.getElementById('txtOutgoing_1').disabled=false;
		
		document.getElementById('txtOutgoingMax_1').disabled=false;
		//alert(document.getElementById('txtOutgoingMax_1').disabled);

  	}
	else  
	{   
		document.getElementById('txtCombine').innerHTML = "";
		document.getElementById('txtCombineMax').innerHTML = "";
	  
		document.getElementById('txtCombine_1').disabled=true;
		document.getElementById('txtCombine_1').disabled =true;
		document.getElementById('txtCombineMax_1').disabled=true;
		
		document.getElementById('txtIncoming_1').disabled=true;
		
		document.getElementById('txtIncomingMax_1').disabled=true;
		
		document.getElementById('txtOutgoing_1').disabled=true;
		
		document.getElementById('txtOutgoingMax_1').disabled=true;
		document.getElementById('txtAdditional_1').disabled=true;
		document.getElementById('txtUpgrade_1').disabled=true;
		document.getElementById('cmbUnits1').disabled=true;
		//alert(document.getElementById('txtOutgoingMax_1').disabled);
	}
 
  }
}


function funcValidatetraffic()
{
	var flg, flg1;
	flg = true;
	
  if((document.getElementById('chkenable').checked == true)  && (document.getElementById('chktraffic').checked == true ))
  {
  	 document.getElementById('txtIncoming').innerHTML = "";
   	 document.getElementById('txtIncomingMax').innerHTML = "";
   	 document.getElementById('txtOutgoing').innerHTML = "";
   	 document.getElementById('txtOutgoingMax').innerHTML = "";
  	 if(document.getElementById('txtCombine_1').value == "")
	 {
	    document.getElementById('txtCombine').innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else 
	 {
		 //alert(isEmpty(document.getElementById('txtCombine_1').value));
	 	 document.getElementById('txtCombine').innerHTML = "";
		 flg = true;
	 }	 
	 
	 if(document.getElementById('txtCombineMax_1').value == "")
	 {
	    document.getElementById('txtCombineMax').innerHTML = "Should not be blank";
		flg = false;
		return false;
	 }
	 else
	 {
	 	 document.getElementById('txtCombineMax').innerHTML = "";
		 flg = true;
	 }	
	 
	 if(document.getElementById('txtAdditional_1').value == "")
	 {
		document.getElementById('txtAdditional').innerHTML = "Should not be blank";
		flg = false;
		return false;
	 }
	 else
	 {
		 document.getElementById('txtAdditional').innerHTML = "";
		 flg = true;
	 }	 
	 
	  if(document.getElementById('txtUpgrade_1').value == "")
	 {
		document.getElementById('txtUpgrade').innerHTML = "Should not be blank";
		flg = false;
		return false;
	 }
	 else
	 {
		 document.getElementById('txtUpgrade').innerHTML = "";
		 flg = true;
	 }	
			 
	 if(flg == true)
	   return true;
	 else 
	   return false;  
		 
		
  }
  else
  {
	if((document.getElementById('chkenable').checked == true ) && (document.getElementById('chktraffic').checked == false ))
  	{
			 document.getElementById('txtCombine').innerHTML = "";
			  document.getElementById('txtCombineMax').innerHTML = "";
			 if(document.getElementById('txtIncoming_1').value == "")
			 {
				document.getElementById('txtIncoming').innerHTML = "Should not be blank";
				flg = false;
				return false;
			 }
			 else
			 {
				 document.getElementById('txtIncoming').innerHTML = "";
				 flg = true;
			 }	 
			 
			  if(document.getElementById('txtIncomingMax_1').value == "")
			 {
				document.getElementById('txtIncomingMax').innerHTML = "Should not be blank";
				flg = false;
				return false;
			 }
			 else
			 {
				 document.getElementById('txtIncomingMax').innerHTML = "";
				 flg = true;
			 }	 
			 
			 if(document.getElementById('txtOutgoing_1').value == "")
			 {
				document.getElementById('txtOutgoing').innerHTML = "Should not be blank";
				flg = false;
				return false;
			 }
			 else
			 {
				 document.getElementById('txtOutgoing').innerHTML = "";
				 flg = true;
			 }	 
			 
			 
			 if(document.getElementById('txtOutgoingMax_1').value == "")
			 {
				document.getElementById('txtOutgoingMax').innerHTML = "Should not be blank";
				flg = false;
				return false;
			 }
			 else
			 {
				 document.getElementById('txtOutgoingMax').innerHTML = "";
				 flg = true;
			 }	 
			 
			 if(document.getElementById('txtAdditional_1').value == "")
			 {
				document.getElementById('txtAdditional').innerHTML = "Should not be blank";
				flg = false;
				return false;
			 }
			 else
			 {
				 document.getElementById('txtAdditional').innerHTML = "";
				 flg = true;
			 }	 
			 
			  if(document.getElementById('txtUpgrade_1').value == "")
			 {
				document.getElementById('txtUpgrade').innerHTML = "Should not be blank";
				flg = false;
				return false;
			 }
			 else
			 {
				 document.getElementById('txtUpgrade').innerHTML = "";
				 flg = true;
			 }	 
			 if(flg == true)
			   return true;
			 else 
			   return false;  
	}
	else
	{
	 document.getElementById('txtIncoming').innerHTML = "";
   	 document.getElementById('txtIncomingMax').innerHTML = "";
   	 document.getElementById('txtOutgoing').innerHTML = "";
   	 document.getElementById('txtOutgoingMax').innerHTML = "";
	  document.getElementById('txtCombine').innerHTML = "";
	  document.getElementById('txtCombineMax').innerHTML = "";
	   return true;
	 
	}
  }	
    
}
// the function returns true; if not (that is, if the value actually contains some data), the function returns false
function isEmpty(val)
{
	if (val.match(/^s+$/) || val == "")
	{
		return true;
	}
	else
	{
		return false;
	}	
}

function change_action(val)
{
	var browser_version= parseInt(navigator.appVersion);
   	var  browser_type = navigator.appName;
	
  if(val == "register_new") 
  {
	  if(browser_type=="Microsoft Internet Explorer")
	  {
	   			document.getElementById(val).style.setAttribute('cssText', 'table-row');
				window.document.getElementById("tragree").style.setAttribute('cssText', 'table-row');
				window.document.getElementById("trRegister").style.setAttribute('cssText', 'table-row');
				//window.document.getElementById(val).style.display = "block";
				window.document.getElementById("signed_in").style.setAttribute('display', 'none');
				window.document.getElementById("trSignedin").style.setAttribute('display', 'none');

	  }
		else
			{
				document.getElementById(val).style.display='table-row';
				window.document.getElementById("tragree").style.display = "table-row";
				window.document.getElementById("trRegister").style.display = "table-row";
				//window.document.getElementById(val).style.display = "block";
				window.document.getElementById("signed_in").style.display = "none";
				window.document.getElementById("trSignedin").style.display = "none";
			}
	}
	else
	{//alert(val);
		 if(browser_type=="Microsoft Internet Explorer")
		 {
				document.getElementById(val).style.setAttribute('cssText', 'table-row');
				window.document.getElementById("trSignedin").style.setAttribute('cssText', 'table-row');
				window.document.getElementById("register_new").style.setAttribute('display', 'none');
				window.document.getElementById("trRegister").style.setAttribute('display', 'none');
				window.document.getElementById("tragree").style.setAttribute('display', 'none');
		 }
		else
		{
		
		 document.getElementById(val).style.display='table-row';	
		 window.document.getElementById("trSignedin").style.display = 'table-row';	
		 window.document.getElementById("register_new").style.display = "none";
		 window.document.getElementById("tragree").style.display = "none";
		  window.document.getElementById("trRegister").style.display = "none";
		}
		
	}

}

function editSubValidate()
{ 
	 var flg, flg1;
	 flg = true;
	 
	if (document.getElementById("txtFee_1_21").value=="")
	{
		//document.getElementById("txtFee").innerHTML="Subscription fee must be numeric";
		//return false;
		return true;
	}
	else
	{
		if(!IsNumeric(document.getElementById("txtFee_1_21").value))
		{
			document.getElementById("txtFee").innerHTML="Subscription fee must be numeric";
			return false;
		}
		else
		{
			document.getElementById("txtFee").innerHTML="";
			return true;
		}
	}			
	

}

function confirmation(url) 
{
	var answer = confirm("Are you sure you want to terminate the subscription?");
	
	if (answer){
		window.parent.document.location=url;//"links.php?act=trackdelete&id=<? echo $row['id']; ?>";
	}

}

function divAddr(val) 
{
	var  browser_type = navigator.appName;
	
	if(browser_type=="Microsoft Internet Explorer")
	{
		if(val==0)
		{
			 
			window.document.getElementById("Divnewaddress").style.setAttribute('display', 'none');
			
		}
		else
		{
			 
			window.document.getElementById("Divnewaddress").style.setAttribute('cssText', 'block');
		
	
		}
	}
	else
	{
		
		if(val==0)
		{
			 
			document.getElementById("Divnewaddress").style.display='none';
			
		}
		else
		{ 
			 
			document.getElementById("Divnewaddress").style.display='block';
		
	
		}
	}	 
}

// search div
function ShowHideHR(id)
{
	
	var  browser_type = navigator.appName;
	var imgId = "img"+id;

	id = "tr"+id;
	var img = document.getElementById(imgId);

	if(browser_type=="Microsoft Internet Explorer")
	{
		
		if(img.src == show_path)
		{
			img.src = hide_path;
			
			//document.getElementById(id).style.display='none';			
			window.document.getElementById(id).style.setAttribute('display', 'none');			
			
		}
		else
		{
			img.src = show_path;
			//document.getElementById(id).style.display='table-row';
		
			window.document.getElementById(id).style.setAttribute('cssText', 'table-row');
			
		}
	}
	else
	{		
	
		if(img.src == show_path)
		{
			img.src = hide_path;
			document.getElementById(id).style.display='none';
			
		}
		else
		{
			img.src = show_path;
			document.getElementById(id).style.display='table-row';
		
	
		}
	}	
}


function submit1(i,page,orderby,column_name) //pagination link
{	
	
	var formname;
	if(page=='ViewPlans')
	{
		formname="frmhp";
	}
	if(page=='PlanManagersubscrs')
	{
		formname="frmplansubscriptions";
	}
	if(page=="Subscriptions" )
	{
		formname="frmsubscriptions";
	}
	if( page=="manualorders")
	{
		formname="frmrequests";
	}
	if(page=="Subscriptionsonhold" || page=="expired" || page=="terminating"|| page=='failed' || page=="payhistory")
	{
		formname="frmHold";
	}
	if(page=="expired")
	{
		formname="frmHold";
	}
	if(page=="terminating")
	{
		formname="frmHold";
	}
	if(page=='pending_orders')
	{
		formname="frmorderpending";
	}	
	if(page=='document' || page=='orderdetails')
	{
		formname="frmorder";
	}
	if(page=='orders')
	{
		formname="frmHold";
	}
	if(page=='addAcc')
	{
		formname="frmaddacc";
	}
	if(page=='addhr')
	{
		formname="frmaddhr";
	}
	if(page=='antifraud_manager')
	{
		
		formname="frmFraud";
	}
	if(page=='show_terminate_request')
	{
		
		formname="frmtermreq";
	}
    if(page=='gateways')
	{
		
		formname="frmaddgs";
	}
	 if(page=='transactionlogs')
	{
		
		formname="frmlogs";
	}
	
	document.getElementById('p_start').value=i;
	document.getElementById('p_sort').value=orderby;
	document.getElementById('column_name').value=column_name;
	document.getElementById('start_search').value=2;
	//alert(document.getElementById('start_search').value);
	
	document.forms[formname].submit();
}

function sortclick(orderby,column,page)  //sort link
{
	var formname;
	
	if(page=="Subscriptions" )
	{
		formname="frmsubscriptions";
	}
	if( page=="manualorders")
	{
		formname="frmrequests";
	}
	if(page=="Subscriptionsonhold" || page=="expired" || page=="terminating"|| page=='failed' || page=="payhistory")
	{
		formname="frmHold";
	}
	/*if(page=="expired")
	{
		formname="frmHold";
	}
	if(page=="terminating")
	{
		formname="frmHold";
	}*/
	if(page=='document' || page=='orderdetails')
	{
		formname="frmorder";
	}
	if(page=='pending_orders')
	{
		formname="frmorderpending";
	}
	if(page=='PlanManagersubscrs')
	{
		formname="frmplansubscriptions";
	}
	if(page=='ViewPlans')
	{
		formname="frmhp";
	}
	if(page=='addAcc')
	{
		formname="frmaddacc";
	}
	if(page=='addhr')
	{
		
		formname="frmaddhr";
	}
	if(page=='antifraud_manager')
	{
		
		formname="frmFraud";
	}
	if(page=='show_terminate_request')
	{
		
		formname="frmtermreq";
	}
	if(page=='gateways')
	{
		
		formname="frmaddgs";
	}
	if(page=='selmethod')
	{
		
		formname="frmpro";
	}
	 if(page=='transactionlogs')
	{
		
		formname="frmlogs";
	}
	 if(page=='orders')
	{
		formname="frmHold";
	}
   /* if(page=='failed')
	{
		
		formname="frmtermreq";
	}*/
	 
	document.getElementById('orderby').value=orderby;
	document.getElementById('column_name').value=column;
 
	//document.forms[formname].submit();
	document.getElementById(formname).submit();
}

//


function CheckAll(chk)
{
	
	if(document.frmvm.chkAll.checked==true){
	for (i = 0; i < chk.length; i++)
	chk[i].checked = true ;
	}else{
	
	for (i = 0; i < chk.length; i++)
	chk[i].checked = false ;
	}
}

function chkSentSelected() {
    var flag = true;
	if((document.getElementById('txtsubject_1').value == "") )
	{
	   document.getElementById('errMsg').innerHTML = "Please enter subject";
	   window.scroll(0,100);
	   return false;
	}
	else
	{
		document.getElementById('errMsg').innerHTML = "";
	}   
	 
	
	if((document.getElementById('frmscr').rdoption[0].checked == false) && (document.getElementById('frmscr').rdoption[1].checked == false))
	{
	   document.getElementById('errMsg').innerHTML = "Please select all clients or selected clients option";
	    window.scroll(0,100);
	   return false;
	}   
	else
	{
	   if(document.getElementById('frmscr').rdoption[1].checked == true)
	   {
	   	 var cselect;
		 cselect = document.getElementById('cmbserver'); 
		 if(cselect.length>0)
		 {
		 	 chkSelectAll('cmbserver');
		 	 document.getElementById('errMsg').innerHTML = ""; 	
	   		 return true;  
		 }
		 else
		 {
	   	 document.getElementById('errMsg').innerHTML = "Please add selected clients";
		  window.scroll(0,100);
	   	 return false;
		 }
	   }
	   else
	   {
	   document.getElementById('errMsg').innerHTML = ""; 	
	   return true;   
	   }
	}   
}



function change_rdo_action(val)
{
	var browser_version= parseInt(navigator.appVersion);
   	var  browser_type = navigator.appName;
	
  if(val == "register_new") 
  {
	  if(browser_type=="Microsoft Internet Explorer")
	  {
	   			document.getElementById(val).style.setAttribute('cssText', 'table-row');
				//window.document.getElementById("tragree").style.setAttribute('cssText', 'table-row');
				//window.document.getElementById("trRegister").style.setAttribute('cssText', 'table-row');
				 
				window.document.getElementById("signed_in").style.setAttribute('display', 'none');
				//window.document.getElementById("trSignedin").style.setAttribute('display', 'none');

	  }
		else
			{
				document.getElementById(val).style.display='table-row';
				//window.document.getElementById("tragree").style.display = "table-row";
				//window.document.getElementById("trRegister").style.display = "table-row";
				
				window.document.getElementById("signed_in").style.display = "none";
				//window.document.getElementById("trSignedin").style.display = "none";
			}
	}
	else
	{//alert(val);
		 if(browser_type=="Microsoft Internet Explorer")
		 {
				document.getElementById(val).style.setAttribute('cssText', 'table-row');
				//window.document.getElementById("trSignedin").style.setAttribute('cssText', 'table-row');
				window.document.getElementById("register_new").style.setAttribute('display', 'none');
				//window.document.getElementById("trRegister").style.setAttribute('display', 'none');
				//window.document.getElementById("tragree").style.setAttribute('display', 'none');
		 }
		else
		{
		
		 document.getElementById(val).style.display='table-row';	
		 //window.document.getElementById("trSignedin").style.display = 'table-row';	
		 window.document.getElementById("register_new").style.display = "none";
		 //window.document.getElementById("tragree").style.display = "none";
		 //window.document.getElementById("trRegister").style.display = "none";
		}
		
	}

}


function uncheckall()
{
	document.getElementById("chkostempall32").checked = false;
	document.getElementById("chkostempall64").checked = false;
	//document.getElementById("chkostempall").checked = false;	
	
}

function un_checkall(frm, chkid)
{ 
		for (i = 0; i < frm.length; i++) { 
			if(frm[i].name == chkid)
				frm[i].checked = false ;
		}
	
}

function showOrderButton() {  
	selbox = document.getElementById('cmbtemplate');
	 
	if(selbox.value != '') {
		 
		document.getElementById('ordernow').style.display = 'block';	
	}	
	else {
		document.getElementById('ordernow').style.display = 'none';			
	}
	 
}


function showDivAddr(val) 
{
	var  browser_type = navigator.appName;
	
	if(browser_type=="Microsoft Internet Explorer")
	{
		if(val==0)
		{
			 
			window.document.getElementById("addr1").style.setAttribute('display', 'none');
			
		}
		else
		{
			 
			window.document.getElementById("addr1").style.setAttribute('cssText', 'block');
		
	
		}
	}
	else
	{
		
		if(val==0)
		{
			 
			document.getElementById("addr1").style.display='none';
			
		}
		else
		{ 
			 
			document.getElementById("addr1").style.display='block';
		
	
		}
	}	 
}

/*Check for a special character'***/
function isSpclChar(){  
var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";
        for (var i = 0; i < document.frmsearch.txtsearch.value.length; i++) {
                if (iChars.indexOf(document.frmsearch.txtsearch.value.charAt(i)) != -1) {
					document.getElementById('searcherror').innerHTML = "Special characters are not allowed.";
                	//alert ("The box has special characters. \nThese are not allowed.\n");
                	return false;
        		}
       } 
} 