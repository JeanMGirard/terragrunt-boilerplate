const lib = require("../..");

module.exports = [
  {
    type: 'select',
    name: 'env',
    message: "What environment?",
    choices: lib.environments.all()
  },
  {
    type: "select",
    name: 'region',
    message: 'region',
    choices: lib.regions.aws.all()
  },
]
