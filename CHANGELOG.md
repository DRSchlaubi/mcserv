# McServ

## [Unreleased]
### Fixed
- Fix docs CI failing
- Fix script generators not appending /bin/java

### Security

## [0.0.4] - 2021-12-10
### Added

### Changed
- Update dependencies
- Make Velocity use the PaperMC API

### Deprecated

### Removed

### Fixed

### Security

## [0.0.3] - 2021-09-08
### Fixed
- Fix Bug causing process to not terminate correctly when downloading items
- Fix JDK installer

## [0.0.2] - 2021-09-05
### Added
- non-interactive CLI flags for all interactive components
- `--ascii` mode (Use `--no-ascii` on Windows to restore old mode)
- Loading spinners for expensive tasks (e.g. Unpacking a JDK)
- Human-readable filesize in Download progress instead of byte count

### Changed
- Use interact for progress bars

### Fixed
- Cursor invisible after exiting with Ctrl+C [#12](https://github.com/DRSchlaubi/mcserv/issues/12)
- Long process exit times due to left-open resources
- 64-bit program installed to `Program Files (x86)` on Windows

## [0.0.1]
### Added
- Initial version.