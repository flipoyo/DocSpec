# Slidev helpers

This directory contains templates for the communication artifacts referenced by this repository.

## Files

- `.gitignore` — recommended ignore rules to copy into the root of a Slidev project before syncing it to Git.

## Getting started on Ubuntu 22+

The helper scripts are Bash scripts and are designed for Ubuntu 22+ with Node.js 20 or newer. Node.js 22 is recommended.

1. Install Node.js with `nvm`:

   ```bash
   sudo apt update
   sudo apt install -y curl
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
   source ~/.bashrc
   nvm install 22
   nvm use 22
   ```

2. Create a Project


```bash
npm create slidev@latest MyPresentation
cd .\MyPresentation
npm install
```

3. Launch a Project

```
npm run dev
```

5. Edit `MyPresentation/slides.md`.

Use whatever software such as code or codium. Launching the project makes it accessible from a simple webbrowser for a WYSWYG experience.


In that case, copy `slidev/.gitignore` into the project root before syncing the presentation to Git.
