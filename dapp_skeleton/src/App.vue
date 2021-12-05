<template>
    <img alt="Foy logo" class="logo" src="./assets/foy.jpeg" />
    <Foy
        msg="🍻 Welcome to the new Foy ! 🍻"
        contractAddress="0x9A25e54BA4908183b0081A2D7b26775CD78d1f32"
    />
    <iframe
        width="300"
        height="169"
        src="https://www.youtube.com/embed/CYsDi-Q5k5o"
        title="YouTube video player"
        frameborder="0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen
        class="player"
    ></iframe>
</template>

<script>
import Foy from "./components/Foy.vue";

export default {
    name: "App",
    components: {
        Foy,
    },
};
</script>

<style>
body {
    background: #0d0d0d;
    color: #f2edeb;
    margin: 0;
    padding: 0;
}
#app {
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    font-family: "Roboto", sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 2rem;
}

.player {
    border: 3px solid #f2edeb;
    border-radius: 1rem;
    border-width: 3px;
    margin: 1.4rem 0;
}

a {
    color: #f2edeb;
}

img.logo {
    border-radius: 100%;
    border: 3px solid #f2edeb;
}

img {
    max-width: 100px;
}
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
