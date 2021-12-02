# ZSH Completions directory

Any files placed in this directory will be included in the `zsh` `fpath` and will be indexed as
autocompletion data for ZSH tab-completion.

## Usage

If you have a command with `zsh` autocompletion that is not supported via an `oh-my-zsh` plugin or
other built-in mechanism, you can save the `zsh` completion script in this directory, named for the
command that they should be called for.

### Example

`kustomize` has `zsh` autocompletion, but no `omzsh` plugin. Thus, we save the `kustomize` `zsh`
completion output here as `_kustomize`, and `zsh` will then automatically use this script for
autocompletion when you type `kustomize <TAB>` in a terminal.

In .zshrc:

```console
❯ kustomize completion zsh > "${COMPLETIONS_DIR}/_kustomize"
```

In a terminal:

```console
❯ kustomize<TAB>

build                      -- Build a kustomization target from a directory or URL.
cfg                        -- Commands for reading and writing configuration.
completion                 -- Generate shell completion script
create                     -- Create a new kustomization in the current directory
docs-fn                    -- [Alpha] Documentation for developing and invoking Configuration Functions.
docs-fn-spec               -- [Alpha] Documentation for Configuration Functions Specification.
docs-io-annotations        -- [Alpha] Documentation for annotations used by io.
docs-merge                 -- [Alpha] Documentation for merging Resources (2-way merge).
docs-merge3                -- [Alpha] Documentation for merging Resources (3-way merge).
edit                       -- Edits a kustomization file
fn                         -- Commands for running functions against configuration.
help                       -- Help about any command
tutorials-command-basics   -- [Alpha] Tutorials for using basic config commands.
tutorials-function-basics  -- [Alpha] Tutorials for using functions.
version                    -- Prints the kustomize version

❯ kustomize build<TAB>

--enable-alpha-plugins        -- enable kustomize plugins
--enable-exec                 -- enable support for exec functions (raw executables); do not use for untrusted configs! (Alpha)
--enable-helm                 -- Enable use of the Helm chart inflator generator.
--enable-managedby-label      -- enable adding app.kubernetes.io/managed-by
--enable-star                 -- enable support for starlark functions. (Alpha)
--env                     -e  -- a list of environment variables to be used by functions
--helm-command                -- helm command (path to executable)
--load-restrictor             -- if set to 'LoadRestrictionsNone', local kustomizations may load files from outside their root. This does, however, break the relocatability of the kustomiza
--mount                       -- a list of storage options read from the filesystem
--network                     -- enable network access for functions that declare it
--network-name                -- the docker network to run the container in
--output                  -o  -- If specified, write output to this path.
--reorder                     -- Reorder the resources just before output. Use 'legacy' to apply a legacy reordering (Namespaces first, Webhooks last, etc). Use 'none' to suppress a final r
--stack-trace                 -- print a stack-trace on error
```
