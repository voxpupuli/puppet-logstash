# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v7.0.0](https://github.com/voxpupuli/puppet-logstash/tree/v7.0.0) (2023-01-04)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/6.1.5...v7.0.0)

**Breaking changes:**

- Fix option spelling in jvm.options template [\#412](https://github.com/voxpupuli/puppet-logstash/pull/412) ([travees](https://github.com/travees))

**Implemented enhancements:**

- allow overriding default jvm options [\#417](https://github.com/voxpupuli/puppet-logstash/pull/417) ([juliantaylor](https://github.com/juliantaylor))
- Add a parameter to override the plugin install user [\#414](https://github.com/voxpupuli/puppet-logstash/pull/414) ([thebeanogamer](https://github.com/thebeanogamer))
- New parameter for home directory [\#368](https://github.com/voxpupuli/puppet-logstash/pull/368) ([joernott](https://github.com/joernott))

**Closed issues:**

- Need to Override Plugin Install User [\#413](https://github.com/voxpupuli/puppet-logstash/issues/413)
- Cleanup failing tests  [\#401](https://github.com/voxpupuli/puppet-logstash/issues/401)
- jvm options for java 11 [\#397](https://github.com/voxpupuli/puppet-logstash/issues/397)
- Add support for Logstash 7.x [\#390](https://github.com/voxpupuli/puppet-logstash/issues/390)
- logstash-system-install fails with Java not in Path / JAVA\_HOME not set error [\#383](https://github.com/voxpupuli/puppet-logstash/issues/383)
- Cannot override JVM options for plugins [\#381](https://github.com/voxpupuli/puppet-logstash/issues/381)
- Release version 6.1.5 [\#379](https://github.com/voxpupuli/puppet-logstash/issues/379)

**Merged pull requests:**

- Finalize voxpupuli transition [\#420](https://github.com/voxpupuli/puppet-logstash/pull/420) ([h-haaks](https://github.com/h-haaks))
- metadata.json: Adjust modulename/GitHub URLs [\#416](https://github.com/voxpupuli/puppet-logstash/pull/416) ([bastelfreak](https://github.com/bastelfreak))
- migrate .fixtures.yml to git repos [\#410](https://github.com/voxpupuli/puppet-logstash/pull/410) ([bastelfreak](https://github.com/bastelfreak))
- puppet-lint: autofix [\#409](https://github.com/voxpupuli/puppet-logstash/pull/409) ([bastelfreak](https://github.com/bastelfreak))
- Stop using Travis CI [\#406](https://github.com/voxpupuli/puppet-logstash/pull/406) ([jmlrt](https://github.com/jmlrt))
- bump up dependencies [\#405](https://github.com/voxpupuli/puppet-logstash/pull/405) ([anesterova](https://github.com/anesterova))

## [6.1.5](https://github.com/voxpupuli/puppet-logstash/tree/6.1.5) (2018-11-13)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/6.1.4...6.1.5)

**Closed issues:**

- Empty manifests causes errors in Puppet6 [\#375](https://github.com/voxpupuli/puppet-logstash/issues/375)

**Merged pull requests:**

- Test `restart_on_change` for startup files [\#378](https://github.com/voxpupuli/puppet-logstash/pull/378) ([jarpy](https://github.com/jarpy))
- Honour `restart_on_change` for startup files [\#377](https://github.com/voxpupuli/puppet-logstash/pull/377) ([v-slenter](https://github.com/v-slenter))
- Replace deprecated validate\_re function [\#376](https://github.com/voxpupuli/puppet-logstash/pull/376) ([baurmatt](https://github.com/baurmatt))

## [6.1.4](https://github.com/voxpupuli/puppet-logstash/tree/6.1.4) (2018-09-16)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/6.1.3...6.1.4)

**Merged pull requests:**

- Add OracleLinux 6 Service Provider [\#374](https://github.com/voxpupuli/puppet-logstash/pull/374) ([ayohrling](https://github.com/ayohrling))

## [6.1.3](https://github.com/voxpupuli/puppet-logstash/tree/6.1.3) (2018-08-28)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/6.1.2...6.1.3)

**Closed issues:**

- Support stdlib 5 [\#372](https://github.com/voxpupuli/puppet-logstash/issues/372)
- Tag 6.1.2 is missing [\#371](https://github.com/voxpupuli/puppet-logstash/issues/371)
- Deprecated elasticsearch/logstash on Puppet Forge [\#370](https://github.com/voxpupuli/puppet-logstash/issues/370)
- Plugin installation fails if puppet run from directory that logstash user can't read [\#363](https://github.com/voxpupuli/puppet-logstash/issues/363)

**Merged pull requests:**

- Allow stdlib version 5 [\#373](https://github.com/voxpupuli/puppet-logstash/pull/373) ([jarpy](https://github.com/jarpy))

## [6.1.2](https://github.com/voxpupuli/puppet-logstash/tree/6.1.2) (2018-06-08)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/6.1.1...6.1.2)

**Implemented enhancements:**

- Readd support for managing multiple instances of logstash on the same machine [\#144](https://github.com/voxpupuli/puppet-logstash/issues/144)

**Closed issues:**

- Apt dependency when manually managing repository [\#359](https://github.com/voxpupuli/puppet-logstash/issues/359)
- Plugins are not installed as logstash user [\#354](https://github.com/voxpupuli/puppet-logstash/issues/354)
- Systemd unit file created with wrong user and group [\#349](https://github.com/voxpupuli/puppet-logstash/issues/349)
- Inconsistent sort order of hashes in jvm.options.erb and logstash.yml.erb [\#332](https://github.com/voxpupuli/puppet-logstash/issues/332)
- Add package installation options parameter [\#199](https://github.com/voxpupuli/puppet-logstash/issues/199)

## [6.1.1](https://github.com/voxpupuli/puppet-logstash/tree/6.1.1) (2018-05-31)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/6.1.0...6.1.1)

**Closed issues:**

- Amazon Linux requires specific service startup parameters [\#365](https://github.com/voxpupuli/puppet-logstash/issues/365)
- there is no "${logstash::home\_dir}/bin/system-install" with logstash 2.2.4 [\#364](https://github.com/voxpupuli/puppet-logstash/issues/364)
- Failing to install package from package\_url [\#361](https://github.com/voxpupuli/puppet-logstash/issues/361)

**Merged pull requests:**

- added condition for amazon linux [\#366](https://github.com/voxpupuli/puppet-logstash/pull/366) ([vchan2002](https://github.com/vchan2002))
- fix: remove apt dependency requirement when managing repositories manually [\#360](https://github.com/voxpupuli/puppet-logstash/pull/360) ([StevePorter92](https://github.com/StevePorter92))

## [6.1.0](https://github.com/voxpupuli/puppet-logstash/tree/6.1.0) (2018-04-03)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/6.0.2...6.1.0)

**Fixed bugs:**

- New package name regex for Redhat is breaking YUM  [\#353](https://github.com/voxpupuli/puppet-logstash/issues/353)

**Closed issues:**

- Disable path.config when using elasticsearch centralised pipeline management [\#357](https://github.com/voxpupuli/puppet-logstash/issues/357)

**Merged pull requests:**

- No path.config for centralized pipeline management [\#362](https://github.com/voxpupuli/puppet-logstash/pull/362) ([jarpy](https://github.com/jarpy))
- Reload logstash when purging files [\#358](https://github.com/voxpupuli/puppet-logstash/pull/358) ([jarro2783](https://github.com/jarro2783))

## [6.0.2](https://github.com/voxpupuli/puppet-logstash/tree/6.0.2) (2017-12-06)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/5.3.0...6.0.2)

**Closed issues:**

- CentOS7 and puppet 5 service start issue [\#352](https://github.com/voxpupuli/puppet-logstash/issues/352)
- Logstash getting installed in /opt [\#351](https://github.com/voxpupuli/puppet-logstash/issues/351)
- Support for offline plugin packs served via puppet [\#347](https://github.com/voxpupuli/puppet-logstash/issues/347)
- CentOS7 and puppet 4 service start issue [\#344](https://github.com/voxpupuli/puppet-logstash/issues/344)

**Merged pull requests:**

- Fix resource defaults for plugins on Puppet 5 \#354 [\#355](https://github.com/voxpupuli/puppet-logstash/pull/355) ([jarpy](https://github.com/jarpy))
- Add spec and implementation for offline .zip packages and fix fixtures [\#348](https://github.com/voxpupuli/puppet-logstash/pull/348) ([Ymbirtt](https://github.com/Ymbirtt))

## [5.3.0](https://github.com/voxpupuli/puppet-logstash/tree/5.3.0) (2017-06-06)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/5.2.1...5.3.0)

**Closed issues:**

- Java installation handling [\#341](https://github.com/voxpupuli/puppet-logstash/issues/341)
- Make this module friendly to users who store their logstash config in a separate git \(or other\) repo [\#338](https://github.com/voxpupuli/puppet-logstash/issues/338)

## [5.2.1](https://github.com/voxpupuli/puppet-logstash/tree/5.2.1) (2017-05-09)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/5.2.0...5.2.1)

**Closed issues:**

- No support for URL in plugin [\#337](https://github.com/voxpupuli/puppet-logstash/issues/337)

**Merged pull requests:**

- Fixes for Puppet 4 strict\_variables [\#330](https://github.com/voxpupuli/puppet-logstash/pull/330) ([mrbanzai](https://github.com/mrbanzai))

## [5.2.0](https://github.com/voxpupuli/puppet-logstash/tree/5.2.0) (2017-05-03)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/5.1.0...5.2.0)

**Closed issues:**

- Jenkins build fail [\#336](https://github.com/voxpupuli/puppet-logstash/issues/336)
- Release 5.0.5 [\#335](https://github.com/voxpupuli/puppet-logstash/issues/335)

**Merged pull requests:**

- Support installing plugins over http\(s\) \#337 [\#340](https://github.com/voxpupuli/puppet-logstash/pull/340) ([jarpy](https://github.com/jarpy))
- Strict variables when logstash::configfile is used with $source param… [\#339](https://github.com/voxpupuli/puppet-logstash/pull/339) ([sathieu](https://github.com/sathieu))

## [5.1.0](https://github.com/voxpupuli/puppet-logstash/tree/5.1.0) (2017-04-07)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/5.0.4...5.1.0)

**Closed issues:**

- Ability to Remove Logstash::Configfile resources. [\#329](https://github.com/voxpupuli/puppet-logstash/issues/329)
- Use an array from hiera to create config files [\#327](https://github.com/voxpupuli/puppet-logstash/issues/327)
- Hiera for Pattenfile [\#326](https://github.com/voxpupuli/puppet-logstash/issues/326)
- Missing tag 5.0.4 [\#325](https://github.com/voxpupuli/puppet-logstash/issues/325)

**Merged pull requests:**

- Allow file:/// paths [\#331](https://github.com/voxpupuli/puppet-logstash/pull/331) ([adamgibbins](https://github.com/adamgibbins))
- Fix ownership of `/etc/logstash` [\#323](https://github.com/voxpupuli/puppet-logstash/pull/323) ([joshuaspence](https://github.com/joshuaspence))

## [5.0.4](https://github.com/voxpupuli/puppet-logstash/tree/5.0.4) (2017-01-16)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/5.0.3...5.0.4)

**Closed issues:**

- Changing log.level and path.logs  [\#322](https://github.com/voxpupuli/puppet-logstash/issues/322)
- Plugins installation fails as logstash user [\#320](https://github.com/voxpupuli/puppet-logstash/issues/320)

**Merged pull requests:**

- Parameterize Logstash home directory [\#324](https://github.com/voxpupuli/puppet-logstash/pull/324) ([joshuaspence](https://github.com/joshuaspence))

## [5.0.3](https://github.com/voxpupuli/puppet-logstash/tree/5.0.3) (2016-12-23)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/5.0.2...5.0.3)

**Closed issues:**

- Add option to use content as input for patternfile [\#318](https://github.com/voxpupuli/puppet-logstash/issues/318)
- logstash::configfile overload values into a template file [\#314](https://github.com/voxpupuli/puppet-logstash/issues/314)
- Logstash 5.x Support [\#312](https://github.com/voxpupuli/puppet-logstash/issues/312)
- Logstash plugins are not installed as "$logstash\_user" [\#307](https://github.com/voxpupuli/puppet-logstash/issues/307)
- Logstash service does not start with systemd [\#302](https://github.com/voxpupuli/puppet-logstash/issues/302)
- Logstash enable changed 'false' to 'true' [\#300](https://github.com/voxpupuli/puppet-logstash/issues/300)
- use https for repo url rather than http [\#298](https://github.com/voxpupuli/puppet-logstash/issues/298)
- Use supported Java module [\#293](https://github.com/voxpupuli/puppet-logstash/issues/293)
- The logstash::logstash\_user and logstash::logstash\_group parameters should be set to 'logstash' when installing from packages [\#289](https://github.com/voxpupuli/puppet-logstash/issues/289)
- Inconsistent starting of service after crash/kill. [\#286](https://github.com/voxpupuli/puppet-logstash/issues/286)
- Service is falsely thought to be not disabled on Debian 8. [\#266](https://github.com/voxpupuli/puppet-logstash/issues/266)
- Patterns fail due to permissions if logstash\_user and logstash\_group are not specified [\#255](https://github.com/voxpupuli/puppet-logstash/issues/255)
- Logstash config files are not purged under ${logstash::configdir} folder [\#232](https://github.com/voxpupuli/puppet-logstash/issues/232)
- Why concat multiple smaller configuration files? [\#227](https://github.com/voxpupuli/puppet-logstash/issues/227)
- logstash::patternfile puts file into wrong directory [\#224](https://github.com/voxpupuli/puppet-logstash/issues/224)
- Inputs, codecs, filters, outputs config management [\#211](https://github.com/voxpupuli/puppet-logstash/issues/211)

## [5.0.2](https://github.com/voxpupuli/puppet-logstash/tree/5.0.2) (2016-12-19)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/5.0.1...5.0.2)

**Merged pull requests:**

- Do not add extension to filter file [\#317](https://github.com/voxpupuli/puppet-logstash/pull/317) ([flysen](https://github.com/flysen))

## [5.0.1](https://github.com/voxpupuli/puppet-logstash/tree/5.0.1) (2016-12-15)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.6.6...5.0.1)

## [0.6.6](https://github.com/voxpupuli/puppet-logstash/tree/0.6.6) (2016-12-15)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/5.0.0...0.6.6)

## [5.0.0](https://github.com/voxpupuli/puppet-logstash/tree/5.0.0) (2016-12-14)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.6.4...5.0.0)

**Closed issues:**

- which release supports logstash 5.x [\#316](https://github.com/voxpupuli/puppet-logstash/issues/316)
- Add ability to override restart command [\#315](https://github.com/voxpupuli/puppet-logstash/issues/315)
- Logstash not restarted if plugin is installed [\#305](https://github.com/voxpupuli/puppet-logstash/issues/305)
- Mismatch between Modulefile and metadata.json [\#301](https://github.com/voxpupuli/puppet-logstash/issues/301)
- Logstash 1.3.3 and 2.3.4 from same puppet master [\#297](https://github.com/voxpupuli/puppet-logstash/issues/297)
- Problems with electrical-file\_concat [\#287](https://github.com/voxpupuli/puppet-logstash/issues/287)
- How to use in a server which has default jdk version 1.6 [\#285](https://github.com/voxpupuli/puppet-logstash/issues/285)
- ensure =\> absent fails when run twice [\#228](https://github.com/voxpupuli/puppet-logstash/issues/228)

**Merged pull requests:**

- Added package\_name parameter. [\#311](https://github.com/voxpupuli/puppet-logstash/pull/311) ([cropalato](https://github.com/cropalato))
- Install plugins as "$logstash\_user" [\#310](https://github.com/voxpupuli/puppet-logstash/pull/310) ([elconas](https://github.com/elconas))
- Make sure to also restart logstash if plugin is installed [\#306](https://github.com/voxpupuli/puppet-logstash/pull/306) ([elconas](https://github.com/elconas))
- Acceptance tests currently fail, and don't test current logstash. [\#303](https://github.com/voxpupuli/puppet-logstash/pull/303) ([andrewspiers](https://github.com/andrewspiers))
- Add support for puppetlabs/apt 2.x [\#296](https://github.com/voxpupuli/puppet-logstash/pull/296) ([baurmatt](https://github.com/baurmatt))
- Use legacy /opt/logstash/bin/plugin. [\#295](https://github.com/voxpupuli/puppet-logstash/pull/295) ([jarpy](https://github.com/jarpy))
- Support installing a custom plugin version [\#290](https://github.com/voxpupuli/puppet-logstash/pull/290) ([joshuaspence](https://github.com/joshuaspence))
- Ensure tests run against $LS\_VERSION. [\#288](https://github.com/voxpupuli/puppet-logstash/pull/288) ([jarpy](https://github.com/jarpy))
- Strict variables when logstash::configfile is used with $source parameter [\#234](https://github.com/voxpupuli/puppet-logstash/pull/234) ([sathieu](https://github.com/sathieu))

## [0.6.4](https://github.com/voxpupuli/puppet-logstash/tree/0.6.4) (2016-05-16)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.6.3...0.6.4)

**Closed issues:**

- Support Puppet 4.x. [\#269](https://github.com/voxpupuli/puppet-logstash/issues/269)

**Merged pull requests:**

- Explicity support Puppet 4. [\#274](https://github.com/voxpupuli/puppet-logstash/pull/274) ([jarpy](https://github.com/jarpy))

## [0.6.3](https://github.com/voxpupuli/puppet-logstash/tree/0.6.3) (2016-05-16)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.6.2...0.6.3)

## [0.6.2](https://github.com/voxpupuli/puppet-logstash/tree/0.6.2) (2016-05-16)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.6.1...0.6.2)

## [0.6.1](https://github.com/voxpupuli/puppet-logstash/tree/0.6.1) (2016-05-13)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.6.0...0.6.1)

**Implemented enhancements:**

- LS\_USER and LS\_GROUP hard-coded in debian upstart conf template [\#168](https://github.com/voxpupuli/puppet-logstash/issues/168)

**Fixed bugs:**

- Logstash install fails due to dependency on PGP server [\#191](https://github.com/voxpupuli/puppet-logstash/issues/191)

**Closed issues:**

- output zeromq met error due to "zmq\_ctx\_new" not found [\#280](https://github.com/voxpupuli/puppet-logstash/issues/280)
- does it support multiple config files in /etc/logstash/conf.d [\#279](https://github.com/voxpupuli/puppet-logstash/issues/279)
- is filter grok still available now in puppet-logstash [\#278](https://github.com/voxpupuli/puppet-logstash/issues/278)
- can't start logstash service after puppet run [\#276](https://github.com/voxpupuli/puppet-logstash/issues/276)
- why software\_provider "custom" is missing [\#273](https://github.com/voxpupuli/puppet-logstash/issues/273)
- Logstash 2.0 support [\#249](https://github.com/voxpupuli/puppet-logstash/issues/249)
- Has elastic abandoned this puppet module? [\#240](https://github.com/voxpupuli/puppet-logstash/issues/240)
- logstash::patternfile should notify the logstash service [\#230](https://github.com/voxpupuli/puppet-logstash/issues/230)
- When will a new release come out? [\#226](https://github.com/voxpupuli/puppet-logstash/issues/226)
- Incompatible with Puppet Apt 2.0.0 module [\#214](https://github.com/voxpupuli/puppet-logstash/issues/214)
- FalseClass [\#206](https://github.com/voxpupuli/puppet-logstash/issues/206)
- ensure =\> absent fails to remove logstash package when logstash-contrib has been installed [\#203](https://github.com/voxpupuli/puppet-logstash/issues/203)
- \[Doc\] Add inline documentation for 'template' option in configfile.pp [\#197](https://github.com/voxpupuli/puppet-logstash/issues/197)
- doesn't seem to work with puppet-server [\#193](https://github.com/voxpupuli/puppet-logstash/issues/193)
- Refresh causing multiple processes [\#190](https://github.com/voxpupuli/puppet-logstash/issues/190)
- init\_defaults not actually taking effect? [\#188](https://github.com/voxpupuli/puppet-logstash/issues/188)
- contrib\_url failed dependency [\#186](https://github.com/voxpupuli/puppet-logstash/issues/186)
- CentOS init crashing [\#185](https://github.com/voxpupuli/puppet-logstash/issues/185)
- Modifications to the module we can make [\#172](https://github.com/voxpupuli/puppet-logstash/issues/172)
- Add support for other OS's / distro's [\#143](https://github.com/voxpupuli/puppet-logstash/issues/143)
- Add define for managing curator. [\#139](https://github.com/voxpupuli/puppet-logstash/issues/139)

**Merged pull requests:**

- Run unit tests on Travis. [\#284](https://github.com/voxpupuli/puppet-logstash/pull/284) ([jarpy](https://github.com/jarpy))
- Fix patternfile paths. [\#283](https://github.com/voxpupuli/puppet-logstash/pull/283) ([jarpy](https://github.com/jarpy))
- Restart sevice on pattern change. For \#225. [\#282](https://github.com/voxpupuli/puppet-logstash/pull/282) ([jarpy](https://github.com/jarpy))
- Only require logstash::package, not all of module [\#281](https://github.com/voxpupuli/puppet-logstash/pull/281) ([johanek](https://github.com/johanek))
- Test "ensure =\> absent" is idempotent. [\#277](https://github.com/voxpupuli/puppet-logstash/pull/277) ([jarpy](https://github.com/jarpy))
- Removed GPG server and instead get the key file itself. Issue \#191 [\#275](https://github.com/voxpupuli/puppet-logstash/pull/275) ([jarpy](https://github.com/jarpy))
- Removed GPG server and instead get the key file itself.  [\#247](https://github.com/voxpupuli/puppet-logstash/pull/247) ([abednarik](https://github.com/abednarik))

## [0.6.0](https://github.com/voxpupuli/puppet-logstash/tree/0.6.0) (2016-05-02)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.5.1...0.6.0)

**Implemented enhancements:**

- initscript should provide LS\_OPTS option to be added to DAEMON\_OPTS [\#18](https://github.com/voxpupuli/puppet-logstash/issues/18)

**Fixed bugs:**

- logstash::configfile with 'source =\>' throws cryptic error [\#194](https://github.com/voxpupuli/puppet-logstash/issues/194)
- Version conflict for logstash and logstash-contrib [\#167](https://github.com/voxpupuli/puppet-logstash/issues/167)
- /var/log/logstash folder not assigned to uid.gid correctly [\#68](https://github.com/voxpupuli/puppet-logstash/issues/68)

**Closed issues:**

- File\_concat unresolvable [\#261](https://github.com/voxpupuli/puppet-logstash/issues/261)
- Service not correctly enabled on CentOS when serviceprovider == 'init' [\#256](https://github.com/voxpupuli/puppet-logstash/issues/256)
- Installing community-based plugins [\#253](https://github.com/voxpupuli/puppet-logstash/issues/253)
- first puppet run: Could not autoload puppet/type/file\_concat: [\#248](https://github.com/voxpupuli/puppet-logstash/issues/248)
- Debian 8, Logstash 2 support [\#245](https://github.com/voxpupuli/puppet-logstash/issues/245)
- Unable to find module 'ispavailability-file\_concat' on https://forgeapi.puppetlabs.com [\#244](https://github.com/voxpupuli/puppet-logstash/issues/244)
- Multiple Broker/Indexers ingesting [\#239](https://github.com/voxpupuli/puppet-logstash/issues/239)
- Support Logstash 1.5.x [\#238](https://github.com/voxpupuli/puppet-logstash/issues/238)
- Updated APT module warns if not using 40char keys for repo [\#237](https://github.com/voxpupuli/puppet-logstash/issues/237)
- Template in elasticsearch output not used when service first started [\#236](https://github.com/voxpupuli/puppet-logstash/issues/236)
- Could not autoload puppet/provider/file\_concat/posix: cannot load such file [\#233](https://github.com/voxpupuli/puppet-logstash/issues/233)
- Should the latest version work with LS 1.5.0-1? [\#216](https://github.com/voxpupuli/puppet-logstash/issues/216)
- Should manage the "logstash-web" service [\#198](https://github.com/voxpupuli/puppet-logstash/issues/198)
- Could not find init script or upstart conf file - Ubuntu 14.04 [\#189](https://github.com/voxpupuli/puppet-logstash/issues/189)
- logstash::configfile example in README doesn't work [\#184](https://github.com/voxpupuli/puppet-logstash/issues/184)
- Howto fix noexec on Ubuntu 14.04 [\#171](https://github.com/voxpupuli/puppet-logstash/issues/171)
- Specifying contrib\_package\_url does not create the swdl download directory. [\#170](https://github.com/voxpupuli/puppet-logstash/issues/170)
- Puppet versions [\#169](https://github.com/voxpupuli/puppet-logstash/issues/169)
- internal dependency between manage\_repo and repo\_version [\#166](https://github.com/voxpupuli/puppet-logstash/issues/166)
- puppet-logstash produces a blank logstash.conf [\#162](https://github.com/voxpupuli/puppet-logstash/issues/162)
- if condition in puppet recipe [\#161](https://github.com/voxpupuli/puppet-logstash/issues/161)
- Documentation - Readme has a typo with regards to contrib package installation [\#160](https://github.com/voxpupuli/puppet-logstash/issues/160)
- Option of using stage setup [\#157](https://github.com/voxpupuli/puppet-logstash/issues/157)
- logstash\_user and logstash\_group ignored on init.d script [\#66](https://github.com/voxpupuli/puppet-logstash/issues/66)

**Merged pull requests:**

- Logstash 2.0 [\#270](https://github.com/voxpupuli/puppet-logstash/pull/270) ([jarpy](https://github.com/jarpy))
- Logstash 1.5 [\#268](https://github.com/voxpupuli/puppet-logstash/pull/268) ([jarpy](https://github.com/jarpy))
- Test rework [\#267](https://github.com/voxpupuli/puppet-logstash/pull/267) ([jarpy](https://github.com/jarpy))
- update common files [\#258](https://github.com/voxpupuli/puppet-logstash/pull/258) ([electrical](https://github.com/electrical))
- update common files [\#243](https://github.com/voxpupuli/puppet-logstash/pull/243) ([electrical](https://github.com/electrical))
- Replacing logstash mailing list with discussion forum link [\#221](https://github.com/voxpupuli/puppet-logstash/pull/221) ([ycombinator](https://github.com/ycombinator))
- Provide full-length fingerprint for Apt key [\#207](https://github.com/voxpupuli/puppet-logstash/pull/207) ([tmuellerleile](https://github.com/tmuellerleile))
- For patterns and plugins using file:// in source should be supported [\#205](https://github.com/voxpupuli/puppet-logstash/pull/205) ([igoraj](https://github.com/igoraj))
- Update Readme according to code [\#202](https://github.com/voxpupuli/puppet-logstash/pull/202) ([AAlvz](https://github.com/AAlvz))
- 166 dependency manage repo repo version [\#201](https://github.com/voxpupuli/puppet-logstash/pull/201) ([AAlvz](https://github.com/AAlvz))
- Update README.md [\#192](https://github.com/voxpupuli/puppet-logstash/pull/192) ([binary1230](https://github.com/binary1230))
- Fix Puppet Lint errors [\#187](https://github.com/voxpupuli/puppet-logstash/pull/187) ([baurmatt](https://github.com/baurmatt))
- make array line based, for better readability [\#181](https://github.com/voxpupuli/puppet-logstash/pull/181) ([igalic](https://github.com/igalic))
- Updated logstash::configfile method  [\#180](https://github.com/voxpupuli/puppet-logstash/pull/180) ([hartfordfive](https://github.com/hartfordfive))
- Sync common files [\#179](https://github.com/voxpupuli/puppet-logstash/pull/179) ([electrical](https://github.com/electrical))
- \[TESTING\] Fix platform name so PE installer uses the correct file [\#178](https://github.com/voxpupuli/puppet-logstash/pull/178) ([electrical](https://github.com/electrical))
- Update testing for opensuse and SLES. [\#177](https://github.com/voxpupuli/puppet-logstash/pull/177) ([electrical](https://github.com/electrical))
- SuSE/SLES support [\#176](https://github.com/voxpupuli/puppet-logstash/pull/176) ([electrical](https://github.com/electrical))
- Add support for passing in logstash-contrib package version [\#175](https://github.com/voxpupuli/puppet-logstash/pull/175) ([jlintz](https://github.com/jlintz))
- minor typo in the table showing versions of Puppet and Logstash [\#174](https://github.com/voxpupuli/puppet-logstash/pull/174) ([daks](https://github.com/daks))
- \[TESTING\] Make use of new centos image [\#163](https://github.com/voxpupuli/puppet-logstash/pull/163) ([electrical](https://github.com/electrical))

## [0.5.1](https://github.com/voxpupuli/puppet-logstash/tree/0.5.1) (2014-05-15)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.5.0...0.5.1)

**Closed issues:**

- Module does not change /etc/default/logstash to allow logstash to start [\#155](https://github.com/voxpupuli/puppet-logstash/issues/155)

**Merged pull requests:**

- Add option to use stages for the repo setup instead anchors [\#159](https://github.com/voxpupuli/puppet-logstash/pull/159) ([electrical](https://github.com/electrical))
- Increase package dl timeout [\#158](https://github.com/voxpupuli/puppet-logstash/pull/158) ([electrical](https://github.com/electrical))

## [0.5.0](https://github.com/voxpupuli/puppet-logstash/tree/0.5.0) (2014-05-06)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.4.3...0.5.0)

**Closed issues:**

- Bug with file\_concat. [\#153](https://github.com/voxpupuli/puppet-logstash/issues/153)
- Logstash 1.4 support? [\#150](https://github.com/voxpupuli/puppet-logstash/issues/150)
- rspec tests fail due to Unsupported lsbdistid for apt based os [\#145](https://github.com/voxpupuli/puppet-logstash/issues/145)
- Java 1.6 required but java 7 gets installed [\#142](https://github.com/voxpupuli/puppet-logstash/issues/142)
- Improve puppet module removal [\#141](https://github.com/voxpupuli/puppet-logstash/issues/141)

**Merged pull requests:**

- Module update [\#154](https://github.com/voxpupuli/puppet-logstash/pull/154) ([electrical](https://github.com/electrical))
- match other config perms with patterns [\#151](https://github.com/voxpupuli/puppet-logstash/pull/151) ([bryanhelmig](https://github.com/bryanhelmig))
- Improve puppet module removal - Issue \#141 [\#149](https://github.com/voxpupuli/puppet-logstash/pull/149) ([mieciu](https://github.com/mieciu))
- Fix typo in group name variable [\#147](https://github.com/voxpupuli/puppet-logstash/pull/147) ([jbouse](https://github.com/jbouse))
- Closes \#145 added lsbdistid = Debian to rspec facts [\#146](https://github.com/voxpupuli/puppet-logstash/pull/146) ([derektamsen](https://github.com/derektamsen))

## [0.4.3](https://github.com/voxpupuli/puppet-logstash/tree/0.4.3) (2014-02-21)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.4.2...0.4.3)

**Closed issues:**

- CONFIG\_PATH is wrong on EL6 [\#136](https://github.com/voxpupuli/puppet-logstash/issues/136)
- CONF\_DIR check in init script issue [\#135](https://github.com/voxpupuli/puppet-logstash/issues/135)
- Custom plugin doesn't get picked up when running logstash as a service [\#134](https://github.com/voxpupuli/puppet-logstash/issues/134)
- Embedded web server arguments not yet added to init script [\#113](https://github.com/voxpupuli/puppet-logstash/issues/113)
- /var/lock/subsys/logstash missing [\#78](https://github.com/voxpupuli/puppet-logstash/issues/78)

**Merged pull requests:**

- Add beaker testing and fix 2 race conditions [\#140](https://github.com/voxpupuli/puppet-logstash/pull/140) ([electrical](https://github.com/electrical))
- Adds name to centos repo [\#138](https://github.com/voxpupuli/puppet-logstash/pull/138) ([spuder](https://github.com/spuder))
- Fixes examples [\#137](https://github.com/voxpupuli/puppet-logstash/pull/137) ([spuder](https://github.com/spuder))
- Improve testing and add coverage reporting [\#133](https://github.com/voxpupuli/puppet-logstash/pull/133) ([electrical](https://github.com/electrical))
- Fix incorrect parameter name "file" in doco [\#132](https://github.com/voxpupuli/puppet-logstash/pull/132) ([barthoda](https://github.com/barthoda))

## [0.4.2](https://github.com/voxpupuli/puppet-logstash/tree/0.4.2) (2014-01-31)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.4.1...0.4.2)

**Closed issues:**

- Please update forge [\#131](https://github.com/voxpupuli/puppet-logstash/issues/131)
- Cannot install on same host as puppet-elasticsearch; exec duplicate declaration [\#129](https://github.com/voxpupuli/puppet-logstash/issues/129)
- \[discussion\] Conditional support [\#107](https://github.com/voxpupuli/puppet-logstash/issues/107)
- Working on updating for LS 1.2 [\#76](https://github.com/voxpupuli/puppet-logstash/issues/76)

**Merged pull requests:**

- Patch 2 [\#130](https://github.com/voxpupuli/puppet-logstash/pull/130) ([phrawzty](https://github.com/phrawzty))

## [0.4.1](https://github.com/voxpupuli/puppet-logstash/tree/0.4.1) (2014-01-23)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.4.0...0.4.1)

## [0.4.0](https://github.com/voxpupuli/puppet-logstash/tree/0.4.0) (2014-01-21)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.3.4...0.4.0)

**Fixed bugs:**

- When updating the jar file, old file is not removed [\#42](https://github.com/voxpupuli/puppet-logstash/issues/42)

**Closed issues:**

- Add support for codecs [\#122](https://github.com/voxpupuli/puppet-logstash/issues/122)
- default settings fail on centos 6.4 [\#112](https://github.com/voxpupuli/puppet-logstash/issues/112)
- Codec parameter on file input [\#109](https://github.com/voxpupuli/puppet-logstash/issues/109)
- Cannot create configdir on single instance setup [\#96](https://github.com/voxpupuli/puppet-logstash/issues/96)
- update jenkins job to create packages for logstash 1.2.x [\#88](https://github.com/voxpupuli/puppet-logstash/issues/88)
- spec testing rewrite [\#77](https://github.com/voxpupuli/puppet-logstash/issues/77)
- logrotate support needed [\#59](https://github.com/voxpupuli/puppet-logstash/issues/59)
- Need better documentation of the defines [\#58](https://github.com/voxpupuli/puppet-logstash/issues/58)
- puppet doc fails [\#31](https://github.com/voxpupuli/puppet-logstash/issues/31)

**Merged pull requests:**

- Rewrite [\#127](https://github.com/voxpupuli/puppet-logstash/pull/127) ([electrical](https://github.com/electrical))
- minor doc clean-up [\#126](https://github.com/voxpupuli/puppet-logstash/pull/126) ([phrawzty](https://github.com/phrawzty))
- Amplify the README [\#125](https://github.com/voxpupuli/puppet-logstash/pull/125) ([phrawzty](https://github.com/phrawzty))
- Honour the NICE setting [\#104](https://github.com/voxpupuli/puppet-logstash/pull/104) ([jabley](https://github.com/jabley))
- Add the ability to specify a local jar file for logstash package to install [\#99](https://github.com/voxpupuli/puppet-logstash/pull/99) ([fdrouet](https://github.com/fdrouet))

## [0.3.4](https://github.com/voxpupuli/puppet-logstash/tree/0.3.4) (2013-10-14)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.3.3...0.3.4)

**Closed issues:**

- Install config file [\#92](https://github.com/voxpupuli/puppet-logstash/issues/92)
- Support for codecs [\#91](https://github.com/voxpupuli/puppet-logstash/issues/91)
- rpm installation fails dependency management [\#82](https://github.com/voxpupuli/puppet-logstash/issues/82)
- logstash config files not written [\#79](https://github.com/voxpupuli/puppet-logstash/issues/79)
- Uninstalling Logstash module does not remove all associated directories [\#61](https://github.com/voxpupuli/puppet-logstash/issues/61)
- service logstash not starting [\#60](https://github.com/voxpupuli/puppet-logstash/issues/60)

**Merged pull requests:**

- add ability to install a logstash config file [\#93](https://github.com/voxpupuli/puppet-logstash/pull/93) ([jlambert121](https://github.com/jlambert121))
- http download of jar should require $jardir [\#90](https://github.com/voxpupuli/puppet-logstash/pull/90) ([maxamg](https://github.com/maxamg))
- Add small input/output examples [\#89](https://github.com/voxpupuli/puppet-logstash/pull/89) ([xorpaul](https://github.com/xorpaul))
- added 'in progress' for logstash version 1.2.x [\#87](https://github.com/voxpupuli/puppet-logstash/pull/87) ([rtoma](https://github.com/rtoma))
- fix wrong creates path at jar custom provider [\#83](https://github.com/voxpupuli/puppet-logstash/pull/83) ([dwerder](https://github.com/dwerder))
- spec\_cleanup [\#75](https://github.com/voxpupuli/puppet-logstash/pull/75) ([jlambert121](https://github.com/jlambert121))
- set logstash logdir perms when using custom jar provider [\#74](https://github.com/voxpupuli/puppet-logstash/pull/74) ([jlambert121](https://github.com/jlambert121))
- remove installpath when ensure =\> absent [\#73](https://github.com/voxpupuli/puppet-logstash/pull/73) ([jlambert121](https://github.com/jlambert121))
- clean up ${logstash::installpath} when updating jars [\#72](https://github.com/voxpupuli/puppet-logstash/pull/72) ([jlambert121](https://github.com/jlambert121))
- Permit HTTP\(s\) for downloading logstash [\#71](https://github.com/voxpupuli/puppet-logstash/pull/71) ([pcfens](https://github.com/pcfens))
- define logstash::configdir [\#70](https://github.com/voxpupuli/puppet-logstash/pull/70) ([jlambert121](https://github.com/jlambert121))
- small typo in comment [\#67](https://github.com/voxpupuli/puppet-logstash/pull/67) ([xorpaul](https://github.com/xorpaul))
- Added brief note about sourcing logstash packages [\#65](https://github.com/voxpupuli/puppet-logstash/pull/65) ([doismellburning](https://github.com/doismellburning))
- force removal of directories if ensure is absent [\#64](https://github.com/voxpupuli/puppet-logstash/pull/64) ([jkoppe](https://github.com/jkoppe))
- puppet-logstash-issue\#61 adding directory and file purging for uninstall... [\#62](https://github.com/voxpupuli/puppet-logstash/pull/62) ([MixMuffins](https://github.com/MixMuffins))

## [0.3.3](https://github.com/voxpupuli/puppet-logstash/tree/0.3.3) (2013-06-15)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.3.2...0.3.3)

**Closed issues:**

- Filter Scope Issue [\#57](https://github.com/voxpupuli/puppet-logstash/issues/57)
- Correct template variables [\#55](https://github.com/voxpupuli/puppet-logstash/issues/55)

**Merged pull requests:**

- Template [\#56](https://github.com/voxpupuli/puppet-logstash/pull/56) ([richardpeng](https://github.com/richardpeng))

## [0.3.2](https://github.com/voxpupuli/puppet-logstash/tree/0.3.2) (2013-05-23)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.3.1...0.3.2)

## [0.3.1](https://github.com/voxpupuli/puppet-logstash/tree/0.3.1) (2013-05-15)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.3.0...0.3.1)

**Fixed bugs:**

- Hash serialization is not stable [\#51](https://github.com/voxpupuli/puppet-logstash/issues/51)
- ensure absent causes some resources to be created [\#37](https://github.com/voxpupuli/puppet-logstash/issues/37)

**Closed issues:**

- Update defines to be generated based on Logstash 1.1.12 [\#54](https://github.com/voxpupuli/puppet-logstash/issues/54)
- logstash\_user and logstash\_group not carried through plugins [\#52](https://github.com/voxpupuli/puppet-logstash/issues/52)
- Puppet apply fails on Service\[logstash\] [\#50](https://github.com/voxpupuli/puppet-logstash/issues/50)

## [0.3.0](https://github.com/voxpupuli/puppet-logstash/tree/0.3.0) (2013-05-09)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.2.0...0.3.0)

**Closed issues:**

- Logstash fails to start with minimal config [\#49](https://github.com/voxpupuli/puppet-logstash/issues/49)
- Write tests for file owner feature [\#48](https://github.com/voxpupuli/puppet-logstash/issues/48)
- notify variable in output/hipchat needs to be replaced [\#46](https://github.com/voxpupuli/puppet-logstash/issues/46)
- LICENSE file missing [\#45](https://github.com/voxpupuli/puppet-logstash/issues/45)

**Merged pull requests:**

- Fix containment, create log dir, preserve java.io.tmpdir [\#53](https://github.com/voxpupuli/puppet-logstash/pull/53) ([blalor](https://github.com/blalor))

## [0.2.0](https://github.com/voxpupuli/puppet-logstash/tree/0.2.0) (2013-04-30)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.1.0...0.2.0)

**Implemented enhancements:**

- Change mode of files to 0640 [\#36](https://github.com/voxpupuli/puppet-logstash/issues/36)
- Allow for files required for pugins to be automatically transfered to the host [\#24](https://github.com/voxpupuli/puppet-logstash/issues/24)
- Multi instance feature [\#23](https://github.com/voxpupuli/puppet-logstash/issues/23)

**Fixed bugs:**

- boolean validation is wrong [\#43](https://github.com/voxpupuli/puppet-logstash/issues/43)
- Create tmp dir [\#35](https://github.com/voxpupuli/puppet-logstash/issues/35)
- regexp fields cause issues with puppet defines [\#3](https://github.com/voxpupuli/puppet-logstash/issues/3)

**Closed issues:**

- Support for agent vs central [\#41](https://github.com/voxpupuli/puppet-logstash/issues/41)
- gelf is not working [\#40](https://github.com/voxpupuli/puppet-logstash/issues/40)
- gelf is not working [\#39](https://github.com/voxpupuli/puppet-logstash/issues/39)
- Dependency cycle when using output [\#33](https://github.com/voxpupuli/puppet-logstash/issues/33)
- Filter parameters defined multiple times [\#30](https://github.com/voxpupuli/puppet-logstash/issues/30)

**Merged pull requests:**

- Debian use tmpdir created by logstash::config [\#44](https://github.com/voxpupuli/puppet-logstash/pull/44) ([dcarley](https://github.com/dcarley))
- changed LS\_USER and LS\_GROUP to root in debian init script. [\#34](https://github.com/voxpupuli/puppet-logstash/pull/34) ([adenning](https://github.com/adenning))
- fixed duplicate cases in params.pp [\#32](https://github.com/voxpupuli/puppet-logstash/pull/32) ([adenning](https://github.com/adenning))
- Apply the correct Puppet URI scheme based on Puppet offical doc [\#28](https://github.com/voxpupuli/puppet-logstash/pull/28) ([Spredzy](https://github.com/Spredzy))
- Refresh the service if the defaultsfiles file changes. [\#27](https://github.com/voxpupuli/puppet-logstash/pull/27) ([fsalum](https://github.com/fsalum))
- Fixing RedHat init script \(PIDFILE and status\) [\#26](https://github.com/voxpupuli/puppet-logstash/pull/26) ([fsalum](https://github.com/fsalum))

## [0.1.0](https://github.com/voxpupuli/puppet-logstash/tree/0.1.0) (2013-03-25)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.0.6...0.1.0)

**Closed issues:**

- File buckets try to back up the jarfile, which fails the resource. [\#25](https://github.com/voxpupuli/puppet-logstash/issues/25)

## [0.0.6](https://github.com/voxpupuli/puppet-logstash/tree/0.0.6) (2013-03-07)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.0.5...0.0.6)

## [0.0.5](https://github.com/voxpupuli/puppet-logstash/tree/0.0.5) (2013-03-02)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.0.4...0.0.5)

**Implemented enhancements:**

- Add default java packages with possibility to be overwritten. [\#16](https://github.com/voxpupuli/puppet-logstash/issues/16)

**Closed issues:**

- add the ability to add multiple 'add\_field's to a grok filter.  [\#21](https://github.com/voxpupuli/puppet-logstash/issues/21)
- default location on ubuntu/debian is /etc/default not /etc/defaults [\#19](https://github.com/voxpupuli/puppet-logstash/issues/19)
- allow custom init script when installed from package [\#17](https://github.com/voxpupuli/puppet-logstash/issues/17)

**Merged pull requests:**

- Update README.md to mention installpath.  [\#20](https://github.com/voxpupuli/puppet-logstash/pull/20) ([rjw1](https://github.com/rjw1))

## [0.0.4](https://github.com/voxpupuli/puppet-logstash/tree/0.0.4) (2013-02-10)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.0.3...0.0.4)

**Merged pull requests:**

- Link logstash.jar file properly when provision by jar [\#14](https://github.com/voxpupuli/puppet-logstash/pull/14) ([featheredtoast](https://github.com/featheredtoast))
- Fixed: Name of RedHat init, Added jar file as link, Added Amazon Linux Support [\#12](https://github.com/voxpupuli/puppet-logstash/pull/12) ([pkubat](https://github.com/pkubat))

## [0.0.3](https://github.com/voxpupuli/puppet-logstash/tree/0.0.3) (2013-02-05)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/0.0.2...0.0.3)

**Implemented enhancements:**

- Provide a way to deploy jar file instead of a package [\#4](https://github.com/voxpupuli/puppet-logstash/issues/4)

**Closed issues:**

- empty /etc/init.d/logstash [\#10](https://github.com/voxpupuli/puppet-logstash/issues/10)
- Undocumented requirement for custom provider for jarfile installation [\#5](https://github.com/voxpupuli/puppet-logstash/issues/5)

**Merged pull requests:**

- Wrap all init.d logic in a check for status != unmanaged. [\#9](https://github.com/voxpupuli/puppet-logstash/pull/9) ([tavisto](https://github.com/tavisto))
- Add RedHat as OS type \(for RHEL\) [\#8](https://github.com/voxpupuli/puppet-logstash/pull/8) ([phrawzty](https://github.com/phrawzty))
- Supply default init.d script if none specified. [\#7](https://github.com/voxpupuli/puppet-logstash/pull/7) ([garthk](https://github.com/garthk))
- Add README info, self-defence re custom provider for jarfile installation [\#6](https://github.com/voxpupuli/puppet-logstash/pull/6) ([garthk](https://github.com/garthk))

## [0.0.2](https://github.com/voxpupuli/puppet-logstash/tree/0.0.2) (2013-01-19)

[Full Changelog](https://github.com/voxpupuli/puppet-logstash/compare/62b2b7597cd4fc4c9598143cbcb29681c44ebbe6...0.0.2)

**Fixed bugs:**

- 'name' variables in plugins need to be removed. [\#2](https://github.com/voxpupuli/puppet-logstash/issues/2)
- Cleanup [\#1](https://github.com/voxpupuli/puppet-logstash/issues/1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
