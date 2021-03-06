# CHANGELOG

## 2.1.4 (2015/05/11)
This releases fixes an issue present since v2.0.0 that resulted in a build's
ETA not being calculated correctly.
  - 50932c6 - (fixup) fix eta query broken by 9badacc

## 2.1.3 (2015/04/16)
This commit contains a minor fix to the provided `config/unicorn.rb` config
file so that the Unicorn app server always creates a PID file. The location
is customizable via the `$PID` environment variable, such as when Unicorn is
launched via an init script.
  - 2f593f0 - Unicorn should always create a pid file

## 2.1.2 (2015/04/14)
This release reintroduces pessimistic versioning of dependencies.
  - a7817f9 - pessmisitic versioning of deps (reverts bc20b84)

## 2.1.1 (2015/04/14)
This release contains fixes to Waylon's included `unicorn.rb` config file, for
a better experience when launching Waylon from an init script.
  - 8f6d0da - unicorn config should specify `working_directory`

## 2.1.0 (2015/03/11)
This release contains fixes to better deploy Waylon. For a complete list,
see <https://github.com/rji/waylon/compare/v2.0.0...v2.1.0>.

## 2.0.0 (2014/12/08)
There were a lot of changes for this release. The largest have been summarized
here. Otherwise, check out the compare on GitHub.

Breaking changes:
  - Config file modifications; changes to the YAML structure.
  - API changes.
  - Upgraded to jQuery 2.1.1; older browsers, IE impacted.

Non-breaking changes:
  - The "display name" for a job is now used if it is set in Jenkins.
  - The build number is displayed alongside the job's display name. If using
    the [Build Name Setter](https://wiki.jenkins-ci.org/display/JENKINS/Build+Name+Setter+Plugin)
    plugin, this means you could display the Git SHA next to the job's name.
  - Implemented memcached for reducing the API hits to a Jenkins instance.
  - Added failure reasons to the 'investigate' buttons.
  - Improve ETA calculation.
  - Trouble mode displays an image of a forest fire if the number of failed
    builds is greater than `trouble_threshold`. Default disabled.

A huge thanks to [Adrien Thebo](https://github.com/adrienthebo) for his work
developing a proper API and a Backbone-based JS front-end.

## 1.2.0 (2014/05/15)
  - Add config and examples for using [Unicorn](http://unicorn.bogomips.org/)
    for application deployment.
  - Move `waylon.yml` to the `config/` directory.

## 1.1.0 (2014/05/14)
  - Implement build progress indicator and calculate estimated time remaining.

## 1.0.0 (2014/05/08)
  - Initial release
