# Workshop instructor README

This is **only** for the workshop **instructor**, _not_ for **participants**.

## Repo and Remote desktop preparation work (_workshop instructor only_)

- Import the repo to a GitHub throwaway account (to get the "repo-copy")
- In the repo-copy, start a GitHub Codespace. Inside that Codespace:
  - Install the _Live Share_ extension, start a session and add the session link in the Google doc
  - In the terminal: `VNC_PASSWORD=your-choice ./setup-vnc.sh`
  - In the terminal: `./start-vnc-and-browser.sh`
  - In the _Ports_ tab, set the Privacy of the 6080 port to _Public_ and distribute the URL and VNC password in the chat
