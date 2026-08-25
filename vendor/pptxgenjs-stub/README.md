# pptxgenjs stub

`@slidev/cli` depends on `pptxgenjs` unconditionally, but only loads it via a dynamic
`import("pptxgenjs")` inside its pptx-export code path (`slidev export --format pptx`).
This template only ever exports PDF, so that path never runs.

`pptxgenjs` pulls in `image-size`, which has two open high-severity advisories
([GHSA-w3rx-r6r6-pgpr](https://github.com/advisories/GHSA-w3rx-r6r6-pgpr),
[GHSA-5p2g-fcmc-qvqq](https://github.com/advisories/GHSA-5p2g-fcmc-qvqq)) affecting
every published version, including the latest. There is no real fix to apply.

`package.json`'s `overrides` redirects `pptxgenjs` to this local no-op package, which
drops `image-size` (and the advisories) out of `node_modules` entirely. If pptx export
is ever attempted, it fails with a clear error instead of silently mis-behaving.

To re-enable real pptx export, remove the `pptxgenjs` entry from `overrides` in
`package.json` and run `pixi run install-npm`.
