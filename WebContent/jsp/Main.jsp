<html>
<title>Remote Client</title>
<head>
	<script type="text/javascript" src="/lib/jquery-1.11.0.min.js"></script>	
	<script type="text/javascript" src="/lib/handlebars.js"></script>	
	<script type="text/javascript" src="/lib/RingCentral/ringcentral-bundle.js"></script>
	<script type="text/javascript" src="/lib/RingCentral/ringcentral-helpers.js"></script>
	<script type="text/javascript" src="/lib/RingCentral/sip-0.7.5.min.js"></script>
	<script type="text/javascript" src="/lib/RingCentral/ringcentral-web-phone.js"></script>


	<script type="text/javascript" src="https://github.com/ZohoDevelopers/embeddedApp-js-sdk/releases/download/0.2/ZohoEmbededAppSDK.min.js"></script>
	<script type="text/javascript" src="/js/handler.js"></script>
	<script type="text/javascript" src="/js/rc.js"></script>
	

	<!-- SDK as per widget Configuration -->


	
	<script type="text/javascript">
		$(document).ready(function()
		{
			/*
			 * initialize widget with config data
			 */
			ZOHO.embededApp.init({
				events:{
					TelephonyInit:Handler.widgetInit,
					TelephonyCall:Handler.initiateCall,
					EntityPageLoad:Handler.entityPageLoad
				},
			});
			
			$("#widgetsDiv").on("click", ".toggle-icons", function() {
				var ele = $(this);
				if(ele.hasClass("blueTxt"))
				{
					ele.removeClass("blueTxt")	
				}
				else
				{
					ele.addClass("blueTxt")
				}
			});
			
			Handler.widgetInit();
		});
	
	
	</script>
</head>

<link rel="stylesheet"  type="text/css" href="/css/style.css" />
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>

<body class="loadingDiv">
<div>
	<div id="loadingDiv" style="display:none">
		<div class="loadingBG">&nbsp;</div>
		<div class="loadingText">Loading...</div>
	</div>
	<div class="successMsg" style="display:none"></div>
	<div id="widgetsDiv" class="commonDiv">
	</div>
</div>
<script id='LoginWait' type='text/x-handlebars-template'>
	<div class="incomeHead">
		<p class="callTxtTtl" style="">Log In</p>
		<a class="hideWdgt" href="javascript:;" onclick="Handler.minimizePane()">-</a>		
	</div>
      <div class="p20">
		<h4 class="mT30 logginTxt" align="center">Logging you in..</h4>
		<h4 class="mT30" align="center"><img class="mT30" src="/img/loading.gif"></h4>		
	</div>
