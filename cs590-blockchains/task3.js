console.log("#########################################################\n\n Hi, this is Pavan's task3.js script. \n\n#########################################################");

function printTxn(txn) {
        console.log(
                "{\n\tblockHash: " + txn.blockHash + ",\n" +
                "\tblockNumber: " + txn.blockNumber + ",\n" +
                "\tchainId: " + txn.blockHash + ",\n" +
                "\tfrom: " + txn.from + ",\n" +
                "\tgas: " + txn.gas + ",\n" +
                "\tgasPrice: " + txn.gasPrice + ",\n" +
                "\thash: " + txn.hash + ",\n" +
                "\tinput: " + txn.input + ",\n" +
                "\tnonce: " + txn.nonce + ",\n" +
                "\tr: " + txn.r + ",\n" +
                "\ts: " + txn.s + ",\n" +
                "\tto: " + txn.to + ",\n" +
                "\ttransactionIndex: " + txn.transactionIndex + ",\n" +
                "\ttype: " + txn.type + ",\n" +
                "\tv: " + txn.v + ",\n" +
                "\tvalue: " + txn.value + "\n}\n"
        );
}

eth.accounts.forEach(
	acc => personal.unlockAccount(acc, "pac123!")
);

var txn = eth.sendTransaction({
	from: eth.accounts[0],
	to: "0x3ffda5accffc6663d14f8b27bf791555e88c046f",
	value:web3.toWei(1, "ether")
});

miner.start(1);

setTimeout( function() {
	printTxn(eth.getTransaction(txn));
	miner.stop();
}, 60000);
