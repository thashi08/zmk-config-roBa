# zmk-config-roBa

A personalized fork of [kumamuk-git/zmk-config-roBa](https://github.com/kumamuk-git/zmk-config-roBa), focused on custom JIS layout keymaps and local build support.

## Features

- Custom keymap designed for the JIS layout (not US)
- Simple local build process using included scripts

## Keymap

### Layers

> [!WARNING]
> When displayed in [Keymap Editor](https://nickcoutsos.github.io/keymap-editor/), keys that use values defined in [jis_keys.h](config/jis_keys.h) are marked as `undefined`:no_entry_sign:.

![default_layer](/images/layer0.png)

![SYMBOL](/images/layer1.png)

![FUNCTION](/images/layer2.png)

![NUM](/images/layer3.png)

![ARROW](/images/layer4.png)

![MOUSE](/images/layer5.png)

![SCROLL](/images/layer6.png)

![BLUETOOTH](/images/layer7.png)

### Combos

Combos in the default_layer:

![combos](/images/combos.png)

### Mouse

Mouse settings are configured in [roBa_R.conf](/config/boards/shields/Test/roBa_R.conf).

Modified:

| Settings                            | Value |
| ----------------------------------- | ----- |
| CONFIG_PMW3610_CPI                  | 1000  |
| CONFIG_PMW3610_AUTOMOUSE_TIMEOUT_MS | 500   |

## Building Locally

This build process is intended for **Ubuntu on WSL2**.

### Setup

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Install [Dev Container CLI](https://github.com/devcontainers/cli)
3. Run the setup command:

```sh
./scripts/setup.sh
```

### Build

For the initial build, use the `-p` option to enable the pristine build (clean build) option.

```sh
./scripts/build.sh -p
```

After the initial build, you can omit the `-p` option for faster subsequent builds.

```sh
./scripts/build.sh
```

### Output

```sh
.
└── build
    ├── roBa_L.uf2          # Left
    ├── roBa_R.uf2          # Right
    └── settings_reset.uf2  # Reset firmware
```

## License

This repository does not include a license file because the upstream repository ([kumamuk-git/zmk-config-roBa](https://github.com/kumamuk-git/zmk-config-roBa)) does not specify any license.
