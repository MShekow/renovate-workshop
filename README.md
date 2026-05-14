# renovate-workshop

This repo contains the material for Marius' **Renovate mob programming workshop**, held first at [CloudLand 2026](https://meine.doag.org/events/cloudland/2026/agenda/#agendaId.7304).

The slides shown at the beginning of the workshop are available [here](./renovate-introduction-slides.pdf).

## How does _mob programming_ work?

One person, known as the **driver**, writes code (or follows other instructions, e.g., browsing on GitHub.com) while the others (known as **navigators**) read the workshop instructions out loud and tell the driver the concrete actions they should execute. The driver is not supposed to "think" much, but instead focuses on executing very concrete instructions. In this workshop, the driver rotates every 10-15 minutes, ensuring that everyone stays engaged and has an opportunity to contribute.

## Preparation work for _mob session_ participants

If you want to take part in the _mob session_:
- You were given a piece of paper with an anonymous number and a link to the _chat_ session. In the chat, you found the link to this GitHub repo. Keep the browser tab with this repo's README open throughout the session.
- Join the VS Code **Live Share** mob session (link in the chat). Choose **one** of the following approaches:
  - **Browser (recommended):**
    - In Chrome/Chromium/Microsoft Edge, open the link to the VS Code live share that Marius posted in the chat
    - Choose "Continue in web", then "Continue as anonymous"
    - In the prompt at the top, use your **number** as username
    - After a short moment, you should see the files of the project
  - **Local VS Code installation:**
    - If you prefer to use your _local_ VS Code installation (e.g., because you want to use your keyboard shortcuts), and if you can live with the disadvantage that you might not be able to join _anonymously_, you can also install the "Live Share" extension and join the session, using the link that Marius posted in the chat.

Whenever it is your turn, join the _remote desktop_ (VNC) session using your browser. The link to it is posted to the chat.

## Preparation work for _individual_ participants

If you **don't** want to join the mob but work in your _own_ repository copy (or if you are the instructor), follow these steps:

