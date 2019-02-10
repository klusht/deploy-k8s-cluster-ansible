#!/usr/bin/python
import sys
import re

# read file for searching
log_file = sys.argv[1]
in_file = open(log_file, "rt")
contents = in_file.read()
in_file.close()
# extract
kubeadm_join_line = str(re.findall("kubeadm join (.*)", contents)[0])

# write data
extracted = open("generated_resources/generated_vars.yml","w+")
extracted.write("join_line: kubeadm join %s\r\n" % kubeadm_join_line)
extracted.close()
# flag success for ansible
sys.stdout.write("success")