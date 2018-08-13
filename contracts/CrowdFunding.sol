pragma solidity ^0.4.17;

//合约生成工厂
contract FundingFactory{

    //储存众筹合约地址的数组
    address[] public fundings;

    //合约生成
    function deploy(string _projectName,uint _supportMoney,uint _goalMoney) public{
        //调用创建众筹合约的方法，拿到创建者的地址
        address funding=new Funding( _projectName , _supportMoney , _goalMoney , msg.sender);
        fundings.push(funding);
    }
}

contract Funding{
    //创建者
    address public manager;

    //商品名
    string public projectName;

    //每次筹钱量
    uint public supportMoney;

    //众筹结束时间
    uint public endTime;

    //需要筹集的资金量
    uint public goalMoney;

    //参与者的地址数组
    address[] public players;

    //储存参与者地址的集合
    mapping(address=>bool) playersMap;

    //拨款请求的数组
    Request[] public requests;

    //拨款请求对象
    struct Request{
        //请求名称
        string description;
        //求情款量
        uint money;
        //收款方地址
        address shopAddress;
        //是否完成
        bool complete;
        //可投票人地址集合
        mapping(address=>bool) votedMap;
        //支持人数
        uint voteCount;
    }

    //创建众筹合约
    function Funding(string _projectName,uint _supportMoney,uint _goalMoney,address _address) public{
        manager=_address ;
        projectName=_projectName;
        goalMoney=_goalMoney;
        supportMoney=_supportMoney;
        endTime=now+4 weeks;
    }

    //参与众筹方法
    function support() public payable{
        require(msg.value==supportMoney);
        players.push(msg.sender);
        //付款成功置true
        playersMap[msg.sender]=true;
    }
//获取参与人数
    function getPlayersCount() public view returns(uint){
        return players.length;
    }
//获取参与众筹人员的地址
    function getPlayers() public view returns(address[]){
        return players;
    }
//
    function getTotalBalance() public view returns(uint){
        return this.balance;
    }

    function getRemainTime() public view returns(uint){
        return (endTime-now)/24/60/60;
    }

    function getSupportMoney() public view returns(uint){
        return supportMoney;
    }

    function getProjectName() public view returns(string){
        return projectName;
    }

    function getGoalMoney() public view returns(uint){
        return goalMoney;
    }

    function getRequestSize() public view returns(uint){
        return requests.length;
    }

    //拨款求情方法
    function createRequest(string _description,uint _money,address _shopAddress) public onlyManagerCancall{

        Request memory request = Request({
            description : _description,
            money : _money,
            shopAddress : _shopAddress,
            complete : false,
            voteCount:0
            });
        requests.push(request);
    }

    //验证是否是发起众筹者
    modifier onlyManagerCancall(){
        require(msg.sender==manager);
        _;
    }

    //参与众筹的人员对拨款请求投票的方法
    function approveRequest(uint index) public{

        Request storage request = requests[index];

        //在可投票人员名单中
        require(playersMap[msg.sender]);

        //不在已经投票过的人员名单中
        require(!requests[index].votedMap[msg.sender]);
        request.voteCount ++;

        requests[index].votedMap[msg.sender]=true;
    }

    //发起众筹的人执行拨款的方法
    function finalizeRequest(uint index) public onlyManagerCancall {
        Request storage request= requests[index];

        require(!request.complete);

        require(request.voteCount*2 > players.length);

        require(this.balance>=request.money);
        request.shopAddress.transfer(request.money);
        request.complete=true;
    }

}
