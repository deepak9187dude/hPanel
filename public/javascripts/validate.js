function explodeArray(items,delimiter)
{ 

	tempArray=new Array(1); 
	var Count=0; 
	var tempstring=items; 
	while (tempstring.indexOf(delimiter)>0) { 
	tempArray[Count]=tempstring.substr(0,tempstring.indexOf(delimiter)); 
	tempstring=tempstring.substr(tempstring.indexOf(delimiter)+1,tempstring.length-tempstring.indexOf(delimiter)+1); 
	Count=Count+1 
	} 
	
	tempArray[Count]=tempstring;
	return tempArray; 
} 


function validateForms(frm)
	{
	   	var flagerr1=0;
		
		//if (!document.getElementById) return false;
		elementForms = document.getElementById(frm);		

		for (var intCounter = 0; intCounter < elementForms.length; intCounter++)
		 
		{
							
			var type=elementForms[intCounter].type;
			//alert(elementForms[intCounter].id);

			if(validateForm(elementForms[intCounter].id,type))
			{
			//	flagerr1=0;	
			}
			else
			{
				flagerr1=1;	
			}
		}
		//alert("fl".flagerr1);
		//alert("Top Flag="+flagerr1);
		if(flagerr1==1)
		{
			return false;	 	
		}
		else
		{
			return true;			
		}
		//return true;			
 }

 function validateForm(id1,type)
 {
 	arr = explodeArray(id1,'_');
	var flagerr=0;
	//alert('type'+type);
	   if(type=="select-one")
		{			
			if(arr.length!=0)
			{
				var i=0;
				for(i=0;i<arr.length;i++)
				{
				
					if(arr.length!=0)
						{
							if(arr[i]==1) // FOR BLANK
							{
								if(document.getElementById(id1).value==0)
								{
									document.getElementById(arr[0]).innerHTML="Select option";
									flagerr=1;
								}
								else
								{
									document.getElementById(arr[0]).innerHTML="";
								}
							}
						}
				} //for end
			} //if end
		}//if end
	
		if(type=="text" || type=="textarea" || type=="password" || type=="hidden")
		{
			if(arr.length!=0)
			{
				var i=0;
				for(i=0;i<arr.length;i++)
				{
					//alert(document.getElementById(id1).name+":::"+document.getElementById(id1).value);
					//alert(arr[i]);
					//myRegExp=/35/;
					var matchPos1 = arr[i].search('35');
					
					var matchPos36 = arr[i].search('36');
					
					if (i!=0)
						{
							
							if(arr[i]==1) // FOR BLANK
							{
								
							    if(LTrim(document.getElementById(id1).value)=="")
								{	
									
									document.getElementById(arr[0]).innerHTML="Should not be blank";
									flagerr=1;
									
								}
								else
								{
									document.getElementById(arr[0]).innerHTML="";	
								}
								
								
							 }
						
							if(arr[i]==2 && flagerr!=1) // EMAIL VALIDATION
							{
								
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!checkEmail(document.getElementById(id1).value))
										{
											document.getElementById(arr[0]).innerHTML="Invalid Email Address";
											flagerr=1;
										}
										else
										{
											document.getElementById(arr[0]).innerHTML="";
										}
								}
								
							}
						
							if(arr[i]==3 && flagerr!=1) // ALPHABETIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!isAlphabetic(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Only Alphabetic characters are allowed";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							if(arr[i]==19 && flagerr!=1) // ALPHABETIC VALIDATION WITH SPACE
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!isAlphabeticWithSpace(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Only Alphabetic characters are allowed";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							if(arr[i]==4 && flagerr!=1) // NUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!IsNumeric(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Only numbers are allowed";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							
							//
							if(arr[i]==20 && flagerr!=1) // NUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!IsNumeric(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Setup fee must be numeric";
										flagerr=1;
									}
									else
									{
										//if(document.getElementById(id1).value<0)
										if(!isNegative(document.getElementById(id1).value))
										{
											document.getElementById(arr[0]).innerHTML="Invalid Setup fee";
											flagerr=1;
										}
										else
											document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							
							if(arr[i]==21 && flagerr!=1) // NUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!IsNumeric(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Recurring fee must be numeric";
										flagerr=1;
									}
									else
									{
										//if(document.getElementById(id1).value<0)
										if(!isNegative(document.getElementById(id1).value))
										{
											document.getElementById(arr[0]).innerHTML="Invalid Recurring fee";
											flagerr=1;
										}										
										else
											document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							
							if(arr[i]==22 && flagerr!=1) // NUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!IsNumeric(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Included value must be numeric";
										flagerr=1;
									}
									else
									{
										//if(document.getElementById(id1).value<0)
										//alert(isNegative(document.getElementById(id1).value));
										if(!isNegative(document.getElementById(id1).value))
										{
											document.getElementById(arr[0]).innerHTML="Invalid Included value";
											flagerr=1;
										}
										else
											document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							
							if(arr[i]==23 && flagerr!=1) // NUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!IsNumeric(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Maximum consumable value must be numeric";
										flagerr=1;
									}
									else
									{
										//if(document.getElementById(id1).value<0)
										if(!isNegative(document.getElementById(id1).value))
										{
											document.getElementById(arr[0]).innerHTML="Invalid Maximum consumable value";
											flagerr=1;
										}
										else
											document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							
							if(arr[i]==24 && flagerr!=1) // NUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!IsNumeric(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Cost per additional unit must be numeric";
										flagerr=1;
									}
									else
									{
										//if(document.getElementById(id1).value<0)
										if(!isNegative(document.getElementById(id1).value))
										{
											document.getElementById(arr[0]).innerHTML="Invalid Cost";
											flagerr=1;
										}
										else
											document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							
							if(arr[i]==25 && flagerr!=1) // NUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!IsNumeric(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Upgrade block must be numeric";
										flagerr=1;
									}
									else
									{
										//if(document.getElementById(id1).value<0)
										if(!isNegative(document.getElementById(id1).value))
										{
											document.getElementById(arr[0]).innerHTML="Invalid Upgrade block";
											flagerr=1;
										}
										else
											document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							//
							if(arr[i]==28 && flagerr!=1) // NUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!IsNumeric(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Grace period must be numeric";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							
							if(arr[i]==29 && flagerr!=1) // NUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!IsNumeric(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Expiration period must be numeric";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							
							if(arr[i]==30 && flagerr!=1) // NUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!IsNumeric(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Termination period must be numeric";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							//
							if(arr[i]==99 && flagerr!=1) // NUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									 
									if(validateInteger(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="";
										 
									}
									else
									{
										document.getElementById(arr[0]).innerHTML= "Enter a value greater than 0";//"value must be integer";
										flagerr=1;
										 
									}
								}
								
							}
							//
							if(arr[i]==5 && flagerr!=1) // ALPHANUMERIC VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!isAlphaNumeric(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Only Alphanumeric characters are allowed";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							if(arr[i]==6 && flagerr!=1) // ZIPCODE VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!isValidZipCode(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Invalid Postcode";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							if(arr[i]==7 && flagerr!=1) // PHONENUMBER VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!isValidPhone(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Invalid Phone No";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							if(arr[i]==8 && flagerr!=1) // MAX 6 CHARACTERS VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!atleastSixChar(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="More than 5 chars required";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							
							if(arr[i]==9 && flagerr!=1) // URL VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!checkUrl(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Invalid url";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								
							}
							
							if(arr[i]==10 && flagerr!=1) // SPECIAL CHARS VALIDATION
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!isSpecialChars(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Special chars/white spaces are not allowed";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
							
							}
							if(arr[i]==11 && flagerr!=1) //VALIDATION FOR MOBILE NO
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!isValidMobile(document.getElementById(id1).value))
									{
										document.getElementById(arr[0]).innerHTML="Invalid Mobile No.";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
							
							}
							if(arr[i]==12 && flagerr!=1) 
							{
								if (document.getElementById(id1).value=="")
								{
									
								}
								else
								{
									if(!isSpecialCharsb(LTrim(document.getElementById(id1).value)))
									{
										document.getElementById(arr[0]).innerHTML="Special characters are not allowed";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
							
							}
							if(arr[i]==13 && flagerr!=1) // URL VALIDATION FOR dyanamic textboxes
							{
								if(!checkUrl(document.getElementById(id1).value))
								{
									document.getElementById(arr[0]).innerHTML="Invalid url";
									flagerr=1;
								}
								else
								{
									document.getElementById(arr[0]).innerHTML="";
								}
							}
							
							if(arr[i]==14 && flagerr!=1) // MULTIPLE EMAIL VALIDATION
							{																	
								if (document.getElementById(id1).value != "")
								{										
									email_str = document.getElementById(id1).value;
									email_arr = explodeArray(email_str,',');	
									
									for(j=0; j<email_arr.length; j++)
									{
										email_id = trim(email_arr[j]);
										if(email_id!="")
										{
											if(!checkEmail(email_id))
												flagerr=1;
										}
									} 
									if(flagerr==1)
										document.getElementById(arr[0]).innerHTML="Invalid Email Address";
									else	
										document.getElementById(arr[0]).innerHTML="";

								}
								
							}  //end of case 14
							
							if(arr[i]==15 && flagerr!=1) // No numbers are allowed
							{
								if(!isNumberChars(document.getElementById(id1).value))
								{
									document.getElementById(arr[0]).innerHTML="Numbers are not allowed";
									flagerr=1;
								}
								else
								{
									document.getElementById(arr[0]).innerHTML="";
								}
							} ////if(arr[i]==13 && flagerr!=1)
							if(arr[i]==16 && flagerr!=1) // No numbers are allowed
							{
								//alert('in 16');
								//alert(document.getElementById(id1).value);
								//if(document.getElementById(id1).value == 0.00)
								//if((document.getElementById(id1).value == 0.00)||(document.getElementById(id1).value < 0))
								if(parseInt(document.getElementById(id1).value) <=0)
								{
									document.getElementById(arr[0]).innerHTML="Please enter valid amount";
									flagerr=1;
								}
								else
								{
									document.getElementById(arr[0]).innerHTML="";
								}
							} ////if(arr[i]==13 && flagerr!=1)
							if(arr[i]==17 && flagerr!=1) // No numbers are allowed
							{
								
								if(parseInt(document.getElementById(id1).value) < 0)
								{
									document.getElementById(arr[0]).innerHTML="Please enter valid amount";
									flagerr=1;
								}
								else
								{
									document.getElementById(arr[0]).innerHTML="";
								}
							} ////if(arr[i]==13 && flagerr!=1)
							
							//new validation for <0>1000
							if(arr[i]==18 && flagerr!=1) // No numbers are allowed
							{
								
								if((document.getElementById(id1).value <= 0) || (document.getElementById(id1).value >1000))
								{
									document.getElementById(arr[0]).innerHTML="Input should be between 1-1000";
									flagerr=1;
								}
								else
								{
									document.getElementById(arr[0]).innerHTML="";
								}
							} ////if(arr[i]==13 && flagerr!=1)
							//new validation for <0>1000 ends here
							//if(arr[i]==35) // limit
							if(matchPos1 != -1 && flagerr!=1)
							{
								//alert("There was a match at position " + matchPos1); 
								//alert (arr[i]);
								//alert(document.getElementById(id1).value);
								//alert('kkk');
								//var maxmin=document.getElementById(id1).value
								//alert ("limit  ->"+maxmin);
								marr = explodeArray(arr[i],'%');
								var mlim='';
								if(marr.length!=0)
								{
									var m=1;
									for(m=1;m<marr.length;m++)
									{
										min1=marr[1];
										max2=marr[2];
									}
								}
								//alert(min1);
							//	alert(document.getElementById(id1).value);
								if(document.getElementById(id1).value!='')
								{
									//alert('if');
									if(!countChars(document.getElementById(id1),min1,max2))
									{
										document.getElementById(arr[0]).innerHTML="Allowed character length is "+min1+" to "+max2;
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								else
								{
										//alert('else');
										document.getElementById(arr[0]).innerHTML="";
								}
							} ////if(arr[i]==16 && flagerr!=1)
							
							if(matchPos36 != -1 && flagerr!=1)
							{
								//alert("There was a match at position " + matchPos1); 
								//alert (arr[i]);
								//alert(document.getElementById(id1).value);
								//alert('kkk');
								//var maxmin=document.getElementById(id1).value
								//alert ("limit  ->"+maxmin);
								marr = explodeArray(arr[i],'%');
								var mlim='';
								if(marr.length!=0)
								{
									var m=1;
									for(m=1;m<marr.length;m++)
									{
										min1=marr[1];
										max2=marr[2];
									}
								}
								//alert(min1);
							//	alert(document.getElementById(id1).value);
								if(document.getElementById(id1).value!='')
								{
									//alert('if');
									if(!countChars(document.getElementById(id1),min1,max2))
									{
										document.getElementById(arr[0]).innerHTML="Minimum 6 characters allowed ";
										flagerr=1;
									}
									else
									{
										document.getElementById(arr[0]).innerHTML="";
									}
								}
								else
								{
										//alert('else');
										document.getElementById(arr[0]).innerHTML="";
								}
							}
															
						}
					
				}	
			}
		}
	   //alert("Inner Flag="+flagerr);
		if(flagerr==1)
		{
			return false;	
		}
		else
		{
			return true;	
		}
		//return true;
	
	
 }
 
 
