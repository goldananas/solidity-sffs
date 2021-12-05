# Solidity & DApp | SFFS

DApp using Solidity for the SFFS course.

## Sujet

En raison des conditions sanitaires, le Foy de l'INSA Rennes a décidé de se diversifier en proposant une expérience virtuelle à ses habitués. Le bureau du Foy t'a choisi pour mettre en place un Smart Contract permettant à quiconque possédant un portefeuille Ethereum d'acheter des bières virtuelles. De plus l'acheteur pourra visualiser ses nouvelles trouvailles sur une application décentralisée (DApp) ! L'avenir du Foy est entre tes mains.


## Prise en main de Remix

1. Se rendre sur l'IDE Solidity en ligne [Remix](https://remix.ethereum.org). Au niveau du bandeau à gauche, la première icône correspond à l'explorateur de fichier, la deuxième au compilateur, la troisième au déploiement des Smart Contracts, et la quatrième permet d'installer des plugins.

2. Par défaut, Remix crée un workspace avec déjà plusieurs Smart Contracts, vous pouvez les laisser ou les supprimer, cela n'importe pas pour ce TP. Créer un nouveau fichier **foy.sol** dans le répertoire [/contracts](/contracts).

3. Spécifier l'identifiant [SPDX](https://fr.wikipedia.org/wiki/SPDX) et la version du compilateur à utiliser puis on déclare le contrat comme une classe Java. 
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;
contract Foy {
}
```

4. Compiler avec CTRL + S, le compilateur doit afficher une coche ✔ verte.

## Création du Smart Contract

1. Créer le constructeur du contrat, **constructor**, ne prenant aucun paramètre. On stocke 
l'adresse du propriétaire du contrat afin de réaliser des transactions vers celle-ci par la suite.

> La propriété **msg.sender** permet de récupérer l'adresse de l'expéditeur d'une transaction. Son type est **address** qui permet de stocker des valeurs sur 20 octets.


2. On veut rendre stocker les inventaires des acheteurs dans un map : address -> BeerInventory
BeerInventory étant un objet comptant le nombre de bières possédé par une adresse (= 1 acheteur) pour chaque type de bière. Choisir plusieurs bières à ajouter à cet inventaire (Chouffe, La Bête, ...).

3. Le Foy veut créer une fonction permettant d'acheter un type de bière. La fonction incrémentera l'inventaire de l'acheteur et transférera le montant de la transaction à l'adresse propriétaire du contrat. Pour l'instant aucune condition sur le montant de la transaction n'est demandée. 

> Le mot clé **payable**, spécifié après la visibilité d'une fonction, permet d'utiliser la propriété **msg.value** qui correspond le montant d'ethereum dans une transaction.

> La fonction **transfer**, permet de transférer un montant d'ethereum à un destinataire.

4. Tester manuellement votre fonction en déployant le contrat, laisser les valeurs par défaut. Changer de compte pour acheter une bière et changer le montant de la transaction (**value**). Vous devez voir le compte du propriétaire du contrat s'incrémenter et le votre se décrémenter !

5. Ajouter une fonction permettant de récupérer l'inventaire de l'émetteur d'une transaction.

> Lorsque que l'on déclare un type non-primitif en paramètre d'une fonction il faut spécifier la localisation de la mémoire. Ici on choisira **memory** car c'est le plus adapté pour une [utilisation temporaire](https://docs.soliditylang.org/en/v0.3.3/frequently-asked-questions.html#what-is-the-memory-keyword-what-does-it-do).

> On utilise le mot clé **view** pour s'assurer qu'il n'y pas de modification d'état.

5. On va créer une grille de prix pour nos bières et annuler les transactions ne respectant pas le prix pour une bière donnée. Attention si l'acheteur a envoyé plus d'ether que le prix de la bière alors on lui renvoie la différence (cela est géré dans la même fonction).

> Le mot clé **revert** permet d'annuler la transaction (retourne le montant et les frais de transaction à l'expéditeur) et renvoie une erreur de type **error**.

> Le mot clé **ether** peut être utilisé en arithmétique : 1 ether = 1 * 1e18

6. Afin de booster les ventes en début de soirée, on veut créer une fonction **happyHour(uint duration)** permettant de démarrer l'happy hour. Durant l'happy hour toutes les bières sont à -50%  !! Seulement le propriétaire du contrat peut démarrer l'happy hour.

> **block.timestamp** permet d'accéder à l'[heure Unix](https://fr.wikipedia.org/wiki/Heure_Unix) au moment de la transaction en cours.

> Les **modifier** permettent d'exécuter du code avant ou après votre fonction. _ correspond à votre fonction. Même si on est jamais "obligé" d'utiliser les modifiers, cela reste intéressant pour factoriser votre code.

Exemple de **modifier** :

```solidity
modifier checkCondition() {
    if (_condition) revert NotValid();
    _;
}

