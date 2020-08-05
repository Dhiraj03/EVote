
module.exports = {
  networks: {
    development: {
      networkCheckTimeout:1000000,
      host: "192.168.0.12",
      port: 7545,
      network_id: "*", // Match any network id
    },
    advanced: {
      websockets: true, // Enable EventEmitter interface for web3 (default: false)
    },
  },
  contracts_build_directory: "./src/abis/",
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};