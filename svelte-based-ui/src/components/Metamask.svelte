<script>
    // @ts-nocheck
    import { onMount } from "svelte";
    import Web3 from "web3";
    import { createEventDispatcher } from "svelte";

    let accounts = [];
    let connectedWallet = "";
    let web3
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
        // alert("web3")
        // alert(web3)
        // alert("window.ethereum")
        // alert(JSON.stringify(window.ethereum))
        web3 = new Web3(window.ethereum);
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

You are connected with wallet: {connectedWallet}
