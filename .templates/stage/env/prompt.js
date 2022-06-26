const lib = require("../..");

module.exports = [
  {
    type: 'input',
    name: 'env',
    message: "What environment?"
  },
  {
    type: "multiselect",
    name: 'regions',
    message: 'regions',
    choices: lib.regions.aws.all()
  },
  {
    type: "multiselect",
    name: 'stacks',
    message: 'stacks',
    choices: lib.stacks.all()
  }
]
