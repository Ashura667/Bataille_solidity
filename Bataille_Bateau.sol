pragma solidity ^0.8.7;



contract Bataille_navale {
    address owner_contract;
    uint balance_contract;
    constructor(){
        owner_contract = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner_contract);
        _;
    }
    struct Bateau {
        uint sante;
        uint degat;
        address equipe;
        uint level;
        uint prix;
        bool disponible;

        
    }
    uint count;
    mapping(address =>  uint[]) Bateaux_utilisateur;
    mapping(address =>  uint) solde_utilisateur;

    mapping(uint => Bateau) All_bateau;
    receive() external payable 
    {
        balance_contract+=msg.value;
        solde_utilisateur[msg.sender] += msg.value;

    }
    function return_credit() public view returns (uint) 
    {
        return solde_utilisateur[msg.sender];
    }
    function return_balance_contract() public view returns (uint) 
    {
        return balance_contract;
    }
    

    function acheter_bateau(uint id_bateau) public {
        require(All_bateau[id_bateau].disponible ==true, "Bateau deja vendu");
        require(solde_utilisateur[msg.sender]>=All_bateau[id_bateau].prix, "Solde insuffisant");
        if (All_bateau[id_bateau].equipe != 0x0000000000000000000000000000000000000000) 
        {
            solde_utilisateur[All_bateau[id_bateau].equipe] += All_bateau[id_bateau].prix;
        }
        All_bateau[id_bateau].disponible = false;
        solde_utilisateur[msg.sender]-=All_bateau[id_bateau].prix;
        Bateaux_utilisateur[msg.sender].push(id_bateau);
        All_bateau[id_bateau].equipe = msg.sender;
    }
    function vendre_bateau(uint id_bateau, uint _prix) public {
        require(All_bateau[id_bateau].equipe ==msg.sender, "Le bateau ne vous appartient pas");
        All_bateau[id_bateau].disponible = true;
        All_bateau[id_bateau].prix = _prix;
        
    }

    function creer_bateau(uint _sante, uint _degat) public isOwner{
        require (_sante !=0 && _degat !=0 && _sante !=0);
        //Bateaux_utilisateur[msg.sender].push(count);
        //All_bateau[count].equipe = msg.sender;

        All_bateau[count].sante = _sante;
        All_bateau[count].degat = _degat;
        All_bateau[count].level = 1;
        All_bateau[count].prix = 1 ether;
        All_bateau[count].disponible = true;

        count+=1;

    }

    function retourner_all_bateau_user(address cible) public view returns (uint[] memory)
    {
        return Bateaux_utilisateur[cible];

    }
    
    
    function retourner_stat_bateau(uint id_bateau) public view returns (Bateau memory) {
        return All_bateau[id_bateau];
    }



//Retourner le nombre de bateau disponible 

function retourner_nbr_bateau() public view isOwner returns (uint)
    {
        return count;

    }
    function attaquer(uint bateau_utilisateur, uint bateau_cible) public view  returns (string memory) {
        require(All_bateau[bateau_utilisateur].equipe == msg.sender,"ce n'est pas votre bateau");
        require(All_bateau[bateau_utilisateur].equipe != All_bateau[bateau_cible].equipe, "Vous attaquez un de vos bateaux");
        uint sante1 = All_bateau[bateau_utilisateur].sante;
        uint sante2 = All_bateau[bateau_cible].sante;
        while (sante1 !=0 && sante2 !=0)
        {
            if (sante1 < All_bateau[bateau_cible].degat) 
            {
                sante1=0;
            }
            else if (sante2 < All_bateau[bateau_utilisateur].degat) 
            {
                sante2=0;
            }
            else 
            {
            sante1 -=All_bateau[bateau_cible].degat;
            sante2 -=All_bateau[bateau_utilisateur].degat;
            }
            
        }
        if (sante1 ==0) 
        {
            return "Vous avez perdu";
        }
        else {
                        return "Vous avez gagne";

        }


    }
}
