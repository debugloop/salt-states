=================
Salt States |img|
=================

.. |img| image:: https://travis-ci.org/danieljn/salt-states.png?branch=master
  :target: https://travis-ci.org/danieljn/salt-states

This repository contains some salt states I use and experiment with.

They are geared toward my own needs and I am not really documenting this stuff. You're
of course free to ask about stuff, file an issue or even submit a pull request.

Hints on using those states
~~~~~~~~~~~~~~~~~~~~~~~~~~~
I use this repository straight on my Salt Master, as you can see in the 
``salt_master_conf``.

I keep any data I consider too delicate out of this repository by putting this
stuff into Salt's Pillar. If you want to use a state doing this, you'll have to 
adjust your Pillar's configuration.

You can find an minimal working example in the Travis configuration:
The ``.travis`` directory contains some dummy pillar data (as well as an alternative 
top file and minion configuration) that is copied over to www.travis-ci.org as 
specified in ``.travis.yml``

Some words of caution
~~~~~~~~~~~~~~~~~~~~~
- **Always** look at all Salt States your using thoroughly and do not trust them blindly.
- Not all of these states would be considered best practices. For example, the ``myuser``
  state sets an initial password for my personal user, serving as poor alternative to 
  a proper LDAP setup on my minions.
