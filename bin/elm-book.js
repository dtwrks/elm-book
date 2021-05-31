#! /usr/bin/env node

const exec = require("child_process").exec;
const entryPoint = process.argv[2];
const extraArgs = process.argv.slice(3).join(" ");

if (!entryPoint) {
  console.warn("elm-book: please specify your entry point.");
  process.exit(1);
} else {
  exec(
    `npx elm-live ${entryPoint} --pushstate --open ${extraArgs}`,
    (error, stdout, stderr) => {
      if (stdout) console.log(stdout);
      if (error) console.warn(error);
      if (stderr) console.error(stderr);
    }
  );
}
