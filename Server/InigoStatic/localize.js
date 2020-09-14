#!/bin/env node

const { promisify } = require('util');
const { resolve } = require('path');
const fs = require('fs');
const path = require('path');
const readdir = promisify(fs.readdir);
const stat = promisify(fs.stat);

let [_n, _f, dir, output] = process.argv;
let skipExt = !!process.env['SKIP_EXT'];

if (!dir || !output) {
  console.error("usage: ./localize.js <dir> <output>");
  console.error();
  process.exit(1);
}

async function getFiles(dir) {
  return await doGetFiles(dir, dir);
}

async function doGetFiles(dir, root) {
  const subdirs = await readdir(dir);
  const files = await Promise.all(subdirs.map(async (subdir) => {
    const res = resolve(dir, subdir);
    return (await stat(res)).isDirectory() ? doGetFiles(res, root) : path.relative(root, res);
  }));
  return files.reduce((a, f) => a.concat(f), []);
}

async function run(dir, output, skipExt) {
  let files = await getFiles(dir);
  let result = await files.reduce(async(acc, file) => {
    let contents = await fs.promises.readFile(path.join(dir, file), 'utf8');
    let key = '/' + file;
    if (skipExt) {
      key = key.replace(/[.].*$/, '');
    }
    return {
      ...await acc,
      [key]: contents
    }
  }, {});

  await fs.promises.writeFile(output, JSON.stringify(result, null, 2));

  console.log(`Updated ${output} with ${files.length} file(s)`);
}

run(dir, output, skipExt);
