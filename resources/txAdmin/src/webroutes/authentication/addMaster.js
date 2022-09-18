//Requires
const modulename = 'WebServer:AddMaster';
const { dir, log, logOk, logWarn, logError } = require('../../extras/console')(modulename);

//Helper functions
const isUndefined = (x) => { return (typeof x === 'undefined') };
const returnJustMessage = (ctx, errorTitle, errorMessage) => {
    return ctx.utils.render('login', {template: 'justMessage', errorTitle, errorMessage});
};

/**
 * Handles the Add Master flow
 * @param {object} ctx
 */
module.exports = async function AddMaster(ctx) {
    //Sanity check
    if(isUndefined(ctx.params.action)){
        return ctx.utils.error(400, 'Invalid Request');
    }
    const action = ctx.params.action;

    //Check if there are no master admins set up
    if(globals.authenticator.admins !== false){
        return returnJustMessage(
            ctx,
            `Master account already set.`,
        );
    }

    //Delegate to the specific action handler
    if(action == 'pin'){
        return await handlePin(ctx);
    }else if(action == 'callback'){
        return await handleCallback(ctx);
    }else if(action == 'save'){
        return await handleSave(ctx);
    }else{
        return ctx.send({
            type: 'danger',
            message: 'Unknown action.'
        });
    }
};


//================================================================
/**
 * Handle Pin
 * @param {object} ctx
 */
async function handlePin(ctx) {
    //Sanity check
    if(
        isUndefined(ctx.request.body.pin) ||
        typeof ctx.request.body.pin !== 'string' ||
        ctx.method != 'POST'
    ){
        return ctx.utils.error(400, 'Invalid Request - missing parameters');
    }

    //Checking the PIN
    if(ctx.request.body.pin !== globals.authenticator.addMasterPin){
        logWarn(`Wrong PIN for from: ${ctx.ip}`);
        const message = `Wrong PIN.`;
        return ctx.utils.render('login', {template: 'noMaster', message});
    }

    //Make sure the session is initialized
    ctx.session.startedSocialLogin = Date.now();

    //Generate URL
    try {
        const callback = ctx.protocol + '://' + ctx.get('host') + `/auth/addMaster/callback`;
        const url = await globals.authenticator.providers.citizenfx.getAuthURL(callback, ctx.session._sessCtx.externalKey);
        return ctx.response.redirect(url);
    } catch (error) {
        return returnJustMessage(
            ctx,
            `Failed to generate callback URL with error:`,
            error.message
        );
    }
}


//================================================================
/**
 * Handle Callback
 * @param {object} ctx
 */
async function handleCallback(ctx) {
    //Sanity check
    if(ctx.method != 'GET'){
        return ctx.utils.error(400, 'Invalid Request - missing parameters');
    }

    //Exchange code for access token
    let tokenSet;
    try {
        const currentURL = ctx.protocol + '://' + ctx.get('host') + `/auth/addMaster/callback`;
        tokenSet = await globals.authenticator.providers.citizenfx.processCallback(ctx, currentURL, ctx.session._sessCtx.externalKey);
    } catch (error) {
        logWarn(`Code Exchange error: ${error.message}`);
        if(!isUndefined(error.tolerance)){
            return returnJustMessage(
                ctx,
                `Please Update/Synchronize your VPS clock.`,
                `Failed to login because this host's time is wrong. Please make sure to synchronize it with the internet.`
            );
        }else if(error.code === 'ETIMEDOUT'){
            return returnJustMessage(
                ctx,
                `Connection to FiveM servers timed out:`,
                `Failed to verify your login with FiveM's identity provider. Please try again or check your connection to the internet.`
            );
        }else if(error.message.startsWith('state mismatch')){
            return returnJustMessage(
                ctx,
                `Invalid Browser Session.`,
                `You may have restarted txAdmin right before entering this page, or copied the link to another browser. Please try again.`
            );
        }else{
            return returnJustMessage(ctx, `Code Exchange error:`, error.message);
        }
    }

    //Get userinfo
    let userInfo;
    try {
        userInfo = await globals.authenticator.providers.citizenfx.getUserInfo(tokenSet.access_token);
    } catch (error) {
        logError(`Get UserInfo error: ${error.message}`);
        return returnJustMessage(
            ctx,
            `Get UserInfo error:`,
            error.message
        );
    }

    // Setar userinfo na sessão
    ctx.session.tmpAddMasterTokenSet = tokenSet;
    ctx.session.tmpAddMasterUserInfo = userInfo;

    return ctx.utils.render('login', {
        template: 'callback',
        addMaster_name: userInfo.name,
        addMaster_picture: userInfo.picture
    });
}


//================================================================
/**
 * Handle Save
 * @param {object} ctx
 */
async function handleSave(ctx) {
    //Sanity check
    if(
        typeof ctx.request.body.password !== 'string' ||
        typeof ctx.request.body.password2 !== 'string'
    ){
        return ctx.utils.error(400, 'Invalid Request - missing parameters');
    }

    //Sanity check2: Electric Boogaloo (Validating password)
    const password = ctx.request.body.password.trim();
    const password2 = ctx.request.body.password2.trim();
    if(password != password2 || password.length < 6 || password.length > 24){
        return returnJustMessage(
            ctx,
            `Invalid Password.`,
        );
    }

    //Checking if session is still present
    if(
        typeof ctx.session.tmpAddMasterUserInfo === 'undefined' ||
        typeof ctx.session.tmpAddMasterUserInfo.name !== 'string' ||
        typeof ctx.session.tmpAddMasterUserInfo.picture !== 'string'
    ){
        return returnJustMessage(
            ctx,
            `Invalid Session.`,
            `You may have restarted txAdmin right before entering this page. Please try again.`
        );
    }

    //Creating admins file
    try {
        await globals.authenticator.createAdminsFile(ctx.session.tmpAddMasterUserInfo.name, ctx.session.tmpAddMasterUserInfo, password);
    } catch (error) {
        return returnJustMessage(
            ctx,
            `Error:`,
            error.message
        );
    }

    //Login user
    try {
        ctx.session.auth = await globals.authenticator.providers.citizenfx.getUserSession(
            ctx.session.tmpAddMasterTokenSet,
            ctx.session.tmpAddMasterUserInfo
        );
        ctx.session.auth.username = ctx.session.tmpAddMasterUserInfo.name
        delete ctx.session.tmpAddMasterTokenSet;
        delete ctx.session.tmpAddMasterUserInfo;
    } catch (error) {
        ctx.session.auth = {};
        logError(`Failed to login: ${error.message}`);
        return returnJustMessage(
            ctx,
            `Failed to login:`,
            error.message
        );
    }

    log('Admin file created! You can now login normally.');
    return ctx.response.redirect('/');
}
