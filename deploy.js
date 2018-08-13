//部署智能合约到真实的rankeby网络
const Web3 = require('web3');
const {interface,bytecode} = require('./compile');
const HDWalletProvider = require('truffle-hdwallet-provider');
const mnemonic = "display rural hawk mushroom ostrich stove drip hard alien voyage rain yellow";
const provider = new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/3745fd89da3d4224aa511ac7d2703062");
const web3 = new Web3(provider);

deploy =async ()=>{
    const accounts = await web3.eth.getAccounts();
    console.log(accounts[0]);
    const result =await new web3.eth.Contract(JSON.parse(interface))
        .deploy({
            data:bytecode
        }).send({
            from:accounts[0],
            gas:'3000000'
        });
    console.log('address:'+result.options.address);

    console.log('------------------');
    console.log(interface);
};
deploy();