<script>
  // import FileUploadForm from "./components/FileUploadForm.svelte";
  import Seo from "./Seo.svelte";
  import { onMount } from "svelte";
  import Metamask from "./components/Metamask.svelte";


  let searchTerm = "";
  let publicWalletAddress;
  let web3;

  onMount(async () => {
    setTimeout(() => {
      // optimizing speed for first meaningful content display ... https://pagespeed.web.dev/
    }, 1000 * 1);
  });

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
  };
  
</script>

<Seo
  title="Freedom"
  description="We are a freedom network. We supporting those who support fairness, freedom and peace."
/>

<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
/>

<div class={topNavClass} id="myTopnav">
  <!-- svelte-ignore a11y-missing-attribute -->
  <a
    href="https://github.com/cultfamily-on-github/cult-donations-microservice/issues/new"
    target="_blank"
    class="linkChampagne">Give Feedback</a
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

      This currency lets you explore tools and architectures of freedom.



      <p><br /><br /></p>

      <div class="input-group">
        <!-- svelte-ignore a11y-autofocus -->
        <input
          type="proofLink"
          bind:value={searchTerm}
          placeholder="add link to proof that you care about freedom"
        />
      </div>



    <p><br /></p>

    

    <p><br /></p>

    

    <p><br /></p>

    <Metamask
    on:walletConnected={handleWalletConnected}
    showConnectedWallet={false}
  />

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
    color: #efdcb3;
  }
  h1 {
    color: #d7c69d;
  }

  .topnav {
    overflow: hidden;
    background-color: black;
  }

  .topnav a {
    float: left;
    display: block;
    color: #efdcb3;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
    font-size: 17px;
  }

  .topnav a:hover {
    background-color: #efdcb3;
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
