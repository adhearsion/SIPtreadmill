# [develop](https://github.com/mojolingo/SIPtreadmill/compare/1.0.1...develop)
  * Properly log RTCP collection errors
  * Allow and document fully configuring Airbrake for error notification

# [1.0.1](https://github.com/mojolingo/SIPtreadmill/compare/1.0.0...1.0.1)
  * Allow running Rails console in production installed from packages. Minitest / TestUnit are required.

# [1.0.0](https://github.com/mojolingo/SIPtreadmill/compare/0.1.1...1.0.0)
  * Authentication is now optional. When disabled, anonymous users have full administrative access.
  * AT&T APIMatrix authentication was removed, since the client library for this has been abandoned.
  * File storage may now be to local disk or S3
  * Profiles and targets may now be cloned similarly to test runs
  * Failures to gather info from the test target via SSH are now notified as exceptions
  * Test runs can be created and run via a REST API
  * Call rate differentials may now be more finely controlled
  * A Javascript error when rendering the test run listing was fixed
  * The application now runs on Ruby 2.2.0

# [0.1.1](https://github.com/mojolingo/SIPtreadmill/compare/0.1.0...0.1.1)
  * Fix duplication of test run attributes

# [0.1.0](https://github.com/mojoingo/SIPtreadmill/compare/5949933d1fe4940f1e401e86514c596104ff41eb...0.1.1)
  * First official release