</script>
<script id='CallInProgress' type='text/x-handlebars-template'>
	<div class="incomeHead">
		<p class="callTxtTtl" style="">Call</p>
		<a class="hideWdgt" href="javascript:;" onclick="Handler.minimizePane()">-</a>		
	</div>
      <div class="callerInfo">
		<div class="topInfocaller">
			<img class="callInprogImg fL" src ="/img/caller.jpg"/>
				<h3 class="callerName">{{#if Name}}{{Name}}{{else}}unknown...{{/if}}
				</h3>
				<h3 class="callerNo">{{Number}}</h3>
			<div class="clear"></div>
        	<div class="timeText" id="callTimer">09:35</div>
		</div>
        <table align="center" class="callActions" border="0">
          <tr>
            <td class="whiteTxt pointer">
                <div class="callerOpt"><i class="ringIcon toggle-icons volumeOff" onclick="Handler.MuteUnmute(this)" data-action="mute"></i></div>
				<p class="callerOptTxt">Park</p>              
            </td>
            <td class="whiteTxt pointer">
	             <div class="callerOpt"> <i class="ringIcon flip" onclick="Handler.VolUp()"></i></div>
					<p class="callerOptTxt">Flip</p>              
            </td>
            <td class="whiteTxt pointer">
	              <div class="callerOpt"><i class="ringIcon transfer" onclick="Handler.VolDown()"></i></div>
					<p class="callerOptTxt">Transfer</p>                         
            </td>

          </tr>
          <tr>
            <td class="whiteTxt pointer">
    	          <div class="callerOpt"><i class="ringIcon messageAdd" onclick="Handler.Hold()"></i></div>
					<p class="callerOptTxt">Add</p>              
            </td>
            <td class="whiteTxt pointer">
	              <div class="callerOpt"><i class="ringIcon record" onclick="Handler.HoldUnhold(this)" data-action="hold"></i></div>
					<p class="callerOptTxt">Record</p>              
            </td>
            <td class="whiteTxt pointer">
              	<div class="callerOpt"><i class="ringIcon notes" onclick="Handler.StartStopRecord(this)" data-action="start"></i></div>
				<p class="callerOptTxt">Notes</p>              
            </td>
          </tr>
          <tr>
            <td class="whiteTxt pointer"></td>
            <td class="pR">
	              <input type="button" class="callredBtn" value="End" onclick="Handler.Hangup('{{dataID}}')" />
            </td>
            <td class="whiteTxt pointer"></td>
          </tr>
        </table>
      </div>
</script>

<script id='IncomingCall' type='text/x-handlebars-template'>
	<div class="incomeHead">
		<p class="incomTxtTtl">Incoming call to +1 044 6744 7070</p>
		<a class="hideWdgt" href="javascript:;" onclick="Handler.minimizePane()">-</a>		
	</div>
	<div class="callerInfo">
        <img class="callerImg" src ="/img/caller.jpg"/>
        <div>
          <h2 class="callerName">
            {{#if Name}} 
                {{Name}} 
            {{else}}
             unknown...
            {{/if}}
          </h2>
        </div>
        <div><h3 class="phNumber">{{Number}}</h3></div>
	<h3 class="recentTtle">Recent activities</h3>
	<ul class="listOptions">
		<li><i class="ringIcon follFigIco" /> <span>Follow up about deal figure</span></li>
		<li><i class="ringIcon approveIco" /> <span>Get approval on figures</span></li>
		<li><i class="ringIcon callingIco" /> <span>Called Jeff Moss</span></li>
	</ul>
        <div class="responseBtn">
	        <input class="actionTxt fL" style="width: 138px;" type="button" value="Dismiss" onclick="Handler.Hangup()"/>
            <input class="actionTxt grnBtn fR" style="width: 138px; margin:0px;" type="button" value="Answer" onclick="Handler.AnswerCall()"/>
        </div>
	</div>
</div>
</script>
<script id='Dialer' type='text/x-handlebars-template'>
	<div id="wrapper">
          <div class="dialpad compact">
			<a class="hideWdgt" href="javascript:;" onclick="Handler.minimizePane()">-</a>
              <div class="call-info">
                    <input class="number" id="dialNumber" value="{{Number}}"></input>
              </div>
              <div class="dials">
                  <ol>
                      <li class="digits" onclick="Handler.enterNumber(this)"><p><label>1</label></p></li>
                      <li class="digits centerWdgt" onclick="Handler.enterNumber(this)"><label>2</label><p>abc</p></li>
                      <li class="digits" onclick="Handler.enterNumber(this)"><label>3</label><p>def</p></li>
                      <li class="digits" onclick="Handler.enterNumber(this)"><label>4</label><p>ghi</p></li>
                      <li class="digits centerWdgt" onclick="Handler.enterNumber(this)"><label>5</label><p>jkl</p></li>
                      <li class="digits" onclick="Handler.enterNumber(this)"><label>6</label><p>mno</p></li>
                      <li class="digits" onclick="Handler.enterNumber(this)"><label>7</label><p>pqrs</p></li>
                      <li class="digits centerWdgt" onclick="Handler.enterNumber(this)"><label>8</label><p>tuv</p></li>
                      <li class="digits" onclick="Handler.enterNumber(this)"><label>9</label><p>wxyz</p></li>
                      <li class="digits" onclick="Handler.enterNumber(this)"><label class="starLabel">*</label></li>
                      <li class="digits centerWdgt" onclick="Handler.enterNumber(this)"><label>0</label><p>+</p></li>
                      <li class="digits" onclick="Handler.enterNumber(this)"><label class="hashLabel">#</label></li>
                      <li class="fL" onclick="Handler.enterNumber(this)"><p class="btnAlign"><strong class="actionTxt"><label style="font-size: 16px;">Clear</lable></strong></p></li>
					  <li class="fL pad-action" onclick="Handler.DialNumber()"><p class="btnAlign"><strong class="actionTxt grnBtn"><label style="font-size: 16px;">Call</lable></strong></p></li>
                      <li class="fL" onclick="Handler.enterNumber(this)"><p class="btnAlign"><strong class="actionTxt"><label style="font-size: 16px;">Delete</lable></strong></p></li>                      
                  </ol>
              </div>
          </div>
      </div>
</script>
<script id='FeedBack' type='text/x-handlebars-template'>
	<div class="incomeHead">
		<p class="callTxtTtl" style="">Call</p>
		<a class="hideWdgt" href="javascript:;" onclick="Handler.minimizePane()">-</a>		
	</div>
      <div class="callerInfo">
		<div class="topInfocaller">
			<img class="callInprogImg fL"" src ="/img/caller.jpg"/>
        	<div class="fL">
				<h3 class="callerName">
            	{{#if Name}} 
                	{{Name}} 
            	{{else}}
             		unknown...
            	{{/if}}
				</h3>
				<h3 class="callerNo">{{Number}}</h3>
			</div>
			<div class="clear"></div>
        	<div class="timeText" id="callTimer">09:35</div>
		</div>  
		<div class="pR mT30"><i class="fl ringIcon entExt" /> <input type="textbox" name="extension" placeholder="Enter Extension" class="fL extInputBox"/></div>
  		<div><textarea id="calleeFeedBack" placeholder="Enter Notes"></textarea></div>
  		<div><input type="button" value="submit" onclick="Handler.saveNotes('{{dataID}}')" class="callredBtn pR" /></div>

</div>
</div>
</script>
<script id='callLog' type='text/x-handlebars-template'>
	<div class="incomeHead">
		<p class="callTxtTtl" style="">Log Call</p>
		<a class="hideWdgt" href="javascript:;" onclick="Handler.minimizePane()">-</a>		
	</div>
      <div class="p20">
		<h4 class="callLogName mT10">Jeff Moss</h4>
		<div class="pR "><input type="textbox" name="extension" placeholder="Sumbject" class="fL subjectInputBox"/></div>
  		<div><textarea id="calleeFeedBack" placeholder="Comments" style="height: 200px;"></textarea></div>
  		<div align="center" class="mT30"><input type="button" value="Save" class="callBluebtn pR" /> <input type="button" value="Cancel" class="actionTxt" /></div>
	</div>
</div>
</script>
<script id='login' type='text/x-handlebars-template'>
<form>
	<div class="incomeHead">
		<p class="callTxtTtl" style="">Log In</p>
		<a class="hideWdgt" href="javascript:;" onclick="Handler.minimizePane()">-</a>		
	</div>
      <div class="p20">
		<h4 class="mT30"><img src="/img/ringcentral.png"></h4>
		<div class="pR "><input type="textbox" id="rcLogin" name="rcLogin" placeholder="Login" class="fL inputBox"/></div>
		<div class="pR "><input type="password"id="rcPassword" name="rcPassword" placeholder="Password" class="fL inputBox"/></div>
		<div class="pR "><input type="textbox" id="rcExtension" name="rcExtension" placeholder="Extension" class="fL inputBox"/></div>
		<div class="clear"></div>  		
  		<div align="center" class="mT10"><input type="button" value="Login" class="callBluebtn pR w100per" onclick="Handler.initiateLogin()"/></div>
	</div>
</div>
</form>
</script>
</body>
</html>
