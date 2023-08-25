<script>
    // @ts-nocheck
    import { onMount } from "svelte";
    import Web3 from "web3";
    import { createEventDispatcher } from "svelte";

    export let showConnectedWallet = false;
    let accounts = [];
    let connectedWallet = "";


    onMount(() => connectBrowserWallet());

    const dispatch = createEventDispatcher();

    const connectBrowserWallet = async () => {
        if (typeof window.ethereum === "undefined") {
            console.log(
                `You might install https://metamask.io or use https://brave.com with its integrated browserwallet`
            );
        } else {
            await updateAccountsList();
        }
        web3 = new Web3(web3.currentProvider);
        ethereum.on("accountsChanged", async (accounts) => {
            // alert(`in accountsChanged`);
            await updateAccountsList();
            dispatchWalletConnected();
        });

        dispatchWalletConnected();
    };

    const updateAccountsList = async () => {
        accounts = await ethereum.request({
            method: "eth_requestAccounts",
        });
        connectedWallet = accounts[0].toLowerCase();
    };

    const dispatchWalletConnected = () => {
        dispatch("walletConnected", {
            publicWalletAddress: connectedWallet,
            web3,
        });
    };

</script>

{#if connectedWallet !== undefined && showConnectedWallet}
    You are connected with wallet: {connectedWallet}
{/if}