function IsEmpty(aTextField)
{
   if ((aTextField.value.length==0) || (aTextField.value==null))
   {
      return true;
   }
   else 
   {
   	  return false;
   }
}	

// check to see if input is numeric
function IsNumeric(val) 
{
   if(isNaN(val))
   {
   		return false;
   }
   else
   {  
   		return true;
   }
}

// check to see if input is alphabetic
function isAlphabetic(val)
{
	if (val.match(/^[a-zA-Z ]+$/))
	{
		return true;
	}
	else
	{
		return false;
	} 
}

// check to see if input is alphabetic
function isAlphabeticWithSpace(val)
{
	if (val.match(/^[a-zA-Z ]+$/))
	{
		return true;
	}
	else
	{
		return false;
	} 
}

// check to see if input is alphanumeric
function isAlphaNumeric(val)
{
	if (val.match(/^[a-zA-Z0-9]+$/))
	{
		return true;
	}
	else
	{
		return false;
	} 
}


// For phone number validation
function isValidPhone(val)
{
  var values = " 1234567890-+()";
  for (var i=0; i < val.length; i++)
    if (values.indexOf(val.charAt(i)) < 0)
       return false;
  return true;
}
function isValidMobile(val)
{
  var values = " 1234567890+-";
  for (var i=0; i < val.length; i++)
    if (values.indexOf(val.charAt(i)) < 0)
       return false;
  return true;
}
// For Zip code validation
function isValidZipCode(val) {
   if(val.length < 4) {
   	return false;
   }
   else {
   	return true;
   }
}

