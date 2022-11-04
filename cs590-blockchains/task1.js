console.log("#########################################################\n\n Hi, this is Pavan's task1.js script. \n\n#########################################################");

eth.accounts.forEach(
        acc => personal.unlockAccount(acc, "pac123!")
);

console.log(web3.fromWei(eth.getBalance(eth.accounts[0]), "ether"));

miner.start(1);

setTimeout(function () {
	console.log(web3.fromWei(eth.getBalance(eth.accounts[0]), "ether"));
	miner.stop()
 }, 300000);
