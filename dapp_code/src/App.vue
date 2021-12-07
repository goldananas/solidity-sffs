<template>
    <img alt="Foy logo" class="logo" src="./assets/foy.jpeg" />
    <Foy
        msg="🍻 Welcome to the new Foy ! 🍻"
        contractAddress="0x2Be101FCb263A4A491e006191FC8CA7FE977029e"
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
</style>
