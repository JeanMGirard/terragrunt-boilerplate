const lib = require("../..");

module.exports = [
  {
    type: "select",
    name: 'region',
    message: 'region',
    choices: lib.regions.aws.all()
  },
  {
    type: 'input',
    name: 'env',
    message: "What environment?"
  },
]
