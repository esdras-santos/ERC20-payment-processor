var PaymentProcessor = artifacts.require("./contracts/PaymentProcessor.sol");
PaymentProcessor.web3.eth.getGasPrice(function(error, result) {
var gasPrice = Number(result);
console.log("Gas Price is " + gasPrice + " wei"); // "10000000000000"
// Get the contract instance
PaymentProcessor.deployed().then(function(PaymentProcessorInstance) {
// Use the keyword 'estimateGas' after the function name to get the gas
// estimation for this particular function (aprove)
PaymentProcessorInstance.send(web3.toWei(1, "ether"));
return PaymentProcessorInstance.addToken.estimateGas(web3.toWei(0.1, "ether"));
}).then(function(result) {
var gas = Number(result);
console.log("gas estimation = " + gas + " units");
console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
console.log("gas cost estimation = " +
PaymentProcessor.web3.fromWei((gas * gasPrice), 'ether') + " ether");
});
});