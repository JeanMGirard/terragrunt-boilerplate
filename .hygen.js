const path = require("path")

const dir_staging = () =>  path.join(__dirname, "staging")
const dir_env = (args={})=> path.join(dir_staging(), args.env)
const dir_region = (args={})=> path.join(dir_env(args), args.region)

//.hygen.js
module.exports = {
    templates: `${__dirname}/.templates`,
    helpers: {
        // relative: (from, to) => path.relative(from, to),
      root: ()=> __dirname,
      src: dir_staging,
      unless_exists: () => true,
      dir_env: (args) => dir_env(args),
      dir_region: (args) => dir_region(args)
    }
}
