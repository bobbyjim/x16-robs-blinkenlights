# BOCKER

A Docker parody for the Commander X16.

The name is a portmanteau of "bock" (as in the chicken sound) and "Docker" — because
the Commodore rainbow-logo, rendered in PETSCII, looks a bit like an idealized
chicken's head.  Bock bock.  The compiled binary is therefore named `BOCKBOCK`.

---

## What is it?

BOCKER is a tiny, toy re-implementation of the Docker CLI experience, running
natively on the Commander X16 retro computer.  It has an image registry, a
container registry, a login banner, and a `%`-prompt shell loop — all in a few
hundred lines of cc65 C.

It is not connected to the internet.  It does not actually run containers.
It is entirely, gloriously fake.  This is intentional.

---

## Platform

- **Hardware:** Commander X16 (or the x16emu emulator)
- **Compiler:** cc65 / cl65, targeting the cx16 platform, 65C02 CPU
- **Build:** `make` produces the `BOCKBOCK` program binary

---

## Running

```
make
./run        # launches x16emu with BOCKBOCK
```

---

## Session Start-up

On launch, BOCKER:

1. Draws a PETSCII Commodore-chicken logo in the corner.
2. Displays a satirical login banner ("not a warning! all are welcome…").
3. Waits for a keypress to log in.
4. Performs a quick filesystem smoke-test (writes `HELLOWORLD.TXT`, reads it back,
   lists the current directory).
5. Drops you into the interactive shell loop.

---

## The Shell

The prompt shows available heap memory and a Unix-style `%`:

```
14320 %
```

Type a command and press Return.

---

## Commands

### `ps`

List all running containers.

```
14320 % ps
```

Clears the screen and prints a table of every container that has been created in
this session:

```
container id        image               created             status
------------------- ------------------- ------------------- ------
zippy_zebra         ubuntu              2031/07/14 09:23    ok
hapless_harpy       alpine              1998/03/02 17:44    ok
```

Fields:

| Field        | Description                                              |
|--------------|----------------------------------------------------------|
| container id | A randomly generated `adjective_noun` name (see below)  |
| image        | The image the container was created from                 |
| created      | A randomly assigned timestamp (year/month/day hh:mm)    |
| status       | `ok` or `dead`                                          |

---

### `image`

Manage the image registry.

#### `image` (no subcommand)

List all images that have been pulled in this session.

```
14320 % image
```

```
repository      image id     created on         size
--------------- --------     ----------------   ------
ubuntu          3f7a2c91     2019/05/11 03:17   142 kb
alpine          1b4e8d00     2043/12/30 21:55    37 kb
```

#### `image pull <name>`

"Pull" an image by name.  BOCKER invents a random hexadecimal image ID, a random
creation date, and a random size for it.  No network required.

```
14320 % image pull ubuntu
attempting to pull ubuntu
14320 % image pull alpine
attempting to pull alpine
```

A maximum of 16 images can be held at one time.

---

### `container create <imageId>`

Create a container from a previously pulled image.  The `imageId` can be either
the repository name (e.g. `ubuntu`) or the short hex ID shown by `image`.

```
14320 % container create ubuntu
container [zippy_zebra] created
```

If the specified image does not exist the shell reports:

```
image does not exist.
```

A maximum of 16 containers can be held at one time.

---

### `container stop <containerId>`

Stop a running container.  Its status changes from `ok` to `dead`.

```
14320 % container stop zippy_zebra
container [zippy_zebra] stopped
```

---

### `container start <containerId>`

Restart a stopped container.  Its status returns to `ok`.

```
14320 % container start zippy_zebra
container [zippy_zebra] started
```

---

### `container rm <containerId>`

Remove a container permanently.  It is deleted from the registry and will no
longer appear in `ps`.

```
14320 % container rm zippy_zebra
container [zippy_zebra] removed
```

If the container ID is not found, any of the above subcommands reports:

```
no such container.
```

---

## Container Naming

Container IDs are auto-generated as `adjective_noun` pairs drawn from two curated
alphabetical word lists (A–Z each).  Examples: `arthritic_ankle`,
`grungy_gruel`, `maniacal_mud`, `zippy_zebra`.  Docker does exactly the same
thing; BOCKER just does it on a 6502.

---

## Architecture

| File            | Responsibility                                        |
|-----------------|-------------------------------------------------------|
| `main.c`        | Shell loop, line tokenizer, command dispatcher        |
| `container.c/h` | Container struct, `ps`, `container create`            |
| `image.c/h`     | Image struct, `image` list, `image pull`              |
| `universal.c/h` | Logo, login screen, `generateName()`, `wipeScreen()`  |
| `helloworld.c/h`| Startup file-I/O smoke-test and directory listing     |

---

## Known Limitations (a.k.a. Features)

- Containers do not actually run anything.
- Images are not actually downloaded from anywhere.
- The creation timestamps are random.  Your `ubuntu` image may claim to have been
  created in 2067.
- There is no `run`, `exec`, `push`, `tag`, `inspect`, `logs`,
  `network`, `volume`, `compose`, or `swarm`.
- Heap memory on the X16 is finite.  The prompt will tell you how much is left.
- Sessions are not persisted between runs.  Everything is lost when you quit.
  (There is no `quit` command yet either.  Power-cycle as needed.)

---

## Why?

Practice.  Fun.  The Commander X16 is a delightful platform for writing C that
actually fits in memory, and Docker's CLI makes surprisingly good material for
a tiny shell exercise: it has nouns, verbs, tabular output, and a registry
metaphor that maps neatly onto two fixed-size arrays.

Bock bock.
