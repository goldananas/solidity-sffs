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
// import { onBeforeMount } from "vue";

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
            this.foyContract.methods
                .buyChouffe()
                .send({ from: this.connectedAccount, value: this.prixChouffe })
                .once("receipt", () => {
                    this.getInventory();
                });
        },
        buyTripleGrim() {
            this.foyContract.methods
                .buyTripleGrim()
                .send({
                    from: this.connectedAccount,
                    value: this.prixTripleGrim,
                })
                .once("receipt", () => {
                    this.getInventory();
                });
        },
        buyLaBete() {
            this.foyContract.methods
                .buyLaBete()
                .send({ from: this.connectedAccount, value: this.prixLaBete })
                .once("receipt", () => {
                    this.getInventory();
                });
        },
        async getNormalPrices() {
            let price = await this.foyContract.methods.getNormalPrices().call();
            this.prixChouffe = price[0];
            this.prixLaBete = price[1];
            this.prixTripleGrim = price[2];
        },
        async getHHPrices() {
            let price = await this.foyContract.methods
                .getPricesHappyHour()
                .call();
            this.prixChouffe = price[0];
            this.prixLaBete = price[1];
            this.prixTripleGrim = price[2];
        },
        async getInventory() {
            let inventory = await this.foyContract.methods
                .getMyInventory()
                .call({ from: this.connectedAccount });

            this.invChouffe = inventory[0];
            this.invLaBete = inventory[1];
            this.invTripleGrim = inventory[2];
        },
        async getOwner() {
            let owner = await this.foyContract.methods
                .getOwner()
                .call({ from: this.connectedAccount });

            this.isOwner = this.connectedAccount == owner;
        },
        async happyHour() {
            await this.foyContract.methods
                .happyHour(this.durationModel)
                .send({ from: this.connectedAccount });
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

        this.foyContract = new this.web3.eth.Contract(
            FoyABI,
            this.contractAddress
        );

        this.foyContract.events.HappyHourStart().on("data", event => {
            this.isHappyHour = true;
            let end = +event.returnValues.duration;
            this.startHappyHourCountDown(end);
        });

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

        this.getOwner();

        this.getNormalPrices();

        this.getInventory();
    },
};
</script>

<style scoped>
.table-container {
    border-radius: 14px;
    border: 4px solid #f2edeb;
    overflow: hidden;
}

.styled-table {
    border-collapse: collapse;
    font-size: 0.9em;
    font-family: sans-serif;
    min-width: 400px;
    overflow: hidden;
    margin: 0 auto;
}

.styled-table button {
    background-color: #737373; /* Green */
    border: none;
    border-radius: 0.6rem;
    color: white;
    font-weight: bold;
    padding: 0.2rem 0.6rem;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    cursor: pointer;
    transform: translateY(-2px);
    box-shadow: 0px 4px 0px 0px #0d0d0d;
}

.styled-table button:hover {
    transform: translateY(0px);
}

.styled-table thead tr {
    background-color: #0d0d0d;
    color: #ffffff;
    text-align: center;
}

.styled-table th,
.styled-table td {
    padding: 12px 15px;
}

.styled-table tbody tr:nth-of-type(even) {
    background-color: #262626;
}

.styled-table tbody tr:nth-of-type(odd) {
    background-color: #404040;
}

.styled-table tbody tr:last-of-type {
    border-bottom: none;
}

.styled-table button:hover {
    box-shadow: 0 0 10px 0 grey;
}

.styled-table button {
    transition: box-shadow 150ms linear;
}

.owner-dashboard input {
    width: 30px;
}

.owner-dashboard input:focus {
    outline: none;
}

.happyhour {
    font-weight: 800;
    padding: 1rem;
}

.normal-weight {
    font-weight: normal;
}

.rainbow-text {
    color: transparent;

    font-family: "Poppins", sans-serif;
    font-size: 60px;
    letter-spacing: 0.05em;
    background: linear-gradient(
        #fd004c 16.7%,
        #fe9000 16.7%,
        #fe9000 33.4%,
        #fff020 33.4%,
        #fff020 50.1%,
        #3edf4b 50.1%,
        #3edf4b 66.8%,
        #3363ff 66.8%,
        #3363ff 83.5%,
        #b102b7 83.5%
    );
    -webkit-text-stroke: 0.04em #ffffff;
    -webkit-background-clip: text;
    background-clip: text;
    line-height: 1.1em;
    animation: rainbow 30s linear infinite;
    box-sizing: border-box;
}

@keyframes rainbow {
    100% {
        background-position: 0 30em;
    }
}
</style>
