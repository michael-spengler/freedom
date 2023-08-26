<script>
  import Seo from "./Seo.svelte";
  import { onMount } from "svelte";
  import Metamask from "./components/Metamask.svelte";
  import { erc20ABI } from "./freedom-abi";
  import Web3 from "web3";

  // const smartContractAddress = "0xf709B84402D6d3a082Bf63Ca70565F0ac174357E"; // on Modulus Testnet
  // const smartContractAddress = "tbd"; // on Modulus Mainnet
  const smartContractAddress = "0xAbAF0b69662750Fe13C69816e793545629B30f71"; // on Polygon zkEVM

  let proofLink = "";
  let publicWalletAddress;
  let web3;
  let theERC20Contract;
  let ready = false;
  let helper = "";
  let balanceOfFreedomOfConnectedWallet;
  let currentThreshold;
  let approvedMembers = [];
  let prospects = [];

  onMount(async () => {});

  let topNavClass = "topnav";

  function toggleTopNavCSSClass() {
    if (topNavClass === "topnav responsive") {
      topNavClass = "topnav";
    } else {
      topNavClass = "topnav responsive";
    }
  }

  const handleWalletConnected = async (event) => {
    publicWalletAddress = event.detail.publicWalletAddress;
    web3 = event.detail.web3;
    theERC20Contract = new web3.eth.Contract(erc20ABI, smartContractAddress);
    if (publicWalletAddress.length > 0) {
      setTimeout(async () => {
        balanceOfFreedomOfConnectedWallet = await (
          await theERC20Contract.methods.balanceOf(
            "0x9E972a43B3B8D68cD70930697E16429E47E88151"
          )
        ).call();

        helper = await (await theERC20Contract.methods.getProspects()).call();

        for (let prospectEntry of helper) {
          const splitArray = prospectEntry.toString().split(",");
          
          const prospect = {
            walletAddressOfMember: splitArray[0],
            appliedOn: splitArray[1],
            proofLink: splitArray[2],
            amountOfReceivedApprovals: splitArray[3],
            approvedOn: splitArray[4],
            approversForThisMember:
            "can stay empty - maybe also not needed in get... in SC only for duplicate approvals check it might be helpful",
          };
          
          prospects.push(prospect);
          console.log(prospects);
        }
        
          helper = await (
          await theERC20Contract.methods.getApprovedMembers()
          ).call();
          
          for (let approvedMemberEntry of helper) {
            const splitArray = approvedMemberEntry.toString().split(",");
            
            const approvedMember = {
              walletAddressOfMember: splitArray[0],
              appliedOn: splitArray[1],
              proofLink: splitArray[2],
              amountOfReceivedApprovals: splitArray[3],
              approvedOn: splitArray[4],
              approversForThisMember:
              "can stay empty - maybe also not needed in get in SC only for duplicate approvals check it might be helpful",
            };
            approvedMembers.push(approvedMember);
          }

        currentThreshold = await (
          await theERC20Contract.methods.threshold()
        ).call();

        ready = true;
        console.log(balanceOfFreedomOfConnectedWallet);
      }, 1 * 1000);
    }
  };

  async function joinUs() {
    const result = await (
      await theERC20Contract.methods.applyForMembership(proofLink)
    ).call();
    console.log(result);
  }

  async function approveProspect() {
    const result = await (
      await theERC20Contract.methods.approveMembership(proofLink)
    ).call();
    console.log(result);
  }
</script>

<Seo
  title="Freedom"
  description="We are a freedom network. We supporting those who support fairness, freedom and peace."
/>

<link
  rel="stylesheet"
  class="linkWhite"
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
/>

<div class={topNavClass} id="myTopnav">
  <!-- svelte-ignore a11y-missing-attribute -->
  <a
    href="https://github.com/michael-spengler/freedom/"
    target="_blank"
    class="linkWhite">Check The Code</a
  >
  <!-- svelte-ignore a11y-missing-attribute -->
  <a
    href="https://github.com/michael-spengler/freedom/issues/new"
    target="_blank"
    class="linkWhite">Give Feedback</a
  >
  <!-- svelte-ignore a11y-missing-attribute -->
  <a class="icon" on:click={toggleTopNavCSSClass}>
    <i class="fa fa-bars" />
  </a>
</div>

<main class="container">
  <div class="text-center">
    <h1>Freedom</h1>

    <p><br /><br /></p>

    Let us explore tools, architectures and incentive systems for freedom.

    <p><br /><br /></p>

    <div class="input-group">
      <!-- svelte-ignore a11y-autofocus -->
      <input
        type="proofLink"
        bind:value={proofLink}
        placeholder="add link to proof that you care about freedom"
      />
    </div>
    <p><br /></p>
    {#if proofLink.length > 0}
      <button on:click={joinUs}> Send </button>
    {/if}

    <p><br /></p>

    Other Holders provided e.g. the following links:
    <p><br /></p>
    {#if ready}
      {#each approvedMembers as approvedMember}
        {approvedMember.walletAddressOfMember} <br />
        <a href={approvedMember.proofLink} class="linkWhite" target="_blank"
          >{approvedMember.proofLink}</a
        >
        <p><br /></p>
      {/each}
      <p><br /></p>
      <hr />
      <p><br /></p>
      <hr />
      <p><br /></p>
      <p><br /></p>
      {#if prospects.length > 0}
        Please approve the following prospects if you like their link:

        <p><br /></p>
      {/if}

      {#each prospects as prospect}
        {prospect.walletAddressOfMember} <br />
        <a href={prospect.proofLink} class="linkWhite" target="_blank"
          >{prospect.proofLink}</a
        >
        <p><br /></p>
        <button on:click={approveProspect}> Approve Prospect </button>
        <p><br /></p>
        <hr />
        <p><br /></p>
      {/each}
      <p><br /></p>

      The current threshold for being community approved is: {currentThreshold}
    {/if}
    <p><br /></p>
    <Metamask on:walletConnected={handleWalletConnected} />

    <p><br /></p>

    <p><br /></p>
  </div>
</main>

<style>
  .assetsArea {
    max-height: 140vh;
    overflow-y: scroll;
  }

  ::-webkit-scrollbar {
    display: none;
  }
  .whiteLink {
    color: white;
  }
  h1 {
    color: white;
    font-size: 42;
  }

  .topnav {
    overflow: hidden;
    background-color: rgb(0, 153, 255);
  }

  .topnav a {
    float: left;
    display: block;
    color: white;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
    font-size: 20px;
  }

  .topnav a:hover {
    background-color: white;
    color: black;
  }

  .topnav .icon {
    display: none;
  }

  @media screen and (max-width: 600px) {
    .topnav a:not(:first-child) {
      display: none;
    }
    .topnav a.icon {
      float: right;
      display: block;
    }
  }

  @media screen and (max-width: 600px) {
    .topnav.responsive {
      position: relative;
    }
    .topnav.responsive .icon {
      position: absolute;
      right: 0;
      top: 0;
    }
    .topnav.responsive a {
      float: none;
      display: block;
      text-align: left;
    }
  }
</style>
