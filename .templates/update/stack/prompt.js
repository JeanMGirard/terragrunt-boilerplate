const lib = require("../..");

module.exports = [
  {
    type: "select",
    name: 'stack',
    message: 'stack',
    choices: lib.stacks.all()
  },
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
