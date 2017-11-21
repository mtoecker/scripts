# scripts

This is a uncatagorized collection of scripts I've used or created over the years.

sign-vmware.sh - Automatically signs the vmnet and vmmon kernel modules for UEFI instances of Ubuntu when kernel versions are increased, and relaunches the modules. Basically, UEFI enabled systems require that kernel modules be signed prior to being run.  VMWare requires recompilation of these two modules whenever the headers change, but doesn't sign them.  You have to set up a new public key in your Linux system that is trusted for signing, and I'm working on a writeup for that as well.  This script simply uses that already set up trusted key to sign the modules.  