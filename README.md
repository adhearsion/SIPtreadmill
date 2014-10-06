# SIP Treadmill

SIP load test tool originally built with support from AT&amp;T Foundry.

## Core Concepts

### Test Run

Test Runs are the focal point of SIP Treadmill. When a Test Run is started, SIP traffic is sent via SIPp and analyzed by SIPp and an RTCP listener. Each Test Run is comprised of one or more Scenarios, a Profile, and a Target.

### Scenario

Scenarios describe how the calls in a Test Run behave. Call duration, DTMF input, and the beginning and end of the call are all described in the Scenario. Scenarios may be specified in either the [SIPp](http://sipp.sourceforge.net) or [SippyCup](https://github.com/mojolingo/sippy_cup) formats.

### Profile

The profile describes the call volume produced by the Test Run. The profile has three main fields: calls per second (how many calls are generated each second), concurrent calls (the number of calls that can occur at one time), and total number of calls for the test run.  

### Target

The target describes the server on which the SIP application being tested is running. Each target has a name, an IP address, and an optional SSH username. If the user has SSH access to the target machine, system performance metrics can be gathered and analyzed by SIP Treadmill.

## The Setup

In order to get started with Treadmill, the following are required:

* [SIPp](http://sipp.sourceforge.net) - MUST BE A DEVELOPMENT BUILD, see https://github.com/SIPp/sipp/pull/106
* An [AT&T APIMatrix](https://apimatrix.tfoundry.com) account, or a [GitHub](https://github.com) account.
* An AT&T APIMatrix application with profile access, or a GitHub application with user access.
* [Redis](http://redis.io)
* [PostgreSQL](http://www.postgresql.org/) (preferred, but any other Rails-compatible database will do)
* Amazon S3 credentials for file uploads with CarrierWave

Once you have all of the pieces, copy `config/database.yml.sample` to `config/database.yml`, and plug in the values required to connect to your database of choice.

### Environment Variables

The majority of configuration for SIP Treadmill is done via environment variables. These environment variables are:
<dl>
  <dt>COOKIE_SECRET</dt>
  <dd>A secret token used to sign cookies. Should be at least 30 random characters long.</dd>
  <dt>OMNIAUTH_TYPE</dt>
  <dd>The omniauth method to use. Valid options are 'github' and 'att'</dd>
  <dt>APIMATRIX_KEY</dt>
  <dd>The Client ID for your APIMatrix application</dd>
  <dt>APIMATRIX_SECRET</dt>
  <dd>The Client Secret for your APIMatrix application</dd>
  <dt>GITHUB_KEY</dt>
  <dd>The Client ID of your GitHub application</dd>
  <dt>GITHUB_SECRET</dt>
  <dd>The Client secret for your GitHub application</dd>
  <dt>AWS_ACCESS_KEY_ID</dt>
  <dd>The access key ID for your Amazon S3</dd>
  <dt>AWS_SECRET_ACCESS_KEY</dt>
  <dd>The access key secret for your Amazon S3</dd>
  <dt>TEST_RUN_BIND_IP</dt>
  <dd>The IP address to bind to for sending SIP traffic</dd>
</dl>

## Development environment

1. Install [virtualbox](https://www.virtualbox.org/wiki/Downloads)
2. Install [vagrant](http://vagrantup.com)
3. Clone this repository.
4. Add the [librarian-chef plugin](https://github.com/jimmycuadra/vagrant-librarian-chef) to your Vagrant installation by doing `vagrant plugin install vagrant-librarian-chef`.
4. Build the VMs: `vagrant up`
5. SSH into the `dev` VM (`vagrant ssh dev`), move to `/srv/treadmill/current` and run the specs (`rake spec`)
6. Launch the app (`foreman start`).
6. You can access the app via http://dev.local.treadmill.mojolingo.net:5000/

The app is shared with the VM, and everything runs in the VM, but you can use your editor on the host machine.
