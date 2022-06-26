const path = require("path")
const fs = require("fs")

const root_dir = path.resolve(__dirname, "../..")
const stacks_dir = path.resolve(root_dir, "modules/stacks")

function getAllStacks() {
  return getDirectories2(stacks_dir)
    .filter(dir => !dir.startsWith('_'))
    .map(dir => ({ name: dir, value: dir }))
}

const handlerFactory = () => {
    return {
      all: () => getAllStacks()
    }
}

const getDirectories = (source) => fs.readdirSync(source, { withFileTypes: true })
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name)

const getDirectories2 = (source) => [].concat(...getDirectories(source)
  .map(name => getDirectories(path.join(source, name))
    .map(name2 => `${name}/${name2}`)
  ))


module.exports = handlerFactory()
