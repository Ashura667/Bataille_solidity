pragma solidity ^0.8.7;



contract Bataille_navale {
    address owner;
    constructor(){
        owner = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }
    struct Bateau {
        uint sante;
        uint degat;
        address equipe;
        uint level;
        
    }
    uint count;
    mapping(address =>  uint[]) Bateaux_utilisateur;
    mapping(uint => Bateau) All_bateau;
    

    function creer_bateau(uint _sante, uint _degat) public {
        require (_sante !=0 && _degat !=0 && _sante !=0);
        Bateaux_utilisateur[msg.sender].push(count);
        All_bateau[count].sante = _sante;
        All_bateau[count].degat = _degat;
        All_bateau[count].equipe = msg.sender;
        All_bateau[count].level = 1;

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