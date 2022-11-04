console.log("#########################################################\n\n Hi, this is Pavan's task2.js script. \n\n #########################################################");

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

function printBlock(block) {
	console.log(
	  "{\n\tdifficulty: " + block.difficulty + ",\n" +
          "\textraData: " + block.extraData + ",\n" +
          "\tgasLimit: " + block.gasLimit + ",\n" +
          "\tgasUsed: " + block.gasUsed + ",\n" +
          "\thash: " + block.hash + ",\n" +
          "\tlogsBloom: " + block.logsBloom + ",\n" +
          "\tminer: " + block.miner + ",\n" +
          "\tmixHash: " + block.mixHash + ",\n" +
          "\tnonce: " + block.nonce + ",\n" +
          "\tnumber: " + block.number + ",\n" +
          "\tparentHash: " + block.parentHash + ",\n" +
          "\treceiptsRoot: " + block.receiptsRoot + ",\n" +
          "\tsha3Uncles: [" + block.sha3Uncles + "],\n" +
          "\tsize: " + block.size + ",\n" +
          "\tstateRoot: " + block.stateRoot + ",\n" +
          "\ttimestamp: " + block.timestamp + ",\n" +
          "\ttotalDifficulty: " + block.totalDifficulty + ",\n" +
          "\ttransactions: [" + block.transactions + "],\n" +
          "\ttransactionsRoot: " + block.transactionsRoot + ",\n" +
          "\tuncles: [" + block.uncles + "]\n}\n"
        );
}

eth.accounts.forEach(
        acc => personal.unlockAccount(acc, "pac123!")
);

for (let i = 0; i < 5; i++) {
	var block = eth.getBlock(eth.blockNumber - i);
	printBlock(block);
}



var counter = eth.blockNumber
var one_or_two = true;
while (counter >= 1) {
	var transactions = eth.getBlock(counter).transactions;
	
	if (transactions.length >= 2 && one_or_two) {
		printTxn(eth.getTransaction(transactions[0]));
		printTxn(eth.getTransaction(transactions[1]));
		break;
	} 

	if (transactions.length >= 1) {
		printTxn(eth.getTransaction(transactions[0]));
		if (!one_or_two) {
			break;
		}
		one_or_two = false;
	}
	
	counter--;
}


miner.start(1);

setTimeout( function() {
	miner.stop();
	for (let i = 0; i < 5; i++) {
		var block = eth.getBlock(eth.blockNumber - i);
		printBlock(block);
	}
}, 60000);










