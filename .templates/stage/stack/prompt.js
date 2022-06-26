const lib = require("../..");

module.exports = [
  {
    type: 'input',
    name: 'env',
    message: "What environment?"
  },
  {
    type: "select",
    name: 'region',
    message: 'region',
    choices: lib.regions.aws.all()
  }
]
