//直接获取区块链上的彩票的智能合约

import web3 from './web3'; //装好了 用户provider的web3
const address = '';
//ctrl + shift + J
const abi =

const lottery =new web3.eth.Contract(abi, address);

export default lottery