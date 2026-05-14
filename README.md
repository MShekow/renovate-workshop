# renovate-workshop

This repo contains the material for Marius' **Renovate mob programming workshop**, held first at [CloudLand 2026](https://meine.doag.org/events/cloudland/2026/agenda/#agendaId.7304).

The slides shown at the beginning of the workshop are available [here](./renovate-introduction-slides.pdf).

<details>
<summary>How does <em>mob programming</em> work? (Click to expand)</summary>

One person, known as the **driver**, writes code (or follows other instructions, e.g., browsing on GitHub.com) while the others (known as **navigators**) read the workshop instructions out loud and tell the driver the concrete actions they should execute. The driver is not supposed to "think" much, but instead focuses on executing very concrete instructions. In this workshop, the driver rotates every 10-15 minutes, ensuring that everyone stays engaged and has an opportunity to contribute.

</details>

## Workshop instructions

There are different instructions, depending on how you want to participate:

- If you want to **join the mob session**:
  - Open the [README-mob-navigator.md](README-mob-navigator.md), follow the instructions in the first section (`Preparation work`) to set your Visual Studio Code Live Share browser/app client as _mob participant_
  - Open the [README-mob-driver.md](README-mob-driver.md), just **read** (don't **do** the things yet) of the `Becoming a driver` section, so that you already have an idea how to be a driver, once it is your turn
- If you want to **work on the tasks on your own**, only read the [README-selfpaced.md](README-selfpaced.md)
 
## Repo contents

FYI: This _mono_ repo contains small "quote-generator" demo web apps, implemented in different languages (Python, Rust, Golang, Node), to illustrate Renovate's features.

These demo apps are based on [this code](https://github.com/earthly/earthly-vs-gha/tree/b1a269defdfb3d3219a3285f5921cb0bb876304d), and are built/tested using [Earthly](https://github.com/earthly/earthly), a Docker-based build tool that is no longer maintained, but it still works.
