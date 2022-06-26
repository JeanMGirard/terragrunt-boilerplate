const fs = require("fs");
const path = require("path");

const root_dir = path.resolve(__dirname, "../..")
const envs_dir = path.resolve(root_dir, "staging")

function getAllEnvironments() {
  return getDirectories(envs_dir)
    .filter(dir => !dir.startsWith('_'))
    .map(dir => ({ name: dir, value: dir }))
}


const handlerFactory = () => {
    return {
      all: () => getAllEnvironments()
    }
}


const getDirectories = source => fs.readdirSync(source, { withFileTypes: true })
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name)



module.exports = handlerFactory()
