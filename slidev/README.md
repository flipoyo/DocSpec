# Slidev helpers

This directory contains helper files for creating and running [Slidev](https://sli.dev/) presentations for the communication artifacts referenced by this repository.

## Files

- `create_slidev_project.sh` — creates a new Slidev project and installs its dependencies.
- `launch_slidev_project.sh` — opens an existing Slidev project, installs dependencies if needed, optionally opens an editor, and starts the Slidev dev server.
- `.gitignore` — recommended ignore rules to copy into the root of a Slidev project before syncing it to Git.

## Getting started on Ubuntu 22+

The helper scripts are Bash scripts and are designed for Ubuntu 22+ with Node.js 20 or newer. Node.js 22 is recommended.

1. Install Node.js with `nvm`:

   ```bash
   sudo apt update
   sudo apt install -y curl
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
   source ~/.bashrc
   nvm install 22
   nvm use 22
   ```

2. From the repository root, create a presentation:

   ```bash
   ./slidev/create_slidev_project.sh MyPresentation
   ```

3. Copy the recommended Git ignore rules into the new project:

   ```bash
   cp ./slidev/.gitignore ./MyPresentation/.gitignore
   ```

4. Start the project:

   ```bash
   ./slidev/launch_slidev_project.sh ./MyPresentation codium
   ```

   Replace `codium` with `code` or `none` if needed.

5. Edit `MyPresentation/slides.md`.

## Windows

The helper scripts in this directory require Bash. On Windows, the simplest option is to use WSL2 with Ubuntu 22.04+ and follow the Ubuntu steps above.

If you prefer to work directly from PowerShell, create and run Slidev manually:

```powershell
npm create slidev@latest MyPresentation
cd .\MyPresentation
npm install
npm run dev
```

In that case, copy `slidev/.gitignore` into the project root before syncing the presentation to Git.
