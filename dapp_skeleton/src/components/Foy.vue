<template>
    <h1>
        <span class="normal-weight">🍻</span> Welcome to the new Foy !
        <span class="normal-weight">🍻</span>
    </h1>
    <p v-if="connectedAccount">
        Connected with account : {{ connectedAccount }}
    </p>
    <p v-else>Please connect your wallet</p>
    <div class="table-container">
        <table class="styled-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Price (ether)</th>
                    <th>Inventory</th>
                    <th>Buy</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Chouffe</td>
                    <td>{{ (prixChouffe * 1e-18).toFixed(4) }}</td>
                    <td>{{ invChouffe }}</td>
                    <td><button @click="buyChouffe">Buy 1</button></td>
                </tr>
                <tr>
                    <td>La Bête</td>
                    <td>{{ (prixLaBete * 1e-18).toFixed(4) }}</td>
                    <td>{{ invLaBete }}</td>
                    <td><button @click="buyLaBete">Buy 1</button></td>
                </tr>
                <tr>
                    <td>Triple Grim</td>
                    <td>{{ (prixTripleGrim * 1e-18).toFixed(4) }}</td>
                    <td>{{ invTripleGrim }}</td>
                    <td><button @click="buyTripleGrim">Buy 1</button></td>
                </tr>
            </tbody>
        </table>
    </div>
    <div>
        <p v-if="isHappyHour" class="happyhour">
            <span class="rainbow-text"> HAPPY HOUR </span>
        </p>
        <p v-if="isHappyHour" class="happyhour">
            TIME REMAINING :
            {{ duration }}
        </p>
        <p v-else>Come back later for the happy hour.</p>
    </div>
    <div v-if="isOwner" class="owner-dashboard">
        <h2>
            <span class="normal-weight">💼</span> Owner dashboard
            <span class="normal-weight">💼</span>
        </h2>
        Happy hour duration :
        <input placeholder="time" v-model="durationModel" /> sec
        <button @click="happyHour()">Start</button>
    </div>
    <a
        :href="'https://rinkeby.etherscan.io/address/' + contractAddress"
        target="_blank"
        rel="noopener noreferrer"
        >Etherscan contract</a
    >
    <a
        v-if="connectedAccount !== ''"
        :href="'https://rinkeby.etherscan.io/address/' + connectedAccount"
        target="_blank"
        rel="noopener noreferrer"
        >Etherscan account</a
    >
</template>

<script>
import Web3 from "web3";
import FoyABI from "../abi.json";

export default {
    name: "Foy",
    props: {
        msg: String,
        contractAddress: String,
    },
    data: function () {
        return {
            durationModel: 0,
            duration: 0,
            isOwner: false,
            isHappyHour: false,
            prixChouffe: 0,
            prixLaBete: 0,
            prixTripleGrim: 0,
            invChouffe: 0,
            invLaBete: 0,
            invTripleGrim: 0,
            connectedAccount: "",
            web3: new Web3(Web3.givenProvider || "ws://localhost:8545"),
            foyContract: null,
        };
    },

    methods: {
        buyChouffe() {
            // TODO 4
        },
        buyTripleGrim() {
            // TODO 4
        },
        buyLaBete() {
            // TODO 4
        },
        async getNormalPrices() {
            // TODO 4 : Get normal prices
            // this.prixChouffe = ?;
            // this.prixLaBete = ?;
            // this.prixTripleGrim = ?;
        },
        async getHHPrices() {
            // TODO 4 : Get happy hour prices
            // this.prixChouffe = ?;
            // this.prixLaBete = ?;
            // this.prixTripleGrim = ?;
        },
        async getInventory() {
            // TODO 4 : Get account inventory
            // this.invChouffe = ?;
            // this.invLaBete = ?;
            // this.invTripleGrim = ?;
        },
        async getOwner() {
            // TODO 4 : Get contract's owner
            // this.isOwner = ?;
        },
        async happyHour() {
            // TODO 4 : Start happy hour
        },
        startHappyHourCountDown(end) {
            if (Math.floor(Date.now() / 1000) < end) {
                this.isHappyHour = true;
                this.duration = end - Math.floor(Date.now() / 1000);
                this.getHHPrices();
                var myInterval = setInterval(() => {
                    this.duration--;
                    if (this.duration === 0) {
                        clearInterval(myInterval);
                        this.isHappyHour = false;
                        this.getNormalPrices();
                    }
                }, 1000);
            }
        },
    },

    async created() {
        const accounts = await this.web3.eth.requestAccounts();
        this.connectedAccount = accounts[0];

        // Create contract object
        this.foyContract = new this.web3.eth.Contract(
            FoyABI,
            this.contractAddress
        );

        // TODO 6 : Handle Happy Hour events

        // This part handle old Happy Hour events, if the page is loaded during the happy hour
        this.foyContract
            .getPastEvents("HappyHourStart", {
                fromBlock: 0,
                toBlock: "latest",
            })
            .then(events => {
                if (events.length > 0) {
                    let end = +events[events.length - 1].returnValues.duration;
                    this.startHappyHourCountDown(end);
                }
            });

        // Retrieve data at component creation
        this.getOwner();
        this.getNormalPrices();
        this.getInventory();
    },
};
</script>
