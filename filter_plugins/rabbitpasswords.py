#!/usr/bin/env python

import base64
import os
import hashlib
import struct
import sys

# https://stackoverflow.com/a/53016240/2294168
def getRabbitPassword(password):
    # 1.Generate a random 32 bit salt:
    # This will generate 32 bits of random data:
    salt = os.urandom(4)

    # 2.Concatenate that with the UTF-8 representation of the plaintext password
    tmp0 = salt + password.encode('utf-8')

    # 3. Take the SHA256 hash and get the bytes back
    tmp1 = hashlib.sha256(tmp0).digest()

    # 4. Concatenate the salt again:
    salted_hash = salt + tmp1

    # 5. convert to base64 encoding:
    pass_hash = base64.b64encode(salted_hash)
    return pass_hash.decode("utf-8")

class FilterModule(object):
  def filters(self):
    return { 'rabbitpasswords': self.rabbitpasswords }

  def rabbitpasswords(self, list_of_dicts):
    l = []
    for di in list_of_dicts:
        newdi = { }
        for key in di:
            if key == 'password':
                newdi['password_hash'] = getRabbitPassword(di[key])
            else:
                newdi[key] = di[key]
        l.append(newdi)
    return l