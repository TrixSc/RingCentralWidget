// $Id$
RC ={
        loggin	:	false,
        extension : undefined,
    }
RC.config={
		Server:"https://platform.ringcentral.com",
		AppKey:"ZTjEDb5JQkCEtSYsNz40mg",
		AppSecret:"Vd96yrNjQoqJbPZF-UZc5QG0q4SHSbQMqjYlBzESNaPg",
		LogLevel:"0"
}
RC.login =  function(server, appKey, appSecret, login, ext, password, ll) {

        var sdk = new RingCentral.SDK({
            appKey: appKey,
            appSecret: appSecret,
            server: server
        });

        var platform = sdk.platform();

        if (login) {
            login = (login.match(/^[\+1]/)) ? login : '1' + login;
        login = login.replace(/\W/g, '')
    }

    platform.login({
            username: login,
            extension: ext || null,
            password: password
        })
        .then(function() {
            logLevel = ll;
            username = login;

            localStorage.setItem('webPhoneServer', server || ''); //no i18n
            localStorage.setItem('webPhoneAppKey', appKey || ''); //no i18n
            localStorage.setItem('webPhoneAppSecret', appSecret || ''); //no i18n
            localStorage.setItem('webPhoneLogin', login || ''); //no i18n
            localStorage.setItem('webPhoneExtension', ext || ''); //no i18n
            localStorage.setItem('webPhonePassword', password || ''); //no i18n
            localStorage.setItem('webPhoneLogLevel', logLevel || 0); //no i18n

            return platform.get('/restapi/v1.0/account/~/extension/~');

        })
        .then(function(res) {

        	RC.extension = res.json();
            return platform.post('/client-info/sip-provision', { //no i18n
                sipInfo: [{
                    transport: 'WSS' //no i18n
                }]
            });

        })
        .then(function(res) {
            return res.json();
        })
        .then(this.register)
        .catch(function(e) {
        	Handler.successMsg("Login Failed");
        	Handler.RenderTemplate("login",{Login:login,Pass:password});
        	console.log('Error in main promise chain'); //no i18n
            console.log(e.stack || e);
        });

};
RC.register =  function(data) {
    var sipInfo = data.sipInfo[0] || data.sipInfo;
    webPhone = new RingCentral.WebPhone(data, {
        appKey: localStorage.getItem('webPhoneAppKey'), //no i18n//no i18n
        audioHelper: {
            enabled: true
        },
        logLevel: parseInt(logLevel, 1)
    });

    webPhone.userAgent.audioHelper.loadAudio({
        incoming: '../audio/incoming.ogg', //no i18n
        outgoing: '../audio/outgoing.ogg' //no i18n
    })

    webPhone.userAgent.audioHelper.setVolume(.5);

    webPhone.userAgent.on('invite', function(sessionArg) //no i18n
        {
    		Handler.rcIncomingCall(sessionArg);
        });
    webPhone.userAgent.on('connecting', function() {//no i18n
        console.log('UA connecting');//no i18n
    }); 
    webPhone.userAgent.on('connected', function() //no i18n 
        {
    		RC.loggin = true;
            Handler.rcLogginSuccess();
        });
    return webPhone;
};
RC.makeCall = function(number) {
    var homeCountry = (RC.extension && RC.extension.regionalSettings && RC.extension.regionalSettings.homeCountry) ?
    		RC.extension.regionalSettings.homeCountry.id :
        null;
    var interval = setInterval(function() {
        var time = Handler.session.startTime ? (Math.round((Date.now() - Handler.session.startTime) / 1000)) : 'Connecting';
        var result = time;
        if('string' != typeof(time))
        	{
	        	var date = new Date(null);
	        	date.setSeconds(time);
	        	result = date.toISOString().substr(11, 8);
        	}
        $("#callTimer").text(result);
    }, 1000);   
    Handler.session = webPhone.userAgent.invite(number, {
        media: {
            render: {
                remote: document.getElementById('remoteVideo'),
                local: document.getElementById('localVideo')
            }
        },
        fromNumber: username,
        homeCountryId: homeCountry
        
    });
    console.dir(Handler.session);
};
RC.answerCall = function(session,CallBack) 
{
   var acceptOptions = {
           media: {
               render: {
                   remote: document.getElementById('remoteVideo'),
                   local: document.getElementById('localVideo')
                }
            }
        };
      session
      	.accept(acceptOptions).then(this.onAccepted(session,CallBack))
};
RC.onAccepted = function(session, CallBack)
{
	debugger;
    session.on('accepted', function() { 
    	CallBack();
        var interval = setInterval(function() {
            var time = session.startTime ? (Math.round((Date.now() - session.startTime) / 1000)) : 'Connecting';
            var result = time;
            if('string' != typeof(time))
            	{
    	        	var date = new Date(null);
    	        	date.setSeconds(time);
    	        	result = date.toISOString().substr(11, 8);
            	}
            $("#callTimer").text(result);
        }, 1000);    	 
    });
    session.on('progress', function() { console.log('Event: Progress'); });
    session.on('rejected', function() {
        console.log('Event: Rejected');
        close();
    });
    session.on('failed', function() {
        console.log('Event: Failed');
        close();
    });
    session.on('terminated', function() {
        console.log('Event: Terminated');
        close();
    });
    session.on('cancel', function() {
        console.log('Event: Cancel');
        close();
    });
    session.on('refer', function() {
        console.log('Event: Refer');
        close();
    });
    session.on('replaced', function(newSession) {
        console.log('Event: Replaced: old session', session, 'has been replaced with', newSession);
        close();
        RC.onAccepted(newSession);
    });
    session.on('bye', function() { close(); });   
}
RC.getExtensionInfo= function(){
	return extension;
};
RC.getCallerInfo=function(){
	return callerInfo;
};