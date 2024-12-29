I'm trying to fix a neovim implentation of this language server that has very limited documentation. I want to send a custom client command to it to start a filetype preview. I keep getting the following error though related to the type of the argument that I am passing:

```
tinymist: -32602: expect Vec<String> at args[0], error: invalid type: string "/Users/sylvanfranklin/.config/test.typ", expected a sequence
```

The function that calls this, I wrapped it in this thing which is what other plugin authors say to do, but I'm not using either of the functions really so it currently doesn't matter

```lua
    local function client_with_fn(fn)
        return function()
            local bufnr = vim.api.nvim_get_current_buf()
            local client = util.get_active_client_by_name(bufnr, 'tinymist')
            if not client then
                return vim.notify(('tinymist client not found %d'):format(bufnr), vim.log.levels.ERROR)
            end
            fn(client, bufnr)
        end
    end

    local function Preview(client, bufnr)
        local buf_name = vim.api.nvim_buf_get_name(0)
        vim.lsp.buf.execute_command({ command = "tinymist.doStartPreview", arguments = { buf_name }, })
    end
```

How I set it up in the config

```lua
    -- other config stuff, tested to be correct
    ["tinymist"] = function()
        require("lspconfig")["tinymist"].setup {
            capabilities = capabilities,
            settings = {
                formatterMode = "typstyle"
            },
            commands = {
                TypstPreview = {
                    client_with_fn(Preview),
                    description = 'Start the Live Preview',
                },
                ExportPng = {
                    client_with_fn(Export),
                    description = 'Start the Live Preview',
                },
            }
        }
    end,
```

Now here is a working implentation for the same thing in typescript, however the argument structure looks more or less the same to me minus the extra stuff. Maybe that stuff is required but I'm not sure:


```ts
  async function launchCommand() {
    console.log(`Preview Command ${filePath}`);
    const partialRenderingArgs = getPreviewConfCompat<boolean>("partialRendering")
      ? ["--partial-rendering"]
      : [];
    const ivArgs = getPreviewConfCompat("invertColors");
    const invertColorsArgs = ivArgs ? ["--invert-colors", JSON.stringify(ivArgs)] : [];
    const previewInSlideModeArgs = task.mode === "slide" ? ["--preview-mode=slide"] : [];
    const dataPlaneHostArgs = !isDev ? ["--data-plane-host", "127.0.0.1:0"] : [];
    const { dataPlanePort, staticServerPort, isPrimary } = await commandStartPreview([
      "--task-id",
      taskId,
      "--refresh-style",
      refreshStyle,
      ...dataPlaneHostArgs,
      ...partialRenderingArgs,
      ...invertColorsArgs,
      ...previewInSlideModeArgs,
      ...(isNotPrimary ? ["--not-primary"] : []),
      filePath,
    ]);
    console.log(
      `Launched preview, data plane port:${dataPlanePort}, static server port:${staticServerPort}`,
    );
```

And if you follow these calls down you get to pretty much the same api:

```ts
export async function commandStartPreview(previewArgs: string[]): Promise<PreviewResult> {
  const res = await tinymist.executeCommand<PreviewResult>(`tinymist.doStartPreview`, [
    previewArgs,
  ]);
  return res || {};
}
```

Which then goes down to this:

```ts
  async executeCommand<R>(command: string, args: any[]) {
    return await (
      await this.getClient()
    ).sendRequest<R>("workspace/executeCommand", {
      command,
      arguments: args,
    });
  }
```

Do you have any ideas of where my code could be failing, it seems to work for other methods for instance the export png method. 
