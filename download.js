
var casper = require("casper").create({
   pageSettings: {
      loadImages: false,
      loadPlugins: false
   }
});

if (casper.cli.args.length < 4) {
    casper.echo("Missing args...").exit();
}

var agreementUrl = casper.cli.get(0);
var downloadUrl  = casper.cli.get(1);
var ssoUsername  = casper.cli.get(2);
var ssoPassword  = casper.cli.get(3);

casper.start();

// Accept the license agreement.
casper.thenOpen(agreementUrl, function () {
   this.evaluate(function () {
      acceptAgreement(window.self);
   });
});

// Try to access the download page, wait for redirection and submit the login form.
casper.thenOpen(downloadUrl).waitForUrl(/signon\.jsp$/, function (re) {
   this.evaluate(function (username, password) {
      document.getElementById("sso_username").value = username;
      document.getElementById("ssopassword").value = password;
      doLogin(document.LoginForm);
   }, ssoUsername, ssoPassword);
});

casper.on("resource.received", function (resource) {
   if (resource.url.indexOf("AuthParam") !== -1) {
      this.echo(resource.url);
   }
});

casper.run(function () {
   this.exit();
});