// For max character validation
function maxCharacter(val,maxlen) {
   if(isNaN(val) || val.length	!= maxlen) {
   	return false;
   }
   else {
   	return true;
   }
}

// For at least 6 characters 
function atleastSixChar(val) {
   if(val.length < 6) {
   	return false;
   }
   else {
   	return true;
   }
}

//For email address validation
function isEmailAddress(val)
{
	if (val.match(/^([a-zA-Z0-9])+([.a-zA-Z0-9_-])*@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-]+)+/))
	{
		return true;
	}
	else
	{
		return false;
	} 
}
function checkUrl(val)
{
	 var tomatch= /^(([\w]+:)?\/\/)?(([\d\w]|%[a-fA-f\d]{2,2})+(:([\d\w]|%[a-fA-f\d]{2,2})+)?@)?([\d\w][-\d\w]{0,253}[\d\w]\.)+[\w]{2,4}(:[\d]+)?(\/([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)*(\?(&?([-+_~.\d\w]|%[a-fA-f\d]{2,2})=?)*)?(#([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)?$/; 
     if (tomatch.test(val))
     {
         return true;
     }
     else
     {
         return false; 
     }
}

function checkEmail(val)
{
	if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/.test(val)){
	return (true)
}
	//alert("Invalid E-mail Address! Please re-enter.")
	return (false)
}

function isSpecialChars(val)
{
	var iChars = " !@#$%^&*()+=-[]\\\';,./{}|\":<>?";

	var flag=1;

	for (var j = 0; j < val.length; j++)
	{
  		if (iChars.indexOf(val.charAt(j)) != -1)
		{
  			flag=0;
  		}
		else
		{
		}
	}

	if(flag==1)
	{
		return true;	
	}
	else
	{
		return false;	
	}

}

function isSpecialCharsb(val)
{
	var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";

	var flag=1;

	for (var j = 0; j < val.length; j++)
	{
  		if (iChars.indexOf(val.charAt(j)) != -1)
		{
  			flag=0;
  		}
		else
		{
		}
	}

	if(flag==1)
	{
		return true;	
	}
	else
	{
		return false;	
	}

}

function isNegative(val)
{
	var iChars = "-";

	var flag=1;

	for (var j = 0; j < val.length; j++)
	{
  		if (iChars.indexOf(val.charAt(j)) != -1)
		{
  			flag=0;
  		}
		else
		{
		}
	}

	if(flag==1)
	{
		return true;	
	}
	else
	{
		return false;	
	}

}

function isNumberChars(val)
{
	var iChars = "1,2,3,4,5,6,7,8,9,0";

	var flag=1;

	for (var j = 0; j < val.length; j++)
	{
  		if (iChars.indexOf(val.charAt(j)) != -1)
		{
  			flag=0;
  		}
		else
		{
		}
	}

	if(flag==1)
	{
		return true;	
	}
	else
	{
		return false;	
	}

}


function goto(a,b)
{
	window.location="index.php?cid=9&"+a+"="+b
}

// Removes leading whitespaces

function LTrim( value ) {
	
	var re = /\s*((\S+\s*)*)/;
	return value.replace(re, "$1");
	
}

// Removes ending whitespaces
function RTrim( value ) {
	
	var re = /((\s*\S+)*)\s*/;
	return value.replace(re, "$1");
	
}

// Removes leading and ending whitespaces
function trim( value ) {
	
	return LTrim(RTrim(value));
	
}


function CountWords (this_field, show_word_count, show_char_count, max1, type)
{
	
	//alert ('type '+type);
	//alert ('max '+max1);
	if (show_word_count == null)
	{
		show_word_count = true;
	}
	if (show_char_count == null)
	{
		show_char_count = false;
	}
	var char_count = this_field.value.length;
	
	var fullStr = this_field.value + " ";
	var initial_whitespace_rExp = /^[^A-Za-z0-9]+/gi;
	var left_trimmedStr = fullStr.replace(initial_whitespace_rExp, "");
	var non_alphanumerics_rExp = rExp = /[^A-Za-z0-9]+/gi;
	var cleanedStr = left_trimmedStr.replace(non_alphanumerics_rExp, " ");
	var splitString = cleanedStr.split(" ");
	var word_count = splitString.length -1;
	
	
	if (fullStr.length <2) 
	{
		word_count = 0;
	}
	
	//if (max1==150)
	if (type=='Free')
	{
	
		if (char_count > max1)
		{
			document.getElementById('businessdescrerr').innerHTML="Maximum Limit is "+max1+" Characters";
			return false;
		}
		else
		{
				document.getElementById('businessdescrerr').innerHTML="";
				return true;
		}
	}
	else if(type=='Paid')     //else if(max1==300)
	{
		if (char_count > max1)
		{
			document.getElementById('businessdescrerr').innerHTML="Maximum Limit is "+max1+" Characters";
			return false;
		}
		else
		{
			document.getElementById('businessdescrerr').innerHTML="";
			return true;
		}
	}	
	
return true;
}

function countChars (this_field,min1,max2)
{
	//alert(min1);
	//alert(max2);
	var char_count = this_field.value.length;
	//alert(char_count);
		if (char_count < min1 || char_count > max2)
		{
			//alert('error');
			return false;
		}
		else
		{
			return true;
		}
			
}	

////////////////////Function for validating money format/////////////////
function moneyFormat1(textObj) {
   var newValue = textObj.value;
  // alert('kk'+newValue);
   var decAmount = "";
   var dolAmount = "";
   var decFlag = false;
   var aChar = "";
   
   // ignore all but digits and decimal points.
   for(i=0; i < newValue.length; i++) {
      aChar = newValue.substring(i,i+1);
      if(aChar >= "0" && aChar <= "9") {
         if(decFlag) {
            decAmount = "" + decAmount + aChar;
         }
         else {
            dolAmount = "" + dolAmount + aChar;
         }
      }
      if(aChar == ".") {
         if(decFlag) {
            dolAmount = "";
            break;
         }
         decFlag=true;
      }
   }
   
   // Ensure that at least a zero appears for the dollar amount.

   if(dolAmount == "") {
      dolAmount = "0";
   }
   // Strip leading zeros.
   if(dolAmount.length > 1) {
      while(dolAmount.length > 1 && dolAmount.substring(0,1) == "0") {
         dolAmount = dolAmount.substring(1,dolAmount.length);
      }
   }
   
   // Round the decimal amount.
   if(decAmount.length > 2) {
      if(decAmount.substring(2,3) > "4") {
         decAmount = parseInt(decAmount.substring(0,2)) + 1;
         if(decAmount < 10) {
            decAmount = "0" + decAmount;
         }
         else {
            decAmount = "" + decAmount;
         }
      }
      else {
         decAmount = decAmount.substring(0,2);
      }
      if (decAmount == 100) {
         decAmount = "00";
         dolAmount = parseInt(dolAmount) + 1;
      }
   }
   
   // Pad right side of decAmount
   if(decAmount.length == 1) {
      decAmount = decAmount + "0";
   }
   if(decAmount.length == 0) {
      decAmount = decAmount + "00";
   }
   
   // Check for negative values and reset textObj
   if(newValue.substring(0,1) != '-' ||
         (dolAmount == "0" && decAmount == "00")) {
      textObj.value = dolAmount + "." + decAmount;

   }
   else{
      textObj.value = '-' + dolAmount + "." + decAmount;
   }
}
////////////////////////////////////////////////////////////
function validate_resources()
{  
	var flg, flg1;
	flg = true;
	var emptyString = /^\s*$/ ;
	
	var id1 = 'txtRAM2';
	var id2 = 'RAM2';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Included value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Included value";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	 var id1 = 'txtRAM3';
	 var id2 = 'RAM3';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Maximum consumable value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Maximum consumable value";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	  var id1 = 'txtRAM4';
	 var id2 = 'RAM4';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Cost value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Cost";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	 var id1 = 'txtRAM5';
	 var id2 = 'RAM5';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Upgrade Block value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Upgrade Block";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	  var id1 = 'txtBurstRam';
	 var id2 = 'BurstRam';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Burst Ram value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Burst Ram";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	var id1 = 'txtDiskSpace6';
	var id2 = 'DiskSpace6';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Included value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Included value";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	 var id1 = 'txtDiskSpace7';
	 var id2 = 'DiskSpace7';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Maximum consumable value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Maximum consumable value";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	  var id1 = 'txtDiskSpace8';
	 var id2 = 'DiskSpace8';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Cost value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Cost";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	 var id1 = 'txtDiskSpace9';
	 var id2 = 'DiskSpace9';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Upgrade Block value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Upgrade Block";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	 var id1 = 'txtIPaddresses10';
	var id2 = 'IPaddresses10';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Included value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Included value";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	 var id1 = 'txtIPaddresses11';
	 var id2 = 'IPaddresses11';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Maximum consumable value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Maximum consumable value";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	  var id1 = 'txtIPaddresses12';
	 var id2 = 'IPaddresses12';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Cost value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Cost";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	 var id1 = 'txtIPaddresses13';
	 var id2 = 'IPaddresses13';
	 if(document.getElementById(id1).value == "")
	 {
		document.getElementById(id2).innerHTML = "Should not be blank";
	  
		flg = false;
		return false;
	 }
	 else
	 {
	 	 
	 	if(emptyString.test(document.getElementById(id1).value))
		 {
		 	document.getElementById(id2).innerHTML = "Should not be blank";
			flg = false;
			return false;
		 }
		 else
		 {
			
			if(!IsNumeric(document.getElementById(id1).value))
			{
				document.getElementById(id2).innerHTML="Upgrade Block value must be numeric";
				flg = false;
				return false;
			}
			else
			{
				//if(document.getElementById(id1).value<0)
				if(!isNegative(document.getElementById(id1).value))
				{
					document.getElementById(id2).innerHTML="Invalid Upgrade Block";
					flg = false;
					return false;
				}
				else
				{
					document.getElementById(id2).innerHTML="";
					flg = true;
				}	
			} 
		  }
	 }
	 
	 if(flg == true)
	   return true;
	 else 
	   return false;   
 
}

//////////
function validateInteger(val)
   {
      var o = val;
      switch (isInt(o))
      {
         case true:
            //alert(o.value + " is an integer")
			return true
            break;
         case false:
            //alert(o.value + " is not an integer")
			return false 
      }
   }

 function isInt(s)
   {
      var i;

      if (chkEmpty(s))
      if (isInt.arguments.length == 1) return 0;
      else return (isInt.arguments[1] == true);

      for (i = 0; i < s.length; i++)
      {
         var c = s.charAt(i);

         if (!chkDigit(c)) return false;
      }

      return true;
   }

   function chkEmpty(s)
   {
      return ((s == null) || (s.length == 0))
   }

   function chkDigit (c)
   {
      return ((c >= "0") && (c <= "9"))
   }
   
   //Validation for possitive number
   function numValidate(val){  
	  
	  if(val!='') {
	 	if (val.match(/^[0-9|.]+$/))
			{
				return true;
			} else {
				alert("Please enter positive number only");
			}
        }
     }
	 
	 
  

	