error NotValid();

function foo() public checkCondition() {}
```

## Création de la Dapp

1. Il est maintenant temps d'ouvrir votre Smart Contract vers l'extérieur. C'est pourquoi nous allons avoir besoin d'installer [Metamask](https://metamask.io/). Il s'agit d'une extension de navigateur permettant de gérer des portefeuilles Ethereum. Lors de votre installation vous serez amené à **créer un portefeuille**. Une fois l'installation terminée, ouvrez l'extension puis cliquez sur _Réseau principal Ethereum_ puis sur **afficher/cacher les réseaux de test** et cochez l'option. Cela permet ensuite de choisir le réseau de test **Rinkeby**. Puis vous pouvez utiliser un [faucet](https://faucets.chain.link/rinkeby) afin de récolter un peu d'ether (si le site ne marche pas vous pouvez nous contacter, nous avons quelques ethers en rab pour vous ;)). Vous pouvez répéter l'action mais comme vous le voyez il est fastidieux d'obtenir plus de 1 ether, c'est pourquoi il faudra faire attention aux prix que vous définissez pour vos bières (sachant qu'une transaction sur Rinkeby coûte environ 0.0001 ether de frais et le déploiement d'un contrat 0.001 ether).

2. Le squelette de la dapp a déjà été créé. Le framework front-end choisi est Vue. Vous pouvez vous connecter à l'IDE en ligne de Vue :  [codesandbox.io](https://codesandbox.io/s/foy-dapp-skeleton-v1216) ou alors si voulez une solution plus "stable" et reactive, vous pouvez aussi cloner le repo Git, et **npm ci** puis **npm run serve** dans le directory _dapp\_skeleton_. Voici une exemple de version finie de la dapp : [foy-dapp](https://goldananas.github.io/solidity-sffs-private/)

3. Il vous faudra compiler votre Smart Contract sous Remix et copier l'ABI obtenu (tout en bas de l'onglet de compilateur) dans le projet Vue (_src/abi.json_). Vous pouvez aller voir l'ABI existant pour comparer avec votre solution. Également il faudra déployer le contrat sur Remix, pour cela on choisira l'environnement **Injected Web3**, normalement un pop up Metamask apparaîtra, accepter (il faut rafraîchir la page si vous venez juste d'installer Metamask). Ensuite vous pouvez déployer le contrat, il faudra attendre un certain temps, puis Metamask affichera une notification, copier l'adresse du contrat, puis collez là dans le fichier _src/App.vue_.

4. Complétez les méthodes dans methods du fichier (_src/components/Foy.vue_).

Voici les principales fonctions de Web3.js à utiliser pour compléter ces méthodes :

```solidity
// Call a view method (read only, with no ether value) :

    let res = await this.foyContract.methods
        .yourMethod(...<optional params>)
        .call();


// Call a normal method (requiring Metamask transaction but not sending ether) :

    this.foyContract.methods
        .yourMethod(...<optional params>)
        .send({ from: this.connectedAccount });

// Call a payable method (and send ether along with this transaction) :

    this.foyContract.methods
        .yourMethod(...<optional params>)
        .send({ from: this.connectedAccount, value: <transaction value> })
        
// You can also subscribe to transaction's events, such as :

    this.foyContract.methods
        .yourMethod(...)
        .send(...)
        .once('receipt', function(receipt){ ... }) // Transaction is effective
        .on('error', function(error){ ... }) // Transaction failed
```


5. Ensuite il faut gérer l'affichage de l'Happy Hour. La DApp doit pouvoir être capable de voir quand est-ce que l'Happy Hour est lancé. Pour cela, retourner sur Remix et ajouter à la fonction **happyHour** l'émission d'un event, aussi à ajouter.

> Le type **event** permet de définir des évènements personnalisés.

> La fonction **emit(event)** permet d'émettre un event.


6. Refaire les mêmes actions que dans l'étape 3 pour recopier l'ABI, mettre à jour abi.json et déployer le contrat modifié. Enfin, dans created() de Foy.vue, écouter l'event émis par le contrat. Lorsque l'event est émis, utiliser la fonction ```this.startHappyHourCountDown(end)``` déjà définie pour lancer le compteur de l'Happy Hour.

Voici les principales fonctions de Web3.js à utiliser pour écouter les events :
```solidity
// You can subscribe to contract's events (emitted with 'emit') :

    this.foyContract.events.YourEvent().on("data", event => {
        // event.returnValues contains the data sent by the event
    });
```
## Liens utiles

- [Documentation Solidity](https://docs.soliditylang.org/en/latest/)
- [Convertisseur d'unités Ethereum](https://coinguides.org/ethereum-unit-converter-gwei-ether/)
- [Version finie de la Dapp](https://goldananas.github.io/solidity-sffs-private/)
