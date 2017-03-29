
var casper = require('casper').create({
   verbose: true,
   pageSettings: {
      loadImages: false,
      loadPlugins: false,
      webSecurityEnabled: false
   }
});

if (casper.cli.args.length < 4) {
   casper.echo('Missing parameters: username password agreementUrl downloadUrl').exit(1);
}

// Script parameters.
var paramUsername = casper.cli.get(0);
var paramPassword = casper.cli.get(1);
var agreementUrl  = casper.cli.get(2);
var downloadUrl   = casper.cli.get(3);
var fileName      = casper.cli.get(4);
var downloaded    = false;

casper.start(agreementUrl, function () {
   this.echo('Accepting License');
   this.evaluate(function () {
      acceptAgreement(window.self);
   });
});

// Try to access the download page, wait for redirection and submit the login form.
casper.thenOpen(downloadUrl).waitForUrl(/signon\.jsp$/, function (re) {
   this.echo('Injecting Login Info');
   this.evaluate(function (username, password) {
      document.getElementById('sso_username').value = username;
      document.getElementById('ssopassword').value = password;
      doLogin(document.LoginForm);
      // TODO: Check if login was successfull.
   }, paramUsername, paramPassword);
});

// TODO: Error handling.
casper.on('error', function (msg, backtrace) {
    this.echo(msg);
});

casper.on('resource.received', function (resource) {
   if (resource.url.indexOf('AuthParam') !== -1 && !downloaded) {
      this.echo('DownloadUrl: ' + resource.url);
      this.echo('Target: ' + fileName);
      this.download(resource.url, fileName);
      downloaded = true;
   }
});

casper.run(function () {
   this.exit();
});
