
function getAllStacks() {
  return [
    { name: "network", value: "network" }
  ]
}

const handlerFactory = () => {
    return {
      all: () => getAllStacks()
    }
}


module.exports = handlerFactory()
