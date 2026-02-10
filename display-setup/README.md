# i3 + Polybar Config Generator

This repository supports running the same dotfiles on multiple machines (e.g. laptop and desktop) without configuration conflicts in git.

## The approach is:

Track templates and profiles
Generate host-specific configs at runtime
Keep generated files out of git
Use symlinks for workspace → monitor mappings

## Overview

The entry point is:
bin/genwm
It:
Detects the current machine by hostname
Loads a host-specific profile
Generates i3 and polybar configs from templates
Symlinks the correct workspace mapping file
Writes output to ~/.config

## Directory layout

dotfiles/
├── bin/
│ └── genwm
├── profiles/
│ ├── laptop.env
│ └── desktop.env
└── templates/
├── i3/
│ ├── config.tmpl
│ ├── laptop.conf
│ └── desktop.conf
└── polybar/
└── config.ini.tmpl

## Host detection

genwm determines which machine it is running on using:
hostname -s

Known hosts are mapped explicitly:
Thinkerton → laptop
BadRobot → desktop

If the hostname is unknown, genwm exits with an error to avoid generating incorrect configs.

## Profiles (profiles/\*.env)

Profiles are simple shell files containing variables used during generation.
Typical responsibilities:

- i3 font size
- i3 gaps
- polybar height
- polybar font size
  Profiles are sourced and exported so that envsubst can access the variables.

i3 configuration

## Templates

The main i3 template is:
templates/i3/config.tmpl

It may contain placeholders such as:

${I3_FONT_SIZE}
${I3_GAPS_INNER}

## Generated output

The generated file is written to:

~/.config/i3/generated.conf

Your real i3 config should include it:

include ~/.config/i3/generated.conf

## Workspace → monitor mapping (no templating)

Workspace assignment is not templated.
Instead, host-specific files are used:

- templates/i3/laptop.conf
- templates/i3/desktop.conf

At generation time, genwm creates a symlink:

~/.config/i3/workspaces.conf

pointing to the correct file for the current host.

The main i3 template includes it with:

include workspaces.conf

This keeps long workspace/output mappings out of templates.

## Polybar configuration

Templates

Polybar is generated from:

templates/polybar/config.ini.tmpl

## Generated output

The generated polybar config is written to:

~/.config/polybar/generated.ini

Polybar launch scripts should reference this file.

## Safe variable substitution

i3 configs use their own variables (e.g. $mod, $ws1).
To avoid breaking them, envsubst is restricted to substitute only explicitly allowed variables:

- I3_VARS = ${I3_FONT_SIZE} ${I3_GAPS_INNER} ${I3_AUTORANDR_CMD}
- POLYBAR_VARS = ${FONT_SIZE} ${POLYBAR_HEIGHT} ${POLYBAR_FONT_SIZE}

This prevents accidental replacement of i3’s internal variables.

## Generated files (not tracked)

The following files are generated and must not be committed:

~/.config/i3/generated.conf
~/.config/i3/workspaces.conf
~/.config/polybar/generated.ini

They should be listed in .gitignore.

## Usage

bin/genwm

The output will show:
which profile was selected
which workspace mapping file is in use

## Adding a new machine

Create a new profile in profiles/
Add the hostname mapping in bin/genwm
Optionally add a new workspace mapping file in templates/i3/
