
// Current supported product list.
const productList = {
   "se12c": {
      agreementUrl: "",
      downloadUrl: ""
   },
   "xe11g": {
      agreementUrl: "http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html",
      downloadUrl: "https://edelivery.oracle.com/akam/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip"
   },
   "sqlcl": {
      agreementUrl: "http://www.oracle.com/technetwork/developer-tools/sqlcl/downloads/index.html",
      downloadUrl: "http://download.oracle.com/otn/java/sqldeveloper/sqlcl-4.2.0.16.355.0402-no-jre.zip"
   }
};

var casper = require("casper").create({
   //verbose: true,
   //logLevel: "debug",
   pageSettings: {
      loadImages: false,
      loadPlugins: false
   }
});

if (casper.cli.args.length < 2) {
   casper.echo("Missing username and password.").exit(1);
}

if (!casper.cli.has("product")) {
   casper.echo("Missing --product option.").exit(1);
}

// Script parameters.
var paramUsername = casper.cli.get(0);
var paramPassword = casper.cli.get(1);
var paramProduct = casper.cli.get("product");

// Check if is a valid product.
var productInfo = productList[paramProduct];
if (!productInfo) {
   casper.echo("Invalid product: " + paramProduct).exit(1);
}

casper.start();
// TODO: Error handling.

// Accept the license agreement.
casper.thenOpen(productInfo.agreementUrl, function () {
   // this.echo("Accepting License");
   this.evaluate(function () {
      acceptAgreement(window.self);
   });
});

// Try to access the download page, wait for redirection and submit the login form.
casper.thenOpen(productInfo.downloadUrl).waitForUrl(/signon\.jsp$/, function (re) {
   // this.echo("Injecting Login Info");
   this.evaluate(function (username, password) {
      document.getElementById("sso_username").value = username;
      document.getElementById("ssopassword").value = password;
      doLogin(document.LoginForm);
   }, paramUsername, paramPassword);
   // this.capture("Screenshot.png");
});

casper.on("resource.received", function (resource) {
   if (resource.url.indexOf("AuthParam") !== -1) {
      // this.echo("DownloadUrl:");
      // Print the download url.
      this.echo(resource.url);
      // TODO: Try to download file from here. this.download is not working because of cross site request.
   }
});

casper.run(function () {
   this.exit();
});
