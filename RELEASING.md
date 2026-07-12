# Releasing a new version

1. **Bump the version** in two places:
   - `nosleep`, the `VERSION="X.Y.Z"` constant
   - `man/nosleep.1`, the `.TH` header (`"nosleep X.Y.Z"`)

2. **Commit, tag, and release:**

   ```sh
   git commit -am "vX.Y.Z: <what changed>"
   git tag vX.Y.Z
   git push && git push origin vX.Y.Z
   gh release create vX.Y.Z --title "vX.Y.Z" --notes "<what changed>"
   ```

3. **Update the Homebrew formula** in [wynnwu/homebrew-tap](https://github.com/wynnwu/homebrew-tap):

   ```sh
   curl -sL https://github.com/wynnwu/nosleep/archive/refs/tags/vX.Y.Z.tar.gz | shasum -a 256
   ```

   Put the new tag in `url` and the new checksum in `sha256` in
   `Formula/nosleep.rb`, then commit and push the tap.

4. **Verify:**

   ```sh
   brew update && brew upgrade nosleep && brew test nosleep
   nosleep version
   ```

The curl installer needs no release step, it always serves `main`, so it picks
up the new version as soon as step 2's push lands.
