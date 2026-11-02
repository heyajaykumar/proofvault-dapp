# ProofVault: a blockchain notary for documents

## Project description
ProofVault lets anyone prove that a document existed, unchanged, at a specific moment. The file is hashed (SHA-256) in the browser, and only the hash, the owner's address and the block timestamp are stored on the Ethereum Sepolia test network. The file itself never leaves the user's computer. Anyone can later drop the same file into the Verify box to confirm it matches a recorded fingerprint, without needing a wallet.

## Real-world uses
- Students proving an assignment or project was completed before a deadline
- Institutions issuing certificates that employers can verify, with revoke support
- Freelancers and creators proving authorship of designs, code or writing at a given date
- Contracts and agreements where a tamper-proof timestamp matters

## Features
- Register a document fingerprint with a title (each fingerprint can be registered once)
- Verify any file instantly, with no wallet required (read-only RPC)
- Clear results: Verified, Revoked, or No record found
- "Your records" list for the connected wallet
- Revoke your own records (for example, an invalid certificate)
- Privacy by design: files are never uploaded
- MetaMask connection with automatic Sepolia switch, built with ethers.js v6

## Steps to deploy the smart contract

### Option A: Remix (quickest)
1. Open https://remix.ethereum.org, create `ProofVault.sol` and paste `contracts/ProofVault.sol`.
2. Compile with Solidity 0.8.24.
3. In **Deploy & Run**, select **Injected Provider - MetaMask** (network: Sepolia).
4. Click **Deploy**, confirm in MetaMask, and copy the contract address.

### Option B: Hardhat
```bash
npm install
cp .env.example .env     # fill SEPOLIA_RPC_URL and PRIVATE_KEY (test wallet only)
npm run compile
npm run deploy
```
Get Sepolia test ETH from a faucet first.

## Steps to run the frontend
1. Set `CONTRACT_ADDRESS` in `frontend/index.html` to your deployed address.
2. Run a local server:
   ```bash
   cd frontend
   python3 -m http.server 8000
   ```
3. Open http://localhost:8000 with MetaMask installed.
4. Connect wallet, choose a file, and click **Register on blockchain**.
5. Choose the same file in **Verify a document** to see the result. Change even one character of the file and verification fails.

## Contract address and network
- Network: **Sepolia testnet** (chain ID 11155111)
- Contract address: `0xYourContractAddressHere`
- Etherscan: https://sepolia.etherscan.io/address/0xYourContractAddressHere

## Screenshots
![ProofVault UI](screenshots/ui.png)

## Limitations
The blockchain proves a file existed by a given time, not who originally created it: the first wallet to register a fingerprint owns that record.

## License
MIT
