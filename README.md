# Canon

Compare the output from a group of hosts to a canonical good expected return.

## Preface

Check the expected output of a command across N hosts and compare to what you think it should be.

## What it does

knife canon -C "good stuff" QUERY COMMAND

example:

knife canon -C "rsync-3.0.6-1.el5.rf" fqdn:example.com "rpm -q rsync"

myhost1.example.com failed to match expected output: rsync-3.0.5

myhost2.example.com failed to match expected output: rsync-3.0.4


Surpresses output from hosts that match.  Useful when plotting convergence paths.

## This is a mess, yo
I'm getting better at the ruby.

I'll work on getting the output red for non-matching hosts.
