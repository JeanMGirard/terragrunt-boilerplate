const lib = require("../..");

module.exports = [
  {
    type: "select",
    name: 'stack',
    message: "What stack ?",
    choices: lib.stacks.all()
  },
  {
    type: 'select',
    name: 'env',
    message: "What environment ?",
    choices: lib.environments.all()
  },
  {
    type: "multiselect",
    name: 'regions',
    message: "What regions ?",
    choices: lib.regions.aws.all()
  }
]