- Open https://github.com/new/import to make a _copy_ of this repo (_forking_ would work too, but it is less anonymous)
- Grant access to the Renovate GitHub app to the _repo-copy_
  - Open https://github.com/apps/renovate and in the top-right corner of the page click **Install** (or **Configure**)
  - Select the _GitHub organization_ of the repo-copy (that's usually your GitHub username)
  - Choose _Only select repositories_ and select the repo-copy
  - Click **Install** (or **Save**)
  - You will be redirected to https://developer.mend.io/install:
    - For the **product**, choose "Renovate only"
    - For the **mode**, choose "Scan and alert"
    - Click _Finish_
 
## Preparation work for the _first driver_

- Connect to the "remote control" (noVNC) as instructed in the Google Doc that contains the links to the workshop material
- In the VNC session: Grant access to the Renovate GitHub app to the _repo-copy_
  - Open https://github.com/apps/renovate and in the top-right corner of the page click **Install** (or **Configure**)
  - Select the _GitHub organization_ of the repo-copy (that's usually your GitHub username)
  - Choose _Only select repositories_ and select the repo-copy
  - Click **Install** (or **Save**)
  - You will be redirected to https://developer.mend.io/install:
    - For the **product**, choose "Renovate only"
    - For the **mode**, choose "Scan and alert"
    - Click _Finish_

## Remote desktop preparation work (_workshop instructor only_)

- Start the GitHub Codespace
- Install the _Live Share_ extension, start a session and post the session link in the chat
- In the terminal: `VNC_PASSWORD=your-choice ./setup-vnc.sh`
- In the terminal: `./start-vnc-and-browser.sh`
- In the _Ports_ tab, set the Privacy of the 6080 port to _Public_ and distribute the URL and VNC password in the chat

## Repo contents

This _mono_ repo contains small "quote-generator" demo web apps, implemented in different languages (Python, Rust, Golang, Node), to illustrate Renovate's features.

These demo apps are based on [this code](https://github.com/earthly/earthly-vs-gha/tree/b1a269defdfb3d3219a3285f5921cb0bb876304d), and are built/tested using [Earthly](https://github.com/earthly/earthly), a Docker-based build tool that is no longer maintained, but it still works.

## Task 1: Renovate _repository onboarding_

After granting the GitHub Renovate app access to the repo-copy, we can see that Renovate created an _onboarding PR_ named "Configure Renovate" in the repo. The goal of this PR is to allow you to _tune_ the Renovate-config for this repo, and provide you with a _preview_ of the PRs Renovate will create, once you merged this Onboarding PR. The basic idea is that Renovate will only do any real work if you completed its onboarding, to protect your repo from a flood of unwanted/accidental dependency-update-PRs.

Let's closely look at it the Onboarding PR's description:
- The **Detected Package Files** shows in which files the different [managers](https://docs.renovatebot.com/modules/manager/) (such as `npm`) found various dependencies. _Managers_ are Renovate's file parsers that find pinned dependencies in your repository. Each manager knows which files to look for (e.g. `requirements.txt` for `pip_requirements`), and can parse their internal structure, to identify dependencies.
- The **Configuration Summary** section lists how Renovate is configured. Renovate has dozens of detailed configuration options (briefly scroll through the [full list](https://docs.renovatebot.com/configuration-options/) to get a glimpse - do this now). The PR lists many applied configurations, but we did not really do anything yet! To understand this, we need to examine this PR's contents: Renovate only added a repo-specific configuration file, `renovate.json`. It tells Renovate how to behave for that repo (if you have multiple repos, you configure Renovate differently for each one). Currently, `renovate.json` is basically empty, except that it `extends` the `"config:recommended"` preset. It is one of many configuration presets baked into Renovate. Look at its documentation [here](https://docs.renovatebot.com/presets-config/#configrecommended). This preset _recursively_ loads other presets (they are organized like a _tree_) and the "leaf" presets actually set some specific configuration option.
- The **What to expect** section lists all Dependency-update PRs that Renovate will (ultimately) create. However, it also mentions an _hourly limit_.

Before we merge the Onboarding PR, let's tune the `renovate.json` by making the following changes to it in the `renovate/configure` onboarding branch:

- Replace `"config:recommended"` with `"config:best-practices"` to get even better defaults
- Add the [:disableRateLimiting](https://docs.renovatebot.com/presets-default/#disableratelimiting) preset to `extends`, so that Renovate creates _all_ dependency-update PRs at once (rather than in batches)
- Teach Renovate to treat `Earthfile`s like `Dockerfile`s, because an `Earthfile` also contains `FROM base-image:tag` statements. This means that you need to tune the [dockerfile manager](https://docs.renovatebot.com/modules/manager/dockerfile/) so that its `managerFilePatterns` list contains the glob-pattern `"**/Earthfile"`. [This documentation section](https://docs.renovatebot.com/modules/manager/#extending-a-managers-default-managerfilepatterns) explains the concrete changes you need to make to `renovate.json`

Finally, push the changes. The detailed steps are:
- `git checkout renovate/configure`
- Update the `renovate.json` contents
- `git commit -m "chore(renovate): tune config" && git push`
- Observe how the description of the Onboarding PR changes, shortly afterward. The _Configuration summary_ section shows more configurations (and the _hourly limit_ notice has disappeared), and the _Detected Package Files_ show the `Earthfile`s.

Now, **merge** the Onboarding PR. Shortly afterward, you will see the Dependency-update-PRs appear. Once Renovate created all PRs, the _Issues_ tab of the GitHub repo will show a "Dependency dashboard" issue.

- Look at the "Dependency dashboard" issue
- Look at some of the PRs, notice the detailed information and the provided changelogs

## Task 2: Adding labels to Renovate PRs

Right now we have a large number of PRs, all of them from Renovate. In the real world, your team also creates their own PRs. You might have a hard time finding them in the large mass of Renovate PRs.

A common solution is to tell Renovate to add _labels_ to PRs, because that allows you to filter for PRs. Modify your `renovate.json` by adding this section:

`"labels": ["dependency-update", "deptype:{{manager}}", "updatetype:{{updateType}}"]`

Commit and push the changes.

In the next 1-2 minutes, Renovate will add three labels to each PR: one with the _static_ value `dependency-update`, and two with a _dynamic_ value, using [handlebar template fields](https://docs.renovatebot.com/templates/#template-fields). This is useful information to have, because the _PR title_ alone (e.g., _"Update dependency MarkupSafe to v3"_) often lacks information. Here, `"deptype:{{manager}}"` indicates where the dependency is declared/found. And `"updatetype:{{updateType}}"` indicates whether it's a major/minor/patch update.

Try out the advantages yourself. Go to the list of PRs and then:

- Look at the "Update **kafka** Docker tag to v32" PR: you'll immediately see that this did _not_ affect a `FROM <base-image>` line in a `Dockerfile`, but a _Helm chart_
- Click on any _label_ to filter PRs. For instance, click on "deptype:pip_requirements" to only see PRs that update Python/pip dependencies.
- While filtering, in the **Filters** text field, you can add a `-` in front of a label filter (e.g., `-label:deptype:npm`) to _hide/exclude_ PRs with that label

## Task 3: Grouping dependency updates

We currently have _many_ PRs (over 40). The advantage is that we immediately see the CI pipeline status for each individual dependency update, indicating potentially breaking changes. But the disadvantage is that merging each PR individually will be a lot of work, and often some dependencies need to be updated together anyway (if you updated just one, the build or test would break). Depending on your GitHub notification settings, you would also get a lot of notification spam (-> emails) if you always have individual PRs for every dependency.

We will now configure Renovate **grouping** feature, i.e., telling Renovate to bundle several dependencies into a single PR, based on **rules** that we define. The feature is called `packageRules` (take a brief look at its [docs](https://docs.renovatebot.com/configuration-options/#packagerules) now, particularly the table of contents in the right sidebar!). The `packageRules` key in the `renovate.json` file lets you fine-tune / override the Renovate’s behavior for specific dependencies. Selecting these dependencies is done via the **matchXXXX** keys, e.g., **matchFileNames**, **matchPackagePatterns** or **matchUpdateTypes**. `packageRules` is an array of (JSON) objects, where each object must have:

- one or more of the sub-keys explained in the [packagesRules documentation](https://docs.renovatebot.com/configuration-options/#packagerules) (such as **matchPackageNames**)
- one or more of "regular" configuration options documented on the Configuration Options page, e.g., [automerge](https://docs.renovatebot.com/configuration-options/#automerge), [enabled](https://docs.renovatebot.com/configuration-options/#enabled), or [groupName](https://docs.renovatebot.com/configuration-options/#groupname)

In practice, these are probably the most useful matchers:
- `matchDepNames`: array of glob-patterns (or regex) strings to match the name of a dependency. Take home exercise: read [this post](https://www.jvt.me/posts/2025/05/21/renovate-depname-packagename/) to understand the difference between `depName` and `packageName` and when to use `matchDepNames` vs. `matchPackageNames` respectively
- `matchDepTypes`: list of "dependency types". Each package manager defines this differently For instance, the [npm manager docs](https://docs.renovatebot.com/modules/manager/npm/#dependency-types) provides the complete list for NPM/PNPM/Yarn, such as "regular" `dependencies`, `devDependencies` or `peerDependencies`
- `matchUpdateTypes`: array of strings for update types, e.g., `major`, `minor`, `patch`, or `lockFileMaintenance`. For every dependency Renovate updates in a PR, Renovate assigns such an update type, and you can see it in the label that we added in task 2
- `matchCategories`: array of strings matching the _category_ of _managers_, e.g., `java`, `node` or `python`. See the **Category ID** column in the _Supported Managers_ table in the [manager docs](https://docs.renovatebot.com/modules/manager/)

Note: if you define several **matchXXXX** keys, then your package rule only applies if **all** of them match.

Back to our task at hand: to group specific dependencies, we need to choose a suitable matchXXXX key first. A suggestion is to use `matchCategories` because then we can use it to group, say, all Python dependencies.

Having decided that, we need to build a `packageRules` object that also sets the [groupName](https://docs.renovatebot.com/configuration-options/#groupname) key to a string of your choice. This string will appear in the PR title in place of the concrete dependency names, i.e., the PR title will have the form `Update <groupName>`.

Your task (no help this time): add a `packageRules` entry to the `renovate.json` file. It's an array of objects with the `matchCategories` and `groupName` key.

Commit and push the changes. Wait for Renovate to do its work (you can always check https://developer.mend.io in parallel, to see the Renovate _job status_).

After 1-2 minutes, you will observe that the number of PRs has decreased. Take a look at the _closed_ PRs. Renovate automatically closed all the _individual_ Python-related PRs and instead created _two_ new PRs:

- One PR contains all dependencies with minor/patch updates
- One PR contains all major updates

This default behavior of Renovate _could_ be changed. There are various configuration options named "separate...", e.g., [separateMajorMinor](https://docs.renovatebot.com/configuration-options/#separatemajorminor) that we could tune. [This documentation](https://docs.renovatebot.com/faq/#renovates-default-behavior-for-majorminor-releases) provides more details. However, we'll leave it at the default behavior, though.

## Task 4: Automatic merging of Renovate PRs

Assuming that you have extensive test coverage, it makes sense to allow Renovate to automatically merge PRs, given that the CI pipeline passes.

However, it makes sense to first **configure _realistic_ (real-world) PR-merge settings** in your repo-copy, where the `main` branch is protected, forcing all changes to be done via PRs whose branches are up-to-date regarding `main`. To implement this, go to your repo's **Settings** tab, and then Go to **Rules -> Rulesets** and create a new **Branch rule set** with the following settings:
- _Ruleset name_: Anything you want, e.g., "Protect main"
- _Enforcement status_: Active
- _Bypass list_: Add yourself (e.g. "Repository admin"), just for this workshop, to allow yourself to push changes you make to `renovate.json` directly to `main`, without a PR
- _Target branches_: add the "default branch"
- In _Branch rules_:
  - Check "Require a pull request before merging"
  - Check "Require status checks to pass". In its _Additional settings_, check "Require branches to be up to date before merging". Add the "run-tests" check to the list of required checks (in the dropdown that shows when you click on "Add checks", type "test" and wait for the auto-complete to suggest "run-tests")
- Click _Create_

Next, update the `renovate.json` file, adding another `packageRule` that sets `"automerge": true` for updates made to `Dockerfiles` of type _minor_.

Commit and push the changes to `main` directly.

Wait 1-2 minutes for Renovate to update PRs: verify that those PRs with `deptype:dockerfile` and `updatetype:minor` labels have updated descriptions which now mention that the PRs will be automatically merged, whereas PRs with different labels (e.g., `deptype:dockerfile` and `updatetype:major`) have unchanged descriptions.

However, you'll find that no PR has been merged yet. The reason is that Renovate follows this process when it **visits** your repo:
- Step 1: Renovate **rebases** those existing Renovate-PRs that are out of date (regarding `main`) and thus need to be rebased, because of your branch ruleset
- Step 2: Renovate clicks on the "Merge" button for you (via API call), but only for **one** auto-mergeable PR per visit, and only if this PR did not need rebasing to begin with, and only if its CI (status checks) had already passed. In other words, PRs rebased just now in step 1 are _not_ in scope for step 2 in the current visit/run.

Let's see auto-merge (of one PR) in action:
- Make sure that at least one CI pipeline for a minor-Dockerfile-update-PR has already passed successfully
- Go to the _Dependency dashboard_ issue and check the checkbox at the very bottom of the issue description, to trigger another Renovate visit
- About one minute later, you will observe that Renovate merged one of the Dockerfile update PRs.

In summary, auto-merging PRs this way is quite time-consuming, especially if you use Renovate's hosted app which only visits "inactive" repos (without activity on `main`) every 2-12 hours (depending on Mend's available resources).

In practice, to get a higher throughput of auto-merging PRs, use GitHub's _Merge queue_ feature. Renovate documents its merge queue support [here](https://docs.renovatebot.com/key-concepts/automerge/#github-merge-queue). A merge queue exists to solve the problem of dealing with many PR-merges per day. It avoids that developers (or Renovate itself) have to manually / repeatedly rebase branches, wait for the CI to pass and then click "merge". You can try out the Merge Queue feature at home.

## Task 5: Detecting versions in unsupported files

Renovate can parse many file types with its bundled managers, but you will often encounter gaps. A concrete example is GitHub Actions. Take a look at the `.github/workflows/ci.yml` file: Renovate is able to detect version-updates for the _actions themselves_ (e.g., `uses: earthly/actions/setup-earthly@v1`), and also supports finding dependencies in `with: version: ...` blocks for a few specific hard-coded actions (like `actions/setup-python`, see [docs](https://docs.renovatebot.com/modules/manager/github-actions/#withversion-support-for-built-in-actions)). But Renovate does not support finding the _Earthly_ version defined in the `with: version: ...` block of the `earthly/actions/setup-earthly@v1` action.

Fortunately, Renovate lets you define "custom managers" to fill these gaps. Traditionally, one would have used the [regex manager](https://docs.renovatebot.com/modules/manager/regex/), where you write a regular expression that defines _capture groups_ to match and extract dependencies and their pinned versions.

However, since early 2025 there is a better alternative, the [JSONata custom manager](https://docs.renovatebot.com/modules/manager/jsonata/), which can parse JSON, YAML and TOML files. Parsing such structured files with a "real" parser (that builds an Abstract Syntax Tree) is often superior to parsing them with a RegEx, because RegExes can easily break due to formatting changes or users inserting comments into a YAML file, which breaks the structure expected by the regex. 

You are probably inexperienced at writing complex regular expression queries or JSONata queries. But LLMs/coding agents simplify the problem. For instance, you can use a prompt like this in your coding agent:

```
You are a Renovate Bot expert. In .github/workflows/ci.yml the setup-earthly action has a "with: version: .." block that defines a version of a Git tag of the github.com/earthly/earthly repo.

I want you to define a custom JSONata-based Renovate manager (see https://docs.renovatebot.com/modules/manager/jsonata/) for the setup-earthly action that is able to parse the version. It should be flexible enough to work for any setup-earthly action version, e.g., also for "earthly/actions/setup-earthly@v2" or "earthly/actions/setup-earthly@v1.2".
```

It produces a working result such as this, including explanations how/why it works:
```json
  "customManagers": [
    {
      "customType": "jsonata",
      "fileFormat": "yaml",
      "managerFilePatterns": [".github/workflows/ci.yml"],
      "matchStrings": [
        "jobs.*.steps[$contains(uses, \"earthly/actions/setup-earthly@\")].with.{ \"depName\": \"earthly/earthly\", \"currentValue\": version, \"datasource\": \"github-tags\" }"
      ]
    }
  ]
```

Add this snippet to your `renovate.json` file, commit and push the changes directly to `main`.

After 1-2 minutes, Renovate will create a new PR that updates the earthly action.

## Congratulations

You completed the tasks of this workshop. 🚀

There is a lot more material. Renovate maintains an official [reading list](https://docs.renovatebot.com/reading-list/). Marius also blogged extensively, see [this blog post](https://www.augmentedmind.de/2023/07/30/renovate-bot-introduction/) for a Renovate introduction, with many links to advanced techniques and a cheat sheet.

Remember that _technically introducing Renovate_ is only a small fraction of the work necessary. Changing your team culture and your paying, non-technical stakeholders is the bigger challenge.
