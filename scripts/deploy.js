const main = async () => {
    const [deployer] = await ethers.getSigners();
    console.log("Contract Deployed by 👤:", deployer.address);
    console.log("Account Balance:", (await deployer.getBalance()).toString());

    const nftContractFactory = await hre.ethers.getContractFactory("BuidLoot");
    const nftContract = await nftContractFactory.deploy() 
    await nftContract.deployed()
    console.log("Contract Deployed to 📄:", nftContract.address)
    
    //Call the mint function
    
    let txn = await nftContract.createBuidloot()
    await txn.wait()
    console.log("Minted NFT #1 🎉")
    
    txn = await nftContract.createBuidloot()
    await txn.wait()
    console.log("Minted NFT #2 🎉")
}
    
const runMain = async () => {
        try {
            await main()
            process.exit(0)
        } catch (error) {
            console.error(error)
            process.exit(1)  // 1    
        }
    };
    
runMain();