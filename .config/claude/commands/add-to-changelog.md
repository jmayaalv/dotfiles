# Update Changelog

This command adds a new entry to the project's CHANGELOG.md file.

## Usage

```
/add-to-changelog <version> <change_type> <message>
```

Where:
- `<version>` is the version number (e.g., "1.1.0")
- `<change_type>` is one of: "added", "changed", "deprecated", "removed", "fixed", "security"
- `<message>` is the description of the change

## Examples

```
/add-to-changelog 1.1.0 added "New markdown to BlockDoc conversion feature"
```

```
/add-to-changelog 1.0.2 fixed "Bug in HTML renderer causing incorrect output"
```

## Behavior

Arguments: $ARGUMENTS

Add the entry to CHANGELOG.md in [Keep a Changelog](https://keepachangelog.com/) format. If the file doesn't exist, create it with the standard header. If the version already has a section, add the entry under its change-type heading; otherwise create the version section dated today. Don't commit - suggest it.
