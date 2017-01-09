var Handler={
		session:undefined,
		Data:undefined,
}
Handler.entityPageLoad = function()
{
	ZOHO.CRM.API.getPageInfo()
    .then(function(data)
    {
        console.log(data);
    });
}
Handler.widgetInit = function(data){
/*
 * Show loginPage here
 */
	if(RC.loggin)
	{
		Handler.showDialer();
	}
	else	
	{
		Handler.RenderTemplate("login");
	}
}
Handler.maximizePane = function(){
	ZOHO.CRM.UI.telephony.maximize()
}
Handler.minimizePane  = function(){
	ZOHO.CRM.UI.telephony.minimize()
}
Handler.RenderTemplate=function(templateId , data){
	var template = $("#"+templateId).html();
	var compiledTemplate = Handlebars.compile(template);
	var widgetsDiv =$("#widgetsDiv");
	widgetsDiv.html(compiledTemplate(data));
};
Handler.rcLogginSuccess = function(){
	Handler.showDialer();
	Handler.hideLoading();
};
Handler.rcIncomingCall= function(session){
	Handler.session = session;
	Handler.maximizePane();
	Handler.RenderTemplate("IncomingCall",Handler.getcallerInfo(Handler.session));	
};
Handler.showDialer = function(){
	Handler.RenderTemplate("Dialer");
};
Handler.enterNumber = function(ele){

	var number = $(ele).find("label").text();
	var inputBox = $("#dialNumber");
	if("Clear" === number){
		inputBox.val('');
	}
	else if ("Delete" === number){
		inputBox.val(inputBox.val().slice(0,-1))
	}
	else{
		inputBox.val(inputBox.val()+number);
	}
};
Handler.initiateCall = function(data){
	console.dir(data);
	Handler.Data = data
	Handler.DialNumber(data.Number);
}
Handler.DialNumber = function(number){
	if(!number)
	{
		number = $("#dialNumber").val();
	}
	number = number+"";
	if(number.length > 0)
	{
		RC.makeCall(number);
		if(Handler.Data)
		{
			
			ZOHO.CRM.API.getRecord({
				Entity : Handler.Data.EntityType,
				RecordID : Handler.Data.EntityID
			})
			.then(function(data)
			{
				var name = data[0].Full_Name;
				Handler.RenderTemplate("CallInProgress",{Name:name,Number:number});
			});
		}
		else
		{
			Handler.RenderTemplate("CallInProgress",{Name:"Unknown",Number:number});
		}
	}
};
Handler.AnswerCall = function(){
	RC.answerCall(Handler.session, function(){
		Handler.RenderTemplate("CallInProgress",Handler.getcallerInfo(Handler.session));
	});
};
Handler.Hangup= function() {
	var callerInfo = Handler.getcallerInfo(Handler.session);
    Handler.session.terminate();

    if(Handler.Data)
    	{
	    	Handler.RenderTemplate("FeedBack");
    	}
    else{
    	Handler.showDialer();
    }
};
Handler.VolUp= function() {
    Handler.session.ua.audioHelper.setVolume(
        (Handler.session.ua.audioHelper.volume != null ? Handler.session.ua.audioHelper.volume : .5) + .1
    );
};
Handler.VolDown= function() {
    Handler.session.ua.audioHelper.setVolume(
        (Handler.session.ua.audioHelper.volume != null ? Handler.session.ua.audioHelper.volume : .5) - .1
    );
};
Handler.MuteUnmute = function(ele)
{
	ele = $(ele);
	var action = ele.attr("data-action");
	if(action === "mute"){
		ele.attr("data-action","unmute");
		Handler.session.mute();
	}
	else if (action === "unmute")
	{
		ele.attr("data-action","mute");
		Handler.session.unmute();
	}
	
}
Handler.StartStopRecord = function(ele)
{
	ele = $(ele);
	var action = ele.attr("data-action");
	if(action === "start"){
		ele.attr("data-action","stop");
		Handler.session.startRecord().then(function() {
		});
	}
	else if (action === "stop")
	{
		ele.attr("data-action","start");
		Handler.session.stopRecord().then(function() {
		});
	}
	
}
Handler.HoldUnhold = function(ele)
{

	ele = $(ele);
	var action = ele.attr("data-action");
	if(action === "hold"){
		ele.attr("data-action","unhold");
	    Handler.session.hold().then(function() {
	    });
	}
	else if (action === "unhold")
	{
		ele.attr("data-action","hold");
	    Handler.session.unhold().then(function() {
	    });
	}
}

Handler.saveNotes = function()
{
	Handler.showLoading()
	var notes = $("#calleeFeedBack").val();
	ZOHO.CRM.API.addNotes({
		Entity : Handler.Data.EntityType,
		RecordID : Handler.Data.EntityID,
		Title : "Status of Call on "+ (new Date()).toLocaleString(),
		Content : notes
	})
	.then(function(data)
	{
		Handler.hideLoading();
		Handler.showDialer();
		Handler.Data = undefined;
	});
}

/*
 * util methods
 */
Handler.getcallerInfo = function(session)
{
	var callerInfo = {
			Name:session.request.from.displayName,
			Number:"unknown",
	};
	return callerInfo;
}
Handler.showLoading = function(){
	$("#loadingDiv").show();
}
Handler.hideLoading = function(){
	$("#loadingDiv").hide();
}
Handler.successMsg = function(message){
	$('.successMsg').text(message);
	 $('.successMsg').slideDown(function() {
			$('.successMsg').delay(3000).slideUp();
			});
}
Handler.initiateLogin = function(event){
	var login = $("#rcLogin").val();
	var pass = $("#rcPassword").val();
	var ext = $("#rcExtension").val();
	RC.login(RC.config.Server, RC.config.AppKey, RC.config.AppSecret, login,ext, pass,RC.config.LogLevel); //no i18n
	Handler.RenderTemplate("LoginWait");
}