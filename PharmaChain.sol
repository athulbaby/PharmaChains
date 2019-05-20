pragma solidity ^0.5.8;

contract PharmaChain {
    
    address public  superAdmin;  //address of the super admin
    
    uint quotlist;
    
    enum Status { NotExist, Pending, Aproved, Rejected, OutForDelivery }    //represting the Status of manufacturer and supplier
    
    enum QuoteStatus { NotExist, Quoted, QuoteApproved, QuoteRejected, ReQuoted }  //Status of the quot
    
    enum Rawmat { Sulphur, Phosphorous, Iron, Calcium }     //raw material data
    
    
    struct mfg {
        
        uint mfgid;
        
        string mfgname;
        
        string productname;                  //structure of manufacturer
        
        uint[] mfgquotlist;
        
        Status status;
        
        address mfgaddress;
        
        address createdby;
        
        uint createdat;
        
        
    }
    
    
    struct sup {
        
        uint supid;
        
        string supname;
        
        Rawmat rawmat;
        
        uint price;                         //structure of supplier
        
        uint[] supquotlist;
        
        Status status;
        
        address supaddress;
        
        address createdby;
        
        uint createdat;
        
        
        
    }
    
    
    
    struct quot {
        
        Rawmat rawmat;
        
        uint quantity;
        
        uint price;
                                            //structure of quot
        QuoteStatus status;
        
        uint supid;
        
        uint mfgid;
        
        uint createdat;
        
        
    }
    
    
    struct admin {
        
        string name;
        
        Status status;
                                            //structure of admin
        address adminaddress;
        
        address createdby;
        
        uint createdat;
    }
    
    struct productVerf {
        
        string productname;
        
        uint productid;   //structure of product
        
        uint quality;
        
        Status status;
        
        
        
        
        
        
    }
    
    mapping (uint => mfg) public mfgs;  
    
    mapping (uint => sup) public sups;
    
    mapping (address => uint) public mfgsid;
                                                                     //all mappings
    mapping (address => uint) public supsid;
    
    mapping (uint => quot) public quots;
    
    mapping (address => admin) public admins;
    
    mapping (uint => productVerf) public productVerfs;
    
    
    
    modifier verifiedAdmin() {
        
        require(admins[msg.sender].status == Status.Aproved);
        _;
    }                                                                                                 //custom modifiers
    
    modifier onlySuperAdmin() {
        
        require(msg.sender == superAdmin);
        _;
    }
    
    
    constructor() payable public {
        
        superAdmin = msg.sender;
                                                                                                                 //initiating the blockchain
        admins[msg.sender] = admin("SuperAdmin", Status.Aproved, msg.sender, msg.sender, now );
        
    }
    
    
    
    function createAdmin ( string memory _name, address _adminaddress ) verifiedAdmin public returns (bool) {
        
        require(admins[_adminaddress].status == Status.NotExist);                                          //creating admin
        
        admins[_adminaddress] = admin ( _name, Status.Pending, _adminaddress, msg.sender, now);
        
        return true;
        
        
    }
    
    
    
    function aproveAdmin (address _adminaddress) onlySuperAdmin public returns (bool) {
        
        require(admins[_adminaddress].status == Status.Pending);                                          //aprove admin
        
        admins[_adminaddress].status = Status.Aproved;
        
        return true;
    }
    
    function rejectAdmin ( address _adminaddress) onlySuperAdmin public returns (bool) {
        
        require(admins[_adminaddress].status == Status.Pending);                                             //reject admin
        
        admins[_adminaddress].status = Status.Rejected;
        
        return true;
    }
    
    
    function createMfg ( uint _mfgid, string memory _mfgname, string memory _productname, address _mfgaddress ) verifiedAdmin public returns (bool) {
        
        require(mfgs[_mfgid].status == Status.NotExist);
        
        mfgs[_mfgid].mfgid = _mfgid;
        
        mfgs[_mfgid].mfgname = _mfgname;
        
        mfgs[_mfgid].productname = _productname;                                                   //create manufacturer
        
        mfgs[_mfgid].status = Status.Pending;
        
        mfgs[_mfgid].mfgaddress = _mfgaddress;
        
        mfgs[_mfgid].createdby = msg.sender;
        
        mfgs[_mfgid].createdat = now;
             
        mfgsid[_mfgaddress] = _mfgid;
        
        return true;

    }
    
    function aproveMfg (uint _id) onlySuperAdmin public returns (bool) {
        
        require(mfgs[_id].createdby != msg.sender);
        
        require(mfgs[_id].status == Status.Pending);                               //aprove manufacturer
        
        mfgs[_id].status = Status.Aproved;
        
        return true;
        
    }
    
    function rejectMfg ( uint _id ) onlySuperAdmin public returns (bool) {
        
        require(mfgs[_id].createdby != msg.sender);
        
        require(mfgs[_id].status == Status.Pending);                                   //reject manufacturer
        
        mfgs[_id].status = Status.Rejected;
        
        return true;
        
    }
    
    
    
    function createSup ( uint _supid, string memory _supname, Rawmat _rawmat, uint _price, address _supaddress ) verifiedAdmin public returns (bool) {
        
        require(sups[_supid].status == Status.NotExist);
        
         sups[_supid].supid = _supid;
         
         sups[_supid].supname = _supname;
         
         sups[_supid].rawmat = _rawmat;
                                                                                        //create supplier
         sups[_supid].price = _price;
         
         sups[_supid].status = Status.Pending;
        
         sups[_supid].supaddress = _supaddress;
        
         sups[_supid].createdby = msg.sender;
        
         sups[_supid].createdat = now;
        
         supsid[_supaddress] = _supid;    
         
         return true;
   
    }
    
    
    function aproveSup ( uint _id ) onlySuperAdmin public returns (bool) {
        
        require(sups[_id].createdby != msg.sender);
        
        require(sups[_id].status == Status.Pending);                                                      //aprove supplier
        
        sups[_id].status = Status.Aproved;
        
        return true;
    }
    
    function rejectSup ( uint _id ) onlySuperAdmin public returns (bool) {
       
       require(sups[_id].createdby != msg.sender);
        
       require(sups[_id].status == Status.Pending);                                                                //reject supplier
        
       sups[_id].status = Status.Rejected; 
       
       return true;
        
    }
    
    
    function searchMfg ( uint _mfgid ) public view returns ( uint, string memory, string memory, Status ) {
        
        mfg memory _mfg = mfgs[_mfgid];                                                                                        //manufacturer search
        
        return ( _mfg.mfgid, _mfg.mfgname, _mfg.productname,_mfg.status);
    }
    
    
    function searchSup (uint _supid ) public view returns ( uint, string memory, Rawmat, uint, Status) {
        
        sup memory _sup = sups[_supid];                                                                                         //supplier search
                                                                                                                  
        return ( _sup.supid, _sup.supname, _sup.rawmat, _sup.price, _sup.status );
    }
    
    function createQuot ( uint _mfgid, Rawmat _rawmat, uint _quantity, uint _price, uint _supid ) public  returns (bool) {
        
        require(mfgs[_mfgid].mfgaddress == msg.sender);
        
        require(mfgs[_mfgid].status == Status.Aproved);
        
        require(sups[_supid].status == Status.Aproved);                                                                                 //create quot
        
        quotlist++;
        
        quots[quotlist] = quot ( _rawmat, _quantity, _price, QuoteStatus.Quoted, _supid, _mfgid, now);
        
        mfgs[_mfgid].mfgquotlist.push(quotlist);
        
        sups[_supid].supquotlist.push(quotlist);
        
        return true;
        
    }
        
        
    function aproveQuot ( uint _quotlist) verifiedAdmin public  returns (bool) {
        
        require(quots[_quotlist].status == QuoteStatus.Quoted);                                           //aprove quot
        
        quots[_quotlist].status = QuoteStatus.QuoteApproved;
        
        return true;
        
        
    }
    
    function rejectQuot ( uint _quotlist ) verifiedAdmin public  returns (bool) {
        
        require(quots[_quotlist].status == QuoteStatus.Quoted);                                           //reject quot
        
        quots[_quotlist].status = QuoteStatus.QuoteRejected;
        
        return true;
        
    }
    
    function requot ( uint _quotlist, uint _quantity, uint _price) public  returns (bool) {
        
        require(quots[_quotlist].status == QuoteStatus.Quoted);
        
        require(quots[_quotlist].mfgid == mfgsid[msg.sender]);
                                                                                                       //for requot
        quots[_quotlist].quantity = _quantity;
        
        quots[_quotlist].price = _price;
        
        quots[_quotlist].status = QuoteStatus.ReQuoted;
        
        return true;
        
        
    }
    
    function aproveRequot ( uint _quotlist) verifiedAdmin public  returns (bool) {
        
        require(quots[_quotlist].status == QuoteStatus.ReQuoted);                              //aprove requot
        
        quots[_quotlist].status = QuoteStatus.QuoteApproved;
        
        return true;
        
    }
    
    function rejectRequot ( uint _quotlist) verifiedAdmin public  returns (bool) {
        
        require(quots[_quotlist].status == QuoteStatus.ReQuoted);                                  //reject requot
                                         
        quots[_quotlist].status = QuoteStatus.QuoteRejected;
        
        return true;
    }
    
    function getQuot (uint _quotid ) public view returns (Rawmat, uint, uint, QuoteStatus, uint, uint, uint) {
        
       require(quots[_quotid].createdat != 0);
                                                                                                                         //get quot details
       quot memory _quot = quots[_quotid];
       
       return(_quot.rawmat, _quot.quantity, _quot.price, _quot.status, _quot.supid, _quot.mfgid, _quot.createdat);
    }
    
    function getmfgQuotlist (uint _id ) public view returns (uint[] memory) {
        
        require(mfgs[_id].status == Status.Aproved);
                                                                          //get manufacturer quot list 
        mfg memory _mfg = mfgs[_id];
        
        return (_mfg.mfgquotlist);
        
    }
    
    function getsupQuotlist ( uint _id ) public view returns (uint[] memory) {
        
        require(sups[_id].status == Status.Aproved);
                                                                          
                                                                          //get suppliers quot list 
        sup memory _sup = sups[_id];
        
        return (_sup.supquotlist);
    }
    
    
    function productVerify ( string memory _productname, uint _productid, uint _quality ) public  returns (bool) {
        
        require(productVerfs[_productid].status == Status.NotExist);
        
        productVerfs[_productid].productid = _productid;
                                                                             //verification of product (by taking samples of the product)
        productVerfs[_productid].productname = _productname;
        
        productVerfs[_productid].quality = _quality;
        
        productVerfs[_productid].status = Status.Pending;
        
        return true;
    }
    
    function aproveProduct (uint _productid ) verifiedAdmin public returns (bool) {
        
        require(productVerfs[_productid].status == Status.Pending);
                                                                                              //product is verified and aproved for delivery
        productVerfs[_productid].status = Status.Aproved;
        
        return true;
    }
    
    function rejectProduct ( uint _productid ) verifiedAdmin public returns (bool) {
        
        require(productVerfs[_productid].status == Status.Pending);
                                                                                                  //product is rejected 
        productVerfs[_productid].status = Status.Rejected;
        
        return true;
    }
    
    function getProduct ( uint _productid ) view public returns ( string memory, uint, uint ,Status ) {
        
        productVerf memory _product = productVerfs[_productid];                                                      //get product details
        
        return ( _product.productname, _product.productid, _product.quality, _product.status );
    }
    
    
    function producyOutdev ( uint _productid ) verifiedAdmin public returns (bool) {
        
        require(productVerfs[_productid].status == Status.Aproved);
        
        productVerfs[_productid].status = Status.OutForDelivery;
        
        return true;
    } 
    
    
    
    
    
    
    
}
    
    
    
    
    
    
    
    
    
    
    
    
